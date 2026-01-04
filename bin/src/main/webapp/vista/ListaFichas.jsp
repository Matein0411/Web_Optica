<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fichas Clínicas - Óptica Latitud Visual</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
    <!-- Sidebar -->
    <nav class="sidebar">
        <div class="sidebar-header">
            <a href="#" class="brand-badge">
                <img src="${pageContext.request.contextPath}/assets/logo.png" alt="logo" class="sidebar-logo-img">
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

    <!-- Header -->
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

    <!-- Main -->
    <main class="main-content">
        <h2 class="page-title">Fichas Clínicas</h2>

        <!-- barra busqueda y boton agregar -->
        <div class="row mb-4 align-items-center">
            <div class="col-md-6">
                <div class="input-group shadow-sm">
                    <span class="input-group-text bg-white ps-3">
                        <i class="fas fa-search"></i>
                    </span>
                    <input type="text" id="searchInput" class="form-control py-2" placeholder="Buscar Paciente o MPC">
                </div>
            </div>

            <div class="col-md-6 text-md-end">
                <button class="btn btn-orange" onclick="abrirModalNuevaFicha()">
                    <i class="fas fa-plus"></i> Nueva Ficha
                </button>
            </div>
        </div>

        <!-- tabla fichas -->
        <div class="card-table">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Paciente</th>
                            <th>Motivo Consulta (MPC)</th>
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
                                    <div class="fw-bold">${ficha.pacienteNombreCompleto}</div>
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

    <!-- Modal -->
    <jsp:include page="FormularioFicha.jsp" />

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        const contextPath = '${pageContext.request.contextPath}';

        let searchTimeout;
        document.getElementById('searchInput').addEventListener('input', function (e) {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                listarFichas(e.target.value);
            }, 500);
        });

        function listarFichas(criterio = '') {
            const url = contextPath + '/fichas?accion=buscar&criterio=' + encodeURIComponent(criterio);
            fetch(url)
                .then(response => {
                    if (!response.ok) throw new Error("Error en la red");
                    return response.json();
                })
                .then(fichas => actualizarTabla(fichas))
                .catch(error => console.error('Error al listar:', error));
        }

        function escapeHtml(text) {
            if (!text) return '';
            return text.toString()
                .replaceAll('&', '&amp;')
                .replaceAll('<', '&lt;')
                .replaceAll('>', '&gt;')
                .replaceAll('"', '&quot;')
                .replaceAll("'", '&#039;');
        }

        function formatFecha(fechaIso) {
            if (!fechaIso) return '';
            const d = new Date(fechaIso);
            try {
                const formatted = new Intl.DateTimeFormat('es-EC', {
                    day: '2-digit',
                    month: 'short',
                    year: 'numeric'
                }).format(d);
                return formatted.replace('.', '');
            } catch (e) {
                return fechaIso;
            }
        }

        function actualizarTabla(fichas) {
            const tbody = document.getElementById('tablaFichas');

            if (!fichas || fichas.length === 0) {
                tbody.innerHTML = `
                    <tr>
                        <td colspan="4" class="text-center text-muted py-4">
                            <i class="fas fa-search fa-2x mb-2"></i>
                            <p>No se encontraron fichas</p>
                        </td>
                    </tr>`;
                return;
            }

            tbody.innerHTML = fichas.map(f => {
                const pacienteNombre = f.paciente ? `${f.paciente.nombre} ${f.paciente.apellido}` : '';
                const pacienteCedula = f.paciente ? f.paciente.cedula : '';
                return `
                    <tr>
                        <td class="text-nowrap text-secondary">${escapeHtml(formatFecha(f.fecha))}</td>
                        <td>
                            <div class="fw-bold">${escapeHtml(pacienteNombre)}</div>
                            <small class="text-muted">${escapeHtml(pacienteCedula)}</small>
                        </td>
                        <td>${escapeHtml(f.motivoConsulta || '')}</td>
                        <td class="text-end">
                            <button class="btn btn-light text-primary shadow-sm" title="Editar"
                                    onclick="editarFicha(${f.id})">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-light text-danger shadow-sm" title="Eliminar"
                                    onclick="confirmarDesactivarFicha(${f.id}, '${escapeHtml(pacienteNombre)}')">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </td>
                    </tr>`;
            }).join('');
        }

        function abrirModalNuevaFicha() {
            document.getElementById('formFicha').reset();
            document.getElementById('fichaId').value = '';
            document.getElementById('pacienteId').value = '';
            document.getElementById('paciente').value = '';
            document.getElementById('pacienteCedula').innerText = '';

            document.getElementById('modalFichaLabel').innerHTML =
                '<i class="fas fa-file-medical me-2"></i>Nueva Ficha Clínica';
            document.getElementById('btnGuardarFicha').innerHTML =
                '<i class="fas fa-save me-2"></i>Guardar Ficha';

            const modal = new bootstrap.Modal(document.getElementById('modalFicha'));
            modal.show();
        }

        async function buscarPaciente() {
            const criterioPrompt = await Swal.fire({
                title: 'Buscar Paciente',
                input: 'text',
                inputPlaceholder: 'Nombre, apellido o cédula...',
                showCancelButton: true,
                confirmButtonText: 'Buscar',
                cancelButtonText: 'Cancelar'
            });

            if (!criterioPrompt.isConfirmed || !criterioPrompt.value) return;

            const criterio = criterioPrompt.value.trim();
            if (!criterio) return;

            const url = contextPath + '/pacientes?accion=buscar&criterio=' + encodeURIComponent(criterio);
            const pacientes = await fetch(url).then(r => r.json());

            if (!pacientes || pacientes.length === 0) {
                await Swal.fire('Sin resultados', 'No se encontraron pacientes.', 'info');
                return;
            }

            const options = {};
            pacientes.forEach(p => {
                options[p.id] = `${p.nombre} ${p.apellido} - ${p.cedula}`;
            });

            const seleccion = await Swal.fire({
                title: 'Selecciona Paciente',
                input: 'select',
                inputOptions: options,
                inputPlaceholder: 'Seleccione...',
                showCancelButton: true,
                confirmButtonText: 'Seleccionar',
                cancelButtonText: 'Cancelar'
            });

            if (!seleccion.isConfirmed || !seleccion.value) return;

            const pacienteId = seleccion.value;
            const texto = options[pacienteId] || '';
            const partes = texto.split(' - ');
            document.getElementById('pacienteId').value = pacienteId;
            document.getElementById('paciente').value = (partes[0] || '').trim();
            document.getElementById('pacienteCedula').innerText = (partes[1] || '').trim();
        }

        function editarFicha(id) {
            const url = contextPath + "/fichas?accion=obtener&id=" + id;
            fetch(url)
                .then(r => {
                    if (!r.ok) throw new Error("Error al obtener ficha");
                    return r.json();
                })
                .then(ficha => {
                    if (!ficha) {
                        Swal.fire('Error', 'Ficha no encontrada', 'error');
                        return;
                    }

                    document.getElementById('formFicha').reset();
                    document.getElementById('fichaId').value = ficha.id || '';

                    if (ficha.paciente) {
                        document.getElementById('pacienteId').value = ficha.paciente.id || '';
                        document.getElementById('paciente').value = `${ficha.paciente.nombre} ${ficha.paciente.apellido}`;
                        document.getElementById('pacienteCedula').innerText = ficha.paciente.cedula || '';
                    }

                    setVal('mpc', ficha.motivoConsulta);
                    setVal('ultimoControlMeses', ficha.ultimoControlMeses);

                    setVal('rxAntOdEsfera', ficha.rxAntOdEsfera);
                    setVal('rxAntOdCilindro', ficha.rxAntOdCilindro);
                    setVal('rxAntOdEje', ficha.rxAntOdEje);
                    setVal('rxAntOdAdd', ficha.rxAntOdAdd);
                    setVal('rxAntOdAvSc', ficha.rxAntOdAvSc);
                    setVal('rxAntOdAvCc', ficha.rxAntOdAvCc);
                    setVal('rxAntOdPrismas', ficha.rxAntOdPrismas);

                    setVal('rxAntOiEsfera', ficha.rxAntOiEsfera);
                    setVal('rxAntOiCilindro', ficha.rxAntOiCilindro);
                    setVal('rxAntOiEje', ficha.rxAntOiEje);
                    setVal('rxAntOiAdd', ficha.rxAntOiAdd);
                    setVal('rxAntOiAvSc', ficha.rxAntOiAvSc);
                    setVal('rxAntOiAvCc', ficha.rxAntOiAvCc);
                    setVal('rxAntOiPrismas', ficha.rxAntOiPrismas);

                    setVal('coverTest', ficha.coverTest);
                    setVal('ppc', ficha.ppc);

                    setVal('oftalmoscopiaOd', ficha.oftalmoscopiaOd);
                    setVal('retinoscopiaOd', ficha.retinoscopiaOd);
                    setVal('queratometriaOd', ficha.queratometriaOd);

                    setVal('oftalmoscopiaOi', ficha.oftalmoscopiaOi);
                    setVal('retinoscopiaOi', ficha.retinoscopiaOi);
                    setVal('queratometriaOi', ficha.queratometriaOi);

                    setVal('rxFinalOdEsfera', ficha.rxFinalOdEsfera);
                    setVal('rxFinalOdCilindro', ficha.rxFinalOdCilindro);
                    setVal('rxFinalOdEje', ficha.rxFinalOdEje);
                    setVal('rxFinalOdAdd', ficha.rxFinalOdAdd);
                    setVal('rxFinalOdAv', ficha.rxFinalOdAv);
                    setVal('rxFinalOdDnp', ficha.rxFinalOdDnp);
                    setVal('rxFinalOdPrisma', ficha.rxFinalOdPrisma);

                    setVal('rxFinalOiEsfera', ficha.rxFinalOiEsfera);
                    setVal('rxFinalOiCilindro', ficha.rxFinalOiCilindro);
                    setVal('rxFinalOiEje', ficha.rxFinalOiEje);
                    setVal('rxFinalOiAdd', ficha.rxFinalOiAdd);
                    setVal('rxFinalOiAv', ficha.rxFinalOiAv);
                    setVal('rxFinalOiDnp', ficha.rxFinalOiDnp);
                    setVal('rxFinalOiPrisma', ficha.rxFinalOiPrisma);

                    setChk('chkCristal', ficha.materialCristal);
                    setChk('chkCR39', ficha.materialCr39);
                    setChk('chkPoly', ficha.materialPolicarbonato);
                    setChk('chkProgresivo', ficha.materialProgresivo);

                    setChk('chkFiltroAzul', ficha.filtroAzul);
                    setChk('chkTransition', ficha.filtroTransition);
                    setChk('chkAntiReflejante', ficha.filtroAntiReflejante);
                    setChk('chkFotocromatico', ficha.filtroFotocromatico);

                    setVal('lcOdEsfera', ficha.lcOdEsfera);
                    setVal('lcOdCilindro', ficha.lcOdCilindro);
                    setVal('lcOdEje', ficha.lcOdEje);
                    setVal('lcOdAdd', ficha.lcOdAdd);
                    setVal('lcOdAv', ficha.lcOdAv);
                    setVal('lcOdTipo', ficha.lcOdTipo);

                    setVal('lcOiEsfera', ficha.lcOiEsfera);
                    setVal('lcOiCilindro', ficha.lcOiCilindro);
                    setVal('lcOiEje', ficha.lcOiEje);
                    setVal('lcOiAdd', ficha.lcOiAdd);
                    setVal('lcOiAv', ficha.lcOiAv);
                    setVal('lcOiTipo', ficha.lcOiTipo);

                    setVal('observaciones', ficha.observaciones);

                    document.getElementById('modalFichaLabel').innerHTML =
                        '<i class="fas fa-file-medical me-2"></i>Editar Ficha Clínica';
                    document.getElementById('btnGuardarFicha').innerHTML =
                        '<i class="fas fa-save me-2"></i>Guardar Cambios';

                    const modal = new bootstrap.Modal(document.getElementById('modalFicha'));
                    modal.show();
                })
                .catch(err => {
                    console.error(err);
                    Swal.fire('Error', 'No se pudo cargar la ficha', 'error');
                });
        }

        function setVal(id, value) {
            const el = document.getElementById(id);
            if (!el) return;
            el.value = value != null ? value : '';
        }

        function setChk(id, value) {
            const el = document.getElementById(id);
            if (!el) return;
            el.checked = value === true;
        }

        function guardarFicha() {
            const pacienteId = document.getElementById('pacienteId').value;
            if (!pacienteId) {
                Swal.fire('Validación', 'Debe seleccionar un paciente.', 'warning');
                return;
            }

            const form = document.getElementById('formFicha');
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            const formData = new FormData(form);
            const id = document.getElementById('fichaId').value;
            formData.append('accion', id ? 'editar' : 'guardar');
            if (id) formData.append('id', id);

            fetch(contextPath + '/fichas', {method: 'POST', body: formData})
                .then(r => {
                    if (!r.ok) throw new Error("Error en la peticion");
                    return r.json();
                })
                .then(data => {
                    if (data.success === 'true') {
                        const modalElement = document.getElementById('modalFicha');
                        const modalInstance = bootstrap.Modal.getInstance(modalElement);
                        modalInstance.hide();

                        Swal.fire({
                            icon: 'success',
                            title: 'Éxito',
                            text: data.message,
                            timer: 1500,
                            showConfirmButton: false
                        });

                        listarFichas('');
                    } else {
                        Swal.fire('Error', data.message, 'error');
                    }
                })
                .catch(err => {
                    console.error(err);
                    Swal.fire('Error', 'Ocurrio un error al guardar.', 'error');
                });
        }

        function confirmarDesactivarFicha(id, nombre) {
            Swal.fire({
                title: '¿Está seguro?',
                text: `¿Desea eliminar la ficha de ${nombre}?`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    desactivarFicha(id);
                }
            });
        }

        function desactivarFicha(id) {
            const formData = new FormData();
            formData.append('accion', 'desactivar');
            formData.append('id', id);

            fetch(contextPath + '/fichas', {method: 'POST', body: formData})
                .then(r => {
                    if (!r.ok) throw new Error("Error en la peticion");
                    return r.json();
                })
                .then(data => {
                    if (data.success === 'true') {
                        Swal.fire({
                            icon: 'success',
                            title: 'Eliminado',
                            text: data.message,
                            timer: 1500,
                            showConfirmButton: false
                        });
                        listarFichas('');
                    } else {
                        Swal.fire('Error', data.message, 'error');
                    }
                })
                .catch(err => {
                    console.error(err);
                    Swal.fire('Error', 'Ocurrio un error al eliminar.', 'error');
                });
        }

    </script>
</body>
</html>
