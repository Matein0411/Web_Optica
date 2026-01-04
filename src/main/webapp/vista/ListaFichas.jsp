<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fichas Clínicas - Optica Latitud Visual</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" />
</head>
<body>

    <nav class="sidebar">
        <div class="sidebar-header">
            <a href="#" class="brand-badge">
                <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo" class="sidebar-logo-img">
                <div class="d-flex flex-column">
                    <span class="brand-text-small">OPTICA</span>
                    <span class="brand-text-main">LATITUD VISUAL</span>
                </div>
            </a>
        </div>
         <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/pacientes" class="nav-link">
                <i class="fa fa-users"></i> Pacientes
            </a>

            <a href="${pageContext.request.contextPath}/inventario" class="nav-link">
                <i class="fa fa-boxes"></i> Inventario
            </a>
            
            <a href="${pageContext.request.contextPath}/servicios" class="nav-link">
                <i class="fa fa-concierge-bell"></i> Servicios
            </a>
            
            <a href="${pageContext.request.contextPath}/ventas" class="nav-link">
                <i class="fas fa-cash-register"></i> Ventas
            </a>

            <a href="${pageContext.request.contextPath}/fichas" class="nav-link active">
                <i class="fa fa-file-medical"></i> Fichas Clínicas
            </a>
        </div>

        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/logout" class="logout-link">
                <i class="fa fa-sign-out-alt me-3"></i> Cerrar sesión
            </a>
        </div>
    </nav>

    <header class="top-header">
        <h4 class="mb-0 fw-bold text-dark">Dashboard</h4>
        <div class="d-flex align-items-center gap-3">
            <div class="text-end">
                <div class="fw-bold">Dra. Cumanda Delgado</div>
                <small class="text-muted">Administrador</small>
            </div>
            <img src="https://ui-avatars.com/api/?name=Cumanda+Delgado&background=0a2342&color=fff"
                 class="rounded-circle" width="40" height="40" alt="Avatar">
        </div>
    </header>

    <main class="main-content">
        <h2 class="page-title">Fichas Clínicas</h2>

        <div class="row mb-4 align-items-center">
            <div class="col-md-6">
                <div class="input-group shadow-sm">
                    <span class="input-group-text bg-white ps-3">
                        <i class="fas fa-search"></i>
                    </span>
                    <input type="text" id="searchInput" class="form-control py-2" placeholder="Buscar Ficha (Paciente)...">
                </div>
            </div>
            <div class="col-md-6 text-md-end">
                <button class="btn btn-orange" onclick="abrirModalNuevaFicha()">
                    <i class="fas fa-plus"></i> Nueva Ficha Clínica
                </button>
            </div>
        </div>

        <div class="card-table">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Paciente</th>
                            <th>Motivo Consulta</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody id="tablaFichas">
                        <c:if test="${empty fichas}">
                            <tr>
                                <td colspan="4" class="text-center text-muted py-4">
                                    <i class="fas fa-search fa-2x mb-2"></i>
                                    <p>No se encontraron fichas registradas</p>
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach items="${fichas}" var="ficha">
                            <tr>
                                <td class="text-nowrap text-secondary">${ficha.fechaFormateada}</td>
                                <td>
                                    <div class="fw-bold text-capitalize">${ficha.pacienteNombreCompleto}</div>
                                    <small class="text-muted">${ficha.pacienteCedula}</small>
                                </td>
                                <td>${ficha.motivoConsulta}</td>
                                <td class="text-end">
                                    <button class="btn btn-light text-primary shadow-sm" title="Editar"
                                            onclick="editarFicha(${ficha.id})">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-light text-danger shadow-sm" title="Eliminar"
                                            onclick="confirmarDesactivarFicha(${ficha.id}, '${ficha.pacienteNombreCompleto}')">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <jsp:include page="FormularioFicha.jsp" />

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    
    <script>
        const contextPath = '${pageContext.request.contextPath}';

        // 1. INICIALIZACIÓN
        $(document).ready(function() {
            console.log("Sistema de Fichas iniciado correctamente.");
        });

        // 2. LÓGICA DE BÚSQUEDA
        let searchTimeout;
        const searchInput = document.getElementById('searchInput');
        
        if(searchInput){
            searchInput.addEventListener('input', function (e) {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    listarFichas(e.target.value);
                }, 500);
            });
        }

        function listarFichas(criterio) {
            // Si el criterio es nulo, enviamos cadena vacía
            if (!criterio) criterio = '';
            
            const url = contextPath + '/fichas?accion=buscar&criterio=' + encodeURIComponent(criterio);
            
            fetch(url)
                .then(response => {
                    if (!response.ok) throw new Error("Error en la red");
                    return response.json();
                })
                .then(data => {
                    console.log("Datos recibidos:", data); // Para depuración
                    actualizarTabla(data);
                })
                .catch(error => console.error('Error al listar:', error));
        }

        // 3. FUNCIÓN PARA ABRIR EL MODAL (NUEVA FICHA)
        function abrirModalNuevaFicha() {
            // Resetear el formulario
            document.getElementById('formFicha').reset();
            
            // Limpiar Select2 si existe
            if ($('#comboPaciente').length) {
                $('#comboPaciente').val(null).trigger('change');
            }
            
            // Limpiar campos ocultos y visuales
            setVal('fichaId', '');
            setVal('pacienteId', '');
            
            const lblCedula = document.getElementById('pacienteCedula');
            if(lblCedula) lblCedula.innerText = '';

            // Cambiar títulos para "Modo Creación"
            const modalTitle = document.getElementById('modalFichaLabel');
            if(modalTitle) modalTitle.innerHTML = '<i class="fas fa-file-medical me-2"></i>Nueva Ficha Clínica';
            
            const btnGuardar = document.getElementById('btnGuardarFicha');
            if(btnGuardar) btnGuardar.innerHTML = '<i class="fas fa-save me-2"></i>Guardar Ficha';

            // Mostrar el Modal
            const modalEl = document.getElementById('modalFicha');
            const modal = new bootstrap.Modal(modalEl);
            modal.show();
        }

        // 4. GUARDAR FICHA
        function guardarFicha() {
            const pacienteId = document.getElementById('pacienteId').value;
            if (!pacienteId) {
                Swal.fire('Atención', 'Debe buscar y seleccionar un paciente antes de guardar.', 'warning');
                return;
            }

            const form = document.getElementById('formFicha');
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            const formData = new FormData(form);
            const id = document.getElementById('fichaId').value;
            
            const accion = id ? 'editar' : 'guardar';
            formData.append('accion', accion);
            if (id) formData.append('id', id);

            fetch(contextPath + '/fichas', {
                method: 'POST', 
                body: formData
            })
            .then(r => r.json())
            .then(data => {
                if (data.success === 'true' || data.success === true) {
                    const modalEl = document.getElementById('modalFicha');
                    const modalInstance = bootstrap.Modal.getInstance(modalEl);
                    if(modalInstance) modalInstance.hide();
                    
                    Swal.fire({
                        icon: 'success',
                        title: '¡Guardado!',
                        text: data.message,
                        timer: 2000,
                        showConfirmButton: false
                    });
                    
                    // Recargar tabla con búsqueda vacía para ver el nuevo registro
                    listarFichas('');
                } else {
                    Swal.fire('Error', data.message, 'error');
                }
            })
            .catch(err => {
                console.error(err);
                Swal.fire('Error', 'Error de conexión con el servidor.', 'error');
            });
        }

        // 5. EDITAR FICHA (CARGAR DATOS)
        function editarFicha(id) {
            const url = contextPath + "/fichas?accion=obtener&id=" + id;
            fetch(url)
                .then(r => r.json())
                .then(ficha => {
                    if (!ficha) {
                        Swal.fire('Error', 'No se pudieron cargar los datos.', 'error');
                        return;
                    }

                    // Resetear formulario primero
                    document.getElementById('formFicha').reset();
                    
                    // Preparar interfaz de edición
                    const modalTitle = document.getElementById('modalFichaLabel');
                    if(modalTitle) modalTitle.innerHTML = '<i class="fas fa-edit me-2"></i>Editar Ficha Clínica';
                    const btnGuardar = document.getElementById('btnGuardarFicha');
                    if(btnGuardar) btnGuardar.innerHTML = '<i class="fas fa-save me-2"></i>Guardar Cambios';

                    // Llenar campos ID
                    setVal('fichaId', ficha.id);
                    
                    // Llenar Paciente (Select2)
                    if (ficha.paciente) {
                        setVal('pacienteId', ficha.paciente.id);
                        
                        // Si usamos Select2, necesitamos crear la opción manualmente si no está cargada
                        if ($('#comboPaciente').length) {
                             const texto = ficha.paciente.nombre + ' ' + ficha.paciente.apellido + ' (' + ficha.paciente.cedula + ')';
                             const newOption = new Option(texto, ficha.paciente.id, true, true);
                             $('#comboPaciente').append(newOption).trigger('change');
                        }
                        
                        const lbl = document.getElementById('pacienteCedula');
                        if(lbl) lbl.innerText = 'C.I: ' + ficha.paciente.cedula;
                    }

                    // Datos Generales
                    setVal('mpc', ficha.motivoConsulta);
                    setVal('ultimoControlMeses', ficha.ultimoControlMeses);
                    
                    // RX Anterior
                    setVal('rxAntOdEsfera', ficha.rxAntOdEsfera); setVal('rxAntOdCilindro', ficha.rxAntOdCilindro);
                    setVal('rxAntOdEje', ficha.rxAntOdEje); setVal('rxAntOdAdd', ficha.rxAntOdAdd);
                    setVal('rxAntOdAvSc', ficha.rxAntOdAvSc); setVal('rxAntOdAvCc', ficha.rxAntOdAvCc);
                    setVal('rxAntOdPrismas', ficha.rxAntOdPrismas);

                    setVal('rxAntOiEsfera', ficha.rxAntOiEsfera); setVal('rxAntOiCilindro', ficha.rxAntOiCilindro);
                    setVal('rxAntOiEje', ficha.rxAntOiEje); setVal('rxAntOiAdd', ficha.rxAntOiAdd);
                    setVal('rxAntOiAvSc', ficha.rxAntOiAvSc); setVal('rxAntOiAvCc', ficha.rxAntOiAvCc);
                    setVal('rxAntOiPrismas', ficha.rxAntOiPrismas);

                    // Examen Externo
                    setVal('coverTest', ficha.coverTest); setVal('ppc', ficha.ppc);
                    setVal('oftalmoscopiaOd', ficha.oftalmoscopiaOd); setVal('retinoscopiaOd', ficha.retinoscopiaOd); setVal('queratometriaOd', ficha.queratometriaOd);
                    setVal('oftalmoscopiaOi', ficha.oftalmoscopiaOi); setVal('retinoscopiaOi', ficha.retinoscopiaOi); setVal('queratometriaOi', ficha.queratometriaOi);

                    // RX Final
                    setVal('rxFinalOdEsfera', ficha.rxFinalOdEsfera); setVal('rxFinalOdCilindro', ficha.rxFinalOdCilindro);
                    setVal('rxFinalOdEje', ficha.rxFinalOdEje); setVal('rxFinalOdAdd', ficha.rxFinalOdAdd);
                    setVal('rxFinalOdAv', ficha.rxFinalOdAv); setVal('rxFinalOdDnp', ficha.rxFinalOdDnp);
                    setVal('rxFinalOdPrisma', ficha.rxFinalOdPrisma);

                    setVal('rxFinalOiEsfera', ficha.rxFinalOiEsfera); setVal('rxFinalOiCilindro', ficha.rxFinalOiCilindro);
                    setVal('rxFinalOiEje', ficha.rxFinalOiEje); setVal('rxFinalOiAdd', ficha.rxFinalOiAdd);
                    setVal('rxFinalOiAv', ficha.rxFinalOiAv); setVal('rxFinalOiDnp', ficha.rxFinalOiDnp);
                    setVal('rxFinalOiPrisma', ficha.rxFinalOiPrisma);

                    // Checkboxes
                    setChk('chkCristal', ficha.materialCristal); setChk('chkCR39', ficha.materialCr39);
                    setChk('chkPoly', ficha.materialPolicarbonato); setChk('chkProgresivo', ficha.materialProgresivo);
                    setChk('chkFiltroAzul', ficha.filtroAzul); setChk('chkTransition', ficha.filtroTransition);
                    setChk('chkAntiReflejante', ficha.filtroAntiReflejante); setChk('chkFotocromatico', ficha.filtroFotocromatico);

                    // Lentes Contacto
                    setVal('lcOdEsfera', ficha.lcOdEsfera); setVal('lcOdCilindro', ficha.lcOdCilindro); setVal('lcOdEje', ficha.lcOdEje); setVal('lcOdAdd', ficha.lcOdAdd); setVal('lcOdAv', ficha.lcOdAv); setVal('lcOdTipo', ficha.lcOdTipo);
                    setVal('lcOiEsfera', ficha.lcOiEsfera); setVal('lcOiCilindro', ficha.lcOiCilindro); setVal('lcOiEje', ficha.lcOiEje); setVal('lcOiAdd', ficha.lcOiAdd); setVal('lcOiAv', ficha.lcOiAv); setVal('lcOiTipo', ficha.lcOiTipo);

                    setVal('observaciones', ficha.observaciones);
                    
                    // Abrir modal
                    const modalEl = document.getElementById('modalFicha');
                    const modal = new bootstrap.Modal(modalEl);
                    modal.show();
                })
                .catch(err => {
                    console.error(err);
                    Swal.fire('Error', 'No se pudo cargar la ficha.', 'error');
                });
        }

        // 6. ELIMINAR / DESACTIVAR
        function confirmarDesactivarFicha(id, nombre) {
            Swal.fire({
                title: '¿Eliminar ficha?',
                text: "Se eliminará la ficha de " + nombre,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    const formData = new FormData();
                    formData.append('accion', 'desactivar');
                    formData.append('id', id);

                    fetch(contextPath + '/fichas', {method: 'POST', body: formData})
                    .then(r => r.json())
                    .then(data => {
                        if (data.success === 'true' || data.success === true) {
                            Swal.fire('Eliminado', data.message, 'success');
                            listarFichas('');
                        } else {
                            Swal.fire('Error', data.message, 'error');
                        }
                    });
                }
            });
        }

        // 7. ACTUALIZAR TABLA (FUNCIÓN BLINDADA CONTRA ERRORES DE DATOS)
        function actualizarTabla(fichas) {
            const tbody = document.getElementById('tablaFichas');
            
            if (!fichas || fichas.length === 0) {
                tbody.innerHTML = `<tr><td colspan="4" class="text-center text-muted py-4"><i class="fas fa-search fa-2x mb-2"></i><p>No se encontraron resultados</p></td></tr>`;
                return;
            }
            
            let html = '';
            fichas.forEach(f => {
                
                // === BLOQUE SEGURO DE EXTRACCIÓN DE DATOS ===
                
                // A) Fecha: Gson puede enviar String "2023-01-01" u Objeto {year:2023...}
                let fechaTexto = "---";
                if (f.fecha) {
                    if (typeof f.fecha === 'object') {
                        // Si llega como objeto
                        fechaTexto = f.fecha.day + '/' + f.fecha.month + '/' + f.fecha.year;
                    } else {
                        // Si llega como string
                        fechaTexto = f.fecha;
                    }
                }

                // B) Paciente: Extraemos del objeto anidado, no del getter @Transient
                let nombrePaciente = "Paciente Desconocido";
                let cedulaPaciente = "";
                
                if (f.paciente) {
                    nombrePaciente = (f.paciente.nombre || "") + " " + (f.paciente.apellido || "");
                    cedulaPaciente = f.paciente.cedula || "";
                }

                // C) Motivo
                let motivo = f.motivoConsulta || "";
                // ===========================================

                html += `
                    <tr>
                        <td class="text-secondary text-nowrap">\${fechaTexto}</td>
                        <td>
                            <div class="fw-bold text-capitalize">\${nombrePaciente}</div>
                            <small class="text-muted">\${cedulaPaciente}</small>
                        </td>
                        <td>\${motivo}</td>
                        <td class="text-end">
                            <button class="btn btn-light text-primary shadow-sm" title="Editar" onclick="editarFicha(\${f.id})">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-light text-danger shadow-sm" title="Eliminar" onclick="confirmarDesactivarFicha(\${f.id}, '\${nombrePaciente}')">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </td>
                    </tr>`;
            });
            tbody.innerHTML = html;
        }

        // UTILIDADES AUXILIARES
        function setVal(id, value) {
            const el = document.getElementById(id);
            if (el) el.value = (value != null) ? value : '';
        }
        function setChk(id, value) {
            const el = document.getElementById(id);
            if (el) el.checked = (value === true);
        }
    </script>
</body>
</html>