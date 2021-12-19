/*
Southeast Missouri State University
CSTL - Tickets Monthly Report Web View project
 */
package com.cstl.listener;

import com.cstl.model.DataAccess.DataAccess;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebServlet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;



/**
 *
 * @author Tuyen
 */
@WebServlet
public class AppContextListener implements ServletContextListener{
    /**
     * Once app starts, load this class and init the app context with shared resource-data access layer.
     * Either a DataAccess instance or null.
     * @param sce 
     */
    @Override
    public void contextInitialized(ServletContextEvent sce)
    {
        ServletContext context = sce.getServletContext();
        
        String dbConnectionString = context.getInitParameter("DbConnectionString");
        DataAccess dataAccess = null;
        
        try {
            dataAccess = new DataAccess(dbConnectionString);
            System.out.println("DataAccess is instantiated successfully in app context listener.");
        } catch (SQLException ex) {
            Logger.getLogger(AppContextListener.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AppContextListener.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        context.setAttribute("DataAccess", dataAccess);
    }
    
    /**
     * Clean resource once the app shutdown.
     * @param sce 
     */
    @Override 
    public void contextDestroyed(ServletContextEvent sce)
    {
        DataAccess dataAccess = (DataAccess) sce.getServletContext().getAttribute("DataAccess");
        try {
            dataAccess.close();
        } 
          catch (SQLException ex) {
            Logger.getLogger(AppContextListener.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
