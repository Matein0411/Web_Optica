package com.lv.servicios.dao;

import com.lv.comun.dao.BaseDAO;
import com.lv.servicios.modelo.Servicio;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

import java.util.ArrayList;
import java.util.List;

public class ServicioDAO extends BaseDAO<Servicio> {

    public ServicioDAO() {
        super(Servicio.class);
    }

    /**
     * Obtiene solo servicios activos ordenados por nombre
     */
    public List<Servicio> obtenerActivos() {
        return executeQuery(session -> {
            CriteriaBuilder cb = session.getCriteriaBuilder();
            CriteriaQuery<Servicio> cq = cb.createQuery(Servicio.class);
            Root<Servicio> root = cq.from(Servicio.class);

            cq.select(root)
                    .where(cb.equal(root.get("activo"), true))
                    .orderBy(cb.asc(root.get("nombre")));

            return session.createQuery(cq).getResultList();
        });
    }

    /**
     * Busca servicios por nombre o descripción
     */
    @Override
    public List<Servicio> buscar(String criterio) {
        return executeQuery(session -> {
            CriteriaBuilder cb = session.getCriteriaBuilder();
            CriteriaQuery<Servicio> cq = cb.createQuery(Servicio.class);
            Root<Servicio> root = cq.from(Servicio.class);

            String criterioBusqueda = "%" + criterio.toLowerCase() + "%";

            Predicate activo = cb.equal(root.get("activo"), true);
            Predicate nombre = cb.like(cb.lower(root.get("nombre")), criterioBusqueda);
            Predicate descripcion = cb.like(cb.lower(root.get("descripcion")), criterioBusqueda);

            cq.select(root)
                    .where(cb.and(activo, cb.or(nombre, descripcion)))
                    .orderBy(cb.asc(root.get("nombre")));

            return session.createQuery(cq).getResultList();
        });
    }

    /**
     * Verifica si existe un nombre de servicio (excluyendo un ID específico para edición)
     */
    public boolean existeNombre(String nombre, Long idExcluir) {
        return executeQuery(session -> {
            CriteriaBuilder cb = session.getCriteriaBuilder();
            CriteriaQuery<Long> cq = cb.createQuery(Long.class);
            Root<Servicio> root = cq.from(Servicio.class);

            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(cb.lower(root.get("nombre")), nombre.toLowerCase()));

            if (idExcluir != null) {
                predicates.add(cb.notEqual(root.get("id"), idExcluir));
            }

            cq.select(cb.count(root)).where(cb.and(predicates.toArray(new Predicate[0])));

            Long count = session.createQuery(cq).getSingleResult();
            return count > 0;
        });
    }

    /**
     * Eliminación lógica (cambia estado a inactivo)
     */
    public void desactivar(Long id) {
        executeInTransaction(session -> {
            Servicio servicio = session.get(Servicio.class, id);
            if (servicio != null) {
                servicio.setActivo(false);
                session.merge(servicio);
            }
        });
    }
}