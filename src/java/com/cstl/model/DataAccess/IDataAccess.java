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
import com.cstl.model.enums.WorkerEnum;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author Tuyen
 * Data access layer 
 */
public interface IDataAccess {
     /*
    Get top 20 end time of all available report data in the database
    @returns A list of Dates in this format mmm, yyyy
    */
    public List<String> getTop20StartTimes()throws SQLException;
    
     /*
    Get top 20 start time of all available report data in the database
    @returns A list of Dates in this format mmm, yyyy
    */
    public List<String> getTop20EndTimes()throws SQLException;
    
     /*
    Get ticket data breakdown by contact type by month
    Args: startDate - the start date of the aggregate data
          endDate - the end date of the aggregate data
    Returns: TicketBreakDownByContactTypeData - The object contains the data of the report type.
    */
    public TicketBreakDownByContactTypeData getTicketBreakDownByContactTypeData(String startDate, String endDate) throws SQLException;
    
    /*
    Get ticket data breakdown by request type by month
    Args: startDate - the start date of the aggregate data
          endDate - the end date of the aggregate data
    Returns: TicketBreakDownByRequesrTypeData - The object contains the data of the report type.
    */
    public TicketBreakDownByRequestTypeData getTicketBreakDownByRequestTypeData(String startDate, String endDate) throws SQLException;
    
    /*
    Get ticket data breakdown by Canvas type by month
    Args: startDate - the start date of the aggregate data
          endDate - the end date of the aggregate data
    Returns: TicketBreakDownByCanvasTypeData - The object contains the data of the report type.
    */
    public TicketBreakDownByCanvasTypeData getTicketBreakDownByCanvasTypeData(String startDate, String endDate) throws SQLException;
    
    
    /*
    Get support ticket assigned tech data by month
    Args: startDate - the start date of the aggregate data
          endDate - the end date of the aggregate data
    Returns: SupportTicketAssignedTechData - The object contains the data of the report type.
    */
    public SupportTicketAssignedTechData getSupportTicketAssignedTechData(String startDate, String endDate) throws SQLException;
    
    /*
    Get ticket data about five most frequent issues by month
    Args: startDate - the start date of the aggregate data
          endDate - the end date of the aggregate data
    Returns: TicketFiveMostFrequentIssuesData - The object contains the data of the report type.
    */   
    public TicketFiveMostFrequentIssuesData getTicketFiveMostFrequentIssuesData(String startDate, String endDate, WorkerEnum handleBy) throws SQLException;
    
    /*
    Get ticket data about CSTL consults
    Args: startDate - the start date of the aggregate data
          endDate - the end date of the aggregate data
    Returns: CSTLConsultData - The object contains the data of the report type.
    */   
    public CSTLConsultData getCSTLConsultData(String startDate, String endDate, WorkerEnum consultBy) throws SQLException;
    
    
    /*Close the database connection*/
    public void close() throws SQLException;
}
