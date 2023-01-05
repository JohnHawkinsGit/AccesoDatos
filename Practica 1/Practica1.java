/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package practica.pkg1;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

/**
 *
 * @author iesjdc
 */
public class Practica1 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        try {
            // Cargamos la clase que implementa el Driver
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            // Creamos una nueva conexión a la base de datos 'prueba'
            String url = "jdbc:mysql://localhost:3306/prueba?serverTimezone=UTC";
            Connection conn = DriverManager.getConnection(url,"root","");
            // Obtenemos un Statement de la conexión
            java.sql.Statement st = conn.createStatement();
            // Ejecutamos una consulta SELECT para obtener la tabla vendedores
            String sql = "SELECT * FROM vendedores";
            ResultSet rs= st.executeQuery(sql);
            // Recorremos todo el ResultSet y mostramos sus datos
            while(rs.next()) {
                int id = rs.getInt("id");
                String nombre = rs.getString("nombre");
                Date fecha = rs.getDate("fecha_ingreso");
                float salario = rs.getFloat("salario");
                System.out.println(id + " " + nombre + " " + fecha + " " + salario);
            }
            // Cerramos el statement y la conexión
            st.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }   
}
