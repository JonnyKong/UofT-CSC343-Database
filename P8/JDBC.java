import java.sql.*;
import java.io.*;

class JDBC {
    
    public static void main(String args[]) throws IOException
        {
            String url;
            Connection conn;
            PreparedStatement pStatement;
            ResultSet rs;
            String queryString;

            try {
                Class.forName("org.postgresql.Driver");
            }
            catch (ClassNotFoundException e) {
                System.out.println("Failed to find the JDBC driver");
            }
            try
            {
                // This program connects to my database csc343h-dianeh,
                // where I have loaded a table called Guess, with this schema:
                //     Guesses(_number_, name, guess, age)
                // and put some data into it.
                
                // Establish our own connection to the database.
                // This is the right url, username and password for jdbc
                // with postgres on cdf -- but you would replace "dianeh"
                // with your cdf account name.
                // Password really does need to be the emtpy string.
                url = "jdbc:postgresql://localhost:5432/csc343h-kongzhao";
                conn = DriverManager.getConnection(url, "kongzhao", "");

                // Executing this query without having first prepared it
                // would be safe because the entire query is hard-coded.  
                // No one can inject any SQL code into our query.
                // But let's get in the habit of using a prepared statement.
                queryString = "select * from guesses where age < 10";
                pStatement = conn.prepareStatement(queryString);
                rs = pStatement.executeQuery();

                // Iterate through the result set and report on each tuple.
                while (rs.next()) {
                    String name = rs.getString("name");
                    int guess = rs.getInt("guess");
                    System.out.println(name + " guessed " + guess);
                }
                
                // The next query depends on user input, so we are wise to
                // prepare it before inserting the user input.
                queryString = "select guess from guesses where name = ?";
                // System.out.println("Inserted guesser number 12");
                PreparedStatement ps = conn.prepareStatement(queryString);

                // Find out what string to use when looking up guesses.
                BufferedReader br = new BufferedReader(new 
                      InputStreamReader(System.in));
                System.out.println("Look up who? ");
                String who = br.readLine();

                // Insert that string into the PreparedStatement and execute it.
                ps.setString(1, who);
                rs = ps.executeQuery();

                // Iterate through the result set and report on each tuple.
                while (rs.next()) {
                    int guess = rs.getInt("guess");
                    System.out.println("   " + who + " guessed " + guess);
                }
		
            // Insert guesser number 12
            // queryString = "INSERT INTO guesses VALUES (12, 'Jonny', 777, 7)";
            // pStatement = conn.prepareStatement(queryString);
            // pStatement.executeUpdate();
            // System.out.println("Inserted guesser number 12");

            // Prompt the user for an age, and print the average guess above
            System.out.println("Age Threshold: ");          
            int age = Integer.parseInt(System.console().readLine());
            queryString = "SELECT AVG(guess) AS ave FROM guesses WHERE age >= ?";
            ps = conn.prepareStatement(queryString);
            ps.setInt(1, age);
            rs = ps.executeQuery();

            while(rs.next()) {
                int guess_average = rs.getInt("ave");
                System.out.println("Average guess: " + guess_average);
            }

            // Create array to store every name in the table
            queryString = "SELECT COUNT(name) as cnt from guesses";
            ps = conn.prepareStatement(queryString);
            rs = ps.executeQuery();

            int size = 0;
            while(rs.next()) {
                size = rs.getInt("cnt");
            }
            String[] myArray = new String[size];
            
            // Store name in new array
            queryString = "SELECT name from guesses";
            ps = conn.prepareStatement(queryString);
            rs = ps.executeQuery();
            System.out.println("All names:");
            int i = 0;
            while(rs.next()) {
                String name = rs.getString("name");
                myArray[i++] = name;
                System.out.println(name);
            }		

        }
        catch (SQLException se)
        {
            System.err.println("SQL Exception." +
                    "<Message>: " + se.getMessage());
        }

    }
        
}
