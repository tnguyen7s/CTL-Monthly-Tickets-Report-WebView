<%-- 
    Document   : index
    Created on : Nov 1, 2021, 7:35:19 AM
    Author     : Tuyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.cstl.model.enums.ReportTypeEnum" %>
<%@page import="java.util.List" %>"
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
		
		<!--Star-->
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                
                <!-- Images rendering -->
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
								<a id="nav-button" href="#reportCustomization">START WITH SINGLE VIEW</a>
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
			<!--		Report customization form		-->
			<form id = "reportCustomization" method="POST" action="report#reportDisplayArea">
				<div id="left-container">
					<p>REPORT TYPES</p>
                                        
                                        
                                        <!--Get report types and display as input and label items to the browser.-->
                                        <%           
                                        ReportTypeEnum[] reportTypes = ReportTypeEnum.values();
                                        int enumValue;
                                        String reportName;
                                        String inputTagContent;
                                        String pTagContent;
                                        for (ReportTypeEnum r:reportTypes)
                                        {
                                            enumValue = r.getEnumValue();
                                            reportName = r.getEnumName();
                                            
                                            inputTagContent = String.format("<input type=\"radio\" name=\"reportType\" value=\"%d\">", enumValue);
                                            pTagContent = String.format("<p>%s</p>", reportName);        
                                            
                                            out.println("<label>");
                                            out.println(inputTagContent);
                                            out.println(pTagContent);
                                            out.println("<span></span>");
                                            out.println("</label>");
                                        }
                                        %>     
					
                                        
				</div>
                                
				
				<div id="right-container">
					<div id="input-area">
                                               
                                            
						<div class="time-select-container">
                                                     
							<select class = "time-select" name="startTime">
                                                            <option value="">From start of</option>
                                                            <%
                                                                if (request.getAttribute("top20StartTimes")!=null)
                                                                {   List<String> top20StartTimes = (List<String>)request.getAttribute("top20StartTimes");
                                                                    String optionTag;
                                                                    for (String time:top20StartTimes)
                                                                    {
                                                                        optionTag = String.format("<option value=\"%s\">From start of %s </option>", time, time);
                                                                        out.println(optionTag);
                                                                    }
                                                                }
                                                            %>
								
							</select>
							<span class="fa fa-star"></span>
						</div>
						
						<div class="time-select-container">
                                                    <select class = "time-select" name="endTime">
                                                            <option value="">To start of</option>
                                                            <%
                                                                if (request.getAttribute("top20EndTimes")!=null)
                                                                {   
                                                                    List<String> top20EndTimes = (List<String>)request.getAttribute("top20EndTimes");
                                                                    String optionTag;
                                                                    for (String time:top20EndTimes)
                                                                    {
                                                                        optionTag = String.format("<option value=\"%s\">To start of %s </option>", time, time);
                                                                        out.println(optionTag);
                                                                    }
                                                                }
                                                            %>
								
							</select>
							<span class="fa fa-star"></span>
						</div>
						
                                                <select id = "chart-or-table-select" name="dataFormat">
							<option value="">I would like to be able to view...--</option>
							<option value="chart">I would like to view the chart.</option>
							<option value="table">I would like to view the table.</option>
							<option value="chart+table">I would like to view the chart and the table side-by-side.</option>
						</select>
					</div>
					<button type="submit">GENERATE</button>
				</div>
                        </form>	
			
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
        body{
                width: 100%;
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


        /*****Main-form: report type: first flex*****/
        #reportCustomization{
                display: flex;
                margin: 50px 3% 200px 3%;
        }

        #left-container{
                display: flex;
                flex-direction: column;

                margin-right: 5%;
        }

        #left-container label{
                font-size: 0.9em;
                cursor: pointer;
                position: relative;
                padding-left: 15px;
                margin-bottom: 20px;
        }

        #left-container span{
                position: absolute; /*relative to the the container which is the label*/
                top: 0px;
                left: 0px;

                width: 17px;
                height: 15px;

                border: solid 2px #ED6332;
                border-radius: 15px;
        }

        #left-container input{
                opacity: 0; /*hidden*/ 
        }

        #left-container label p{
                display: inline;
        }

        /*when the radio is checked*/
        #left-container input:checked ~ span{ /*general silbling css selector*/
                background-color: #ED6332;
        }

        #left-container input:checked ~ p{
                color: #F79541;
        }

        /*when the label is hovered*/
        #left-container label:hover span{
                background-color: #ED6332;
                border-color: #ED6332;
        }

        #left-container label:hover p{
                color: #ED6332;
                /*text-decoration: underline 1px #C4BFD6;*/
        }

        #left-container > p{
                font-size: 1.5em;
                font-weight: 600;
                text-align: center;
                font-family:"roboto condensed";

                padding-bottom: 2px;
                border-bottom: solid 5px #ED6332;
                margin-bottom: 30px;
        }

         /*****drop-down menus and button: second flex*****/

        .time-select-container{
                display: inline;
        }

        .fa {
                position: relative;
                right: 24px;
                font-size: 20px;
                color: white;
        }

        .time-select{
                padding: 7px;

                font-size: 16px;
                border: none;
                background-color: #C8102E;
                color: white;
        }



        #chart-or-table-select{
                padding: 5px;
                font-size: 16px;
                border-color: #EFEFEF;
                background-color: #EFEFEF;
        }

        #input-area{
                padding: 15px;
                border-style: solid dashed dashed solid; 
                /* border-style: solid dashed solid dashed; */
                border-width: 3px;
                border-radius: 10px;
        }

        /*****Main-form: button*****/
        #right-container{
                position: relative;
        }

        #right-container button{
                cursor: pointer;

                position: absolute;
                right: 0px;
                margin-top: 70px; 

                padding: 15px;
                background-color: #A14668;

                font-family: "roboto condensed", Roboto, Arial, Helvetica;
                font-size: 1.1em;
                font-weight: 650;
                color: white;

                border-color: #A14668;
                border-radius: 10px;

                transition: all 0.3s ease-in;
        }

        #right-container button:hover{
                opacity: 0.8;
        }


        </style>
</html>