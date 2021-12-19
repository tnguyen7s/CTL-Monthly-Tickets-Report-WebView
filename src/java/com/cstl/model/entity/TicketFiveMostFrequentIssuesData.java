/*
Southeast Missouri State University
CSTL - Tickets Monthly Report Web View project
 */
package com.cstl.model.entity;

import com.cstl.model.enums.WorkerEnum;
import java.time.LocalDate;
import java.util.LinkedHashMap;

/**
 *
 * @author Tuyen
 * Five Most Frequent Issues ticket report data
 */
public class TicketFiveMostFrequentIssuesData {
    private LinkedHashMap<String, Integer> data;
    private LocalDate startDate;
    private LocalDate endDate;
    private WorkerEnum handleBy;
    
    public TicketFiveMostFrequentIssuesData(LocalDate startDate, LocalDate endDate, WorkerEnum worker)
    {
        this.data = new LinkedHashMap<>();
        this.startDate = startDate;
        this.endDate = endDate;
        this.handleBy = worker;
    }

    public void addARecord(String issue, int numberOfTickets)
    {
        data.put(issue, numberOfTickets);
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
    
    public WorkerEnum getWhoHandles()
    {
        return this.handleBy;
    }
    
}
