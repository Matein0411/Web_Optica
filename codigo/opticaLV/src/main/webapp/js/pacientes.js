// pacientes.js - Funciones para gestión de pacientes

// Búsqueda en tiempo real
let searchTimeout;
document.getElementById('searchInput').addEventListener('input', function(e) {
    clearTimeout(searchTimeout);
    searchTimeout = setTimeout(() => {
        listarPacientes(e.target.value);
    }, 500);
});

function listarPacientes(criterio = '') {
    // Usamos accion=buscar para obtener JSON
    const url = contextPath + '/pacientes?accion=buscar&criterio=' + encodeURIComponent(criterio);

    fetch(url)
        .then(response => {
            if (!response.ok) throw new Error("Error en la red");
            return response.json();
        })
        .then(pacientes => {
            console.log("Pacientes recibidos:", pacientes); // Debug
            actualizarTabla(pacientes);
        })
        .catch(error => {
            console.error('Error al listar:', error);
        });
}

function actualizarTabla(pacientes) {
    const tbody = document.getElementById('tablaPacientes');

    if (pacientes.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="5" class="text-center text-muted py-4">
                    <i class="fas fa-search fa-2x mb-2"></i>
                    <p>No se encontraron pacientes</p>
                </td>
            </tr>`;
        return;
    }

    // Renderizado de filas
    tbody.innerHTML = pacientes.map(p => `
        <tr>
            <td>
                <div class="fw-bold">${p.nombreCompleto || (p.nombre + ' ' + p.apellido)}</div>
                <small class="text-muted">${p.edad || calcularEdad(p.fechaNacimiento)} Años</small>
            </td>
            <td>
                <div>${p.cedula}</div>
            </td>
            <td>
                <div>${p.telefono ? p.telefono : '-'}</div>
            </td>
            <td>
                <span class="text-muted">
                    ${p.correoElectronico ? p.correoElectronico : '-'}
                </span>
            </td>
            <td class="text-end">
                <button class="btn btn-light text-primary shadow-sm" 
                        title="Editar" onclick="editarPaciente(${p.id})">
                    <i class="fas fa-edit"></i>
                </button>
                <button class="btn btn-light text-danger shadow-sm" 
                        title="Desactivar" onclick="confirmarDesactivar(${p.id}, '${(p.nombreCompleto || (p.nombre + ' ' + p.apellido)).replace(/'/g, "\\'")}')">
                    <i class="fas fa-trash-alt"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

function calcularEdad(fecha) {
    if(!fecha) return 0;
    const hoy = new Date();
    const nacimiento = new Date(fecha);
    let edad = hoy.getFullYear() - nacimiento.getFullYear();
    const mes = hoy.getMonth() - nacimiento.getMonth();
    if (mes < 0 || (mes === 0 && hoy.getDate() < nacimiento.getDate())) {
        edad--;
    }
    return edad;
}

function abrirModalNuevo() {
    document.getElementById('formPaciente').reset();
    document.getElementById('pacienteId').value = '';
    document.getElementById('modalPacienteLabel').innerHTML =
        '<i class="fas fa-user-plus me-2"></i>Nuevo Paciente';

    const modal = new bootstrap.Modal(document.getElementById('modalPaciente'));
    modal.show();
}

function editarPaciente(id) {
    if (!id) {
        console.error("ID inválido para editar");
        return;
    }

    const url = contextPath + "/pacientes?accion=obtener&id=" + id;

    fetch(url)
        .then(response => {
            if (!response.ok) throw new Error("Error al obtener paciente");
            return response.json();
        })
        .then(paciente => {
            document.getElementById('pacienteId').value = paciente.id;
            document.getElementById('nombre').value = paciente.nombre;
            document.getElementById('apellido').value = paciente.apellido;
            document.getElementById('cedula').value = paciente.cedula;
            document.getElementById('fechaNacimiento').value = paciente.fechaNacimiento;
            // Manejo seguro de nulos para los campos opcionales
            document.getElementById('celular').value = paciente.telefono || '';
            document.getElementById('email').value = paciente.correoElectronico || '';
            document.getElementById('direccion').value = paciente.direccion || '';
            document.getElementById('ocupacion').value = paciente.ocupacion || '';
            document.getElementById('antecedentesOculares').value = paciente.antecedentesOculares || '';
            document.getElementById('antecedentesMedicos').value = paciente.antecedentesMedicos || '';
            document.getElementById('antecedentesFamiliares').value = paciente.antecedentesFamiliares || '';
            document.getElementById('antecedentesFarmacologicos').value = paciente.antecedentesFarmacologicos || '';

            document.getElementById('modalPacienteLabel').innerHTML =
                '<i class="fas fa-user-edit me-2"></i>Editar Paciente';

            const modal = new bootstrap.Modal(document.getElementById('modalPaciente'));
            modal.show();
        })
        .catch(error => {
            console.error('Error:', error);
            Swal.fire('Error', 'No se pudo cargar la información del paciente', 'error');
        });
}

function guardarPaciente() {
    const form = document.getElementById('formPaciente');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    const formData = new FormData(form);
    const id = document.getElementById('pacienteId').value;
    formData.append('accion', id ? 'editar' : 'guardar');
    if (id) {
        formData.append('id', id);
    }

    fetch(contextPath + '/pacientes', {
        method: 'POST',
        body: formData
    })
        .then(response => {
            if(!response.ok) throw new Error("Error en la petición: " + response.status);
            return response.json();
        })
        .then(data => {
            if (data.success === 'true' || data.success === true) {
                // Cerrar modal
                const modalElement = document.getElementById('modalPaciente');
                const modalInstance = bootstrap.Modal.getInstance(modalElement);
                modalInstance.hide();

                Swal.fire({
                    icon: 'success',
                    title: '¡Éxito!',
                    text: data.message,
                    timer: 1500,
                    showConfirmButton: false
                });

                // Recargar tabla
                listarPacientes('');
            } else {
                Swal.fire('Error', data.message, 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            Swal.fire('Error', 'Ocurrió un error al guardar.', 'error');
        });
}

function confirmarDesactivar(id, nombre) {
    Swal.fire({
        title: '¿Está seguro?',
        text: `¿Desea desactivar al paciente ${nombre}?`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Sí, desactivar',
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        if (result.isConfirmed) {
            desactivarPaciente(id);
        }
    });
}

function desactivarPaciente(id) {
    const formData = new FormData();
    formData.append('accion', 'desactivar');
    formData.append('id', id);

    fetch(contextPath + '/pacientes', {
        method: 'POST',
        body: formData
    })
        .then(response => {
            if(!response.ok) throw new Error("Error en la petición");
            return response.json();
        })
        .then(data => {
            if (data.success === 'true' || data.success === true) {
                Swal.fire({
                    icon: 'success',
                    title: '¡Desactivado!',
                    text: data.message,
                    timer: 1500,
                    showConfirmButton: false
                });

                // Recargar la tabla
                listarPacientes('');
            } else {
                Swal.fire('Error', data.message, 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            Swal.fire('Error', 'Ocurrió un error al desactivar', 'error');
        });
}