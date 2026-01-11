<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>

<!-- Modal Formulario Servicio -->
<div class="modal fade" id="modalServicio" tabindex="-1" aria-labelledby="modalServicioLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title" id="modalServicioLabel">
                    <i class="fas fa-plus-circle me-2"></i>
                    Nuevo Servicio
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                <form id="formServicio">
                    <input type="hidden" id="servicioId" name="id">

                    <!-- INFORMACIÓN DEL SERVICIO -->
                    <div class="section-title">
                        <i class="fas fa-concierge-bell me-2"></i>Información del Servicio
                    </div>

                    <div class="row g-3">
                        <div class="col-12">
                            <label for="nombre" class="form-label required-field">Nombre del Servicio</label>
                            <input type="text" class="form-control" id="nombre" name="nombre"
                                   placeholder="Ej. Examen de la Vista Completo" required>
                        </div>

                        <div class="col-12">
                            <label for="descripcion" class="form-label">Descripción</label>
                            <textarea class="form-control" id="descripcion" name="descripcion" rows="3"
                                      placeholder="Describe brevemente en qué consiste el servicio..." maxlength="500"></textarea>
                            <small class="text-muted">Máximo 500 caracteres</small>
                        </div>

                        <div class="col-md-6">
                            <label for="precioBase" class="form-label required-field">Precio Base</label>
                            <div class="input-group">
                                <span class="input-group-text">$</span>
                                <input type="number" class="form-control" id="precioBase" name="precioBase"
                                       placeholder="0.00" step="0.01" min="0" required>
                            </div>
                        </div>
                    </div>

                    <!-- Información Adicional -->
                    <div class="section-title mt-4">
                        <i class="fas fa-lightbulb me-2"></i>Información Adicional
                    </div>

                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Nota importante:</strong> El precio base es un valor referencial.
                        Al momento de realizar una venta, podrás ajustar el precio según las necesidades del cliente.
                    </div>

                </form>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-2"></i>Cancelar
                </button>
                <button type="button" class="btn btn-orange" onclick="guardarServicio()">
                    <i class="fas fa-save me-2"></i>Guardar Servicio
                </button>
            </div>

        </div>
    </div>
</div>