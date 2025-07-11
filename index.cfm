<cfapplication name="CWSKnottsApp" sessionmanagement="yes">

<!--- Include environment-based database configuration --->
<cfinclude template="config/database.cfm">

<!DOCTYPE html>
<html>
<head>
    <title>Calico Wood Signs - Home</title>
    <link rel="stylesheet" href="style.css">
    <!-- Updated: Added viewport meta tag for mobile responsiveness -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<div class="container">

<!-- ALWAYS SHOW THIS SECTION AT THE TOP -->
<cfset budgetAmount = 925>
<cfset pacificNow = dateAdd("h", -2, now())>

<cfquery name="TotalSalesToday" datasource="#request.datasource#">
    SELECT SUM(AMOUNT) AS Total
    FROM EMPLOYEESALES
    WHERE 
    <cfif request.environment == "local">
        date(SALEDATE) = <cfqueryparam value="#dateFormat(now(), 'yyyy-mm-dd')#" cfsqltype="cf_sql_date">
    <cfelse>
        CONVERT(date, SALEDATE) = <cfqueryparam value="#dateFormat(now(), 'yyyy-mm-dd')#" cfsqltype="cf_sql_date">
    </cfif>
</cfquery>

<h1>Welcome to Calico Wood Signs</h1>
<br><br>
<cfif NOT structKeyExists(session, "loggedIn") OR NOT session.loggedIn>
    <form method="post" action="index.cfm">
        <label>Username: <input type="text" name="username" required></label>
        <label>Password: <input type="password" name="password" required></label><br><br>
        <input type="submit" value="Login">
    </form>
</cfif>

<table class="summary-table" style="width:100%;">
    <tr>
        <td style="text-align:left;">
            <cfif structKeyExists(session, "username")>
                <cfoutput>
                    <a href="##"
                    id="userDashboardLink"
                    style="color:##7a4a0c; text-decoration:underline; cursor:pointer;"
                    data-access-level="#session.accessLevel#"
                    data-username="#URLEncodedFormat(session.username)#">
                        #session.username# #session.lastname#
                    </a>
                </cfoutput>
            </cfif>
        </td>
        <td style="text-align:right;">
            <cfoutput>
                #dateTimeFormat(pacificNow, "mmmm d, yyyy h:nn")#
            </cfoutput>
        </td>
    </tr>
    <tr>
        <td colspan="2" style="text-align:right;">
            Today's Budget is <cfoutput>#dollarFormat(budgetAmount)#</cfoutput>
        </td>
    </tr>
    <tr>
        <td colspan="2" style="text-align:right; font-weight:bold;">
            Total Sales Today: <cfoutput>#dollarFormat(val(TotalSalesToday.Total))#</cfoutput>
        </td>
    </tr>
</table>

<!-- Leaderboard Table -->
<h2>Leaderboard: Sales Per Hour</h2>
<cfquery name="Leaderboard" datasource="#request.datasource#">
    SELECT 
        EI.FIRSTNAME,
        EI.LASTNAME,
        SUM(ES.AMOUNT) AS TotalSales,
        SUM(ES.HOURS) AS TotalHours,
        CASE 
            WHEN SUM(ES.HOURS) > 0 THEN SUM(ES.AMOUNT) / SUM(ES.HOURS)
            ELSE 0
        END AS SalesPerHour
    FROM EMPLOYEESALES ES
    INNER JOIN EMPLOYEEINFO EI ON ES.EID = EI.EID
    GROUP BY EI.FIRSTNAME, EI.LASTNAME
    ORDER BY SalesPerHour DESC
</cfquery>
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
            <td>#numberFormat(TotalHours, "9.99")#</td>
            <td>#dollarFormat(SalesPerHour)#</td>
        </tr>
    </cfoutput>
</table>

<!-- Sales for Today Table -->
<cfquery name="SalesToday" datasource="#request.datasource#">
    SELECT EI.FirstName, EI.LastName, ES.AMOUNT, ES.HOURS
    FROM EMPLOYEESALES ES
    INNER JOIN EMPLOYEEINFO EI ON ES.EID = EI.EID
    WHERE 
    <cfif request.environment == "local">
        date(ES.SALEDATE) = <cfqueryparam value="#dateFormat(now(), 'yyyy-mm-dd')#" cfsqltype="cf_sql_date">
    <cfelse>
        CONVERT(date, ES.SALEDATE) = <cfqueryparam value="#dateFormat(now(), 'yyyy-mm-dd')#" cfsqltype="cf_sql_date">
    </cfif>
    ORDER BY EI.LastName, EI.FirstName
</cfquery>

<h2>Sales for Today</h2>
<table class="custom-table2">
    <tr>
        <th>Name</th>
        <th>Amount</th>
        <th>Hours</th>
    </tr>
    <cfoutput query="SalesToday">
        <tr>
            <td>#FirstName# #LastName#</td>
            <td>#dollarFormat(AMOUNT)#</td>
            <td>#numberFormat(HOURS, "9.99")#</td>
        </tr>
    </cfoutput>
</table>

