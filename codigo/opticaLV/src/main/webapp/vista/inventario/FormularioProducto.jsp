<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Modal Producto -->
<div class="modal fade" id="modalProducto" tabindex="-1" aria-labelledby="modalProductoLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title" id="modalProductoLabel">
                    <i class="fas fa-box me-2"></i>
                    Nuevo Producto
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                <form id="formProducto">
                    <input type="hidden" id="productoId" name="id">

                    <!-- SELECTOR DE TIPO DE PRODUCTO -->
                    <div class="mb-4 p-3 bg-light rounded border shadow-sm">
                        <label for="categoria" class="form-label fw-bold text-dark required-field">Tipo de Producto</label>
                        <select class="form-select border-secondary" id="categoria" name="categoria" required>
                            <option value="armazones">Armazones Oftálmicos</option>
                            <option value="gafas">Gafas de Sol</option>
                            <option value="lentes_contacto">Lentes de Contacto</option>
                            <option value="accesorios">Accesorios</option>
                        </select>
                    </div>

                    <!-- DATOS GENERALES -->
                    <div class="section-title">
                        <i class="fas fa-info-circle me-2"></i>Datos Generales
                    </div>

                    <div class="row g-3">
                        <div class="col-12">
                            <label for="imagenProducto" class="form-label">Imagen del Producto</label>
                            <input class="form-control" type="file" id="imagenProducto" name="imagenProducto" accept="image/*">
                            <small class="text-muted">Opcional</small>
                        </div>

                        <div class="col-md-6">
                            <label for="codigoSku" class="form-label required-field">Código SKU</label>
                            <input type="text" class="form-control" id="codigoSku" name="codigoSku"
                                   placeholder="Ej. RB-3025" required>
                        </div>

                        <div class="col-md-6">
                            <label for="nombre" class="form-label required-field">Nombre</label>
                            <input type="text" class="form-control" id="nombre" name="nombre"
                                   placeholder="Ej. Aviator Large Metal" required>
                        </div>

                        <div class="col-md-4">
                            <label for="marca" class="form-label">Marca</label>
                            <input type="text" class="form-control" id="marca" name="marca" placeholder="Ej. Ray-Ban">
                        </div>

                        <div class="col-md-4">
                            <label for="stock" class="form-label required-field">Stock</label>
                            <input type="number" class="form-control" id="stock" name="stock" value="0" min="0" required>
                        </div>

                        <div class="col-md-4">
                            <label for="precioVenta" class="form-label required-field">Precio Venta ($)</label>
                            <input type="number" class="form-control" id="precioVenta" name="precioVenta"
                                   step="0.01" min="0" placeholder="0.00" required>
                        </div>

                        <div class="col-12">
                            <label for="descripcion" class="form-label">Descripción</label>
                            <textarea class="form-control" id="descripcion" name="descripcion" rows="2"
                                      placeholder="Ej. Lente gris degradado | Polarizado" maxlength="500"></textarea>
                            <small class="text-muted">Máximo 500 caracteres</small>
                        </div>
                    </div>

                    <!-- ESPECIFICACIONES TÉCNICAS -->
                    <div class="section-title">
                        <i class="fas fa-cogs me-2"></i>Especificaciones Técnicas
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="formaEstilo" class="form-label">Forma / Estilo</label>
                            <select class="form-select" id="formaEstilo" name="formaEstilo">
                                <option value="">Seleccionar...</option>
                                <option>Rectangular</option>
                                <option>Redondo</option>
                                <option>Aviador</option>
                                <option>Cuadrado</option>
                                <option>Ojo de Gato</option>
                                <option>Ovalado</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="material" class="form-label">Material</label>
                            <select class="form-select" id="material" name="material">
                                <option value="">Seleccionar...</option>
                                <option>Acetato</option>
                                <option>Metal</option>
                                <option>Titanio</option>
                                <option>TR90</option>
                                <option>Inyectado</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label for="genero" class="form-label">Género</label>
                            <select class="form-select" id="genero" name="genero">
                                <option value="">Seleccionar...</option>
                                <option>Hombre</option>
                                <option>Mujer</option>
                                <option>Unisex</option>
                                <option>Niño</option>
                                <option>Niña</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label for="color" class="form-label">Color Principal</label>
                            <input type="text" class="form-control" id="color" name="color" placeholder="Ej. Negro Mate">
                        </div>

                        <div class="col-md-4">
                            <label for="medidas" class="form-label">Medidas (mm)</label>
                            <input type="text" class="form-control" id="medidas" name="medidas" placeholder="Ej. 55-18-145">
                            <small class="text-muted">Calibre - Puente - Varilla</small>
                        </div>
                    </div>
                </form>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-2"></i>Cancelar
                </button>
                <button type="button" class="btn btn-orange" onclick="guardarProducto()">
                    <i class="fas fa-save me-2"></i>Guardar Producto
                </button>
            </div>

        </div>
    </div>
</div>

