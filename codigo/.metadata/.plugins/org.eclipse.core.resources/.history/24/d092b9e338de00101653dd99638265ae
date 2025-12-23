package com.lv;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import com.lv.pacientes.modelo.Paciente; // Asegúrate de importar tu entidad

public class TestConexion {
    public static void main(String[] args) {
        SessionFactory factory = null;
        Session session = null;

        try {
            System.out.println("1. Cargando configuración de Hibernate...");
            // Esto lee el archivo hibernate.cfg.xml
            Configuration cfg = new Configuration();
            cfg.configure("hibernate.cfg.xml");
            
            // Importante: Agrega la clase anotada por si acaso no la leyó del xml
            cfg.addAnnotatedClass(Paciente.class);

            System.out.println("2. Intentando conectar a la base de datos...");
            factory = cfg.buildSessionFactory();
            
            // Abrir sesión
            session = factory.openSession();
            
            System.out.println("----------------------------------------------");
            System.out.println("¡CONEXIÓN EXITOSA! 🚀");
            System.out.println("Si ves esto, Hibernate ya se conectó a Supabase.");
            System.out.println("----------------------------------------------");
            
        } catch (Exception e) {
            System.err.println("----------------------------------------------");
            System.err.println("❌ ERROR DE CONEXIÓN:");
            e.printStackTrace();
            System.err.println("----------------------------------------------");
        } finally {
            if (session != null) session.close();
            if (factory != null) factory.close();
        }
    }
}