// inventario.js - Funciones para gestión de inventario

let searchTimeout;
let categoriaActual = 'todos';

const searchInput = document.getElementById('searchInput');
if (searchInput) {
    searchInput.addEventListener('input', function (e) {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => {
            listarProductos(e.target.value, categoriaActual);
        }, 500);
    });
}

const categoriasPills = document.getElementById('categoriasPills');
if (categoriasPills) {
    categoriasPills.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', function (e) {
            e.preventDefault();

            categoriasPills.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
            this.classList.add('active');

            categoriaActual = this.dataset.categoria || 'todos';
            listarProductos(searchInput ? searchInput.value : '', categoriaActual);
        });
    });
}

function listarProductos(criterio = '', categoria = 'todos') {
    const url = contextPath + '/inventario?accion=buscar&criterio=' + encodeURIComponent(criterio || '') +
        '&categoria=' + encodeURIComponent(categoria || 'todos');

    fetch(url)
        .then(response => {
            if (!response.ok) throw new Error('Error en la red');
            return response.json();
        })
        .then(productos => {
            actualizarTabla(productos);
        })
        .catch(error => console.error('Error al listar:', error));
}

function actualizarTabla(productos) {
    const tbody = document.getElementById('tablaProductos');

    if (!productos || productos.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="7" class="text-center text-muted py-4">
                    <i class="fas fa-search fa-2x mb-2"></i>
                    <p>No se encontraron productos</p>
                </td>
            </tr>`;
        return;
    }

    tbody.innerHTML = productos.map(p => {
        const imgSrc = p.tieneImagen
            ? `${contextPath}/inventario?accion=imagen&id=${p.id}`
            : 'https://cdn-icons-png.flaticon.com/512/83/83564.png';

        const stock = Number(p.stock || 0);
        const stockClass = stock > 0 ? 'text-success' : 'text-danger';

        const precio = (p.precioVenta != null && p.precioVenta !== '')
            ? `$${parseFloat(p.precioVenta).toFixed(2)}`
            : '$0.00';

        const extra = (p.descripcion && p.descripcion.trim())
            ? p.descripcion
            : (p.marca && p.marca.trim() ? p.marca : 'Sin marca');

        const nombreEscaped = (p.nombre || '').replace(/'/g, "\\'");

        return `
            <tr>
                <td><img src="${imgSrc}" class="product-thumb" alt="Producto"></td>
                <td>
                    <div class="fw-bold">${p.nombre || ''}</div>
                    <small class="text-muted">${extra}</small>
                </td>
                <td class="font-monospace text-secondary">${p.codigoSku || ''}</td>
                <td>
                    <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25">
                        ${categoriaLabel(p.categoria)}
                    </span>
                </td>
                <td><span class="fw-bold ${stockClass}">${stock} u.</span></td>
                <td class="fw-bold">${precio}</td>
                <td class="text-end">
                    <button class="btn btn-light text-primary shadow-sm" title="Editar" onclick="editarProducto(${p.id})">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-light text-danger shadow-sm" title="Desactivar"
                            onclick="confirmarDesactivar(${p.id}, '${nombreEscaped}')">
                        <i class="fas fa-trash-alt"></i>
                    </button>
                </td>
            </tr>`;
    }).join('');
}

function categoriaLabel(categoria) {
    switch ((categoria || '').toLowerCase()) {
        case 'armazones':
            return 'Armazones';
        case 'gafas':
            return 'Gafas';
        case 'lentes_contacto':
            return 'Lentes Contacto';
        case 'accesorios':
            return 'Accesorios';
        default:
            return categoria || '';
    }
}

function abrirModalNuevo() {
    document.getElementById('formProducto').reset();
    document.getElementById('productoId').value = '';
    document.getElementById('modalProductoLabel').innerHTML =
        '<i class="fas fa-box me-2"></i>Nuevo Producto';

    const modal = new bootstrap.Modal(document.getElementById('modalProducto'));
    modal.show();
}

function editarProducto(id) {
    const url = contextPath + '/inventario?accion=obtener&id=' + id;

    fetch(url)
        .then(response => {
            if (!response.ok) throw new Error('Error al obtener producto');
            return response.json();
        })
        .then(producto => {
            document.getElementById('productoId').value = producto.id;
            document.getElementById('categoria').value = producto.categoria || 'armazones';
            document.getElementById('codigoSku').value = producto.codigoSku || '';
            document.getElementById('nombre').value = producto.nombre || '';
            document.getElementById('marca').value = producto.marca || '';
            document.getElementById('stock').value = producto.stock != null ? producto.stock : 0;
            document.getElementById('precioVenta').value = producto.precioVenta != null ? producto.precioVenta : '';
            document.getElementById('descripcion').value = producto.descripcion || '';
            document.getElementById('formaEstilo').value = producto.formaEstilo || '';
            document.getElementById('material').value = producto.material || '';
            document.getElementById('genero').value = producto.genero || '';
            document.getElementById('color').value = producto.color || '';
            document.getElementById('medidas').value = producto.medidas || '';

            document.getElementById('modalProductoLabel').innerHTML =
                '<i class="fas fa-edit me-2"></i>Editar Producto';

            const modal = new bootstrap.Modal(document.getElementById('modalProducto'));
            modal.show();
        })
        .catch(error => {
            console.error('Error:', error);
            Swal.fire('Error', 'No se pudo cargar la información del producto', 'error');
        });
}

function guardarProducto() {
    const form = document.getElementById('formProducto');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    const formData = new FormData(form);
    const id = document.getElementById('productoId').value;
    formData.append('accion', id ? 'editar' : 'guardar');
    if (id) formData.append('id', id);

    fetch(contextPath + '/inventario', {
        method: 'POST',
        body: formData
    })
        .then(response => {
            if (!response.ok) throw new Error('Error en la petición');
            return response.json();
        })
        .then(data => {
            if (data.success === true || data.success === 'true') {
                const modalEl = document.getElementById('modalProducto');
                const modalInstance = bootstrap.Modal.getInstance(modalEl);
                modalInstance.hide();

                Swal.fire({
                    icon: 'success',
                    title: 'Éxito',
                    text: data.message,
                    timer: 1500,
                    showConfirmButton: false
                });

                listarProductos(searchInput ? searchInput.value : '', categoriaActual);
            } else {
                Swal.fire('Error', data.message || 'No se pudo guardar', 'error');
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
        text: `¿Desea desactivar el producto "${nombre}"?`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Sí, desactivar',
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        if (result.isConfirmed) {
            desactivarProducto(id);
        }
    });
}

function desactivarProducto(id) {
    const formData = new FormData();
    formData.append('accion', 'desactivar');
    formData.append('id', id);

    fetch(contextPath + '/inventario', {
        method: 'POST',
        body: formData
    })
        .then(response => {
            if (!response.ok) throw new Error('Error en la petición');
            return response.json();
        })
        .then(data => {
            if (data.success === true || data.success === 'true') {
                Swal.fire({
                    icon: 'success',
                    title: 'Desactivado',
                    text: data.message,
                    timer: 1500,
                    showConfirmButton: false
                });

                listarProductos(searchInput ? searchInput.value : '', categoriaActual);
            } else {
                Swal.fire('Error', data.message || 'No se pudo desactivar', 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            Swal.fire('Error', 'Ocurrió un error al desactivar.', 'error');
        });
}

