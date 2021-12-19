/*
Southeast Missouri State University
CSTL - Tickets Monthly Report Web View project
 */
package com.cstl.model.enums;

/**
 *
 * @author Tuyen
 */
public enum ReportTypeEnum {
     BREAK_DOWN_BY_CONTACT_TYPE("Break Down by Contact Type", 0),
     BREAK_DOWN_BY_REQUEST_TYPE("Break Down by Request Type", 1),
     BREAK_DOWN_BY_CANVAS_TYPE("Break Down by Canvas Type", 2),
     TOP_10_FACULTY_WHO_CONSULT_WITH_KRIS_BARANOVIC("Top 10 Faculty who consult with Kris Baranovic", 3),
     TOP_10_FACULTY_WHO_CONSULT_WITH_MARY_HARRIET("Top 10 Faculty who consult with Mary Harriet", 4),
     FIVE_MOST_FREQUENT_ISSUES_HANDLED_BY_STUDENT_WORKERS("Five Most Frequent Issues Handled by Student Workers", 5),
     FIVE_MOST_FREQUENT_ISSUES_HANDLED_BY_GA("Five Most Frequent Issues Handled by Graduate Assistants", 6),
     SUPPORT_TICKETS_ASSIGNED_TECH("Support Ticket Assigned Tech", 7);
     
     private int value;
     private String name;
     ReportTypeEnum(String name, int value)
     {
         this.name = name;
         this.value= value;
     }
     
     public int getEnumValue()
     {
         return value;
     }
     
     public String getEnumName()
     {
         return name;
     }
}
