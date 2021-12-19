/*
Southeast Missouri State University
CSTL - Tickets Monthly Report Web View project
 */
package com.cstl.model.enums;

/**
 *
 * @author Tuyen
 * Worker enum
 */
public enum WorkerEnum{
    EVERYONE(0),
    STUDENT_WORKER(1),
    GA(2),
    MARY_HARRIET(3),
    KRIS_BARANOVIC(4);

    private int value;
    WorkerEnum(int value)
    {
        this.value=value;
    }
    
    public int value()
    {
        return value;
    }
}
