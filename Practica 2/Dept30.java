/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package dept30;

import java.sql.*;

/**
 *
 * @author iesjdc
 */
public class Dept30 {
    public static void main(String[] args) {
        try{
			//Cargar el driver
			 Class.forName("oracle.jdbc.driver.OracleDriver");
			// Establecemos la conexion con la BD
			Connection conexion = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","profe", "profe");
			// Preparamos la consulta
			Statement sentencia = conexion.createStatement();
			ResultSet resul = sentencia.executeQuery ("SELECT * FROM EMP WHERE DEPTNO=30");  
			 
			// Recorremos el resultado para visualizar cada fila
			// Se hace un bucle mientras haya registros, se van visualizando
			while (resul.next()){
				System.out.println (resul.getInt(1) + " " + resul.getString(2)+ " " + resul.getString(3));
			}
			resul.close();// Cerrar ResultSet
			sentencia.close();// Cerrar Statement
			conexion.close();//Cerrar conexion
		    }catch (ClassNotFoundException cn) {
				cn.printStackTrace();
		    }catch (SQLException e) {e.printStackTrace();
		}  
	}//fin de main
}//fin de la clase