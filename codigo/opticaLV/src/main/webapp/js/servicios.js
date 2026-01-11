// servicios.js - Funciones para gestión de servicios

// Búsqueda en tiempo real
let searchTimeout;
document.getElementById('searchInput').addEventListener('input', function(e) {
    clearTimeout(searchTimeout);
    searchTimeout = setTimeout(() => {
        listarServicios(e.target.value);
    }, 500);
});

function listarServicios(criterio = '') {
    // Usamos accion=buscar para obtener JSON
    const url = contextPath + '/servicios?accion=buscar&criterio=' + encodeURIComponent(criterio);

    fetch(url)
        .then(response => {
            if (!response.ok) throw new Error("Error en la red");
            return response.json();
        })
        .then(servicios => {
            console.log("Servicios recibidos:", servicios); // Debug
            actualizarTabla(servicios);
        })
        .catch(error => {
            console.error('Error al listar:', error);
        });
}

function actualizarTabla(servicios) {
    const tbody = document.getElementById('tablaServicios');

    if (servicios.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="4" class="text-center text-muted py-4">
                    <i class="fas fa-search fa-2x mb-2"></i>
                    <p>No se encontraron servicios</p>
                </td>
            </tr>`;
        return;
    }

    // Renderizado de filas
    tbody.innerHTML = servicios.map(s => `
        <tr>
            <td>
                <div class="fw-bold">${s.nombre}</div>
            </td>
            <td>
                <span class="text-muted">
                    ${s.descripcion ? s.descripcion : '-'}
                </span>
            </td>
            <td>
                <span class="badge-price">$${parseFloat(s.precioBase).toFixed(2)}</span>
            </td>
            <td class="text-end">
                <button class="btn btn-light text-primary shadow-sm" 
                        title="Editar" onclick="editarServicio(${s.id})">
                    <i class="fas fa-edit"></i>
                </button>
                <button class="btn btn-light text-danger shadow-sm" 
                        title="Desactivar" onclick="confirmarDesactivar(${s.id}, '${s.nombre.replace(/'/g, "\\'")}')">
                    <i class="fas fa-trash-alt"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

function abrirModalNuevo() {
    document.getElementById('formServicio').reset();
    document.getElementById('servicioId').value = '';
    document.getElementById('modalServicioLabel').innerHTML =
        '<i class="fas fa-plus-circle me-2"></i>Nuevo Servicio';

    const modal = new bootstrap.Modal(document.getElementById('modalServicio'));
    modal.show();
}

function editarServicio(id) {
    if (!id) {
        console.error("ID inválido para editar");
        return;
    }

    const url = contextPath + "/servicios?accion=obtener&id=" + id;

    fetch(url)
        .then(response => {
            if (!response.ok) throw new Error("Error al obtener servicio");
            return response.json();
        })
        .then(servicio => {
            document.getElementById('servicioId').value = servicio.id;
            document.getElementById('nombre').value = servicio.nombre;
            document.getElementById('descripcion').value = servicio.descripcion || '';
            document.getElementById('precioBase').value = parseFloat(servicio.precioBase).toFixed(2);

            document.getElementById('modalServicioLabel').innerHTML =
                '<i class="fas fa-edit me-2"></i>Editar Servicio';

            const modal = new bootstrap.Modal(document.getElementById('modalServicio'));
            modal.show();
        })
        .catch(error => {
            console.error('Error:', error);
            Swal.fire('Error', 'No se pudo cargar la información del servicio', 'error');
        });
}

function guardarServicio() {
    const form = document.getElementById('formServicio');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    const formData = new FormData(form);
    const id = document.getElementById('servicioId').value;
    formData.append('accion', id ? 'editar' : 'guardar');
    if (id) {
        formData.append('id', id);
    }

    fetch(contextPath + '/servicios', {
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
                const modalElement = document.getElementById('modalServicio');
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
                listarServicios('');
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
        text: `¿Desea desactivar el servicio "${nombre}"?`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Sí, desactivar',
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        if (result.isConfirmed) {
            desactivarServicio(id);
        }
    });
}

function desactivarServicio(id) {
    const formData = new FormData();
    formData.append('accion', 'desactivar');
    formData.append('id', id);

    fetch(contextPath + '/servicios', {
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
                listarServicios('');
            } else {
                Swal.fire('Error', data.message, 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            Swal.fire('Error', 'Ocurrió un error al desactivar', 'error');
        });
}