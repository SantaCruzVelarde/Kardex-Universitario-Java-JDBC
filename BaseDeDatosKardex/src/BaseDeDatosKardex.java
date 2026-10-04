import java.sql.*;
import java.util.Scanner;

public class BaseDeDatosKardex {

    public static void main(String[] args) {
        String url = "jdbc:postgresql://localhost:5432/UniversityDB";
        String usuario = "postgres"; 
        String contraseña = "1234";

        Scanner sc = new Scanner(System.in);
        System.out.print("Ingrese el ID del estudiante: ");
        String idBuscado = sc.nextLine();

        try (Connection conn = DriverManager.getConnection(url, usuario, contraseña)) {
            System.out.println("\nConexión exitosa a la base de datos.\n");

            String sql = """
                    SELECT s.id, s.name, c.title, t.grade
                    FROM student s
                    JOIN takes t ON s.id = t.id
                    JOIN course c ON t.course_id = c.course_id
                    WHERE s.id = ?
                    ORDER BY c.course_id;
                    """;

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, idBuscado);
                ResultSet rs = pstmt.executeQuery();

                boolean tieneDatos = false;

                while (rs.next()) {
                    if (!tieneDatos) {
                        System.out.println("==============================");
                        System.out.println("ID Estudiante: " + rs.getString("id"));
                        System.out.println("Nombre: " + rs.getString("name"));
                        System.out.println("Materias y Calificaciones:");
                        tieneDatos = true;
                    }

                    String title = rs.getString("title");
                    String grade = rs.getString("grade");
                    System.out.printf("   - %-30s | Calificación: %s%n",
                            title, (grade != null ? grade : "Sin calificación"));
                }

                if (!tieneDatos) {
                    System.out.println("No se encontró ningún estudiante con el ID proporcionado.");
                }

            }

        } catch (SQLException e) {
            System.err.println("Error al conectar o ejecutar la consulta:");
            e.printStackTrace();
        }
    }
}
