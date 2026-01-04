package com.lv.fichas.controlador;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import com.lv.fichas.dao.FichaClinicaDAO;
import com.lv.fichas.modelo.FichaClinica;
import com.lv.pacientes.dao.PacienteDAO;
import com.lv.pacientes.modelo.Paciente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/fichas")
@MultipartConfig
public class ControladorFichas extends HttpServlet {

    private FichaClinicaDAO fichaDAO;
    private PacienteDAO pacienteDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        fichaDAO = new FichaClinicaDAO();
        pacienteDAO = new PacienteDAO();

        gson = new GsonBuilder()
                .registerTypeAdapter(LocalDate.class,
                        (JsonSerializer<LocalDate>) (src, typeOfSrc, context) ->
                                context.serialize(src.toString()))
                .create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        try {
            switch (accion) {
                case "listar":
                    listar(request, response);
                    break;
                case "buscar":
                    buscar(request, response);
                    break;
                case "obtener":
                    obtener(request, response);
                    break;
                default:
                    listar(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error en el servidor: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        try {
            switch (accion) {
                case "guardar":
                    guardar(request, response);
                    break;
                case "editar":
                    editar(request, response);
                    break;
                case "desactivar":
                    desactivar(request, response);
                    break;
                default:
                    enviarRespuestaError(response, "Accion no valida");
            }
        } catch (Exception e) {
            e.printStackTrace();
            enviarRespuestaError(response, "Error en el servidor: " + e.getMessage());
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<FichaClinica> fichas = fichaDAO.obtenerActivas();
        request.setAttribute("fichas", fichas);
        request.getRequestDispatcher("/vista/ListaFichas.jsp").forward(request, response);
    }

    private void buscar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String criterio = request.getParameter("criterio");
        List<FichaClinica> fichas;

        if (criterio == null || criterio.trim().isEmpty()) {
            fichas = fichaDAO.obtenerActivas();
        } else {
            fichas = fichaDAO.buscar(criterio.trim());
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(fichas));
    }

    private void obtener(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long id = Long.parseLong(request.getParameter("id"));
        FichaClinica ficha = fichaDAO.obtener(id);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(ficha));
    }

    private void guardar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map<String, String> respuesta = new HashMap<>();

        Long pacienteId = parseLongOrNull(request.getParameter("pacienteId"));
        if (pacienteId == null) {
            enviarRespuestaError(response, "Debe seleccionar un paciente");
            return;
        }

        Paciente paciente = pacienteDAO.obtener(pacienteId);
        if (paciente == null || Boolean.FALSE.equals(paciente.getActivo())) {
            enviarRespuestaError(response, "Paciente no encontrado o inactivo");
            return;
        }

        String mpc = trimToNull(request.getParameter("mpc"));
        if (mpc == null) {
            enviarRespuestaError(response, "El Motivo de Consulta (MPC) es obligatorio");
            return;
        }

        FichaClinica ficha = new FichaClinica();
        ficha.setFecha(LocalDate.now());
        ficha.setPaciente(paciente);
        aplicarCamposDesdeRequest(ficha, request);

        fichaDAO.guardar(ficha);

        respuesta.put("success", "true");
        respuesta.put("message", "Ficha clinica registrada exitosamente");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(respuesta));
    }

    private void editar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long id = parseLongOrNull(request.getParameter("id"));
        if (id == null) {
            enviarRespuestaError(response, "ID no valido");
            return;
        }

        FichaClinica ficha = fichaDAO.obtener(id);
        if (ficha == null) {
            enviarRespuestaError(response, "Ficha no encontrada");
            return;
        }

        Long pacienteId = parseLongOrNull(request.getParameter("pacienteId"));
        if (pacienteId != null) {
            Paciente paciente = pacienteDAO.obtener(pacienteId);
            if (paciente == null || Boolean.FALSE.equals(paciente.getActivo())) {
                enviarRespuestaError(response, "Paciente no encontrado o inactivo");
                return;
            }
            ficha.setPaciente(paciente);
        }

        String mpc = trimToNull(request.getParameter("mpc"));
        if (mpc == null) {
            enviarRespuestaError(response, "El Motivo de Consulta (MPC) es obligatorio");
            return;
        }

        aplicarCamposDesdeRequest(ficha, request);
        fichaDAO.editar(ficha);

        Map<String, String> respuesta = new HashMap<>();
        respuesta.put("success", "true");
        respuesta.put("message", "Ficha clinica actualizada exitosamente");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(respuesta));
    }

    private void desactivar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long id = parseLongOrNull(request.getParameter("id"));
        if (id == null) {
            enviarRespuestaError(response, "ID no valido");
            return;
        }

        fichaDAO.desactivar(id);

        Map<String, String> respuesta = new HashMap<>();
        respuesta.put("success", "true");
        respuesta.put("message", "Ficha eliminada exitosamente");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(respuesta));
    }

    private void aplicarCamposDesdeRequest(FichaClinica ficha, HttpServletRequest request) {
        ficha.setMotivoConsulta(trimToNull(request.getParameter("mpc")));
        ficha.setUltimoControlMeses(parseIntegerOrNull(request.getParameter("ultimoControlMeses")));

        ficha.setRxAntOdEsfera(trimToNull(request.getParameter("rxAntOdEsfera")));
        ficha.setRxAntOdCilindro(trimToNull(request.getParameter("rxAntOdCilindro")));
        ficha.setRxAntOdEje(trimToNull(request.getParameter("rxAntOdEje")));
        ficha.setRxAntOdAdd(trimToNull(request.getParameter("rxAntOdAdd")));
        ficha.setRxAntOdAvSc(trimToNull(request.getParameter("rxAntOdAvSc")));
        ficha.setRxAntOdAvCc(trimToNull(request.getParameter("rxAntOdAvCc")));
        ficha.setRxAntOdPrismas(trimToNull(request.getParameter("rxAntOdPrismas")));

        ficha.setRxAntOiEsfera(trimToNull(request.getParameter("rxAntOiEsfera")));
        ficha.setRxAntOiCilindro(trimToNull(request.getParameter("rxAntOiCilindro")));
        ficha.setRxAntOiEje(trimToNull(request.getParameter("rxAntOiEje")));
        ficha.setRxAntOiAdd(trimToNull(request.getParameter("rxAntOiAdd")));
        ficha.setRxAntOiAvSc(trimToNull(request.getParameter("rxAntOiAvSc")));
        ficha.setRxAntOiAvCc(trimToNull(request.getParameter("rxAntOiAvCc")));
        ficha.setRxAntOiPrismas(trimToNull(request.getParameter("rxAntOiPrismas")));

        ficha.setCoverTest(trimToNull(request.getParameter("coverTest")));
        ficha.setPpc(trimToNull(request.getParameter("ppc")));

        ficha.setOftalmoscopiaOd(trimToNull(request.getParameter("oftalmoscopiaOd")));
        ficha.setRetinoscopiaOd(trimToNull(request.getParameter("retinoscopiaOd")));
        ficha.setQueratometriaOd(trimToNull(request.getParameter("queratometriaOd")));

        ficha.setOftalmoscopiaOi(trimToNull(request.getParameter("oftalmoscopiaOi")));
        ficha.setRetinoscopiaOi(trimToNull(request.getParameter("retinoscopiaOi")));
        ficha.setQueratometriaOi(trimToNull(request.getParameter("queratometriaOi")));

        ficha.setRxFinalOdEsfera(trimToNull(request.getParameter("rxFinalOdEsfera")));
        ficha.setRxFinalOdCilindro(trimToNull(request.getParameter("rxFinalOdCilindro")));
        ficha.setRxFinalOdEje(trimToNull(request.getParameter("rxFinalOdEje")));
        ficha.setRxFinalOdAdd(trimToNull(request.getParameter("rxFinalOdAdd")));
        ficha.setRxFinalOdAv(trimToNull(request.getParameter("rxFinalOdAv")));
        ficha.setRxFinalOdDnp(trimToNull(request.getParameter("rxFinalOdDnp")));
        ficha.setRxFinalOdPrisma(trimToNull(request.getParameter("rxFinalOdPrisma")));

        ficha.setRxFinalOiEsfera(trimToNull(request.getParameter("rxFinalOiEsfera")));
        ficha.setRxFinalOiCilindro(trimToNull(request.getParameter("rxFinalOiCilindro")));
        ficha.setRxFinalOiEje(trimToNull(request.getParameter("rxFinalOiEje")));
        ficha.setRxFinalOiAdd(trimToNull(request.getParameter("rxFinalOiAdd")));
        ficha.setRxFinalOiAv(trimToNull(request.getParameter("rxFinalOiAv")));
        ficha.setRxFinalOiDnp(trimToNull(request.getParameter("rxFinalOiDnp")));
        ficha.setRxFinalOiPrisma(trimToNull(request.getParameter("rxFinalOiPrisma")));

        ficha.setMaterialCristal(isChecked(request, "materialCristal"));
        ficha.setMaterialCr39(isChecked(request, "materialCr39"));
        ficha.setMaterialPolicarbonato(isChecked(request, "materialPolicarbonato"));
        ficha.setMaterialProgresivo(isChecked(request, "materialProgresivo"));

        ficha.setFiltroAzul(isChecked(request, "filtroAzul"));
        ficha.setFiltroTransition(isChecked(request, "filtroTransition"));
        ficha.setFiltroAntiReflejante(isChecked(request, "filtroAntiReflejante"));
        ficha.setFiltroFotocromatico(isChecked(request, "filtroFotocromatico"));

        ficha.setLcOdEsfera(trimToNull(request.getParameter("lcOdEsfera")));
        ficha.setLcOdCilindro(trimToNull(request.getParameter("lcOdCilindro")));
        ficha.setLcOdEje(trimToNull(request.getParameter("lcOdEje")));
        ficha.setLcOdAdd(trimToNull(request.getParameter("lcOdAdd")));
        ficha.setLcOdAv(trimToNull(request.getParameter("lcOdAv")));
        ficha.setLcOdTipo(trimToNull(request.getParameter("lcOdTipo")));

        ficha.setLcOiEsfera(trimToNull(request.getParameter("lcOiEsfera")));
        ficha.setLcOiCilindro(trimToNull(request.getParameter("lcOiCilindro")));
        ficha.setLcOiEje(trimToNull(request.getParameter("lcOiEje")));
        ficha.setLcOiAdd(trimToNull(request.getParameter("lcOiAdd")));
        ficha.setLcOiAv(trimToNull(request.getParameter("lcOiAv")));
        ficha.setLcOiTipo(trimToNull(request.getParameter("lcOiTipo")));

        ficha.setObservaciones(trimToNull(request.getParameter("observaciones")));
    }

    private void enviarRespuestaError(HttpServletResponse response, String mensaje) throws IOException {
        Map<String, String> respuesta = new HashMap<>();
        respuesta.put("success", "false");
        respuesta.put("message", mensaje);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(respuesta));
    }

    private static String trimToNull(String value) {
        if (value == null) return null;
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private static boolean isChecked(HttpServletRequest request, String name) {
        return request.getParameter(name) != null;
    }

    private static Long parseLongOrNull(String value) {
        try {
            if (value == null || value.trim().isEmpty()) return null;
            return Long.parseLong(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private static Integer parseIntegerOrNull(String value) {
        try {
            if (value == null || value.trim().isEmpty()) return null;
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }
}
