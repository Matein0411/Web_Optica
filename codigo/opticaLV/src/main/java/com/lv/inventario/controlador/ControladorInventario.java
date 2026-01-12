package com.lv.inventario.controlador;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.lv.inventario.dao.ProductoDAO;
import com.lv.inventario.modelo.Producto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/inventario")
@MultipartConfig
public class ControladorInventario extends HttpServlet {

    private ProductoDAO productoDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        productoDAO = new ProductoDAO();
        gson = new GsonBuilder().setPrettyPrinting().create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

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
                case "imagen":
                    imagen(request, response);
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

    private void listar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<Producto> productos = productoDAO.obtenerActivos(null);
        request.setAttribute("productos", productos);
        request.getRequestDispatcher("/vista/inventario/ListaInventario.jsp").forward(request, response);
    }

    private void buscar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String criterio = trimToNull(request.getParameter("criterio"));
        String categoria = trimToNull(request.getParameter("categoria"));

        List<Producto> productos = (criterio == null)
                ? productoDAO.obtenerActivos(categoria)
                : productoDAO.buscar(criterio, categoria);

        List<Map<String, Object>> dto = productos.stream()
                .map(this::toDto)
                .collect(Collectors.toList());

        enviarJson(response, dto);
    }

    private void obtener(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long id = Long.parseLong(request.getParameter("id"));
        Producto producto = productoDAO.obtener(id);
        if (producto == null || Boolean.FALSE.equals(producto.getActivo())) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Producto no encontrado");
            return;
        }
        enviarJson(response, toDto(producto));
    }

    private void imagen(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long id = Long.parseLong(request.getParameter("id"));
        Producto producto = productoDAO.obtener(id);

        if (producto == null || Boolean.FALSE.equals(producto.getActivo())
                || producto.getImagen() == null || producto.getImagen().length == 0) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = (producto.getImagenTipo() != null && !producto.getImagenTipo().isBlank())
                ? producto.getImagenTipo()
                : "application/octet-stream";

        response.setContentType(contentType);
        response.setContentLength(producto.getImagen().length);
        response.getOutputStream().write(producto.getImagen());
    }

    private void guardar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String categoria = trimToNull(request.getParameter("categoria"));
        String codigoSku = trimToNull(request.getParameter("codigoSku"));
        String nombre = trimToNull(request.getParameter("nombre"));

        Integer stock = parseIntegerOrNull(request.getParameter("stock"));
        BigDecimal precioVenta = parseBigDecimalOrNull(request.getParameter("precioVenta"));

        if (categoria == null || codigoSku == null || nombre == null || stock == null || precioVenta == null) {
            enviarRespuestaError(response, "Faltan campos obligatorios");
            return;
        }
        if (stock < 0) {
            enviarRespuestaError(response, "El stock no puede ser negativo");
            return;
        }
        if (precioVenta.compareTo(BigDecimal.ZERO) < 0) {
            enviarRespuestaError(response, "El precio no puede ser negativo");
            return;
        }
        if (productoDAO.existeCodigoSku(codigoSku, null)) {
            enviarRespuestaError(response, "El Código SKU ya está registrado");
            return;
        }

        Producto producto = new Producto();
        producto.setCategoria(categoria.toLowerCase());
        producto.setCodigoSku(codigoSku);
        producto.setNombre(nombre);
        producto.setMarca(trimToNull(request.getParameter("marca")));
        producto.setDescripcion(trimToNull(request.getParameter("descripcion")));
        producto.setStock(stock);
        producto.setPrecioVenta(precioVenta);
        producto.setFormaEstilo(trimToNull(request.getParameter("formaEstilo")));
        producto.setMaterial(trimToNull(request.getParameter("material")));
        producto.setGenero(trimToNull(request.getParameter("genero")));
        producto.setColor(trimToNull(request.getParameter("color")));
        producto.setMedidas(trimToNull(request.getParameter("medidas")));

        Part imagen = safeGetPart(request, "imagenProducto");
        if (imagen != null && imagen.getSize() > 0) {
            producto.setImagen(imagen.getInputStream().readAllBytes());
            producto.setImagenTipo(imagen.getContentType());
        }

        productoDAO.guardar(producto);

        Map<String, Object> respuesta = new HashMap<>();
        respuesta.put("success", true);
        respuesta.put("message", "Producto registrado exitosamente");
        enviarJson(response, respuesta);
    }

    private void editar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long id = Long.parseLong(request.getParameter("id"));
        Producto producto = productoDAO.obtener(id);
        if (producto == null || Boolean.FALSE.equals(producto.getActivo())) {
            enviarRespuestaError(response, "Producto no encontrado");
            return;
        }

        String categoria = trimToNull(request.getParameter("categoria"));
        String codigoSku = trimToNull(request.getParameter("codigoSku"));
        String nombre = trimToNull(request.getParameter("nombre"));

        Integer stock = parseIntegerOrNull(request.getParameter("stock"));
        BigDecimal precioVenta = parseBigDecimalOrNull(request.getParameter("precioVenta"));

        if (categoria == null || codigoSku == null || nombre == null || stock == null || precioVenta == null) {
            enviarRespuestaError(response, "Faltan campos obligatorios");
            return;
        }
        if (stock < 0) {
            enviarRespuestaError(response, "El stock no puede ser negativo");
            return;
        }
        if (precioVenta.compareTo(BigDecimal.ZERO) < 0) {
            enviarRespuestaError(response, "El precio no puede ser negativo");
            return;
        }
        if (productoDAO.existeCodigoSku(codigoSku, id)) {
            enviarRespuestaError(response, "El Código SKU ya está registrado");
            return;
        }

        producto.setCategoria(categoria.toLowerCase());
        producto.setCodigoSku(codigoSku);
        producto.setNombre(nombre);
        producto.setMarca(trimToNull(request.getParameter("marca")));
        producto.setDescripcion(trimToNull(request.getParameter("descripcion")));
        producto.setStock(stock);
        producto.setPrecioVenta(precioVenta);
        producto.setFormaEstilo(trimToNull(request.getParameter("formaEstilo")));
        producto.setMaterial(trimToNull(request.getParameter("material")));
        producto.setGenero(trimToNull(request.getParameter("genero")));
        producto.setColor(trimToNull(request.getParameter("color")));
        producto.setMedidas(trimToNull(request.getParameter("medidas")));

        Part imagen = safeGetPart(request, "imagenProducto");
        if (imagen != null && imagen.getSize() > 0) {
            producto.setImagen(imagen.getInputStream().readAllBytes());
            producto.setImagenTipo(imagen.getContentType());
        }

        productoDAO.editar(producto);

        Map<String, Object> respuesta = new HashMap<>();
        respuesta.put("success", true);
        respuesta.put("message", "Producto actualizado exitosamente");
        enviarJson(response, respuesta);
    }

    private void desactivar(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long id = Long.parseLong(request.getParameter("id"));
        productoDAO.desactivar(id);

        Map<String, Object> respuesta = new HashMap<>();
        respuesta.put("success", true);
        respuesta.put("message", "Producto desactivado exitosamente");
        enviarJson(response, respuesta);
    }

    private Map<String, Object> toDto(Producto p) {
        Map<String, Object> dto = new HashMap<>();
        dto.put("id", p.getId());
        dto.put("categoria", p.getCategoria());
        dto.put("codigoSku", p.getCodigoSku());
        dto.put("nombre", p.getNombre());
        dto.put("marca", p.getMarca());
        dto.put("descripcion", p.getDescripcion());
        dto.put("stock", p.getStock());
        dto.put("precioVenta", p.getPrecioVenta());
        dto.put("formaEstilo", p.getFormaEstilo());
        dto.put("material", p.getMaterial());
        dto.put("genero", p.getGenero());
        dto.put("color", p.getColor());
        dto.put("medidas", p.getMedidas());
        dto.put("tieneImagen", p.getImagen() != null && p.getImagen().length > 0);
        return dto;
    }

    private void enviarJson(HttpServletResponse response, Object objeto) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(objeto));
    }

    private void enviarRespuestaError(HttpServletResponse response, String mensaje) throws IOException {
        Map<String, Object> respuesta = new HashMap<>();
        respuesta.put("success", false);
        respuesta.put("message", mensaje);
        enviarJson(response, respuesta);
    }

    private static String trimToNull(String value) {
        if (value == null) return null;
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private static Integer parseIntegerOrNull(String value) {
        try {
            if (value == null || value.trim().isEmpty()) return null;
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private static BigDecimal parseBigDecimalOrNull(String value) {
        try {
            if (value == null || value.trim().isEmpty()) return null;
            return new BigDecimal(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private static Part safeGetPart(HttpServletRequest request, String name) {
        try {
            return request.getPart(name);
        } catch (Exception ex) {
            return null;
        }
    }
}

