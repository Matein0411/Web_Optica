package com.lv.fichas.dao;

import com.lv.comun.dao.BaseDAO;
import com.lv.fichas.modelo.FichaClinica;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

import java.util.List;

public class FichaClinicaDAO extends BaseDAO<FichaClinica> {

    public FichaClinicaDAO() {
        super(FichaClinica.class);
    }

    public List<FichaClinica> obtenerActivas() {
        return executeQuery(session -> {
            CriteriaBuilder cb = session.getCriteriaBuilder();
            CriteriaQuery<FichaClinica> cq = cb.createQuery(FichaClinica.class);
            Root<FichaClinica> root = cq.from(FichaClinica.class);

            cq.select(root)
                    .where(cb.equal(root.get("activo"), true))
                    .orderBy(cb.desc(root.get("fecha")), cb.desc(root.get("id")));

            return session.createQuery(cq).getResultList();
        });
    }

    public List<FichaClinica> buscar(String criterio) {
        return executeQuery(session -> {
            CriteriaBuilder cb = session.getCriteriaBuilder();
            CriteriaQuery<FichaClinica> cq = cb.createQuery(FichaClinica.class);
            Root<FichaClinica> root = cq.from(FichaClinica.class);

            Join<Object, Object> paciente = root.join("paciente");

            String criterioBusqueda = "%" + criterio.toLowerCase() + "%";

            Predicate activo = cb.equal(root.get("activo"), true);
            Predicate porMpc = cb.like(cb.lower(root.get("motivoConsulta")), criterioBusqueda);
            Predicate porNombre = cb.like(cb.lower(paciente.get("nombre")), criterioBusqueda);
            Predicate porApellido = cb.like(cb.lower(paciente.get("apellido")), criterioBusqueda);
            Predicate porCedula = cb.like(paciente.get("cedula"), "%" + criterio + "%");

            cq.select(root)
                    .where(cb.and(activo, cb.or(porMpc, porNombre, porApellido, porCedula)))
                    .orderBy(cb.desc(root.get("fecha")), cb.desc(root.get("id")));

            return session.createQuery(cq).getResultList();
        });
    }

    public void anular(Long id) {
        executeInTransaction(session -> {
            FichaClinica ficha = session.get(FichaClinica.class, id);
            if (ficha != null) {
                ficha.setActivo(false);
                session.merge(ficha);
            }
        });
    }
}
