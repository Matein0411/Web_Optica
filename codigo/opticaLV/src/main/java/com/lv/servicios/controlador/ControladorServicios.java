package com.lv.servicios.controlador;

import com.lv.servicios.dao.ServicioDAO;
import com.lv.servicios.modelo.Servicio;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/servicios")
@MultipartConfig
public class ControladorServicios extends HttpServlet {

    private ServicioDAO servicioDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        servicioDAO = new ServicioDAO();
        gson = new GsonBuilder().setPrettyPrinting().create();
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
                    enviarRespuestaError(response, "Acción no válida");
            }
        } catch (Exception e) {
            e.printStackTrace();
            enviarRespuestaError(response, "Error en el servidor: " + e.getMessage());
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Servicio> servicios = servicioDAO.obtenerActivos();
        request.setAttribute("servicios", servicios);
        request.getRequestDispatcher("/vista/servicios/ListaServicios.jsp").forward(request, response);
    }

    private void buscar(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String criterio = request.getParameter("criterio");
        List<Servicio> servicios;

        if (criterio == null || criterio.trim().isEmpty()) {
            servicios = servicioDAO.obtenerActivos();
        } else {
            servicios = servicioDAO.buscar(criterio);
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(servicios));
    }

    private void obtener(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Long id = Long.parseLong(request.getParameter("id"));
        Servicio servicio = servicioDAO.obtener(id);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(servicio));
    }

    private void guardar(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        // Validar campos obligatorios
        String nombre = request.getParameter("nombre");
        String precioBaseStr = request.getParameter("precioBase");

        Map<String, String> respuesta = new HashMap<>();

        if (nombre == null || nombre.trim().isEmpty() ||
                precioBaseStr == null || precioBaseStr.trim().isEmpty()) {

            enviarRespuestaError(response, "Faltan campos obligatorios");
            return;
        }

        // Validar que el precio sea válido
        BigDecimal precioBase;
        try {
            precioBase = new BigDecimal(precioBaseStr);
            if (precioBase.compareTo(BigDecimal.ZERO) < 0) {
                enviarRespuestaError(response, "El precio base no puede ser negativo");
                return;
            }
        } catch (NumberFormatException e) {
            enviarRespuestaError(response, "El precio base no es válido");
            return;
        }

        // Verificar si el nombre ya existe
        if (servicioDAO.existeNombre(nombre.trim(), null)) {
            enviarRespuestaError(response, "El nombre del servicio ya está en uso");
            return;
        }

        // Crear servicio
        Servicio servicio = new Servicio();
        servicio.setNombre(nombre.trim());
        servicio.setDescripcion(request.getParameter("descripcion"));
        servicio.setPrecioBase(precioBase);

        servicioDAO.guardar(servicio);

        respuesta.put("success", "true");
        respuesta.put("message", "Servicio registrado exitosamente");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(respuesta));
    }

    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        Long id = Long.parseLong(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String precioBaseStr = request.getParameter("precioBase");

        Map<String, String> respuesta = new HashMap<>();

        // Validar que el precio sea válido
        BigDecimal precioBase;
        try {
            precioBase = new BigDecimal(precioBaseStr);
            if (precioBase.compareTo(BigDecimal.ZERO) < 0) {
                enviarRespuestaError(response, "El precio base no puede ser negativo");
                return;
            }
        } catch (NumberFormatException e) {
            enviarRespuestaError(response, "El precio base no es válido");
            return;
        }

        // Verificar si el nombre ya existe (excluyendo el ID actual)
        if (servicioDAO.existeNombre(nombre.trim(), id)) {
            enviarRespuestaError(response, "El nombre del servicio ya está en uso");
            return;
        }

        Servicio servicio = servicioDAO.obtener(id);
        if (servicio == null) {
            enviarRespuestaError(response, "Servicio no encontrado");
            return;
        }

        servicio.setNombre(nombre.trim());
        servicio.setDescripcion(request.getParameter("descripcion"));
        servicio.setPrecioBase(precioBase);

        servicioDAO.editar(servicio);

        respuesta.put("success", "true");
        respuesta.put("message", "Servicio actualizado exitosamente");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(respuesta));
    }

    private void desactivar(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        Long id = Long.parseLong(request.getParameter("id"));
        servicioDAO.desactivar(id);

        Map<String, String> respuesta = new HashMap<>();
        respuesta.put("success", "true");
        respuesta.put("message", "Servicio desactivado exitosamente");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(respuesta));
    }

    private void enviarRespuestaError(HttpServletResponse response, String mensaje)
            throws IOException {
        Map<String, String> respuesta = new HashMap<>();
        respuesta.put("success", "false");
        respuesta.put("message", mensaje);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(respuesta));
    }
}