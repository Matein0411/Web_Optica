package com.lv.recursos;

import com.lv.inventario.dao.ProductoDAO;
import com.lv.inventario.modelo.Producto;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;

@Path("/productos")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class RecursoInventario {

    private final ProductoDAO productoDAO = new ProductoDAO();

    /**
     * GET /api/productos
     * Obtiene todos los productos activos
     */
    @GET
    public List<Producto> obtenerProductos() {
        return productoDAO.obtenerActivos(null);
    }

    /**
     * GET /api/productos/{id}
     * Obtiene un producto por ID
     */
    @GET
    @Path("/{id}")
    public Response obtenerProductoPorId(@PathParam("id") Long id) {
        Producto producto = productoDAO.obtener(id);
        if (producto == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\":\"Producto no encontrado\"}")
                    .build();
        }
        return Response.ok(producto).build();
    }

    /**
     * GET /api/productos/categoria/{categoria}
     * Obtiene productos activos por categoría
     */
    @GET
    @Path("/categoria/{categoria}")
    public List<Producto> obtenerPorCategoria(@PathParam("categoria") String categoria) {
        return productoDAO.obtenerActivos(categoria);
    }

    /**
     * GET /api/productos/buscar?criterio=rayban&categoria=lentes
     * Busca productos por criterio (SKU, marca o nombre) y opcionalmente por categoría
     */
    @GET
    @Path("/buscar")
    public List<Producto> buscarProductos(
            @QueryParam("criterio") String criterio,
            @QueryParam("categoria") String categoria) {
        return productoDAO.buscar(criterio, categoria);
    }

    /**
     * POST /api/productos
     * Crea un nuevo producto
     */
    @POST
    public Response crearProducto(Producto producto) {
        try {
            // Validar que no exista el SKU
            if (productoDAO.existeCodigoSku(producto.getCodigoSku(), null)) {
                return Response.status(Response.Status.CONFLICT)
                        .entity("{\"error\":\"El código SKU ya existe\"}")
                        .build();
            }

            productoDAO.guardar(producto);
            return Response.status(Response.Status.CREATED)
                    .entity(producto)
                    .build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\":\"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    /**
     * PUT /api/productos/{id}
     * Actualiza un producto existente
     */
    @PUT
    @Path("/{id}")
    public Response actualizarProducto(@PathParam("id") Long id, Producto producto) {
        try {
            Producto existente = productoDAO.obtener(id);
            if (existente == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\":\"Producto no encontrado\"}")
                        .build();
            }

            // Validar que no exista el SKU en otro producto
            if (productoDAO.existeCodigoSku(producto.getCodigoSku(), id)) {
                return Response.status(Response.Status.CONFLICT)
                        .entity("{\"error\":\"El código SKU ya existe en otro producto\"}")
                        .build();
            }

            producto.setId(id); // Asegurar que se actualice el producto correcto
            productoDAO.editar(producto);
            return Response.ok(producto).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\":\"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    /**
     * DELETE /api/productos/{id}
     * Desactiva un producto (eliminación lógica)
     */
    @DELETE
    @Path("/{id}")
    public Response desactivarProducto(@PathParam("id") Long id) {
        try {
            Producto producto = productoDAO.obtener(id);
            if (producto == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\":\"Producto no encontrado\"}")
                        .build();
            }

            productoDAO.desactivar(id);
            return Response.ok()
                    .entity("{\"mensaje\":\"Producto desactivado exitosamente\"}")
                    .build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\":\"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    /**
     * DELETE /api/productos/{id}/permanente
     * Elimina un producto de forma permanente (eliminación física)
     */
    @DELETE
    @Path("/{id}/permanente")
    public Response eliminarProductoPermanente(@PathParam("id") Long id) {
        try {
            Producto producto = productoDAO.obtener(id);
            if (producto == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\":\"Producto no encontrado\"}")
                        .build();
            }

            productoDAO.eliminar(id);
            return Response.ok()
                    .entity("{\"mensaje\":\"Producto eliminado permanentemente\"}")
                    .build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\":\"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    /**
     * GET /api/productos/verificar-sku/{sku}
     * Verifica si un SKU ya existe
     */
    @GET
    @Path("/verificar-sku/{sku}")
    public Response verificarSku(
            @PathParam("sku") String sku,
            @QueryParam("idExcluir") Long idExcluir) {
        boolean existe = productoDAO.existeCodigoSku(sku, idExcluir);
        return Response.ok()
                .entity("{\"existe\":" + existe + "}")
                .build();
    }
}
