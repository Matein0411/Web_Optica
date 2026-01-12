package com.lv.inventario.dao;

import com.lv.comun.dao.BaseDAO;
import com.lv.inventario.modelo.Producto;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

import java.util.ArrayList;
import java.util.List;

public class ProductoDAO extends BaseDAO<Producto> {

    public ProductoDAO() {
        super(Producto.class);
    }

    public List<Producto> obtenerActivos(String categoria) {
        return executeQuery(session -> {
            CriteriaBuilder cb = session.getCriteriaBuilder();
            CriteriaQuery<Producto> cq = cb.createQuery(Producto.class);
            Root<Producto> root = cq.from(Producto.class);

            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("activo"), true));
            if (categoria != null && !categoria.trim().isEmpty() && !"todos".equalsIgnoreCase(categoria)) {
                predicates.add(cb.equal(cb.lower(root.get("categoria")), categoria.trim().toLowerCase()));
            }

            cq.select(root)
                    .where(cb.and(predicates.toArray(new Predicate[0])))
                    .orderBy(cb.asc(root.get("categoria")), cb.asc(root.get("nombre")));

            return session.createQuery(cq).getResultList();
        });
    }

    @Override
    public List<Producto> buscar(String criterio) {
        return buscar(criterio, null);
    }

    public List<Producto> buscar(String criterio, String categoria) {
        return executeQuery(session -> {
            CriteriaBuilder cb = session.getCriteriaBuilder();
            CriteriaQuery<Producto> cq = cb.createQuery(Producto.class);
            Root<Producto> root = cq.from(Producto.class);

            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("activo"), true));

            if (categoria != null && !categoria.trim().isEmpty() && !"todos".equalsIgnoreCase(categoria)) {
                predicates.add(cb.equal(cb.lower(root.get("categoria")), categoria.trim().toLowerCase()));
            }

            if (criterio != null && !criterio.trim().isEmpty()) {
                String like = "%" + criterio.trim().toLowerCase() + "%";
                Predicate sku = cb.like(cb.lower(root.get("codigoSku")), like);
                Predicate marca = cb.like(cb.lower(root.get("marca")), like);
                Predicate nombre = cb.like(cb.lower(root.get("nombre")), like);
                predicates.add(cb.or(sku, marca, nombre));
            }

            cq.select(root)
                    .where(cb.and(predicates.toArray(new Predicate[0])))
                    .orderBy(cb.asc(root.get("categoria")), cb.asc(root.get("nombre")));

            return session.createQuery(cq).getResultList();
        });
    }

    public boolean existeCodigoSku(String codigoSku, Long idExcluir) {
        return executeQuery(session -> {
            CriteriaBuilder cb = session.getCriteriaBuilder();
            CriteriaQuery<Long> cq = cb.createQuery(Long.class);
            Root<Producto> root = cq.from(Producto.class);

            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(cb.lower(root.get("codigoSku")), codigoSku.toLowerCase()));

            if (idExcluir != null) {
                predicates.add(cb.notEqual(root.get("id"), idExcluir));
            }

            cq.select(cb.count(root)).where(cb.and(predicates.toArray(new Predicate[0])));
            Long count = session.createQuery(cq).getSingleResult();
            return count > 0;
        });
    }

    public void desactivar(Long id) {
        executeInTransaction(session -> {
            Producto producto = session.get(Producto.class, id);
            if (producto != null) {
                producto.setActivo(false);
                session.merge(producto);
            }
        });
    }
}