<iframe src="https://calendar.google.com/calendar/embed?height=600&wkst=1&ctz=America%2FLos_Angeles&showPrint=0&showTitle=0&showTabs=0&showCalendars=0&showTz=0&src=Y2FsaWNvd29vZHNpZ25zQGdtYWlsLmNvbQ&color=%23fa9623" 
style="border-width:0" width="100%" height="600" frameborder="0" scrolling="no"></iframe>

<!-- LOGIN LOGIC -->
<cfif NOT structKeyExists(session, "loggedIn") OR NOT session.loggedIn>
    <cfif structKeyExists(form, "username") AND structKeyExists(form, "password")>
        <cfquery name="CheckUser" datasource="#request.datasource#">
            SELECT EID, FirstName, LastName, ACCESSLEVEL
            FROM EMPLOYEEINFO
            WHERE username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">
              AND password = <cfqueryparam value="#form.password#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif CheckUser.recordCount EQ 1>
            <cfset session.loggedIn = true>
            <cfset session.eid = CheckUser.EID>
            <cfset session.username = CheckUser.FirstName>
            <cfset session.lastname = CheckUser.LastName>
            <cfset session.accessLevel = CheckUser.ACCESSLEVEL>
            <!--- Redirect admin users to admin_dashboard --->
            <cfif CheckUser.ACCESSLEVEL GT 2>
                <cflocation url="admin_dashboard.cfml" addtoken="false">
            <cfelse>
                <cflocation url="index.cfm" addtoken="false">
            </cfif>
        <cfelse>
            <div style="color:red;">Invalid username or password.</div>
        </cfif>
    </cfif>
<cfelse>
    <!-- LOGGED-IN USER SECTION -->
    <!-- Handle sales entry form submission -->
    <cfif structKeyExists(form, "addSale")>
        <cfquery datasource="#request.datasource#">
            INSERT INTO EMPLOYEESALES (EID, SALEDATE, AMOUNT, HOURS)
            VALUES (
                <cfqueryparam value="#session.eid#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#dateAdd('h', -2, now())#" cfsqltype="cf_sql_timestamp">,
                <cfqueryparam value="#form.amount#" cfsqltype="cf_sql_decimal">,
                <cfqueryparam value="#form.hours#" cfsqltype="cf_sql_decimal">
            )
        </cfquery>
        <cflocation url="index.cfm" addtoken="false">
    </cfif>

    <!-- Check if the user already has an entry for today -->
    <cfquery name="CheckToday" datasource="#request.datasource#">
        SELECT SALEDATE, AMOUNT, HOURS
        FROM EMPLOYEESALES
        WHERE EID = <cfqueryparam value="#session.eid#" cfsqltype="cf_sql_integer">
        AND 
        <cfif request.environment == "local">
            date(SALEDATE) = <cfqueryparam value="#dateFormat(now(), 'yyyy-mm-dd')#" cfsqltype="cf_sql_date">
        <cfelse>
            CONVERT(date, SALEDATE) = <cfqueryparam value="#dateFormat(now(), 'yyyy-mm-dd')#" cfsqltype="cf_sql_date">
        </cfif>
    </cfquery>

    <div class="welcome">
        <h2>
            <cfoutput>
            <span style="color:##7a4a0c;">#session.username# #session.lastname#</span>
            </cfoutput>
        </h2>
        <cfif CheckToday.recordCount EQ 0>
            <p>Enter your hours and sales amount for today:</p>
            <form method="post" action="index.cfm" style="margin-bottom:2em;">
                <input type="hidden" name="addSale" value="1">
                <label>Hours Worked: <input type="number" name="hours" step="1.00" required></label><br>
                <label>Sales Amount: <input type="number" name="amount" step="1.00" required></label><br><br>
                <input type="submit" value="Add Today's Entry">
            </form>
        <cfelse>
            <h3>Your Entry for Today</h3>
            <table class="custom-table2">
                <tr>
                    <th>Date</th>
                    <th>Hours</th>
                    <th>Amount</th>
                </tr>
                <cfoutput query="CheckToday">
                    <tr>
                        <td>#dateTimeFormat(SALEDATE, "mm/dd/yyyy h:nn tt")#</td>
                        <td>#HOURS#</td>
                        <td>#dollarFormat(AMOUNT)#</td>
                    </tr>
                </cfoutput>
            </table>
            <p style="color:green;">You have already entered your hours and sales for today.</p>
        </cfif>
        <form method="post" action="logout.cfm">
            <input type="submit" value="Logout">
        </form>
    </div>
</cfif>

</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var userLink = document.getElementById('userDashboardLink');
    if (userLink) {
        userLink.addEventListener('click', function(e) {
            e.preventDefault();
            var accessLevel = parseInt(this.getAttribute('data-access-level'));
            var username = this.getAttribute('data-username');
            
            if (accessLevel >= 2) {
                window.location.href = 'admin_dashboard.cfml';
            } else {
                window.location.href = 'employee_dashboard.cfml?searchName=' + username;
            }
        });
    }
});
</script>

</body>
</html>