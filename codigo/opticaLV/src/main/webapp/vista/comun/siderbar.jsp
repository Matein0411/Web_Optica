<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Sidebar -->
<nav class="sidebar">
    <div class="sidebar-header">
        <a href="#" class="brand-badge">
            <img src="${pageContext.request.contextPath}/resources/img/logo.png" alt="logo" class="sidebar-logo-img">
            <div class="d-flex flex-column">
                <span class="brand-text-small">OPTICA</span>
                <span class="brand-text-main">LATITUD VISUAL</span>
            </div>
        </a>
    </div>
    <div class="sidebar-menu">
        <a href="${pageContext.request.contextPath}/pacientes" class="nav-link ${param.activeMenu == 'pacientes' ? 'active' : ''}">
            <i class="fa fa-users"></i> Pacientes
        </a>
        <a href="${pageContext.request.contextPath}/inventario" class="nav-link ${param.activeMenu == 'inventario' ? 'active' : ''}">
            <i class="fa fa-boxes"></i> Inventario
        </a>
        <a href="${pageContext.request.contextPath}/servicios" class="nav-link ${param.activeMenu == 'servicios' ? 'active' : ''}">
            <i class="fa fa-concierge-bell"></i> Servicios
        </a>
        <a href="${pageContext.request.contextPath}/ventas" class="nav-link ${param.activeMenu == 'ventas' ? 'active' : ''}">
            <i class="fas fa-cash-register"></i> Ventas
        </a>
        <a href="${pageContext.request.contextPath}/fichas" class="nav-link ${param.activeMenu == 'fichas' ? 'active' : ''}">
            <i class="fa fa-file-medical"></i> Fichas Clínicas
        </a>
    </div>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="logout-link">
            <i class="fa fa-sign-out-alt me-3"></i> Cerrar sesion
        </a>
    </div>
</nav>