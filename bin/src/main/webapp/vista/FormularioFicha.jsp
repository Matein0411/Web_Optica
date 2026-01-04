<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Modal Ficha -->
<div class="modal fade" id="modalFicha" tabindex="-1" aria-labelledby="modalFichaLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-scrollable">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title" id="modalFichaLabel">
                    <i class="fas fa-file-medical me-2"></i> Nueva Ficha Clínica
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                <form id="formFicha">
                    <input type="hidden" id="fichaId" name="id">
                    <input type="hidden" id="pacienteId" name="pacienteId">

                    <!-- DATOS BÁSICOS -->
                    <div class="row g-3 mb-4">
                        <div class="col-md-8">
                            <label for="paciente" class="form-label required-field">Paciente</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="fas fa-user"></i></span>
                                <input type="text" class="form-control" id="paciente" placeholder="Selecciona un paciente..." readonly>
                                <button class="btn btn-secondary" type="button" onclick="buscarPaciente()">Buscar</button>
                            </div>
                            <small class="text-muted" id="pacienteCedula"></small>
                        </div>
                    </div>

                    <!-- TABS -->
                    <ul class="nav nav-tabs nav-fill mb-4" id="myTab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active fw-bold tab-custom" id="preliminares-tab" data-bs-toggle="tab"
                                    data-bs-target="#preliminares" type="button" role="tab">
                                <i class="fas fa-stethoscope me-2"></i>Examen Preliminar
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link fw-bold tab-custom" id="lunas-tab" data-bs-toggle="tab"
                                    data-bs-target="#lunas" type="button" role="tab">
                                <i class="fas fa-glasses me-2"></i>Refracción (Lunas)
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link fw-bold tab-custom" id="contactos-tab" data-bs-toggle="tab"
                                    data-bs-target="#contactos" type="button" role="tab">
                                <i class="fas fa-eye me-2"></i>Lentes de Contacto
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="myTabContent">

                        <!-- TAB 1: EXAMEN PRELIMINAR -->
                        <div class="tab-pane fade show active" id="preliminares" role="tabpanel">

                            <!-- SECCIÓN 1: ANAMNESIS -->
                            <div class="section-title">
                                <i class="fas fa-clipboard-list me-2"></i>Anamnesis
                            </div>

                            <div class="row g-3 mb-4">
                                <div class="col-md-8">
                                    <label for="mpc" class="form-label required-field">Motivo de Consulta (MPC)</label>
                                    <textarea class="form-control" id="mpc" name="mpc" rows="2"
                                              placeholder="Ej. Dificultad para ver de cerca, dolor de cabeza..." required></textarea>
                                </div>
                                <div class="col-md-4">
                                    <label for="ultimoControlMeses" class="form-label">Último Control (en meses)</label>
                                    <input type="number" class="form-control" id="ultimoControlMeses" name="ultimoControlMeses" placeholder="Ej. 2">
                                </div>
                            </div>

                            <!-- SECCIÓN 2: RX ANTERIOR -->
                            <div class="section-title">
                                <i class="fas fa-history me-2"></i>RX Anterior (Uso Actual)
                            </div>

                            <div class="table-responsive mb-4">
                                <table class="table table-bordered table-sm text-center align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th>Ojo</th>
                                        <th>Esfera</th>
                                        <th>Cilindro</th>
                                        <th>Eje</th>
                                        <th>ADD</th>
                                        <th>AV SC</th>
                                        <th>AV CC</th>
                                        <th>Prismas</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td class="fw-bold bg-light">OD</td>
                                        <td><input type="text" class="form-control form-control-sm border-0 text-center" id="rxAntOdEsfera" name="rxAntOdEsfera"></td>
                                        <td><input type="text" class="form-control form-control-sm border-0 text-center" id="rxAntOdCilindro" name="rxAntOdCilindro"></td>
                                        <td><input type="text" class="form-control form-control-sm border-0 text-center" id="rxAntOdEje" name="rxAntOdEje"></td>
                                        <td><input type="text" class="form-control form-control-sm border-0 text-center" id="rxAntOdAdd" name="rxAntOdAdd"></td>
                                        <td><input type="text" class="form-control form-control-sm border-0 text-center" id="rxAntOdAvSc" name="rxAntOdAvSc"></td>
                                        <td><input type="text" class="form-control form-control-sm border-0 text-center" id="rxAntOdAvCc" name="rxAntOdAvCc"></td>
                                        <td><input type="text" class="form-control form-control-sm border-0 text-center" id="rxAntOdPrismas" name="rxAntOdPrismas"></td>
                                    </tr>
                                    <tr>
                                        <td class="fw-bold bg-light">OI</td>
                                        <td><input type="text" class="form-control form-control-sm border-0 text-center" id="rxAntOiEsfera" name="rxAntOiEsfera"></td>
                                        <td><input type="text" class="form-control form-control-sm border-0 text-center" id="rxAntOiCilindro" name="rxAntOiCilindro"></td>
                                        <td><input type="text" class="form-control form-control-sm border-0 text-center" id="rxAntOiEje" name="rxAntOiEje"></td>
                                        <td><input type="text" class="form-control form-control-sm border-0 text-center" id="rxAntOiAdd" name="rxAntOiAdd"></td>
                                        <td><input type="text" class="form-control form-control-sm border-0 text-center" id="rxAntOiAvSc" name="rxAntOiAvSc"></td>
                                        <td><input type="text" class="form-control form-control-sm border-0 text-center" id="rxAntOiAvCc" name="rxAntOiAvCc"></td>
                                        <td><input type="text" class="form-control form-control-sm border-0 text-center" id="rxAntOiPrismas" name="rxAntOiPrismas"></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>

                            <!-- SECCIÓN 3: EXAMEN EXTERNO -->
                            <div class="section-title">
                                <i class="fas fa-eye-dropper me-2"></i>Examen Externo
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label class="form-label">Cover Test</label>
                                    <input type="text" class="form-control" id="coverTest" name="coverTest" placeholder="Ej. Ortoforia">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">PPC (Punto Próximo de Convergencia)</label>
                                    <input type="text" class="form-control" id="ppc" name="ppc" placeholder="Ej. 8cm">
                                </div>
                            </div>

                            <h6 class="fw-bold mb-3 text-muted" style="font-size: 0.9rem;">Hallazgos por Ojo</h6>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="card bg-light border">
                                        <div class="card-body">
                                            <h6 class="fw-bold mb-3 text-primary-color">Ojo Derecho (OD)</h6>
                                            <div class="mb-2">
                                                <label class="form-label small fw-bold text-muted">Oftalmoscopía</label>
                                                <input type="text" class="form-control form-control-sm" id="oftalmoscopiaOd" name="oftalmoscopiaOd">
                                            </div>
                                            <div class="mb-2">
                                                <label class="form-label small fw-bold text-muted">Retinoscopía</label>
                                                <input type="text" class="form-control form-control-sm" id="retinoscopiaOd" name="retinoscopiaOd">
                                            </div>
                                            <div class="mb-0">
                                                <label class="form-label small fw-bold text-muted">Queratometría</label>
                                                <input type="text" class="form-control form-control-sm" id="queratometriaOd" name="queratometriaOd">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="card bg-light border">
                                        <div class="card-body">
                                            <h6 class="fw-bold mb-3 text-primary-color">Ojo Izquierdo (OI)</h6>
                                            <div class="mb-2">
                                                <label class="form-label small fw-bold text-muted">Oftalmoscopía</label>
                                                <input type="text" class="form-control form-control-sm" id="oftalmoscopiaOi" name="oftalmoscopiaOi">
                                            </div>
                                            <div class="mb-2">
                                                <label class="form-label small fw-bold text-muted">Retinoscopía</label>
                                                <input type="text" class="form-control form-control-sm" id="retinoscopiaOi" name="retinoscopiaOi">
                                            </div>
                                            <div class="mb-0">
                                                <label class="form-label small fw-bold text-muted">Queratometría</label>
                                                <input type="text" class="form-control form-control-sm" id="queratometriaOi" name="queratometriaOi">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- TAB 2: REFRACCIÓN (LUNAS) -->
                        <div class="tab-pane fade" id="lunas" role="tabpanel">

                            <!-- SECCIÓN 4: REFRACCIÓN FINAL (GAFAS) -->
                            <div class="section-title">
                                <i class="fas fa-glasses me-2"></i>Refracción Final (Gafas)
                            </div>

                            <div class="table-responsive mb-4">
                                <table class="table table-bordered text-center align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th style="width: 50px;">RX</th>
                                        <th>Esfera</th>
                                        <th>Cilindro</th>
                                        <th>Eje</th>
                                        <th>ADD</th>
                                        <th>AV</th>
                                        <th>DNP</th>
                                        <th>Prisma</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td class="fw-bold bg-light">OD</td>
                                        <td><input type="text" class="form-control text-center fw-bold" id="rxFinalOdEsfera" name="rxFinalOdEsfera"></td>
                                        <td><input type="text" class="form-control text-center" id="rxFinalOdCilindro" name="rxFinalOdCilindro"></td>
                                        <td><input type="text" class="form-control text-center" id="rxFinalOdEje" name="rxFinalOdEje"></td>
                                        <td><input type="text" class="form-control text-center" id="rxFinalOdAdd" name="rxFinalOdAdd"></td>
                                        <td><input type="text" class="form-control text-center" id="rxFinalOdAv" name="rxFinalOdAv"></td>
                                        <td><input type="text" class="form-control text-center" id="rxFinalOdDnp" name="rxFinalOdDnp"></td>
                                        <td><input type="text" class="form-control text-center" id="rxFinalOdPrisma" name="rxFinalOdPrisma"></td>
                                    </tr>
                                    <tr>
                                        <td class="fw-bold bg-light">OI</td>
                                        <td><input type="text" class="form-control text-center fw-bold" id="rxFinalOiEsfera" name="rxFinalOiEsfera"></td>
                                        <td><input type="text" class="form-control text-center" id="rxFinalOiCilindro" name="rxFinalOiCilindro"></td>
                                        <td><input type="text" class="form-control text-center" id="rxFinalOiEje" name="rxFinalOiEje"></td>
                                        <td><input type="text" class="form-control text-center" id="rxFinalOiAdd" name="rxFinalOiAdd"></td>
                                        <td><input type="text" class="form-control text-center" id="rxFinalOiAv" name="rxFinalOiAv"></td>
                                        <td><input type="text" class="form-control text-center" id="rxFinalOiDnp" name="rxFinalOiDnp"></td>
                                        <td><input type="text" class="form-control text-center" id="rxFinalOiPrisma" name="rxFinalOiPrisma"></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>

                            <h6 class="fw-bold mb-3 text-muted" style="font-size: 0.9rem;">Características de los Lentes</h6>

                            <div class="card bg-light border-0 p-3">
                                <div class="row g-3">
                                    <div class="col-12">
                                        <label class="form-label fw-bold small text-muted">Materiales</label>
                                        <div class="row g-2">
                                            <div class="col-md-3 col-6">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="chkCristal" name="materialCristal">
                                                    <label class="form-check-label small" for="chkCristal">Cristal</label>
                                                </div>
                                            </div>
                                            <div class="col-md-3 col-6">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="chkCR39" name="materialCr39">
                                                    <label class="form-check-label small" for="chkCR39">CR-39</label>
                                                </div>
                                            </div>
                                            <div class="col-md-3 col-6">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="chkPoly" name="materialPolicarbonato">
                                                    <label class="form-check-label small" for="chkPoly">Policarbonato</label>
                                                </div>
                                            </div>
                                            <div class="col-md-3 col-6">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="chkProgresivo" name="materialProgresivo">
                                                    <label class="form-check-label small" for="chkProgresivo">Progresivo</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label fw-bold small text-muted">Filtros y Tratamientos</label>
                                        <div class="row g-2">
                                            <div class="col-md-3 col-6">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="chkFiltroAzul" name="filtroAzul">
                                                    <label class="form-check-label small" for="chkFiltroAzul">Filtro Azul</label>
                                                </div>
                                            </div>
                                            <div class="col-md-3 col-6">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="chkTransition" name="filtroTransition">
                                                    <label class="form-check-label small" for="chkTransition">Transition</label>
                                                </div>
                                            </div>
                                            <div class="col-md-3 col-6">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="chkAntiReflejante" name="filtroAntiReflejante">
                                                    <label class="form-check-label small" for="chkAntiReflejante">Anti-Reflejante</label>
                                                </div>
                                            </div>
                                            <div class="col-md-3 col-6">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="chkFotocromatico" name="filtroFotocromatico">
                                                    <label class="form-check-label small" for="chkFotocromatico">Fotocromático</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- TAB 3: LENTES DE CONTACTO -->
                        <div class="tab-pane fade" id="contactos" role="tabpanel">

                            <!-- SECCIÓN 5: LENTES DE CONTACTO (OPCIONAL) -->
                            <div class="section-title">
                                <i class="fas fa-eye me-2"></i>Lentes de Contacto (Opcional)
                            </div>

                            <div class="table-responsive mb-4">
                                <table class="table table-bordered text-center align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th style="width: 50px;">RX</th>
                                        <th>Esfera</th>
                                        <th>Cilindro</th>
                                        <th>Eje</th>
                                        <th>ADD</th>
                                        <th>AV</th>
                                        <th>Tipo LC</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td class="fw-bold bg-light">OD</td>
                                        <td><input type="text" class="form-control text-center fw-bold" id="lcOdEsfera" name="lcOdEsfera"></td>
                                        <td><input type="text" class="form-control text-center" id="lcOdCilindro" name="lcOdCilindro"></td>
                                        <td><input type="text" class="form-control text-center" id="lcOdEje" name="lcOdEje"></td>
                                        <td><input type="text" class="form-control text-center" id="lcOdAdd" name="lcOdAdd"></td>
                                        <td><input type="text" class="form-control text-center" id="lcOdAv" name="lcOdAv"></td>
                                        <td><input type="text" class="form-control text-center" id="lcOdTipo" name="lcOdTipo" placeholder="Ej. Tórico Blando"></td>
                                    </tr>
                                    <tr>
                                        <td class="fw-bold bg-light">OI</td>
                                        <td><input type="text" class="form-control text-center fw-bold" id="lcOiEsfera" name="lcOiEsfera"></td>
                                        <td><input type="text" class="form-control text-center" id="lcOiCilindro" name="lcOiCilindro"></td>
                                        <td><input type="text" class="form-control text-center" id="lcOiEje" name="lcOiEje"></td>
                                        <td><input type="text" class="form-control text-center" id="lcOiAdd" name="lcOiAdd"></td>
                                        <td><input type="text" class="form-control text-center" id="lcOiAv" name="lcOiAv"></td>
                                        <td><input type="text" class="form-control text-center" id="lcOiTipo" name="lcOiTipo" placeholder="Ej. Tórico Blando"></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </div>

                    <div class="mt-4">
                        <label for="observaciones" class="form-label fw-bold small text-muted">Observaciones Generales / Diagnóstico</label>
                        <textarea class="form-control" id="observaciones" name="observaciones" rows="2"
                                  placeholder="Ej. Se recomienda uso permanente. Revisión en 6 meses."></textarea>
                    </div>
                </form>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-2"></i>Cancelar
                </button>
                <button type="button" class="btn btn-orange" id="btnGuardarFicha" onclick="guardarFicha()">
                    <i class="fas fa-save me-2"></i>Guardar Ficha
                </button>
            </div>
        </div>
    </div>
</div>

