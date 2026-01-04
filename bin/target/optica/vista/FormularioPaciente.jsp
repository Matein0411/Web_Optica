<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Modal Paciente -->
<div class="modal fade" id="modalPaciente" tabindex="-1" aria-labelledby="modalPacienteLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            
            <div class="modal-header">
                <h5 class="modal-title" id="modalPacienteLabel">
                    <i class="fas fa-user-plus me-2"></i>
                    Nuevo Paciente
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            
            <div class="modal-body">
                <form id="formPaciente">
                    <input type="hidden" id="pacienteId" name="id">
                    
                    <!-- DATOS PERSONALES -->
                    <div class="section-title">
                        <i class="fas fa-user me-2"></i>Datos Personales
                    </div>
                    
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="nombre" class="form-label required-field">Nombre</label>
                            <input type="text" class="form-control" id="nombre" name="nombre" 
                                   placeholder="Ej. Juan Carlos" required>
                        </div>
                        
                        <div class="col-md-6">
                            <label for="apellido" class="form-label required-field">Apellido</label>
                            <input type="text" class="form-control" id="apellido" name="apellido" 
                                   placeholder="Ej. Pérez López" required>
                        </div>
                        
                        <div class="col-md-6">
                            <label for="cedula" class="form-label required-field">Cédula</label>
                            <input type="text" class="form-control" id="cedula" name="cedula" 
                                   placeholder="0123456789" maxlength="10" required>
                            <small class="text-muted">Cédula ecuatoriana de 10 dígitos</small>
                        </div>
                        
                        <div class="col-md-6">
                            <label for="fechaNacimiento" class="form-label required-field">Fecha de Nacimiento</label>
                            <input type="date" class="form-control" id="fechaNacimiento" name="fechaNacimiento" required>
                        </div>
                    </div>

                    <!-- DATOS DE CONTACTO -->
                    <div class="section-title">
                        <i class="fas fa-address-book me-2"></i>Datos de Contacto
                    </div>
                    
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="celular" class="form-label">Celular</label>
                            <input type="tel" class="form-control" id="celular" name="telefono" 
                                   placeholder="0991234567" maxlength="10">
                        </div>
                        
                        <div class="col-md-6">
                            <label for="email" class="form-label">Correo Electrónico</label>
                            <input type="email" class="form-control" id="email" name="email" 
                                   placeholder="ejemplo@correo.com">
                        </div>
                        
                        <div class="col-md-8">
                            <label for="direccion" class="form-label">Dirección</label>
                            <input type="text" class="form-control" id="direccion" name="direccion" 
                                   placeholder="Calle, número, sector">
                        </div>
                        
                        <div class="col-md-4">
                            <label for="ocupacion" class="form-label">Ocupación</label>
                            <input type="text" class="form-control" id="ocupacion" name="ocupacion" 
                                   placeholder="Ej. Profesor">
                        </div>
                    </div>

                    <!-- PERFIL CLÍNICO -->
                    <div class="section-title">
                        <i class="fas fa-notes-medical me-2"></i>Perfil Clínico / Antecedentes
                    </div>
                    
                    <div class="row g-3">
                        <div class="col-12">
                            <label for="antecedentesOculares" class="form-label">Antecedentes Oculares</label>
                            <textarea class="form-control" id="antecedentesOculares" name="antecedentesOculares" 
                                      rows="2" placeholder="Ej. Cirugía de cataratas en 2020, conjuntivitis recurrente..."></textarea>
                        </div>
                        
                        <div class="col-12">
                            <label for="antecedentesMedicos" class="form-label">Antecedentes Médicos</label>
                            <textarea class="form-control" id="antecedentesMedicos" name="antecedentesMedicos" 
                                      rows="2" placeholder="Ej. Diabetes tipo 2, hipertensión arterial..."></textarea>
                        </div>
                        
                        <div class="col-12">
                            <label for="antecedentesFamiliares" class="form-label">Antecedentes Familiares</label>
                            <textarea class="form-control" id="antecedentesFamiliares" name="antecedentesFamiliares" 
                                      rows="2" placeholder="Ej. Padre con glaucoma, madre con miopía alta..."></textarea>
                        </div>
                        
                        <div class="col-12">
                            <label for="antecedentesFarmacologicos" class="form-label">Antecedentes Farmacológicos</label>
                            <textarea class="form-control" id="antecedentesFarmacologicos" name="antecedentesFarmacologicos" 
                                      rows="2" placeholder="Ej. Metformina 850mg cada 12h, Losartán 50mg..."></textarea>
                        </div>
                    </div>

                </form>
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-2"></i>Cancelar
                </button>
                <button type="button" class="btn btn-orange" onclick="guardarPaciente()">
                    <i class="fas fa-save me-2"></i>Guardar Paciente
                </button>
            </div>
            
        </div>
    </div>
</div>