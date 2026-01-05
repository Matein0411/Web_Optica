/* ==========================================
   LÓGICA DE FICHAS CLÍNICAS
   Requiere: jQuery, SweetAlert2, Bootstrap, Select2
   ========================================== */

$(document).ready(function() {
    console.log("Sistema de Fichas iniciado correctamente.");

    // Inicializar búsqueda con debounce
    let searchTimeout;
    const searchInput = document.getElementById('searchInput');

    if (searchInput) {
        searchInput.addEventListener('input', function(e) {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                listarFichas(e.target.value);
            }, 500);
        });
    }
});

// --- LISTAR ---
function listarFichas(criterio) {
    if (!criterio) criterio = '';
    const url = `${contextPath}/fichas?accion=buscar&criterio=${encodeURIComponent(criterio)}`;

    fetch(url)
        .then(response => {
            if (!response.ok) throw new Error("Error en la red");
            return response.json();
        })
        .then(data => {
            actualizarTabla(data);
        })
        .catch(error => console.error('Error al listar:', error));
}

// --- ABRIR MODAL (NUEVA) ---
function abrirModalNuevaFicha() {
    document.getElementById('formFicha').reset();

    // Resetear Select2
    if ($('#comboPaciente').hasClass("select2-hidden-accessible")) {
        $('#comboPaciente').val(null).trigger('change');
    } else {
        $('#comboPaciente').val(null);
    }

    setVal('fichaId', '');
    setVal('pacienteId', '');

    const lblCedula = document.getElementById('pacienteCedula');
    if (lblCedula) lblCedula.innerText = '';

    const modalTitle = document.getElementById('modalFichaLabel');
    if (modalTitle) modalTitle.innerHTML = '<i class="fas fa-file-medical me-2"></i>Nueva Ficha Clínica';

    const btnGuardar = document.getElementById('btnGuardarFicha');
    if (btnGuardar) btnGuardar.innerHTML = '<i class="fas fa-save me-2"></i>Guardar Ficha';

    const modalEl = document.getElementById('modalFicha');
    const modal = new bootstrap.Modal(modalEl);

    // Inicializar Select2 cuando el modal se muestra
    modalEl.addEventListener('shown.bs.modal', function() {
        inicializarSelect2();
    }, { once: true });

    modal.show();
}

// --- GUARDAR / EDITAR ---
function guardarFicha() {
    if (!$('#mpc').val()) {
        Swal.fire('Atención', 'El Motivo de Consulta es obligatorio', 'warning');
        return;
    }

    const idActual = $('#fichaId').val();
    const accion = (idActual && idActual !== "") ? "editar" : "guardar";

    let datosFormulario = $('#formFicha').serialize();
    datosFormulario += "&accion=" + accion;

    $.ajax({
        type: "POST",
        url: `${contextPath}/fichas`,
        data: datosFormulario,
        dataType: "json",
        success: function(response) {
            if (response.success === "true" || response.success === true) {
                $('#modalFicha').modal('hide');
                Swal.fire('Éxito', response.message, 'success');

                const busquedaActual = document.getElementById('searchInput').value;
                listarFichas(busquedaActual);
            } else {
                Swal.fire('Error', response.message, 'error');
            }
        },
        error: function(xhr, status, error) {
            console.error(xhr.responseText);
            Swal.fire('Error', 'Error de conexión al guardar la ficha.', 'error');
        }
    });
}

// --- CARGAR DATOS PARA EDITAR ---
function editarFicha(id) {
    const url = `${contextPath}/fichas?accion=obtener&id=${id}`;

    fetch(url)
        .then(r => r.json())
        .then(ficha => {
            if (!ficha) {
                Swal.fire('Error', 'No se pudieron cargar los datos.', 'error');
                return;
            }

            document.getElementById('formFicha').reset();

            const modalTitle = document.getElementById('modalFichaLabel');
            if (modalTitle) modalTitle.innerHTML = '<i class="fas fa-edit me-2"></i>Editar Ficha Clínica';

            const btnGuardar = document.getElementById('btnGuardarFicha');
            if (btnGuardar) btnGuardar.innerHTML = '<i class="fas fa-save me-2"></i>Guardar Cambios';

            setVal('fichaId', ficha.id);

            // Cargar Paciente en Select2
            if (ficha.paciente) {
                setVal('pacienteId', ficha.paciente.id);

                const texto = (ficha.paciente.nombre || '') + ' ' + (ficha.paciente.apellido || '') + ' - C.I: ' + (ficha.paciente.cedula || 'N/A');

                // Opción manual para Select2
                const newOption = new Option(texto, ficha.paciente.id, true, true);

                // Si ya está inicializado, lo añadimos y disparamos change
                if ($('#comboPaciente').data('select2')) {
                    $('#comboPaciente').empty().append(newOption).trigger('change');
                } else {
                    $('#comboPaciente').append(newOption);
                    $('#comboPaciente').val(ficha.paciente.id);
                }

                //const lbl = document.getElementById('pacienteCedula');
                // if(lbl) lbl.innerText = 'Cédula: ' + (ficha.paciente.cedula || 'N/A');
            }

            // Cargar campos de texto
            setVal('mpc', ficha.motivoConsulta);
            setVal('ultimoControlMeses', ficha.ultimoControlMeses);

            // RX Anterior
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

            // Preliminares
            setVal('coverTest', ficha.coverTest);
            setVal('ppc', ficha.ppc);
            setVal('oftalmoscopiaOd', ficha.oftalmoscopiaOd);
            setVal('retinoscopiaOd', ficha.retinoscopiaOd);
            setVal('queratometriaOd', ficha.queratometriaOd);
            setVal('oftalmoscopiaOi', ficha.oftalmoscopiaOi);
            setVal('retinoscopiaOi', ficha.retinoscopiaOi);
            setVal('queratometriaOi', ficha.queratometriaOi);

            // RX Final
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

            // Checkboxes
            setChk('chkCristal', ficha.materialCristal);
            setChk('chkCR39', ficha.materialCr39);
            setChk('chkPoly', ficha.materialPolicarbonato);
            setChk('chkProgresivo', ficha.materialProgresivo);
            setChk('chkFiltroAzul', ficha.filtroAzul);
            setChk('chkTransition', ficha.filtroTransition);
            setChk('chkAntiReflejante', ficha.filtroAntiReflejante);
            setChk('chkFotocromatico', ficha.filtroFotocromatico);

            // Lentes Contacto
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

            const modalEl = document.getElementById('modalFicha');
            const modal = new bootstrap.Modal(modalEl);

            modalEl.addEventListener('shown.bs.modal', function() {
                inicializarSelect2();
            }, { once: true });

            modal.show();
        })
        .catch(err => {
            console.error(err);
            Swal.fire('Error', 'No se pudo cargar la ficha.', 'error');
        });
}

