import java.sql.*;
import java.util.List;

// If you are looking for Java data structures, these are highly useful.
// Remember that an important part of your mark is for doing as much in SQL (not Java) as you can.
// Solutions that use only or mostly Java will not receive a high mark.
import java.util.ArrayList;
//import java.util.Map;
//import java.util.HashMap;
//import java.util.Set;
//import java.util.HashSet;
public class Assignment2 extends JDBCSubmission {

    public Assignment2() throws ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
    }

    @Override
    public boolean connectDB(String url, String username, String password) {
        // Implement this method!
        try {
            connection = DriverManager.getConnection(url, username, password);
        } catch(SQLException se) {
            return false;
        }
        System.out.println("Connected to database");
        return true;
    }

    @Override
    public boolean disconnectDB() {
        // Implement this method!
        if(connnection != null) {
            try {
                connnection.close();
            } catch (SQLException se) {
                return false;
            }
        }
        return true;
    }

    @Override
    public ElectionCabinetResult electionSequence(String countryName) {
        List<Integer> elections = new ArrayList<Integer>();
        List<Integer> cabinets = new ArrayList<Integer>();

        String queryString = "SELECT election.id AS election_id, cabinet.id AS cabinet_id " +
            "FROM election, country, cabinet " +
            "WHERE election.country_id = country.id AND " +
            "election.id = cabinet.election_id AND " +
            "country.name = ?" + 
            "ORDER BY election.e_date DESC;";
        
        PreparedStatement ps = connection.prepareStatement(queryString);
        ps.setString(1, countryName);
        
        ResultSet rs = ps.executeQuery();
        while(rs.next()) {
            elections.add(rs.getInt("election_id"));
            cabinets.add(rs.getInt("cabinet_id"));
        }

        return new ElectionCabinetResult(elections, cabinets);
        // return null;
    }

    @Override
    public List<Integer> findSimilarPoliticians(Integer politicianName, Float threshold) {
        // Implement this method!
        List<Integer> name = new ArrayList<Integer>();

        // Get similarity of given politician
        String description;
        String queryString1 = "SELECT description FROM politician_president " +
            "WHERE politician_president.id = ?";
        PreparedStatement ps1 = connection.prepareStatement(queryString1);
        ps1.setInt(1, politicianName);
        ResultSet rs1 = ps1.executeQuery();
        while(rs1.next()) {
            description = rs1.getString("description");
        }

        // Get all politicians and descriptions
        String queryString2 = "SELECT id, description " +
            "FROM politician_president;";
        PreparedStatement ps2 = connection.prepareStatement(queryString2);
        ResultSet rs2 = ps2.executeQuery();
        while(rs2.next()) {
            double similarity = super.similarity(rs2.getString("description"), description);
            if(similarity >= threshold) {
                name.add(rs2.getInt("id"));
            }
        }

        return name;
    }

    public static void main(String[] args) {
        // You can put testing code in here. It will not affect our autotester.
        System.out.println("Hello");
    }

}

