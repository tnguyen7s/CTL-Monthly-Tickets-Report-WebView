/*
Southeast Missouri State University
CSTL - Tickets Monthly Report Web View project
 */
package com.cstl.model.entity;

import java.time.LocalDate;
import java.util.LinkedHashMap;

/**
 *
 * @author Tuyen
 * Data about Break Down By Canvas Type Tickets Report Data
 */
public class TicketBreakDownByCanvasTypeData {
    private LinkedHashMap<String, Integer> data;
    private LocalDate startDate;
    private LocalDate endDate;
    
    public TicketBreakDownByCanvasTypeData(LocalDate startDate, LocalDate endDate)
    {
        this.data = new LinkedHashMap<>();
        this.startDate = startDate;
        this.endDate = endDate;
    }
    
    public void addARecord(String type, int numberOfTickets)
    {
        data.put(type, numberOfTickets);
    }
    
    public LinkedHashMap<String, Integer> getDataHashmap()
    {
        LinkedHashMap<String, Integer> tmp = new LinkedHashMap<>();
        for (String key:data.keySet())
        {
            tmp.put(key, data.get(key));
        }
        return tmp;
    }
    
    public LocalDate getStartDate()
    {
        return startDate;
    }
    
    public LocalDate getEndDate()
    {
        return endDate;
    }
}