// --- anular
function confirmarAnularFicha(id, nombre) {
    Swal.fire({
        title: '¿Anular ficha?',
        text: "Se anulará la ficha de " + nombre,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Sí, Anular',
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                type: "POST",
                url: `${contextPath}/fichas`,
                data: { accion: 'anular', id: id },
                dataType: "json",
                success: function(data) {
                    if (data.success === 'true' || data.success === true) {
                        Swal.fire('Anulado', data.message, 'success');
                        listarFichas('');
                    } else {
                        Swal.fire('Error', data.message, 'error');
                    }
                },
                error: function(xhr) {
                    Swal.fire('Error', 'Error al procesar la solicitud', 'error');
                }
            });
        }
    });
}

// --- SELECT2 Y UTILIDADES ---

function inicializarSelect2() {
    const $select = $('#comboPaciente');

    // Destruir instancia previa si existe
    if ($select.hasClass("select2-hidden-accessible")) {
        $select.select2('destroy');
    }

    $select.select2({
        theme: 'bootstrap-5',
        dropdownParent: $('#modalFicha'),
        placeholder: 'Escriba nombre o cédula...',
        allowClear: true,
        language: {
            noResults: function() { return "No se encontraron pacientes"; },
            searching: function() { return "Buscando..."; }
        },
        ajax: {
            // NOTA: Aquí usamos la variable contextPath definida en el JSP padre
            url: contextPath + '/pacientes',
            dataType: 'json',
            delay: 250,
            data: function(params) {
                return {
                    accion: 'buscar',
                    criterio: params.term || ''
                };
            },
            processResults: function(data) {
                return {
                    results: data.map(function(p) {
                        return {
                            id: p.id,
                            text: p.nombre + ' ' + p.apellido + ' - C.I: ' + (p.cedula || 'N/A'),

                        };
                    })
                };
            },
            cache: true
        }
    });

    // Actualizar hidden input al seleccionar
    $select.on('change', function(e) {
        const selectedValue = $(this).val();
        document.getElementById('pacienteId').value = selectedValue || '';

        // Actualizar label de cédula
        // if (selectedValue) {
        //     // Verificar que select2 tenga datos (puede fallar si es seteo manual sin trigger data)
        //     const dataArr = $(this).select2('data');
        //     if (dataArr && dataArr.length > 0) {
        //         const selectedData = dataArr[0];
        //         if (selectedData && selectedData.cedula) {
        //             document.getElementById('pacienteCedula').innerText = 'Cédula: ' + selectedData.cedula;
        //         }
        //     }
        // } else {
        //     document.getElementById('pacienteCedula').innerText = '';
        // }
    });

    // Limpiar hidden input al borrar selección
    $select.on('select2:clear', function(e) {
        document.getElementById('pacienteId').value = '';
        document.getElementById('pacienteCedula').innerText = '';
    });
}

function actualizarTabla(fichas) {
    const tbody = document.getElementById('tablaFichas');

    if (!fichas || fichas.length === 0) {
        tbody.innerHTML = `<tr><td colspan="4" class="text-center text-muted py-4"><i class="fas fa-search fa-2x mb-2"></i><p>No se encontraron resultados</p></td></tr>`;
        return;
    }

    let html = '';
    fichas.forEach(f => {
        let fechaTexto = f.fecha || "---";
        let nombrePaciente = "Paciente Desconocido";
        let cedulaPaciente = "";

        if (f.paciente) {
            nombrePaciente = (f.paciente.nombre || "") + " " + (f.paciente.apellido || "");
            cedulaPaciente = f.paciente.cedula || "";
        }

        let motivo = f.motivoConsulta || "";

        html += `
                <tr>
                    <td class="text-secondary text-nowrap">${fechaTexto}</td>
                    <td>
                        <div class="fw-bold text-capitalize">${nombrePaciente}</div>
                        <small class="text-muted">${cedulaPaciente}</small>
                    </td>
                    <td>${motivo}</td>
                    <td class="text-end">
                        <button class="btn btn-light text-primary shadow-sm" title="Editar" onclick="editarFicha(${f.id})">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-light text-danger shadow-sm" title="Anular" onclick="confirmarAnularFicha(${f.id}, '${nombrePaciente}')">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                    </td>
                </tr>`;
    });
    tbody.innerHTML = html;
}

function setVal(id, value) {
    const el = document.getElementById(id);
    if (el) el.value = (value != null) ? value : '';
}

function setChk(id, value) {
    const el = document.getElementById(id);
    if (el) el.checked = (value === true);
}