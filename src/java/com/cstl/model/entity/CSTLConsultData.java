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
 * CSTL Consult Report Data
 */
public class CSTLConsultData {
    private LinkedHashMap<String, Integer> data;
    private LocalDate startDate;
    private LocalDate endDate;
    private WorkerEnum consultBy;
    
    public CSTLConsultData(LocalDate startDate, LocalDate endDate, WorkerEnum worker)
    {
        this.data = new LinkedHashMap<>();
        this.startDate = (LocalDate)startDate;
        this.endDate = (LocalDate)endDate;
        this.consultBy = worker;
    }
    
    public void addARecord(String clientName, int numberOfConsults)
    {
        data.put(clientName, numberOfConsults);
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
    
    public WorkerEnum getWhoConsults()
    {
        return this.consultBy;
    }
}
