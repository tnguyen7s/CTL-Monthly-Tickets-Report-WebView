/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.cstl.model.utils;

/**
 *
 * @author Tuyen
 */
public class ChartSegment {
    public String field;
    public String color;
    public String percentage;
    public String accumulative;
    public ChartSegment(String field, String color, String percentage, String accumulative)
    {
        this.field = field;
        this.color = color;
        this.percentage = percentage;
        this.accumulative = accumulative;
    }
}
