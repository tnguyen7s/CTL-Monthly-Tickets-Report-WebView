/*
Southeast Missouri State University
CSTL - Tickets Monthly Report Web View project
 */
package com.cstl.model.query;
import com.cstl.listener.AppContextListener;
import com.cstl.model.entity.CSTLConsultData;
import com.cstl.model.entity.SupportTicketAssignedTechData;
import com.cstl.model.entity.TicketBreakDownByCanvasTypeData;
import com.cstl.model.entity.TicketBreakDownByContactTypeData;
import com.cstl.model.entity.TicketBreakDownByRequestTypeData;
import com.cstl.model.entity.TicketFiveMostFrequentIssuesData;
import com.cstl.model.enums.WorkerEnum;
import java.nio.file.Paths;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Tuyen
 * Query superclass
 */
public class Query implements IQuery{
    private Connection conn = null;
    
    public Query(String dbConnectionString) throws SQLException, ClassNotFoundException 
    {
        System.load(Paths.get("mssql-jdbc_auth-9.4.0.x64.dll").toAbsolutePath().toString());
        
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        conn = DriverManager.getConnection(dbConnectionString);
        
    }
    
    // clean up the connection (called at the controller (servlet class))
    @Override
    public void close() throws SQLException
    {
        if (conn!=null)
        {
            conn.close();
        }
    }
    
    @Override
    public List<String> getTop20StartTimes() throws SQLException
    {   
        String query = "SELECT DISTINCT TOP(20) StartTime FROM ReportTime ORDER BY StartTime DESC";
        
        Statement stmt=null;
        ResultSet results = null;
        
        List<String> top20 = null;
        try{
            stmt = conn.createStatement();
            results = stmt.executeQuery(query);
            
            top20 = new ArrayList<>(20);
            while(results.next())
            {
                top20.add(results.getString("StartTime"));
            }
            return top20;
        }
        catch (SQLException e){
            throw e;
        }
        finally{
            if (stmt!=null)
            {
                stmt.close();
            }
            
            if (results!=null)
            {
                results.close();
            }
        }
    }
    
    @Override
    public List<String> getTop20EndTimes()throws SQLException{
        String query = "SELECT DISTINCT TOP(20) EndTime FROM ReportTime ORDER BY EndTime desc;";
        
        Statement stmt=null;
        ResultSet results = null;
        
        List<String> top20 = null;
        
        try{
            stmt = conn.createStatement();
            results = stmt.executeQuery(query);
            
            top20 = new ArrayList<>(20);
            while(results.next())
            {
                top20.add(results.getString("EndTime"));
            }
            return top20;
        }
        catch (SQLException e){
            throw e;
        }
        finally{
            if (stmt!=null)
            {
                stmt.close();
            }
            
            if (results!=null)
            {
                results.close();
            }
        }
    }

    @Override
    public TicketBreakDownByContactTypeData getTicketBreakDownByContactTypeData(LocalDate startDate, LocalDate endDate) throws SQLException{
        Logger.getLogger(AppContextListener.class.getName()).log(Level.FINE, null, startDate.toString());
        String startDateString = startDate.toString();
        String endDateString = endDate.toString();
        
        TicketBreakDownByContactTypeData dataObject = new TicketBreakDownByContactTypeData(startDate, endDate);
        
        PreparedStatement stmt = null;
        ResultSet result = null;
        
        try{
            stmt = conn.prepareStatement("SELECT ContactType, SUM(NumberOfTickets) AS NumberOfTickets "
                                        + "FROM BreakdownByContactType WHERE StartTime>=? AND EndTime<=? AND StartTime LIKE '%01' AND EndTime LIKE '%01' "
                                        + "GROUP BY ContactType ORDER BY ContactType;");
            stmt.setString(1, startDateString);
            stmt.setString(2, endDateString);
            
            result = stmt.executeQuery();
            
            while (result.next())
            {
                dataObject.addARecord(result.getString("ContactType"), result.getInt("NumberOfTickets"));
            }
        }
        catch (SQLException e)
        {
            throw e;
        }
        finally
        {
            if (stmt!=null)
            {
                stmt.close();
            }
            
            if (result!=null)
            {
                result.close();
            }
        }
        
        return dataObject;
    }

    @Override
    public TicketBreakDownByRequestTypeData getTicketBreakDownByRequestTypeData(LocalDate startDate, LocalDate endDate) throws SQLException {
        String startDateString = startDate.toString();
        String endDateString = endDate.toString();
        
        TicketBreakDownByRequestTypeData dataObject = new TicketBreakDownByRequestTypeData(startDate, endDate);
        
        PreparedStatement stmt = null;
        ResultSet result = null;
        
        try
        {
            stmt = conn.prepareStatement("SELECT RequestType, SUM(NumberOfTickets) AS NumberOfTickets " +
                                        "FROM BreakdownByRequestType WHERE StartTime>=? AND EndTime<=? AND StartTime LIKE '%01' AND EndTime LIKE '%01' " +
                                        "GROUP BY RequestType ORDER BY RequestType;");
            stmt.setString(1, startDateString);
            stmt.setString(2, endDateString);
            
            result = stmt.executeQuery();
            while (result.next())
            {
                dataObject.addARecord(result.getString("RequestType"), result.getInt("NumberOfTickets"));
            }
        }
        catch(SQLException e)
        {
            throw e;
        }
        finally
        {
            if (stmt!=null)
            {
                stmt.close();
            }
            
            if (result!=null)
            {
                result.close();
            }
        }
        
        return dataObject;
    }

