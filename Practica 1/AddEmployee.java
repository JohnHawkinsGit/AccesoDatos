/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package practica.pkg1;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;

/**
 *
 * @author iesjdc
 */
public class AddEmployee {
	public static void main(String[] args) {
       try{
            // Cargamos la clase que implementa el Driver
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            // Creamos una nueva conexión a la base de datos 'prueba'
            String url = "jdbc:mysql://localhost:3306/prueba?serverTimezone=UTC";
            Connection conn = DriverManager.getConnection(url,"root","");
            // Obtenemos un Statement de la conexión
            java.sql.Statement st = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
            // Ejecutamos una consulta SELECT para obtener la tabla vendedores
            String sql = "SELECT * FROM vendedores";
            ResultSet rs= st.executeQuery(sql);
            
            // Creamos un nuevo registro y lo insertamos
            rs.moveToInsertRow(); //crea una nueva fila
            rs.updateInt("id",2); //modifica la columna id de la fila nueva 
            rs.updateString("nombre","Wall-E"); //modifica la columna nombre de la fila nueva 
            Date fechaIni=new Date(2022-12-04); //se crea un objeto fecha para introducirlo en la columna
            rs.updateDate("fecha_ingreso",fechaIni); //modifica la columna fecha de la fila nueva 
            rs.updateFloat("salario", 12500); //modifica la columna salario de la fila nueva 
            rs.insertRow(); //inserta la fila en la tabla
            // Recorremos todo el ResultSet y mostramos sus datos
			sql = "SELECT * FROM vendedores";
            rs= st.executeQuery(sql);
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

