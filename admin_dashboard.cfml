<cfapplication name="CWSKnottsApp" sessionmanagement="yes">
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">

<cfinclude template="nav.cfm">

<h1>Admin Dashboard</h1>



<cfset adminName = "Rich Johnson">
<cfset budgetAmount = 925>

<!-- Get Pacific Time -->
<cfset pacificNow = dateAdd("h", -2, now())>

<!-- Total Sales Today -->
<cfquery name="TotalSalesToday" datasource="calicowoodsignsdsn">
    SELECT SUM(AMOUNT) AS Total
    FROM EMPLOYEESALES
    WHERE CONVERT(date, SALEDATE) = <cfqueryparam value="#dateFormat(now(), 'yyyy-mm-dd')#" cfsqltype="cf_sql_date">
</cfquery>

<!-- Leaderboard: Sales Per Hour (Year-to-date) -->
<cfquery name="Leaderboard" datasource="calicowoodsignsdsn">
    SELECT 
        EI.USERNAME,
        EI.FIRSTNAME, 
        EI.LASTNAME,
        SUM(ES.AMOUNT) AS TotalSales,
        SUM(ES.HOURS) AS TotalHours,
        CASE WHEN SUM(ES.HOURS) > 0 THEN SUM(ES.AMOUNT)/SUM(ES.HOURS) ELSE 0 END AS SalesPerHour
    FROM EMPLOYEESALES ES
    INNER JOIN EMPLOYEEINFO EI ON ES.EID = EI.EID
    WHERE ES.SALEDATE >= <cfqueryparam value="#createDate(year(now()),1,1)#" cfsqltype="cf_sql_date">
      AND ES.SALEDATE <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
    GROUP BY EI.USERNAME, EI.FIRSTNAME, EI.LASTNAME
    ORDER BY SalesPerHour DESC
</cfquery>

<!-- Sales for Today -->
<cfquery name="SalesToday" datasource="calicowoodsignsdsn">
    SELECT EI.FIRSTNAME, EI.LASTNAME, ES.AMOUNT, ES.HOURS
    FROM EMPLOYEESALES ES
    INNER JOIN EMPLOYEEINFO EI ON ES.EID = EI.EID
    WHERE CONVERT(date, ES.SALEDATE) = <cfqueryparam value="#dateFormat(now(), 'yyyy-mm-dd')#" cfsqltype="cf_sql_date">
    ORDER BY EI.LASTNAME, EI.FIRSTNAME
</cfquery>

<!-- Display Section -->
<div style="display: flex; justify-content: flex-end; margin-bottom:2em;">
    <div style="text-align:right;">
        <div>
            <cfoutput>
                #dateFormat(pacificNow, "mmmm d, yyyy")# #timeFormat(pacificNow, "h:mm tt")#
            </cfoutput>
        </div>
        <div>
            <strong>Today's Budget is <cfoutput>$#budgetAmount#.00</cfoutput></strong>
        </div>
        <div>
            <strong>Total Sales Today:</strong>
            <cfoutput>
                #dollarFormat(TotalSalesToday.Total ?: 0)#
            </cfoutput>
        </div>
    </div>
</div>

<!-- Leaderboard Table -->
<h2>Leaderboard: Sales Per Hour</h2>
<table class="custom-table2">
    <tr>
        <th>Name</th>
        <th>Total Sales</th>
        <th>Total Hours</th>
        <th>Sales Per Hour</th>
    </tr>
    <cfoutput query="Leaderboard">
        <tr>
            <td>#FIRSTNAME# #LASTNAME#</td>
            <td>#dollarFormat(TotalSales)#</td>
            <td>#NumberFormat(TotalHours, "0.00")#</td>
            <td>#dollarFormat(SalesPerHour)#</td>
        </tr>
    </cfoutput>
</table>

<!-- Sales for Today Table -->
<h2>Sales for Today</h2>
<table class="custom-table2">
    <tr>
        <th>Name</th>
        <th>Amount</th>
        <th>Hours</th>
    </tr>
    <cfoutput query="SalesToday">
        <tr>
            <td>#FIRSTNAME# #LASTNAME#</td>
            <td>#dollarFormat(AMOUNT)#</td>
            <td>#NumberFormat(HOURS, "0.00")#</td>
        </tr>
    </cfoutput>
</table>

</div>
</body>
</html>