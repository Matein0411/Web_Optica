<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventario - Óptica Latitud Visual</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
<!-- Sidebar -->
<jsp:include page="../comun/siderbar.jsp">
    <jsp:param name="activeMenu" value="inventario" />
</jsp:include>

<!-- Header -->
<jsp:include page="../comun/header.jsp" />

<!-- Main Content -->
<main class="main-content">
    <h2 class="page-title">Inventario</h2>

    <!-- FILTROS POR CATEGORÍA -->
    <ul class="nav nav-pills mb-4 gap-2" id="categoriasPills">
        <li class="nav-item">
            <a class="nav-link active" href="#" data-categoria="todos">Todos</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#" data-categoria="armazones">
                <i class="fas fa-glasses me-2"></i>Armazones
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#" data-categoria="gafas">
                <i class="fas fa-sun me-2"></i>Gafas
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#" data-categoria="lentes_contacto">
                <i class="fas fa-eye me-2"></i>Lentes Contacto
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#" data-categoria="accesorios">
                <i class="fas fa-spray-can me-2"></i>Accesorios
            </a>
        </li>
    </ul>

    <!-- Barra búsqueda y botón agregar -->
    <div class="row mb-4 align-items-center">
        <div class="col-md-6">
            <div class="input-group shadow-sm">
                    <span class="input-group-text bg-white ps-3">
                        <i class="fas fa-search"></i>
                    </span>
                <input type="text" id="searchInput" class="form-control py-2"
                       placeholder="Buscar por Código SKU, Marca o Modelo">
            </div>
        </div>

        <div class="col-md-6 text-md-end">
            <button class="btn btn-orange" onclick="abrirModalNuevo()">
                <i class="fas fa-plus"></i> Nuevo Producto
            </button>
        </div>
    </div>

    <!-- Tabla inventario -->
    <div class="card-table">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th style="width: 60px;">Img</th>
                    <th>Producto / Modelo</th>
                    <th>Código SKU</th>
                    <th>Categoría</th>
                    <th>Stock</th>
                    <th>Precio Venta</th>
                    <th class="text-end">Acciones</th>
                </tr>
                </thead>
                <tbody id="tablaProductos">
                <c:if test="${empty productos}">
                    <tr>
                        <td colspan="7" class="text-center text-muted py-4">
                            <i class="fas fa-search fa-2x mb-2"></i>
                            <p>No se encontraron productos registrados</p>
                        </td>
                    </tr>
                </c:if>

                <c:forEach items="${productos}" var="producto">
                    <tr>
                        <td>
                            <c:choose>
                                <c:when test="${not empty producto.imagen}">
                                    <img src="${pageContext.request.contextPath}/inventario?accion=imagen&id=${producto.id}"
                                         class="product-thumb" alt="Producto">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://cdn-icons-png.flaticon.com/512/83/83564.png"
                                         class="product-thumb" alt="Producto">
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="fw-bold">${producto.nombre}</div>
                            <small class="text-muted">
                                ${producto.marca != null && !producto.marca.isEmpty() ? producto.marca : 'Sin marca'}
                            </small>
                        </td>
                        <td class="font-monospace text-secondary">${producto.codigoSku}</td>
                        <td>
                            <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25">
                                <c:choose>
                                    <c:when test="${producto.categoria == 'armazones'}">Armazones</c:when>
                                    <c:when test="${producto.categoria == 'gafas'}">Gafas</c:when>
                                    <c:when test="${producto.categoria == 'lentes_contacto'}">Lentes Contacto</c:when>
                                    <c:when test="${producto.categoria == 'accesorios'}">Accesorios</c:when>
                                    <c:otherwise>${producto.categoria}</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${producto.stock > 0}">
                                    <span class="fw-bold text-success">${producto.stock} u.</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="fw-bold text-danger">${producto.stock} u.</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="fw-bold">
                            <fmt:formatNumber value="${producto.precioVenta}" type="currency" currencySymbol="$" minFractionDigits="2" maxFractionDigits="2"/>
                        </td>
                        <td class="text-end">
                            <button class="btn btn-light text-primary shadow-sm" title="Editar"
                                    onclick="editarProducto(${producto.id})">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-light text-danger shadow-sm" title="Desactivar"
                                    onclick="confirmarDesactivar(${producto.id}, '${producto.nombre}')">
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

<!-- Modal Producto -->
<jsp:include page="FormularioProducto.jsp" />

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/inventario.js"></script>
</body>
</html>

