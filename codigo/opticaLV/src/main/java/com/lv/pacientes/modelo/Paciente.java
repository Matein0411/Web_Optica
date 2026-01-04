package com.lv.pacientes.modelo;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.Period;

@Entity
@Table(name = "paciente")
public class Paciente {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, length = 100)
    private String nombre;
    
    @Column(nullable = false, length = 100)
    private String apellido;
    
    @Column(nullable = false, unique = true, length = 10)
    private String cedula;
    
    @Column(name = "fecha_nacimiento", nullable = false)
    private LocalDate fechaNacimiento;
    
    @Column(length = 10)
    private String telefono;
    
    @Column(name = "correo_electronico", length = 150)
    private String correoElectronico;
    
    @Column(length = 255)
    private String direccion;
    
    @Column(length = 100)
    private String ocupacion;
    
    @Column(name = "antecedentes_oculares", columnDefinition = "TEXT")
    private String antecedentesOculares;
    
    @Column(name = "antecedentes_medicos", columnDefinition = "TEXT")
    private String antecedentesMedicos;
    
    @Column(name = "antecedentes_familiares", columnDefinition = "TEXT")
    private String antecedentesFamiliares;
    
    @Column(name = "antecedentes_farmacologicos", columnDefinition = "TEXT")
    private String antecedentesFarmacologicos;
    
    @Column(nullable = false)
    private Boolean activo = true;
    
    // Constructores
    public Paciente() {}
    
    // Getters y Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public String getApellido() {
        return apellido;
    }
    
    public void setApellido(String apellido) {
        this.apellido = apellido;
    }
    
    public String getCedula() {
        return cedula;
    }
    
    public void setCedula(String cedula) {
        this.cedula = cedula;
    }
    
    public LocalDate getFechaNacimiento() {
        return fechaNacimiento;
    }
    
    public void setFechaNacimiento(LocalDate fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }
    
    public String getTelefono() {
        return telefono;
    }
    
    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }
    
    public String getCorreoElectronico() {
        return correoElectronico;
    }
    
    public void setCorreoElectronico(String correoElectronico) {
        this.correoElectronico = correoElectronico;
    }
    
    public String getDireccion() {
        return direccion;
    }
    
    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }
    
    public String getOcupacion() {
        return ocupacion;
    }
    
    public void setOcupacion(String ocupacion) {
        this.ocupacion = ocupacion;
    }
    
    public String getAntecedentesOculares() {
        return antecedentesOculares;
    }
    
    public void setAntecedentesOculares(String antecedentesOculares) {
        this.antecedentesOculares = antecedentesOculares;
    }
    
    public String getAntecedentesMedicos() {
        return antecedentesMedicos;
    }
    
    public void setAntecedentesMedicos(String antecedentesMedicos) {
        this.antecedentesMedicos = antecedentesMedicos;
    }
    
    public String getAntecedentesFamiliares() {
        return antecedentesFamiliares;
    }
    
    public void setAntecedentesFamiliares(String antecedentesFamiliares) {
        this.antecedentesFamiliares = antecedentesFamiliares;
    }
    
    public String getAntecedentesFarmacologicos() {
        return antecedentesFarmacologicos;
    }
    
    public void setAntecedentesFarmacologicos(String antecedentesFarmacologicos) {
        this.antecedentesFarmacologicos = antecedentesFarmacologicos;
    }
    
    public Boolean getActivo() {
        return activo;
    }
    
    public void setActivo(Boolean activo) {
        this.activo = activo;
    }
    
    // Método helper para calcular edad
    @Transient
    public int getEdad() {
        if (fechaNacimiento != null) {
            return Period.between(fechaNacimiento, LocalDate.now()).getYears();
        }
        return 0;
    }
    
    // Método helper para nombre completo
    @Transient
    public String getNombreCompleto() {
        return nombre + " " + apellido;
    }
}