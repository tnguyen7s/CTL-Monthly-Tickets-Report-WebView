/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cstl.servlet;

import com.cstl.model.DataAccess.DataAccess;
import com.cstl.model.enums.ReportTypeEnum;
import com.cstl.model.exception.ExceptionUtils;
import com.cstl.model.utils.ChartUtility;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.LinkedHashMap;

/**
 *
 * @author Tuyen
 */
public class ReportDataServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ReportDataServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ReportDataServlet at " + request.getContextPath() + "</h1>");
            out.println("<p>Db connection string: "+request.getServletContext().getInitParameter("DbConnectionString")+"</p>");
            out.println("</body>");
            out.println("</html>");
           
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        // Using report.jsp to display
        RequestDispatcher dispatcher = request.getRequestDispatcher("report.jsp");
        
        boolean validInput = true;
        
        // get users' selected report type.
        int selectedReportTypeEnum=0;
        try{
            selectedReportTypeEnum = Integer.parseInt(request.getParameter("reportType"));
        }
        catch (NumberFormatException e)
        {
            validInput = false;
            request.setAttribute("validInput", validInput);
            dispatcher.forward(request, response);
            return;
        }
        
        // get users' selected report time range
        String startTime, endTime;
        startTime = request.getParameter("startTime");
        endTime = request.getParameter("endTime");
        if (startTime.compareTo("")==0 || endTime.compareTo("")==0)
        {
            validInput = false;
            request.setAttribute("validInput", validInput);
            dispatcher.forward(request, response);
            return;
        }
        
        // if all inputs are valid.
        DataAccess dataAccess = (DataAccess) request.getServletContext().getAttribute("DataAccess");
        if (dataAccess == null)
        {
            throw new ServletException("Data Access is null.");
        }
        
        // set the request's valid input to be true in the request
        LinkedHashMap<String, Integer> data = null;
        try {
            data = dataAccess.getTicketsData(selectedReportTypeEnum, "1 "+startTime,"1 "+endTime);
        } catch (SQLException ex) {
            throw new ServletException(ExceptionUtils.getStackTrace2(ex));
        }
        request.setAttribute("validInput", validInput);
        request.setAttribute("reportOutput", data);
        
        // get the type of report: table/chart/table+chart
        String dataFormat = request.getParameter("dataFormat");
        if (dataFormat.compareTo("")==0)
        {
            validInput = false;
            request.setAttribute("validInput", validInput);
            dispatcher.forward(request, response);
            return;
        }
        
        // get chart definition
        if ((dataFormat.compareTo("chart")==0 || dataFormat.compareTo("chart+table")==0) &&!data.isEmpty())
        {
            if (selectedReportTypeEnum == ReportTypeEnum.SUPPORT_TICKETS_ASSIGNED_TECH.getEnumValue())
            {
                request.setAttribute("chartDefinition", ChartUtility.getSupportTicketAssignedTechReportChartDefinition(data));
            }
            else
            {
                request.setAttribute("chartDefinition", ChartUtility.getChartDefinition(data));
            }
        }
        
        // set the report type name in the request
        request.setAttribute("reportType", this.getReportName(selectedReportTypeEnum));
        
        // set the time range in the request
        request.setAttribute("startTime", startTime);
        request.setAttribute("endTime", endTime);
        
        // set the header
        String[] headerNames = this.getHeaderNames(selectedReportTypeEnum);
        request.setAttribute("headerNames", headerNames);
        
        // forward to report.jsp to get the data and display
        dispatcher.forward(request, response);
        
    }
    
    public String getReportName(int reportTypeEnum)
    {
        if(reportTypeEnum == ReportTypeEnum.BREAK_DOWN_BY_CONTACT_TYPE.getEnumValue())
       {
           return ReportTypeEnum.BREAK_DOWN_BY_CONTACT_TYPE.getEnumName();
       }
       else if (reportTypeEnum == ReportTypeEnum.BREAK_DOWN_BY_REQUEST_TYPE.getEnumValue())
       {
           return ReportTypeEnum.BREAK_DOWN_BY_REQUEST_TYPE.getEnumName();
       }
       else if (reportTypeEnum == ReportTypeEnum.BREAK_DOWN_BY_CANVAS_TYPE.getEnumValue())
       {
           return ReportTypeEnum.BREAK_DOWN_BY_CANVAS_TYPE.getEnumName();
       }
       else if(reportTypeEnum == ReportTypeEnum.FIVE_MOST_FREQUENT_ISSUES_HANDLED_BY_GA.getEnumValue())
       {
           return ReportTypeEnum.FIVE_MOST_FREQUENT_ISSUES_HANDLED_BY_GA.getEnumName();
       }
       else if(reportTypeEnum == ReportTypeEnum.FIVE_MOST_FREQUENT_ISSUES_HANDLED_BY_STUDENT_WORKERS.getEnumValue())
       {
           return ReportTypeEnum.FIVE_MOST_FREQUENT_ISSUES_HANDLED_BY_STUDENT_WORKERS.getEnumName();
       }
       else if(reportTypeEnum == ReportTypeEnum.SUPPORT_TICKETS_ASSIGNED_TECH.getEnumValue())
       {
           return ReportTypeEnum.SUPPORT_TICKETS_ASSIGNED_TECH.getEnumName();
       }
       else if (reportTypeEnum == ReportTypeEnum.TOP_10_FACULTY_WHO_CONSULT_WITH_KRIS_BARANOVIC.getEnumValue())
       {
           return ReportTypeEnum.TOP_10_FACULTY_WHO_CONSULT_WITH_KRIS_BARANOVIC.getEnumName();
       }
       else 
       {
           return ReportTypeEnum.TOP_10_FACULTY_WHO_CONSULT_WITH_MARY_HARRIET.getEnumName();
       }          
    }
    
     public String[] getHeaderNames(int reportTypeEnum)
     {
         String[] headerNames = new String[2];
         if (reportTypeEnum == ReportTypeEnum.SUPPORT_TICKETS_ASSIGNED_TECH.getEnumValue())
         {
             headerNames[0] = "Tech";
             headerNames[1] = "Number of Tickets";
         }
         else if (reportTypeEnum == ReportTypeEnum.TOP_10_FACULTY_WHO_CONSULT_WITH_KRIS_BARANOVIC.getEnumValue() || reportTypeEnum ==ReportTypeEnum.TOP_10_FACULTY_WHO_CONSULT_WITH_MARY_HARRIET.getEnumValue())
         {
             headerNames[0] = "Faculty";
             headerNames[1] = "Number of Consult Times";
         }
         else
         {
             headerNames[0] = "Type";
             headerNames[1] = "Number of Tickets";
         }
         
         return headerNames;
     }
    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
