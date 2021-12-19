/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.cstl.model.exception;

import java.io.PrintWriter;
import java.io.StringWriter;

/**
 *
 * @author Tuyen
 */
public class ExceptionUtils {
    public static String getStackTrace(Throwable ex)
    {
        final StringWriter sw = new StringWriter();
        final PrintWriter pw = new PrintWriter(sw, true);
        
        while (ex!=null)
        {
            ex.printStackTrace(pw);
            pw.toString();
        }
        
        return sw.toString();
    }
    public static String getStackTrace2(Throwable ex)
    {
        StackTraceElement[] traces = ex.getStackTrace();
        String content="";
        for (int i=0; i<traces.length; i++)
        {
            content = "at " + traces[i].getFileName() + "/" + traces[i].getClassName()+"/"+ traces[i].getMethodName() + "line:" + traces[i].getLineNumber();
        }
        content += "Cause: " + ex.getMessage();
        return content;
    }
}
