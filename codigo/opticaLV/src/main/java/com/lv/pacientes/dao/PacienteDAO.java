package com.lv.pacientes.dao;

import com.lv.comun.dao.BaseDAO;
import com.lv.pacientes.modelo.Paciente;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import org.hibernate.Session;

import java.util.ArrayList;
import java.util.List;

public class PacienteDAO extends BaseDAO<Paciente> {
    
    public PacienteDAO() {
        super(Paciente.class);
    }
    
    /**
     * Obtiene solo pacientes activos ordenados por apellido y nombre
     */
    public List<Paciente> obtenerActivos() {
        return executeQuery(session -> {
            CriteriaBuilder cb = session.getCriteriaBuilder();
            CriteriaQuery<Paciente> cq = cb.createQuery(Paciente.class);
            Root<Paciente> root = cq.from(Paciente.class);
            
            cq.select(root)
              .where(cb.equal(root.get("activo"), true))
              .orderBy(cb.asc(root.get("apellido")), cb.asc(root.get("nombre")));
            
            return session.createQuery(cq).getResultList();
        });
    }
    
    /**
     * Busca pacientes por nombre, apellido o cédula (para el buscador)
     */
    @Override
    public List<Paciente> buscar(String criterio) {
        return executeQuery(session -> {
            CriteriaBuilder cb = session.getCriteriaBuilder();
            CriteriaQuery<Paciente> cq = cb.createQuery(Paciente.class);
            Root<Paciente> root = cq.from(Paciente.class);
            
            String criterioBusqueda = "%" + criterio.toLowerCase() + "%";
            
            Predicate activo = cb.equal(root.get("activo"), true);
            Predicate nombre = cb.like(cb.lower(root.get("nombre")), criterioBusqueda);
            Predicate apellido = cb.like(cb.lower(root.get("apellido")), criterioBusqueda);
            Predicate cedula = cb.like(root.get("cedula"), criterioBusqueda);
            
            cq.select(root)
              .where(cb.and(activo, cb.or(nombre, apellido, cedula)))
              .orderBy(cb.asc(root.get("apellido")), cb.asc(root.get("nombre")));
            
            return session.createQuery(cq).getResultList();
        });
    }
    
    /**
     * Verifica si existe una cédula (excluyendo un ID específico para edición)
     */
    public boolean existeCedula(String cedula, Long idExcluir) {
        return executeQuery(session -> {
            CriteriaBuilder cb = session.getCriteriaBuilder();
            CriteriaQuery<Long> cq = cb.createQuery(Long.class);
            Root<Paciente> root = cq.from(Paciente.class);
            
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("cedula"), cedula));
            
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
            Paciente paciente = session.get(Paciente.class, id);
            if (paciente != null) {
                paciente.setActivo(false);
                session.merge(paciente);
            }
        });
    }
}