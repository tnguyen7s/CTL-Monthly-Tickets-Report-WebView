/*
Southeast Missouri State University
CSTL - Tickets Monthly Report Web View project
 */
package com.cstl.model.DataAccess;

import com.cstl.model.entity.CSTLConsultData;
import com.cstl.model.entity.SupportTicketAssignedTechData;
import com.cstl.model.entity.TicketBreakDownByCanvasTypeData;
import com.cstl.model.entity.TicketBreakDownByContactTypeData;
import com.cstl.model.entity.TicketBreakDownByRequestTypeData;
import com.cstl.model.entity.TicketFiveMostFrequentIssuesData;
import com.cstl.model.enums.ReportTypeEnum;
import com.cstl.model.enums.WorkerEnum;
import com.cstl.model.query.IQuery;
import com.cstl.model.query.Query;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.regex.Pattern;

/**
 *
 * @author Tuyen
 * DataAccess superclass 
 */
public class DataAccess implements IDataAccess{
    private final IQuery query;
    private final DateTimeFormatter dateFormatter;
    private final DateTimeFormatter dateFormatter2;
    public DataAccess(String dbConnectionString) throws SQLException, ClassNotFoundException
    {
        query = new Query(dbConnectionString);
        dateFormatter = new DateTimeFormatterBuilder().parseCaseInsensitive().append(DateTimeFormatter.ofPattern("d LLL, yyyy")).toFormatter(Locale.US);
        dateFormatter2 = new DateTimeFormatterBuilder().parseCaseInsensitive().append(DateTimeFormatter.ofPattern("LLL, yyyy")).toFormatter(Locale.US);
    }
    
    @Override
    public List<String> getTop20StartTimes()throws SQLException{
        List<String> queryResults = this.query.getTop20StartTimes();
        
        LocalDate startTime;
        String[] parts;
        int day, month, year;
        List<String> top20 = null;
        if (queryResults!=null)
        {
            top20 = new ArrayList<>(queryResults.size());
            for (String dateString:queryResults)
            {
                parts = Pattern.compile("-").split(dateString);
                year = Integer.parseInt(parts[0]);
                month = Integer.parseInt(parts[1]);
                day = Integer.parseInt(parts[2]);
                
                startTime = LocalDate.of(year, month, day);
                top20.add(startTime.format(dateFormatter2));
            }   
        }
        
        return top20;
    }
    
    @Override
    public List<String> getTop20EndTimes()throws SQLException
    {
        List<String> queryResults = this.query.getTop20EndTimes();
        
        LocalDate endTime;
        String[] parts;
        int day, month, year;
        List<String> top20 = null;
        if (queryResults!=null)
        {
            top20 = new ArrayList<>(queryResults.size());
            for (String dateString:queryResults)
            {
                parts = Pattern.compile("-").split(dateString);
                year = Integer.parseInt(parts[0]);
                month = Integer.parseInt(parts[1]);
                day = Integer.parseInt(parts[2]);
                
                endTime = LocalDate.of(year, month, day);
                top20.add(endTime.format(dateFormatter2));
            }   
        }
        
        return top20;
    }
    
    public LinkedHashMap<String, Integer> getTicketsData(int reportTypeEnum, String startDate, String endDate) throws SQLException
    {
       if(reportTypeEnum == ReportTypeEnum.BREAK_DOWN_BY_CONTACT_TYPE.getEnumValue())
       {
           return this.getTicketBreakDownByContactTypeData(startDate, endDate).getDataHashmap();
       }
       else if (reportTypeEnum == ReportTypeEnum.BREAK_DOWN_BY_REQUEST_TYPE.getEnumValue())
       {
           return this.getTicketBreakDownByRequestTypeData(startDate, endDate).getDataHashMap();
       }
       else if (reportTypeEnum == ReportTypeEnum.BREAK_DOWN_BY_CANVAS_TYPE.getEnumValue())
       {
           return this.getTicketBreakDownByCanvasTypeData(startDate, endDate).getDataHashmap();
       }
       else if(reportTypeEnum == ReportTypeEnum.FIVE_MOST_FREQUENT_ISSUES_HANDLED_BY_GA.getEnumValue())
       {
           return this.getTicketFiveMostFrequentIssuesData(startDate, endDate, WorkerEnum.GA).getDataHashmap();
       }
       else if(reportTypeEnum == ReportTypeEnum.FIVE_MOST_FREQUENT_ISSUES_HANDLED_BY_STUDENT_WORKERS.getEnumValue())
       {
           return this.getTicketFiveMostFrequentIssuesData(startDate, endDate, WorkerEnum.STUDENT_WORKER).getDataHashmap();
       }
       else if(reportTypeEnum == ReportTypeEnum.SUPPORT_TICKETS_ASSIGNED_TECH.getEnumValue())
       {
           return this.getSupportTicketAssignedTechData(startDate, endDate).getDataHashmap();
       }
       else if (reportTypeEnum == ReportTypeEnum.TOP_10_FACULTY_WHO_CONSULT_WITH_KRIS_BARANOVIC.getEnumValue())
       {
           return this.getCSTLConsultData(startDate, endDate, WorkerEnum.KRIS_BARANOVIC).getDataHashmap();
       }
       else 
       {
           return this.getCSTLConsultData(startDate, endDate, WorkerEnum.MARY_HARRIET).getDataHashmap();
       }          
    }

    @Override
    public TicketBreakDownByContactTypeData getTicketBreakDownByContactTypeData(String startDate, String endDate) throws SQLException {
        return this.query.getTicketBreakDownByContactTypeData(LocalDate.parse(startDate, dateFormatter), LocalDate.parse(endDate, dateFormatter));
    }

    @Override
    public TicketBreakDownByRequestTypeData getTicketBreakDownByRequestTypeData(String startDate, String endDate) throws SQLException {
        return this.query.getTicketBreakDownByRequestTypeData(LocalDate.parse(startDate, dateFormatter), LocalDate.parse(endDate, dateFormatter));
    }

    @Override
    public TicketBreakDownByCanvasTypeData getTicketBreakDownByCanvasTypeData(String startDate, String endDate) throws SQLException {
        return this.query.getTicketBreakDownByCanvasTypeData(LocalDate.parse(startDate, dateFormatter), LocalDate.parse(endDate, dateFormatter));
    }

    @Override
    public SupportTicketAssignedTechData getSupportTicketAssignedTechData(String startDate, String endDate) throws SQLException {
        return this.query.getSupportTicketAssignedTechData(LocalDate.parse(startDate, dateFormatter), LocalDate.parse(endDate, dateFormatter));
    }

    @Override
    public TicketFiveMostFrequentIssuesData getTicketFiveMostFrequentIssuesData(String startDate, String endDate, WorkerEnum handleBy) throws SQLException {
        return this.query.getTicketFiveMostFrequentIssuesData(LocalDate.parse(startDate, dateFormatter), LocalDate.parse(endDate, dateFormatter), handleBy);
    }

    @Override
    public CSTLConsultData getCSTLConsultData(String startDate, String endDate, WorkerEnum consultBy) throws SQLException {
        return this.query.getCSTLConsultData(LocalDate.parse(startDate, dateFormatter), LocalDate.parse(endDate, dateFormatter), consultBy);
    }

    @Override
    public void close() throws SQLException {
        query.close();
    }

}
