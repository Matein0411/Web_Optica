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
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>

<jsp:include page="../comun/siderbar.jsp">
    <jsp:param name="activeMenu" value="fichas" />
</jsp:include>

<jsp:include page="../comun/header.jsp" />

<main class="main-content">
    <h2 class="page-title">Fichas Clínicas</h2>

    <div class="row mb-4 align-items-center">
        <div class="col-md-6">
            <div class="input-group shadow-sm">
                <span class="input-group-text bg-white ps-3">
                    <i class="fas fa-search"></i>
                </span>
                <input type="text" id="searchInput" class="form-control py-2" placeholder="Buscar Ficha por Nombre o CI del Paciente">
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
                        <td class="text-nowrap text-secondary">${ficha.fecha}</td>
                        <td>
                            <div class="fw-bold text-capitalize">${ficha.paciente.nombre} ${ficha.paciente.apellido}</div>
                            <small class="text-muted">${ficha.paciente.cedula}</small>
                        </td>
                        <td>${ficha.motivoConsulta}</td>
                        <td class="text-end">
                            <button class="btn btn-light text-primary shadow-sm" title="Editar"
                                    onclick="editarFicha(${ficha.id})">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-light text-danger shadow-sm" title="Anular"
                                    onclick="confirmarAnularFicha(${ficha.id}, '${ficha.paciente.nombre} ${ficha.paciente.apellido}')">
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
</script>

<script src="${pageContext.request.contextPath}/js/fichas.js"></script>

</body>
</html>