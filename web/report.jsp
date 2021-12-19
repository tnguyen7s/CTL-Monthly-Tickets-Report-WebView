<%-- 
    Document   : report.jsp
    Created on : Nov 7, 2021, 11:15:34 AM
    Author     : Tuyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.cstl.model.enums.ReportTypeEnum"%>
<%@page import="com.cstl.model.utils.ChartSegment"%>
<%@page import="com.cstl.model.utils.ChartUtility"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<title>SEMO CSTL Support Tickets Web View</title>
		<meta charset="utf-8">
		<meta name="description" content="The site is designed to help view ticket data reports(including tables and charts)
		about CSTL supports to faculty at Southeast Missouri State University.">
		
		<!--Icon for Title-->
		<link rel="shortcut icon" href="favicon.ico">
		
		<!--Style-->
		<link rel="stylesheet" type="text/css" href="css/styles.css">
                
                <!-- Temporarily not use this css file-->
                <!-- <style type="text/css"> -->
                <!-- %@ include file="css/styles.css" % --> 
                <!-- </style> -->
		
		<!--Font-->
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=Belleza&display=swap" rel="stylesheet">
		<script type="text/javascripts" scr="https://leaverou.github.io/conic-gradient/"></script>
	</head>
	<body>
		<!--		Header			-->
		<header>
			<div id="semo-background"></div>
			<div id="overlay"></div>
			<section id="header-content">
                            <img src="${pageContext.request.contextPath}/images/semo_logo.png" alt="Southeast Missouri State University white logo">
				<h1>CENTER FOR TEACHING AND LEARNING</h1>
			</section>
			
			<!--		About section		-->
			<section id="about">
				<div id="about-content">
					<h2 class="red-font">CTL</h2> 
					<h2>Monthly Tickets Data Report Web View</h2>
					<p>This website is designed to give you a view to CSTL monthly data report with tables and charts.
					I hope you are going to have a great experience with it.</p>
					<nav>
						<ul>
							<li>
								<a id="nav-button" href="home">START WITH SINGLE VIEW</a>
							</li>
							<li>
								<a id="nav-link" href="">or Go to Multiple Views ></a>
							</li>
						</ul>
					</nav>
				</div>
				
				
				<div id="about-moreinfo">
					<div>
						<img src="${pageContext.request.contextPath}/images/whd_logo.png" alt="Web Help Desk logo">
						<p>
							Data source: Web Help Desk
						</p>
					</div>
					
					<div>
						<img src="${pageContext.request.contextPath}/images/canvas_logo.png" alt="Canvas Learning Management System logo">
						<p>
							CTL's main support: Canvas
						</p>
					</div>
					
				</div>
			</section>
			
		</header>
		<!--		Main			-->
		<main>
                <section id="reportDisplayArea">
                    <%
                        String dataFormat = request.getParameter("dataFormat");
                        Boolean isValidRequestInput = (Boolean)request.getAttribute("validInput"); 
                        if (!isValidRequestInput)
                        {
                            out.println("<div id=\"errorArea\">");
                            out.println("<h3>Missing input.</h3>");
                            out.println("<p>Hi! Please check to make sure that you have specified the report type, the report time range (start and end date), and the data format (chart/table) before generating the report.</p>");
                            out.println("</div>");
                        }  
                        else{
                            LinkedHashMap<String, Integer> dataToDisplay = (LinkedHashMap<String, Integer>)request.getAttribute("reportOutput");
                            if (dataToDisplay.size()==0)
                            {
                                out.println("<div id=\"errorArea\">");
                                out.println("<h3>Unfound data.</h3>");
                                out.println("<p>Hi! We could not find the data in the database given your request input.</p>");
                                out.println("</div>");
                            }
                            else
                            {
                                String reportName = (String)request.getAttribute("reportType");
                                String startTime = (String)request.getAttribute("startTime");
                                String endTime = (String)request.getAttribute("endTime");
                                String reportCaption = (String)String.format("%s<br>%s - %s", reportName, startTime, endTime);
                                String[] headerNames = (String[])request.getAttribute("headerNames");

                                /*********************************TABLE*************************************************/
                                if (dataFormat.compareTo("table") == 0)
                                {
                                    out.println("<table>");
                                    out.println("<caption>");
                                    out.println(reportCaption);
                                    out.println("</caption>");

                                    // table HEADER
                                    out.println("<thead>");
                                    out.println("<tr>");
                                    out.println("<th class=\"center\">Time</th>");
                                    for (int i=0; i<headerNames.length; i++)
                                    {
                                        out.println("<th>");
                                        out.println(headerNames[i]);
                                        out.println("</th>");
                                    }
                                    out.println("</tr>");
                                    out.println("</thead>");

                                    // table BODY
                                    out.println("<tbody>");
                                    int rowNum =  dataToDisplay.size()+1;

                                    String mergedCellHtml = String.format("<tr><td class=\"center\" rowspan=\"%d\">%s</td></tr>", rowNum, startTime);
                                    out.println(mergedCellHtml);

                                    String dataRowHtml;
                                    int count = 0;
                                    for (String key:dataToDisplay.keySet())
                                    {
                                        if (key.compareTo("Total")!=0)
                                        {
                                            if (ChartUtility.isHightlighted(key)) 
                                            {
                                                out.println("<tr class=\"aqua\">");
                                            }
                                            else if((reportName.compareTo(ReportTypeEnum.BREAK_DOWN_BY_CANVAS_TYPE.getEnumName())==0 || reportName.compareTo(ReportTypeEnum.FIVE_MOST_FREQUENT_ISSUES_HANDLED_BY_GA.getEnumName())==0 || reportName.compareTo(ReportTypeEnum.FIVE_MOST_FREQUENT_ISSUES_HANDLED_BY_STUDENT_WORKERS.getEnumName())==0) && count<5)
                                            {
                                                out.println("<tr class=\"aqua\">");
                                                count++;
                                            }

                                            else if ((reportName.compareTo(ReportTypeEnum.TOP_10_FACULTY_WHO_CONSULT_WITH_KRIS_BARANOVIC.getEnumName())==0 || reportName.compareTo(ReportTypeEnum.TOP_10_FACULTY_WHO_CONSULT_WITH_MARY_HARRIET.getEnumName())==0) && count<10)
                                            {
                                                out.println("<tr class=\"aqua\">");
                                                count++;
                                            }
                                            else
                                            {
                                                out.println("<tr>");
                                            }
                                            dataRowHtml = String.format("<td>%s</td> <td>%d</td>", key, dataToDisplay.get(key));
                                            out.println(dataRowHtml);
                                            out.println("</tr>");
                                        }
                                    }

                                    // table FOOTER
                                    if (dataToDisplay.containsKey("Total"))
                                    {
                                        out.println("<tr class=\"yellow\">");
                                        dataRowHtml = String.format("<td>%s</td> <td>%d</td>", "Total", dataToDisplay.get("Total"));
                                        out.println(dataRowHtml);
                                        out.println("</tr>");
                                    }
                                    out.println("</tbody>");
                                    out.println("</table>");
                                }
                                
                                 /*********************************CHART*************************************************/
                                else if (dataFormat.compareTo("chart") == 0)
                                {
                                    List<ChartSegment> chartDefinition = chartDefinition = (List<ChartSegment>)request.getAttribute("chartDefinition");
      
                                    if (reportName.compareTo(ReportTypeEnum.BREAK_DOWN_BY_CONTACT_TYPE.getEnumName())==0 || reportName.compareTo(ReportTypeEnum.SUPPORT_TICKETS_ASSIGNED_TECH.getEnumName())==0)
                                    { 
                                        /*
                                         background: conic-gradient($red 4%, 
                                       $gray 0 8%, 
                                       $blue 0 17%,
                                       $yellow 0 48%,
                                       $purple 0 54%,
                                       $orange 0);
                                        */
                      
                                        out.println("<figure style=\"margin: 60px auto;\">");
                                        
                                        String chartCaption = String.format("%s %s - %s Pie Chart", reportName, startTime, endTime);
                                        out.println("<figcaption>" + chartCaption + "</figcaption>");
                                        
                                        String chartBackground = "background: conic-gradient(";
                                        for (ChartSegment segment:chartDefinition)
                                        {
                                            chartBackground+=segment.color + " 0 " + segment.accumulative + ",";
                                        }
                                        chartBackground=chartBackground.substring(0, chartBackground.length()-1)+");";
                                        out.println("<div style=\"width:95%; max-width:600px;\">");
                                        out.println(String.format("<div class=\"piechart\" style=\"%s\"></div>", chartBackground));
                                        out.println("</div>");
                                        
                                        out.println("<ul class=\"key\">");
                                        for (ChartSegment segment:chartDefinition)
                                        {
                                            out.println("<li>");
                                            out.println(String.format("<strong class=\"percent\" style=\"background:%s;\">%s</strong>",segment.color, segment.percentage));
                                            out.println(String.format("<span class=\"choice\">%s</span>", segment.field));
                                            out.print("</li>");
                                        }
                                        out.println("</ul>");
                                        
                                        out.println("</figure>");
                                    }
                                    else if(reportName.compareTo(ReportTypeEnum.BREAK_DOWN_BY_CANVAS_TYPE.getEnumName())==0 || reportName.compareTo(ReportTypeEnum.FIVE_MOST_FREQUENT_ISSUES_HANDLED_BY_STUDENT_WORKERS.getEnumName())==0 || reportName.compareTo(ReportTypeEnum.FIVE_MOST_FREQUENT_ISSUES_HANDLED_BY_GA.getEnumName())==0)
                                    {
                                        out.println("<dl>");
                                        out.println("<dt>");
                                        out.println(String.format("%s %s - %s Bar Chart", reportName, startTime, endTime));
                                        out.println("</dt>");
                                        
                                        // <dd class="percentage percentage-11"><span class="text">IE 11: 11.33%</span></dd>
                                        for (ChartSegment segment:chartDefinition)
                                        {
                                            out.println(String.format("<dd class=\"percentage percentage-%s\"><span class=\"text\">%s</span></dd>", segment.percentage.replace("%", ""), segment.field));
                                        }
                                               
                                        out.println("</dl>");
                                    }
                                }
                                /*********************************CHART+TABLE********************************************/
                                else
                                {
                                    /*****Table****/
                                    out.println("<table class=\"tableMarginOverride\">");
                                    out.println("<caption>");
                                    out.println(reportCaption);
                                    out.println("</caption>");

                                    // table HEADER
                                    out.println("<thead>");
                                    out.println("<tr>");
                                    out.println("<th class=\"center\">Time</th>");
                                    for (int i=0; i<headerNames.length; i++)
                                    {
                                        out.println("<th>");
                                        out.println(headerNames[i]);
                                        out.println("</th>");
                                    }
                                    out.println("</tr>");
                                    out.println("</thead>");

                                    // table BODY
                                    out.println("<tbody>");
                                    int rowNum =  dataToDisplay.size()+1;

                                    String mergedCellHtml = String.format("<tr><td class=\"center\" rowspan=\"%d\">%s - %s</td></tr>", rowNum, startTime, endTime);
                                    out.println(mergedCellHtml);

                                    String dataRowHtml;
                                    int count = 0;
                                    for (String key:dataToDisplay.keySet())
                                    {
                                        if (key.compareTo("Total")!=0)
                                        {
                                            if (ChartUtility.isHightlighted(key)) 
                                            {
                                                out.println("<tr class=\"aqua\">");
                                            }
                                            else if((reportName.compareTo(ReportTypeEnum.BREAK_DOWN_BY_CANVAS_TYPE.getEnumName())==0 || reportName.compareTo(ReportTypeEnum.FIVE_MOST_FREQUENT_ISSUES_HANDLED_BY_GA.getEnumName())==0 || reportName.compareTo(ReportTypeEnum.FIVE_MOST_FREQUENT_ISSUES_HANDLED_BY_STUDENT_WORKERS.getEnumName())==0) && count<5)
                                            {
                                                out.println("<tr class=\"aqua\">");
                                                count++;
                                            }
                                            else if ((reportName.compareTo(ReportTypeEnum.TOP_10_FACULTY_WHO_CONSULT_WITH_KRIS_BARANOVIC.getEnumName())==0 || reportName.compareTo(ReportTypeEnum.TOP_10_FACULTY_WHO_CONSULT_WITH_MARY_HARRIET.getEnumName())==0) && count<10)
                                            {
                                                out.println("<tr class=\"aqua\">");
                                                count++;
                                            }
                                            else
                                            {
                                                out.println("<tr>");
                                            }
                                            dataRowHtml = String.format("<td>%s</td> <td>%d</td>", key, dataToDisplay.get(key));
                                            out.println(dataRowHtml);
                                            out.println("</tr>");
                                        }
                                    }

                                    // table FOOTER
                                    if (dataToDisplay.containsKey("Total"))
                                    {
                                        out.println("<tr class=\"yellow\">");
                                        dataRowHtml = String.format("<td>%s</td> <td>%d</td>", "Total", dataToDisplay.get("Total"));
                                        out.println(dataRowHtml);
                                        out.println("</tr>");
                                    }
                                    out.println("</tbody>");
                                    out.println("</table>");
                                    
                                    /***Chart****/
                                    List<ChartSegment> chartDefinition = (List<ChartSegment>)request.getAttribute("chartDefinition");
                                    if (reportName.compareTo(ReportTypeEnum.BREAK_DOWN_BY_CONTACT_TYPE.getEnumName())==0 || reportName.compareTo(ReportTypeEnum.BREAK_DOWN_BY_REQUEST_TYPE.getEnumName())==0 || reportName.compareTo(ReportTypeEnum.SUPPORT_TICKETS_ASSIGNED_TECH.getEnumName())==0)
                                    { 
                                        /*
                                         background: conic-gradient($red 4%, 
                                       $gray 0 8%, 
                                       $blue 0 17%,
                                       $yellow 0 48%,
                                       $purple 0 54%,
                                       $orange 0);
                                        */
                                        out.println("<div style=\"margin: 68px auto;\">");
                                     
                                        String chartBackground = "background: conic-gradient(";
                                        for (ChartSegment segment:chartDefinition)
                                        {
                                            chartBackground+=segment.color + " 0 " + segment.accumulative + ",";
                                        }
                                        chartBackground=chartBackground.substring(0, chartBackground.length()-1)+");";
                                        out.println("<div style=\"width:90%; max-width: 700px;\">");
                                        out.println(String.format("<div class=\"piechart\" style=\"%s\"></div>", chartBackground));
                                        out.println("</div>");
                                        
                                        out.println("<ul class=\"key\">");
                                        for (ChartSegment segment:chartDefinition)
                                        {
                                            out.println("<li>");
                                            out.println(String.format("<strong class=\"percent\" style=\"background:%s;\">%s</strong>",segment.color, segment.percentage));
                                            out.println(String.format("<span class=\"choice\">%s</span>", segment.field));
                                            out.print("</li>");
                                        }
                                        out.println("</ul>");
                                        out.println("</div>");
                                    }
                                    else if(reportName.compareTo(ReportTypeEnum.BREAK_DOWN_BY_CANVAS_TYPE.getEnumName())==0 || reportName.compareTo(ReportTypeEnum.FIVE_MOST_FREQUENT_ISSUES_HANDLED_BY_STUDENT_WORKERS.getEnumName())==0 || reportName.compareTo(ReportTypeEnum.FIVE_MOST_FREQUENT_ISSUES_HANDLED_BY_GA.getEnumName())==0)
                                    {
                                        out.println("<dl>");
                                        out.println("<dt>"); 
                                        out.println(String.format("%s %s - %s Bar Chart", reportName, startTime, endTime));
                                        out.println("</dt>");
                                        
                                        // <dd class="percentage percentage-11"><span class="text">IE 11: 11.33%</span></dd>
                                        for (ChartSegment segment:chartDefinition)
                                        {
                                            out.println(String.format("<dd class=\"percentage percentage-%s\"><span class=\"text\">%s</span></dd>", segment.percentage.replace("%", ""), segment.field));
                                        }
                                               
                                        out.println("</dl>");
                                    }
                                                
                                }
                            }
                        }    
                     
                    %>
                </section>    
                <a id="gobackhomelink" href="home#reportCustomization">Go back to home</a>
		</main>
		<footer>
                   
		</footer>
	</body>
        
        <style>
        /*
        almost black: #333333
        almost red: #C8102E
        orange: #ED6332
        less orange: #F79541
        purple: #9370db;
        gray: #EAE4FF
        more gray: #B5B1C5;
        */
        html{
                box-sizing: border-box;
        }

        *, *:before, *:after{
                box-sizing: inherit;
        }

        /*****General*****/
        main{
            padding-bottom: 300px;
        }
        section{
            display: flex;
        }
        body{
                width: <%=1%>;
                font-family: Roboto, Arial, Helvetica;
                font-size: 1em;
                color: #333333;
        }
        *{
                margin: 0px;
                padding: 0px;
        }

        /*****Header*****/
        header{
                position: relative; /*relative to its current position*/
                height: 800px;
        }
        #semo-background{
                background-image: url("${pageContext.request.contextPath}/images/semo_image.jpg"); 
                background-repeat: no-repeat;
                background-position: center;
                background-size: cover;

                width: 100%; /*relative to the containning element the header*/

                position: absolute; /*relative to the containning element: header*/
                top: 0px;
                bottom: 0px;
                left: 0px;
                right: 0px;
                z-index: 98px;/*first layer*/
        }

        #overlay{
                background-color: rgba(0,0,0,.1);

                width: 100%; /*relative to the containning element: header*/

                position: absolute; /*relative to the containning element: header*/
                top: 0px;
                bottom: 0px;
                left: 0px;
                right: 0px;
                z-index: 99px;/*second layer*/

        }

        #header-content{
                position: absolute; /*relative to the containning element: header*/
                z-index: 100px; /*third layer of the stack*/
        }


        #header-content img{
                width: 27%; /*relative to header-content=header*/
                max-width: 1713px; /*max width of the image (avoid distorting the image)*/
                padding: 1% 0px 0px 5%;
        }

        #header-content h1{
                font-family:  'Belleza', sans-serif;
                font-weight: 1000;
                color: white;
                font-size: 3em; /*relative to parent font: 16px*/

                text-align: center;

                text-decoration-line: none;
                /*text-decoration-color: white;
                text-decoration-thickness: 7px;*/
                
                text-shadow: 3px 3px 2px #c8102e;
                margin-top: 53px;
        }



        /*****Header-About section-Main content*****/
        #about{
                display: flex;
                margin: auto 16%;
                padding: 27px 3%;
                background-color: #EAE4FF;
                margin-bottom: 110px;
                position: absolute;
                top: 340px;
                bottom: 0px;
                left: 0px;
                right: 0px;
                opacity: 0.85;
        }

        #about-content{
                padding-right: 5%;
                border-right: dashed 4px #ED6332;
        }

        #about p{
                padding-top: 15px;
                padding-bottom: 30px;
                line-height: 30px;
        }

        #about h2{
                display: inline;
                font-size: 1.7em;
        }

        #about .red-font{
                color: #C8102E;
                font-weight: 800;
                font-size: 2.7em;
        }

        #about ul{
                list-style-type: none;
                display: flex;
                align-items: center;
        }

        #about a{
                display: block; /*to allow padding*/ 
                text-decoration: none;
                transition: all 0.5s ease-in;
        }

        #nav-button{ /*basically this is a link*/

                padding: 15px;
                background-color: #ED6332;

                border: solid #ED6332;
                border-radius: 15px;

                color: white;
                font-weight: 750;
        }

        #nav-button:hover{
                opacity: 0.8;
        }

        #nav-link{
                padding: 10px; 
                color: #ED6332;
                font-weight: 750;
        }

        #nav-link:hover{
                text-decoration: underline;
                color: #9370db;
        }


        /*****Header-About more info*****/
        #about-moreinfo{
                margin-left: 5%;
                margin-top: 35px;
        }

        #about-moreinfo div{
                display: flex;
                align-items: center; /*align images with text by applying flex-display and align items as center relative to the flex container*/
                padding-bottom: 30px;
        }

        #about-moreinfo img{
                width: 20%;
        }

        #about-moreinfo p{
                font-size: 1.1em;
                margin-left: 10px;
        }


        /*****Main-form: table*****/
        table {
            border: 1px solid black;
            border-collapse: collapse;
            margin: 50px auto;
        }
        
        .tableMarginOverride{
            margin: 50px 45px;
            font-size: 0.9em;
        }
        
        th, td {
            border: 1px solid black;
            padding: .2em .7em;
            text-align: right;
        }
        
        th.center, td.center{
            text-align:center;
            vertical-align:middle;
        }
        
        caption, figcaption {
            font-weight: 700;
            margin: 10px auto;
            font-size: 1.25em;
            line-height: 30px;
        }
        
        figcaption{
            margin: 25px 2%;
        }
        
        th:nth-child(2), td:nth-child(1){
            text-align:left;
        }
        
        tr.aqua{
            background-color: aqua;
        }
        
        tr.yellow{
            background-color: yellow;
        }
        
        /*****Main-form: error*****/
        #errorArea {
            margin: 50px 200px;
        }
        #errorArea h3 {
            font-size: 1.5em;
            margin-bottom: 20px;
        }
        
        /*********PIE-CHART**********/
        .piechart 
        {
            border-radius: 50%;
            width: 50%;
            height: 0;
            padding-top: 50%;
            /*float: left;*/
            padding-right: 20px;
            margin: auto;
        }

        .key { /*ul*/
           list-style: none;
           display: table;
           border-collapse: separate;
           margin-top: 25px;
        }
        
        .key li{
            display: table-cell;
        }
        
        .key li *{
            display: table-cell;
            /*border-bottom: 50px solid white;*/
        }
        
        .percent {
          color: white;
          padding: 10px 2px;
          text-shadow: 0 0 1px black;
          text-align: center;
        }
        .choice {
          padding-right: 15px;
        }
        
         /*********BAR-CHART**********/
         dl {
            display: flex;
            background-color: white;
            flex-direction: column;
            width: 100%;
            max-width: 700px;
            position: relative;
            padding: 20px;
            margin: 80px auto;
        }

        dt {
            align-self: flex-start;
            width: 100%;
            font-weight: 700;
            display: block;
            text-align: center;
            font-size: 1.2em;
            font-weight: 700;
            margin-bottom: 35px;
            margin-left: 100px;
        }

        .text {
            font-weight: 600;
            display: flex;
            align-items: center;
            height: 40px;
            width: 320px;
            background-color: white;
            position: absolute;
            left: 0;
            justify-content: flex-start;
        }

        .percentage {
            font-size: 0.9em;
            line-height: 1;
            /*text-transform: uppercase;*/
            width: 100%;
            height: 40px;
            margin-left: 340px;
            background: repeating-linear-gradient(
                        to right,
                        #ddd,
                        #ddd 1px,
                        #fff 1px,
                        #fff 5%);}
  
        .percentage:after {
            content: "";
            text-align: center;
            color: white;
            display: block;
            background-color: #FF5E0E;
            width: 50px;
            margin-bottom: 10px;
            height: 70%;
            position: relative;
            top: 50%;
            transform: translateY(-50%);
            transition: background-color .3s ease;
            cursor: pointer;
        }

        percentage:hover::after
        {
             background-color: #aaa; 
        }

        percentage:focus::after {
            background-color: #aaa; 
        }   
        
        .percentage-1:after {
            width: 1%;
            content: "1%";
        }
         .percentage-2:after {
                 width: 2%;
                 content: "2%";
        }
         .percentage-3:after {
                 width: 3%;
                 content: "3%";
        }
         .percentage-4:after {
                 width: 4%;
                 content: "4%";
        }
         .percentage-5:after {
                 width: 5%;
                 content: "5%";
        }
         .percentage-6:after {
                 width: 6%;
                 content: "6%";
        }
         .percentage-7:after {
                 width: 7%;
                 content: "7%";
        }
         .percentage-8:after {
                 width: 8%;
                 content: "8%";
        }
         .percentage-9:after {
                 width: 9%;
                 content: "9%";
        }
         .percentage-10:after {
                 width: 10%;
                 content: "10%";
        }
         .percentage-11:after {
                 width: 11%;
                 content: "11%";
        }
         .percentage-12:after {
                 width: 12%;
                 content: "12%";
        }
         .percentage-13:after {
                 width: 13%;
                 content: "13%";
        }
         .percentage-14:after {
                 width: 14%;
                 content: "14%";
        }
         .percentage-15:after {
                 width: 15%;
                 content: "15%";
        }
         .percentage-16:after {
                 width: 16%;
                 content: "16%";
        }
         .percentage-17:after {
                 width: 17%;
                 content: "17%";
        }
         .percentage-18:after {
                 width: 18%;
                 content: "18%";
        }
         .percentage-19:after {
                 width: 19%;
                 content: "19%";
        }
         .percentage-20:after {
                 width: 20%;
                 content: "20%";
        }
         .percentage-21:after {
                 width: 21%;
                 content: "21%";
        }
         .percentage-22:after {
                 width: 22%;
                 content: "22%";
        }
         .percentage-23:after {
                 width: 23%;
                 content: "23%";
        }
         .percentage-24:after {
                 width: 24%;
                 content: "24%";
        }
         .percentage-25:after {
                 width: 25%;
                 content: "25%";
        }
         .percentage-26:after {
                 width: 26%;
                 content: "26%";
        }
         .percentage-27:after {
                 width: 27%;
                 content: "27%";
        }
         .percentage-28:after {
                 width: 28%;
                 content: "28%";
        }
         .percentage-29:after {
                 width: 29%;
                 content: "29%";
        }
         .percentage-30:after {
                 width: 30%;
                 content: "30%";
        }
         .percentage-31:after {
                 width: 31%;
                 content: "31%";
        }
         .percentage-32:after {
                 width: 32%;
                 content: "32%";
        }
         .percentage-33:after {
                 width: 33%;
                 content: "33%";
        }
         .percentage-34:after {
                 width: 34%;
                 content: "34%";
        }
         .percentage-35:after {
                 width: 35%;
                 content: "35%";
        }
         .percentage-36:after {
                 width: 36%;
                 content: "36%";
        }
         .percentage-37:after {
                 width: 37%;
                 content: "37%";
        }
         .percentage-38:after {
                 width: 38%;
                 content: "38%";
        }
         .percentage-39:after {
                 width: 39%;
                 content: "39%";
        }
         .percentage-40:after {
                 width: 40%;
                 content: "40%";
        }
         .percentage-41:after {
                 width: 41%;
                 content: "41%";
        }
         .percentage-42:after {
                 width: 42%;
                 content: "42%";
        }
         .percentage-43:after {
                 width: 43%;
                 content: "43%";
        }
         .percentage-44:after {
                 width: 44%;
                 content: "44%";
        }
         .percentage-45:after {
                 width: 45%;
                 content: "45%";
        }
         .percentage-46:after {
                 width: 46%;
                 content: "46%";
        }
         .percentage-47:after {
                 width: 47%;
                 content: "47%";
        }
         .percentage-48:after {
                 width: 48%;
                 content: "48%";
        }
         .percentage-49:after {
                 width: 49%;
                 content: "49%";
        }
         .percentage-50:after {
                 width: 50%;
                 content: "50%";
        }
         .percentage-51:after {
                 width: 51%;
                 content: "51%";
        }
         .percentage-52:after {
                 width: 52%;
                 content: "52%";
        }
         .percentage-53:after {
                 width: 53%;
                 content: "53%";
        }
         .percentage-54:after {
                 width: 54%;
                 content: "54%";
        }
         .percentage-55:after {
                 width: 55%;
                 content: "55%";
        }
         .percentage-56:after {
                 width: 56%;
                 content: "56%";
        }
         .percentage-57:after {
                 width: 57%;
                 content: "57%";
        }
         .percentage-58:after {
                 width: 58%;
                 content: "58%";
        }
         .percentage-59:after {
                 width: 59%;
                 content: "59%";
        }
         .percentage-60:after {
                 width: 60%;
                 content: "60%";
        }
         .percentage-61:after {
                 width: 61%;
                 content: "61%";
        }
         .percentage-62:after {
                 width: 62%;
                 content: "62%";
        }
         .percentage-63:after {
                 width: 63%;
                 content: "63%";
        }
         .percentage-64:after {
                 width: 64%;
                 content: "64%";
        }
         .percentage-65:after {
                 width: 65%;
                 content: "65%";
        }
         .percentage-66:after {
                 width: 66%;
                 content: "66%";
        }
         .percentage-67:after {
                 width: 67%;
                 content: "67%";
        }
         .percentage-68:after {
                 width: 68%;
                 content: "68%";
        }
         .percentage-69:after {
                 width: 69%;
                 content: "69%";
        }
         .percentage-70:after {
                 width: 70%;
                 content: "70%";
        }
         .percentage-71:after {
                 width: 71%;
                 content: "71%";
        }
         .percentage-72:after {
                 width: 72%;
                 content: "72%";
        }
         .percentage-73:after {
                 width: 73%;
                 content: "73%";
        }
         .percentage-74:after {
                 width: 74%;
                 content: "74%";
        }
         .percentage-75:after {
                 width: 75%;
                 content: "75%";
        }
         .percentage-76:after {
                 width: 76%;
                 content: "76%";
        }
         .percentage-77:after {
                 width: 77%;
                 content: "77%";
        }
         .percentage-78:after {
                 width: 78%;
                 content: "78%";
        }
         .percentage-79:after {
                 width: 79%;
                 content: "79%";
        }
         .percentage-80:after {
                 width: 80%;
                 content: "80%";
        }
         .percentage-81:after {
                 width: 81%;
                 content: "81%";
        }
         .percentage-82:after {
                 width: 82%;
                 content: "82%";
        }
         .percentage-83:after {
                 width: 83%;
                 content: "83%";
        }
         .percentage-84:after {
                 width: 84%;
                 content: "84%";
        }
         .percentage-85:after {
                 width: 85%;
                 content: "85%";
        }
         .percentage-86:after {
                 width: 86%;
                 content: "86%";
        }
         .percentage-87:after {
                 width: 87%;
                 content: "87%";
        }
         .percentage-88:after {
                 width: 88%;
                 content: "88%";
        }
         .percentage-89:after {
                 width: 89%;
                 content: "89%";
        }
         .percentage-90:after {
                 width: 90%;
                 content: "90%";
        }
         .percentage-91:after {
                 width: 91%;
                 content: "91%";
        }
         .percentage-92:after {
                 width: 92%;
                 content: "92%";
        }
         .percentage-93:after {
                 width: 93%;
                 content: "93%";
        }
         .percentage-94:after {
                 width: 94%;
                 content: "94%";
        }
         .percentage-95:after {
                 width: 95%;
                 content: "95%";
        }
         .percentage-96:after {
                 width: 96%;
                 content: "96%";
        }
         .percentage-97:after {
                 width: 97%;
                 content: "97%";
        }
         .percentage-98:after {
                 width: 98%;
                 content: "98%";
        }
         .percentage-99:after {
                 width: 99%;
                 content: "99%";
        }
         .percentage-100:after {
                 width: 100%;
                 content: "100%";
        }
        
        
        /*Go back home tag*/
        #gobackhomelink{
            padding: 20px;
            background-color: #C8102E;
            border-radius: 15px;
            text-decoration: none;
            color: white;
            font-weight: bold;
            transition: all 0.5s ease-in-out;
            display: inline-block;
            margin-top: 20px;
            margin-left: 80%;
        }
        
        #gobackhomelink:hover{
            opacity: 0.8;
        }
        </style>
</html>
