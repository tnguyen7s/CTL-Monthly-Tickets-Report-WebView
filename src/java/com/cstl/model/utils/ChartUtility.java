/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.cstl.model.utils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

/**
 *
 * @author Tuyen
 */
public class ChartUtility{
    
    private static final String[] colorPalleteArray = {"#3C9D4E", "#7031AC", "#C94D6D", "#E4BF58", "#4174C9", "#B276B2", "#4D4D4D"};
    private static final String[] hightlightedFieldsArray = {"E-Mail", "Telephone", "Walk-in", "CSTL > Canvas Help", "CSTL > Consultation", "CSTL > SmartEvals", "CSTL > Tools", "CSTL 2 Student Worker", "CSTL GA", "CSTL Student Worker", "Kris Baranovic", "Mary Harriet Talbut"};
    private static final String[] layer1TechsArray = {"CSTL Student Worker", "CSTL 2 Student Worker"};
    private static final String[] layer2TechsArray = {"CSTL GA"};
    private static final String[] layer3TechsArray = {"Mary Harriet Talbut", "Kris Baranovic"};
    private static final String[] layersTechs = {"Layer 1 Techs: CTL Student Workers", "Layer 2 Techs: CTL Graduate Assistants", "Layer 3 Techs: CTL Administrators", "Layer 4 Techs: IT Administration"};
    public static List<ChartSegment> getChartDefinition(LinkedHashMap<String, Integer> data)
    {
        Queue<String> chartColorPallete = new LinkedList<>(Arrays.asList(colorPalleteArray));
        
        double total = data.get("Total");
        
        List<ChartSegment> definition = new ArrayList<>();
        
        String percentage;
        String color;
        int accumulative = 0;
        for (String field:data.keySet())
        {
            if (field.compareTo("Total")!=0 && data.get(field)!=0)
            {
                accumulative += (int)Math.round((data.get(field)/total)*100);
                percentage = ""+(int)(Math.round((data.get(field)/total)*100))+"%";
                color = chartColorPallete.poll();
                if (percentage.compareTo("0%")!=0)
                {
                    definition.add(new ChartSegment(field, color, percentage, accumulative+"%"));
                }
            }
        }
        return definition;
    }
    
    public static List<ChartSegment> getSupportTicketAssignedTechReportChartDefinition(LinkedHashMap<String, Integer> data)
    {
        LinkedHashMap<String, Integer> inferencedData = new LinkedHashMap<>();
       
        int[] layersTickets = new int[4];
        
        ArrayList<String> layer1Techs = new ArrayList<>(Arrays.asList(layer1TechsArray));
        ArrayList<String> layer2Techs = new ArrayList<>(Arrays.asList(layer2TechsArray));
        ArrayList<String> layer3Techs = new ArrayList<>(Arrays.asList(layer3TechsArray));
        
        // get aggregate data for each layer of tech
        for (String key:data.keySet())
        {
            if (layer1Techs.contains(key))
            {
                layersTickets[0] += data.get(key);
            }
            else if (layer2Techs.contains(key))
            {
                layersTickets[1] += data.get(key);
            }
            else if (layer3Techs.contains(key))
            {
                layersTickets[2] += data.get(key);
            }
            else if (key.compareTo("Total")!=0)
            {
                layersTickets[3] += data.get(key);
            }
        }
        
        // build the inferenced data hashmap 
        for (int i=0; i<layersTechs.length; i++)
        {
            inferencedData.put(layersTechs[i], layersTickets[i]);
        }
        inferencedData.put("Total", data.get("Total"));
        
        // get the chart definition based on the inferenced data
        return getChartDefinition(inferencedData);
    }
    
    public static boolean isHightlighted(String field)
    {
         ArrayList<String> hightlightedFields = new ArrayList<>(Arrays.asList(hightlightedFieldsArray));
         return hightlightedFields.contains(field);  
    }
    
}