    @Override
    public TicketBreakDownByCanvasTypeData getTicketBreakDownByCanvasTypeData(LocalDate startDate, LocalDate endDate) throws SQLException{
        String startDateString = startDate.toString();
        String endDateString = endDate.toString();
        
        TicketBreakDownByCanvasTypeData dataObject = new TicketBreakDownByCanvasTypeData(startDate, endDate);
        
        PreparedStatement stmt = null;
        ResultSet result = null;
        
        try
        {
            stmt = conn.prepareStatement("SELECT CanvasType, SUM(NumberOfTickets) AS NumberOfTickets " +
                                        "FROM BreakdownByCanvasType WHERE StartTime>=? AND EndTime<=? AND StartTime LIKE '%01' AND EndTime LIKE '%01' " +
                                        "GROUP BY CanvasType ORDER BY SUM(NumberOfTickets) DESC;");
            stmt.setString(1, startDateString);
            stmt.setString(2, endDateString);
            
            result = stmt.executeQuery();
            while (result.next())
            {
                dataObject.addARecord(result.getString("CanvasType"), result.getInt("NumberOfTickets"));
            }
        }
        catch(SQLException e)
        {
            throw e;
        }
        finally
        {
            if (stmt!=null)
            {
                stmt.close();
            }
            
            if (result!=null)
            {
                result.close();
            }
        }
        
        return dataObject;
    }

    @Override
    public SupportTicketAssignedTechData getSupportTicketAssignedTechData(LocalDate startDate, LocalDate endDate)throws SQLException{
        String startDateString = startDate.toString();
        String endDateString = endDate.toString();
        
        SupportTicketAssignedTechData dataObject = new SupportTicketAssignedTechData(startDate, endDate);
        
        PreparedStatement stmt = null;
        ResultSet result = null;
        
        try
        {
            stmt = conn.prepareStatement("SELECT Tech, SUM(NumberOfTickets) AS NumberOfTickets " +
                                        "FROM SupportTicketAssignedTech WHERE StartTime>=? AND EndTime<=? AND StartTime LIKE '%01' AND EndTime LIKE '%01' " +
                                        "GROUP BY Tech ORDER BY Tech;");
            stmt.setString(1, startDateString);
            stmt.setString(2, endDateString);
            
            result = stmt.executeQuery();
            while (result.next())
            {
                dataObject.addARecord(result.getString("Tech"), result.getInt("NumberOfTickets"));
            }
        }
        catch(SQLException e)
        {
            throw e;
        }
        finally
        {
            if (stmt!=null)
            {
                stmt.close();
            }
            
            if (result!=null)
            {
                result.close();
            }
        }
        
        return dataObject;
    }

    @Override
    public TicketFiveMostFrequentIssuesData getTicketFiveMostFrequentIssuesData(LocalDate startDate, LocalDate endDate, WorkerEnum handleBy) throws SQLException {
        String startDateString = startDate.toString();
        String endDateString = endDate.toString();
        
        TicketFiveMostFrequentIssuesData dataObject = new TicketFiveMostFrequentIssuesData(startDate, endDate, handleBy);
        
        PreparedStatement stmt = null;
        ResultSet result = null;
        
        try
        {
            stmt = conn.prepareStatement("SELECT IssueType, SUM(NumberOfTickets) AS NumberOfTickets " +
                                        "FROM CstlFrequentIssues WHERE StartTime>=? AND EndTime<=? AND StartTime LIKE '%01' AND EndTime LIKE '%01' AND HandleByWorkerEnum =? " +
                                        "GROUP BY IssueType ORDER BY SUM(NumberOfTickets) DESC;");
            stmt.setString(1, startDateString);
            stmt.setString(2, endDateString);
            stmt.setInt(3, handleBy.value());
            
            result = stmt.executeQuery();
            while (result.next())
            {
                dataObject.addARecord(result.getString("IssueType"), result.getInt("NumberOfTickets"));
            }
        }
        catch(SQLException e)
        {
            throw e;
        }
        finally
        {
            if (stmt!=null)
            {
                stmt.close();
            }
            
            if (result!=null)
            {
                result.close();
            }
        }
        
        return dataObject;
    }

    @Override
    public CSTLConsultData getCSTLConsultData(LocalDate startDate, LocalDate endDate, WorkerEnum consultBy) throws SQLException{
        String startDateString = startDate.toString();
        String endDateString = endDate.toString();
        
        CSTLConsultData dataObject = new CSTLConsultData(startDate, endDate, consultBy);
        
        PreparedStatement stmt = null;
        ResultSet result = null;
        
        try
        {
            stmt = conn.prepareStatement("SELECT FacultyName, SUM(ConsultTimes) AS ConsultTimes " +
                                        "FROM CSTLConsult WHERE StartTime>=? AND EndTime<=? AND StartTime LIKE '%01' AND EndTime LIKE '%01' AND ConsultByWorkerEnum = ? " +
                                        "GROUP BY FacultyName ORDER BY SUM(ConsultTimes) DESC;");
            stmt.setString(1, startDateString);
            stmt.setString(2, endDateString);
            stmt.setInt(3, consultBy.value());
            
            result = stmt.executeQuery();
            while (result.next())
            {
                dataObject.addARecord(result.getString("FacultyName"), result.getInt("ConsultTimes"));
            }
        }
        catch(SQLException e)
        {
            throw e;
        }
        finally
        {
            if (stmt!=null)
            {
                stmt.close();
            }
            
            if (result!=null)
            {
                result.close();
            }
        }
        
        return dataObject;
    }
}
