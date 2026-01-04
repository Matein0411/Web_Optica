<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pacientes - Optica Latitud Visual</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
<!-- Sidebar -->
<jsp:include page="../comun/siderbar.jsp">
    <jsp:param name="activeMenu" value="pacientes" />
</jsp:include>

<!-- Header -->
<jsp:include page="../comun/header.jsp" />

<!-- Main Content -->
<main class="main-content">
    <h2 class="page-title">Pacientes</h2>

    <!-- Barra de búsqueda y botón agregar -->
    <div class="row mb-4 align-items-center">
        <div class="col-md-6">
            <div class="input-group shadow-sm">
                    <span class="input-group-text bg-white ps-3">
                        <i class="fas fa-search"></i>
                    </span>
                <input type="text" id="searchInput" class="form-control py-2"
                       placeholder="Buscar por Cédula o Nombre">
            </div>
        </div>

        <div class="col-md-6 text-md-end">
            <button class="btn btn-orange" onclick="abrirModalNuevo()">
                <i class="fas fa-user-plus"></i> Nuevo Paciente
            </button>
        </div>
    </div>

    <!-- Tabla de pacientes -->
    <div class="card-table">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th>Nombre Completo</th>
                    <th>Cédula</th>
                    <th>Celular</th>
                    <th>Correo</th>
                    <th class="text-end">Acciones</th>
                </tr>
                </thead>
                <tbody id="tablaPacientes">
                <c:if test="${empty pacientes}">
                    <tr>
                        <td colspan="5" class="text-center text-muted py-4">
                            <i class="fas fa-search fa-2x mb-2"></i>
                            <p>No se encontraron pacientes registrados</p>
                        </td>
                    </tr>
                </c:if>

                <c:forEach items="${pacientes}" var="paciente">
                    <tr>
                        <td>
                            <div class="fw-bold">${paciente.nombreCompleto}</div>
                            <small class="text-muted">${paciente.edad} Años</small>
                        </td>
                        <td>
                            <div>${paciente.cedula}</div>
                        </td>
                        <td>
                            <div>${paciente.telefono != null ? paciente.telefono : '-'}</div>
                        </td>
                        <td>
                                    <span class="text-muted">
                                            ${paciente.correoElectronico != null ? paciente.correoElectronico : '-'}
                                    </span>
                        </td>
                        <td class="text-end">
                            <button class="btn btn-light text-primary shadow-sm"
                                    title="Editar" onclick="editarPaciente(${paciente.id})">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-light text-danger shadow-sm"
                                    title="Desactivar" onclick="confirmarDesactivar(${paciente.id}, '${paciente.nombreCompleto}')">
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

<!-- Modal Paciente -->
<jsp:include page="FormularioPaciente.jsp" />

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/pacientes.js"></script>
</body>
</html>