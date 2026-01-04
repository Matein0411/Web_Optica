package com.lv.fichas.modelo;

import com.lv.pacientes.modelo.Paciente;
import jakarta.persistence.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

@Entity
@Table(name = "ficha_clinica")
public class FichaClinica {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private LocalDate fecha = LocalDate.now();

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "paciente_id", nullable = false)
    private Paciente paciente;

    @Column(name = "mpc", columnDefinition = "TEXT", nullable = false)
    private String motivoConsulta;

    @Column(name = "ultimo_control_meses")
    private Integer ultimoControlMeses;

    // RX Anterior (Uso actual)
    @Column(name = "rx_ant_od_esfera", length = 20)
    private String rxAntOdEsfera;

    @Column(name = "rx_ant_od_cilindro", length = 20)
    private String rxAntOdCilindro;

    @Column(name = "rx_ant_od_eje", length = 20)
    private String rxAntOdEje;

    @Column(name = "rx_ant_od_add", length = 20)
    private String rxAntOdAdd;

    @Column(name = "rx_ant_od_av_sc", length = 20)
    private String rxAntOdAvSc;

    @Column(name = "rx_ant_od_av_cc", length = 20)
    private String rxAntOdAvCc;

    @Column(name = "rx_ant_od_prismas", length = 50)
    private String rxAntOdPrismas;

    @Column(name = "rx_ant_oi_esfera", length = 20)
    private String rxAntOiEsfera;

    @Column(name = "rx_ant_oi_cilindro", length = 20)
    private String rxAntOiCilindro;

    @Column(name = "rx_ant_oi_eje", length = 20)
    private String rxAntOiEje;

    @Column(name = "rx_ant_oi_add", length = 20)
    private String rxAntOiAdd;

    @Column(name = "rx_ant_oi_av_sc", length = 20)
    private String rxAntOiAvSc;

    @Column(name = "rx_ant_oi_av_cc", length = 20)
    private String rxAntOiAvCc;

    @Column(name = "rx_ant_oi_prismas", length = 50)
    private String rxAntOiPrismas;

    // Examen externo
    @Column(name = "cover_test", length = 150)
    private String coverTest;

    @Column(name = "ppc", length = 50)
    private String ppc;

    @Column(name = "oftalmoscopia_od", length = 255)
    private String oftalmoscopiaOd;

    @Column(name = "retinoscopia_od", length = 255)
    private String retinoscopiaOd;

    @Column(name = "queratometria_od", length = 255)
    private String queratometriaOd;

    @Column(name = "oftalmoscopia_oi", length = 255)
    private String oftalmoscopiaOi;

    @Column(name = "retinoscopia_oi", length = 255)
    private String retinoscopiaOi;

    @Column(name = "queratometria_oi", length = 255)
    private String queratometriaOi;

    // Refracción final (Gafas)
    @Column(name = "rx_final_od_esfera", length = 20)
    private String rxFinalOdEsfera;

    @Column(name = "rx_final_od_cilindro", length = 20)
    private String rxFinalOdCilindro;

    @Column(name = "rx_final_od_eje", length = 20)
    private String rxFinalOdEje;

    @Column(name = "rx_final_od_add", length = 20)
    private String rxFinalOdAdd;

    @Column(name = "rx_final_od_av", length = 20)
    private String rxFinalOdAv;

    @Column(name = "rx_final_od_dnp", length = 20)
    private String rxFinalOdDnp;

    @Column(name = "rx_final_od_prisma", length = 50)
    private String rxFinalOdPrisma;

    @Column(name = "rx_final_oi_esfera", length = 20)
    private String rxFinalOiEsfera;

    @Column(name = "rx_final_oi_cilindro", length = 20)
    private String rxFinalOiCilindro;

    @Column(name = "rx_final_oi_eje", length = 20)
    private String rxFinalOiEje;

    @Column(name = "rx_final_oi_add", length = 20)
    private String rxFinalOiAdd;

    @Column(name = "rx_final_oi_av", length = 20)
    private String rxFinalOiAv;

    @Column(name = "rx_final_oi_dnp", length = 20)
    private String rxFinalOiDnp;

    @Column(name = "rx_final_oi_prisma", length = 50)
    private String rxFinalOiPrisma;

    // Características lentes (materiales / filtros)
    @Column(name = "mat_cristal")
    private Boolean materialCristal = false;

    @Column(name = "mat_cr39")
    private Boolean materialCr39 = false;

    @Column(name = "mat_policarbonato")
    private Boolean materialPolicarbonato = false;

    @Column(name = "mat_progresivo")
    private Boolean materialProgresivo = false;

    @Column(name = "filtro_azul")
    private Boolean filtroAzul = false;

    @Column(name = "filtro_transition")
    private Boolean filtroTransition = false;

    @Column(name = "filtro_anti_reflejante")
    private Boolean filtroAntiReflejante = false;

    @Column(name = "filtro_fotocromatico")
    private Boolean filtroFotocromatico = false;

    // Lentes de contacto (opcional)
    @Column(name = "lc_od_esfera", length = 20)
    private String lcOdEsfera;

    @Column(name = "lc_od_cilindro", length = 20)
    private String lcOdCilindro;

    @Column(name = "lc_od_eje", length = 20)
    private String lcOdEje;

    @Column(name = "lc_od_add", length = 20)
    private String lcOdAdd;

    @Column(name = "lc_od_av", length = 20)
    private String lcOdAv;

    @Column(name = "lc_od_tipo", length = 100)
    private String lcOdTipo;

    @Column(name = "lc_oi_esfera", length = 20)
    private String lcOiEsfera;

    @Column(name = "lc_oi_cilindro", length = 20)
    private String lcOiCilindro;

    @Column(name = "lc_oi_eje", length = 20)
    private String lcOiEje;

    @Column(name = "lc_oi_add", length = 20)
    private String lcOiAdd;

    @Column(name = "lc_oi_av", length = 20)
    private String lcOiAv;

    @Column(name = "lc_oi_tipo", length = 100)
    private String lcOiTipo;

    @Column(name = "observaciones", columnDefinition = "TEXT")
    private String observaciones;

    @Column(nullable = false)
    private Boolean activo = true;

    public FichaClinica() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LocalDate getFecha() {
        return fecha;
    }

    public void setFecha(LocalDate fecha) {
        this.fecha = fecha;
    }

    public Paciente getPaciente() {
        return paciente;
    }

    public void setPaciente(Paciente paciente) {
        this.paciente = paciente;
    }

    public String getMotivoConsulta() {
        return motivoConsulta;
    }

    public void setMotivoConsulta(String motivoConsulta) {
        this.motivoConsulta = motivoConsulta;
    }

    public Integer getUltimoControlMeses() {
        return ultimoControlMeses;
    }

    public void setUltimoControlMeses(Integer ultimoControlMeses) {
        this.ultimoControlMeses = ultimoControlMeses;
    }

    public String getRxAntOdEsfera() {
        return rxAntOdEsfera;
    }

    public void setRxAntOdEsfera(String rxAntOdEsfera) {
        this.rxAntOdEsfera = rxAntOdEsfera;
    }

    public String getRxAntOdCilindro() {
        return rxAntOdCilindro;
    }

    public void setRxAntOdCilindro(String rxAntOdCilindro) {
        this.rxAntOdCilindro = rxAntOdCilindro;
    }

    public String getRxAntOdEje() {
        return rxAntOdEje;
    }

    public void setRxAntOdEje(String rxAntOdEje) {
        this.rxAntOdEje = rxAntOdEje;
    }

    public String getRxAntOdAdd() {
        return rxAntOdAdd;
    }

    public void setRxAntOdAdd(String rxAntOdAdd) {
        this.rxAntOdAdd = rxAntOdAdd;
    }

    public String getRxAntOdAvSc() {
        return rxAntOdAvSc;
    }

    public void setRxAntOdAvSc(String rxAntOdAvSc) {
        this.rxAntOdAvSc = rxAntOdAvSc;
    }

    public String getRxAntOdAvCc() {
        return rxAntOdAvCc;
    }

    public void setRxAntOdAvCc(String rxAntOdAvCc) {
        this.rxAntOdAvCc = rxAntOdAvCc;
    }

    public String getRxAntOdPrismas() {
        return rxAntOdPrismas;
    }

    public void setRxAntOdPrismas(String rxAntOdPrismas) {
        this.rxAntOdPrismas = rxAntOdPrismas;
    }

    public String getRxAntOiEsfera() {
        return rxAntOiEsfera;
    }

    public void setRxAntOiEsfera(String rxAntOiEsfera) {
        this.rxAntOiEsfera = rxAntOiEsfera;
    }

    public String getRxAntOiCilindro() {
        return rxAntOiCilindro;
    }

    public void setRxAntOiCilindro(String rxAntOiCilindro) {
        this.rxAntOiCilindro = rxAntOiCilindro;
    }

    public String getRxAntOiEje() {
        return rxAntOiEje;
    }

    public void setRxAntOiEje(String rxAntOiEje) {
        this.rxAntOiEje = rxAntOiEje;
    }

    public String getRxAntOiAdd() {
        return rxAntOiAdd;
    }

    public void setRxAntOiAdd(String rxAntOiAdd) {
        this.rxAntOiAdd = rxAntOiAdd;
    }

    public String getRxAntOiAvSc() {
        return rxAntOiAvSc;
    }

    public void setRxAntOiAvSc(String rxAntOiAvSc) {
        this.rxAntOiAvSc = rxAntOiAvSc;
    }

    public String getRxAntOiAvCc() {
        return rxAntOiAvCc;
    }

    public void setRxAntOiAvCc(String rxAntOiAvCc) {
        this.rxAntOiAvCc = rxAntOiAvCc;
    }

    public String getRxAntOiPrismas() {
        return rxAntOiPrismas;
    }

    public void setRxAntOiPrismas(String rxAntOiPrismas) {
        this.rxAntOiPrismas = rxAntOiPrismas;
    }

    public String getCoverTest() {
        return coverTest;
    }

    public void setCoverTest(String coverTest) {
        this.coverTest = coverTest;
    }

    public String getPpc() {
        return ppc;
    }

    public void setPpc(String ppc) {
        this.ppc = ppc;
    }

    public String getOftalmoscopiaOd() {
        return oftalmoscopiaOd;
    }

    public void setOftalmoscopiaOd(String oftalmoscopiaOd) {
        this.oftalmoscopiaOd = oftalmoscopiaOd;
    }

    public String getRetinoscopiaOd() {
        return retinoscopiaOd;
    }

    public void setRetinoscopiaOd(String retinoscopiaOd) {
        this.retinoscopiaOd = retinoscopiaOd;
    }

    public String getQueratometriaOd() {
        return queratometriaOd;
    }

    public void setQueratometriaOd(String queratometriaOd) {
        this.queratometriaOd = queratometriaOd;
    }

    public String getOftalmoscopiaOi() {
        return oftalmoscopiaOi;
    }

    public void setOftalmoscopiaOi(String oftalmoscopiaOi) {
        this.oftalmoscopiaOi = oftalmoscopiaOi;
    }

    public String getRetinoscopiaOi() {
        return retinoscopiaOi;
    }

    public void setRetinoscopiaOi(String retinoscopiaOi) {
        this.retinoscopiaOi = retinoscopiaOi;
    }

    public String getQueratometriaOi() {
        return queratometriaOi;
    }

    public void setQueratometriaOi(String queratometriaOi) {
        this.queratometriaOi = queratometriaOi;
    }

    public String getRxFinalOdEsfera() {
        return rxFinalOdEsfera;
    }

    public void setRxFinalOdEsfera(String rxFinalOdEsfera) {
        this.rxFinalOdEsfera = rxFinalOdEsfera;
    }

    public String getRxFinalOdCilindro() {
        return rxFinalOdCilindro;
    }

    public void setRxFinalOdCilindro(String rxFinalOdCilindro) {
        this.rxFinalOdCilindro = rxFinalOdCilindro;
    }

    public String getRxFinalOdEje() {
        return rxFinalOdEje;
    }

    public void setRxFinalOdEje(String rxFinalOdEje) {
        this.rxFinalOdEje = rxFinalOdEje;
    }

    public String getRxFinalOdAdd() {
        return rxFinalOdAdd;
    }

    public void setRxFinalOdAdd(String rxFinalOdAdd) {
        this.rxFinalOdAdd = rxFinalOdAdd;
    }

    public String getRxFinalOdAv() {
        return rxFinalOdAv;
    }

    public void setRxFinalOdAv(String rxFinalOdAv) {
        this.rxFinalOdAv = rxFinalOdAv;
    }

    public String getRxFinalOdDnp() {
        return rxFinalOdDnp;
    }

    public void setRxFinalOdDnp(String rxFinalOdDnp) {
        this.rxFinalOdDnp = rxFinalOdDnp;
    }

    public String getRxFinalOdPrisma() {
        return rxFinalOdPrisma;
    }

    public void setRxFinalOdPrisma(String rxFinalOdPrisma) {
        this.rxFinalOdPrisma = rxFinalOdPrisma;
    }

    public String getRxFinalOiEsfera() {
        return rxFinalOiEsfera;
    }

    public void setRxFinalOiEsfera(String rxFinalOiEsfera) {
        this.rxFinalOiEsfera = rxFinalOiEsfera;
    }

    public String getRxFinalOiCilindro() {
        return rxFinalOiCilindro;
    }

    public void setRxFinalOiCilindro(String rxFinalOiCilindro) {
        this.rxFinalOiCilindro = rxFinalOiCilindro;
    }

    public String getRxFinalOiEje() {
        return rxFinalOiEje;
    }

    public void setRxFinalOiEje(String rxFinalOiEje) {
        this.rxFinalOiEje = rxFinalOiEje;
    }

    public String getRxFinalOiAdd() {
        return rxFinalOiAdd;
    }

    public void setRxFinalOiAdd(String rxFinalOiAdd) {
        this.rxFinalOiAdd = rxFinalOiAdd;
    }

    public String getRxFinalOiAv() {
        return rxFinalOiAv;
    }

    public void setRxFinalOiAv(String rxFinalOiAv) {
        this.rxFinalOiAv = rxFinalOiAv;
    }

    public String getRxFinalOiDnp() {
        return rxFinalOiDnp;
    }

    public void setRxFinalOiDnp(String rxFinalOiDnp) {
        this.rxFinalOiDnp = rxFinalOiDnp;
    }

    public String getRxFinalOiPrisma() {
        return rxFinalOiPrisma;
    }

    public void setRxFinalOiPrisma(String rxFinalOiPrisma) {
        this.rxFinalOiPrisma = rxFinalOiPrisma;
    }

    public Boolean getMaterialCristal() {
        return materialCristal;
    }

    public void setMaterialCristal(Boolean materialCristal) {
        this.materialCristal = materialCristal;
    }

    public Boolean getMaterialCr39() {
        return materialCr39;
    }

    public void setMaterialCr39(Boolean materialCr39) {
        this.materialCr39 = materialCr39;
    }

    public Boolean getMaterialPolicarbonato() {
        return materialPolicarbonato;
    }

    public void setMaterialPolicarbonato(Boolean materialPolicarbonato) {
        this.materialPolicarbonato = materialPolicarbonato;
    }

    public Boolean getMaterialProgresivo() {
        return materialProgresivo;
    }

    public void setMaterialProgresivo(Boolean materialProgresivo) {
        this.materialProgresivo = materialProgresivo;
    }

    public Boolean getFiltroAzul() {
        return filtroAzul;
    }

    public void setFiltroAzul(Boolean filtroAzul) {
        this.filtroAzul = filtroAzul;
    }

    public Boolean getFiltroTransition() {
        return filtroTransition;
    }

    public void setFiltroTransition(Boolean filtroTransition) {
        this.filtroTransition = filtroTransition;
    }

    public Boolean getFiltroAntiReflejante() {
        return filtroAntiReflejante;
    }

    public void setFiltroAntiReflejante(Boolean filtroAntiReflejante) {
        this.filtroAntiReflejante = filtroAntiReflejante;
    }

    public Boolean getFiltroFotocromatico() {
        return filtroFotocromatico;
    }

    public void setFiltroFotocromatico(Boolean filtroFotocromatico) {
        this.filtroFotocromatico = filtroFotocromatico;
    }

    public String getLcOdEsfera() {
        return lcOdEsfera;
    }

    public void setLcOdEsfera(String lcOdEsfera) {
        this.lcOdEsfera = lcOdEsfera;
    }

    public String getLcOdCilindro() {
        return lcOdCilindro;
    }

    public void setLcOdCilindro(String lcOdCilindro) {
        this.lcOdCilindro = lcOdCilindro;
    }

    public String getLcOdEje() {
        return lcOdEje;
    }

    public void setLcOdEje(String lcOdEje) {
        this.lcOdEje = lcOdEje;
    }

    public String getLcOdAdd() {
        return lcOdAdd;
    }

    public void setLcOdAdd(String lcOdAdd) {
        this.lcOdAdd = lcOdAdd;
    }

    public String getLcOdAv() {
        return lcOdAv;
    }

    public void setLcOdAv(String lcOdAv) {
        this.lcOdAv = lcOdAv;
    }

    public String getLcOdTipo() {
        return lcOdTipo;
    }

    public void setLcOdTipo(String lcOdTipo) {
        this.lcOdTipo = lcOdTipo;
    }

    public String getLcOiEsfera() {
        return lcOiEsfera;
    }

    public void setLcOiEsfera(String lcOiEsfera) {
        this.lcOiEsfera = lcOiEsfera;
    }

    public String getLcOiCilindro() {
        return lcOiCilindro;
    }

    public void setLcOiCilindro(String lcOiCilindro) {
        this.lcOiCilindro = lcOiCilindro;
    }

    public String getLcOiEje() {
        return lcOiEje;
    }

    public void setLcOiEje(String lcOiEje) {
        this.lcOiEje = lcOiEje;
    }

    public String getLcOiAdd() {
        return lcOiAdd;
    }

    public void setLcOiAdd(String lcOiAdd) {
        this.lcOiAdd = lcOiAdd;
    }

    public String getLcOiAv() {
        return lcOiAv;
    }

    public void setLcOiAv(String lcOiAv) {
        this.lcOiAv = lcOiAv;
    }

    public String getLcOiTipo() {
        return lcOiTipo;
    }

    public void setLcOiTipo(String lcOiTipo) {
        this.lcOiTipo = lcOiTipo;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public Boolean getActivo() {
        return activo;
    }

    public void setActivo(Boolean activo) {
        this.activo = activo;
    }

    @Transient
    public String getFechaFormateada() {
        if (fecha == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy", new Locale("es", "EC"));
        return fecha.format(formatter);
    }

    @Transient
    public String getPacienteNombreCompleto() {
        if (paciente == null) return "";
        return paciente.getNombreCompleto();
    }

    @Transient
    public String getPacienteCedula() {
        if (paciente == null) return "";
        return paciente.getCedula();
    }
}

