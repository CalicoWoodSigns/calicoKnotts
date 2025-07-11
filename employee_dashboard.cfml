<cfapplication name="CWSKnottsApp" sessionmanagement="yes">
<!DOCTYPE html>
<html>
<head>
    <title>Employee Dashboard</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container">
<cfif structKeyExists(form, "updateEmployeeInfo")>
    <cfquery datasource="calicoknottsdsn">
        UPDATE EMPLOYEEINFO
        SET
            USERNAME = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">,
            PASSWORD = <cfqueryparam value="#form.password#" cfsqltype="cf_sql_varchar">,
            FIRSTNAME = <cfqueryparam value="#form.firstname#" cfsqltype="cf_sql_varchar">,
            LASTNAME = <cfqueryparam value="#form.lastname#" cfsqltype="cf_sql_varchar">,
            ADDRESS1 = <cfqueryparam value="#form.address1#" cfsqltype="cf_sql_varchar">,
            ADDRESS2 = <cfqueryparam value="#form.address2#" cfsqltype="cf_sql_varchar">,
            CITY = <cfqueryparam value="#form.city#" cfsqltype="cf_sql_varchar">,
            STATE = <cfqueryparam value="#form.state#" cfsqltype="cf_sql_varchar">,
            PHONE = <cfqueryparam value="#form.phone#" cfsqltype="cf_sql_varchar">
        WHERE
            FIRSTNAME = <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">
            AND LASTNAME = <cfqueryparam value="#session.lastname#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cflocation url="employee_dashboard.cfml" addtoken="false">
</cfif>
<cfinclude template="navEmp.cfm">

<!-- User Info Horizontal Edit Form -->
<cfquery name="MyInfo" datasource="calicoknottsdsn">
    SELECT USERNAME, PASSWORD, FIRSTNAME, LASTNAME, ADDRESS1, ADDRESS2, CITY, STATE, PHONE
    FROM EMPLOYEEINFO
    WHERE FIRSTNAME = <cfqueryparam value="#trim(session.username)#" cfsqltype="cf_sql_varchar">
      AND LASTNAME = <cfqueryparam value="#trim(session.lastname)#" cfsqltype="cf_sql_varchar">
</cfquery>

<h2>
    <cfif structKeyExists(session, "username") AND structKeyExists(session, "lastname")>
        <cfoutput>
            #ucase(left(trim(session.username),1))##lcase(mid(trim(session.username),2,len(trim(session.username))-1))#
            #ucase(left(trim(session.lastname),1))##lcase(mid(trim(session.lastname),2,len(trim(session.lastname))-1))#
        </cfoutput>
    <cfelse>
        Hello!
    </cfif>
</h2>

<!-- User Info Display/Edit Section (max-width: 1400px) -->
<div style="max-width:1400px; margin:0 auto 1.5em auto;">
    <h3>Your Employee Information</h3>
    <cfif structKeyExists(url, "edit") AND url.edit EQ 1>
        <!-- Edit Form -->
        <form method="post" action="employee_dashboard.cfml">
            <table class="custom-table2" style="width:100%; max-width:1400px;">
                <tr>
                    <th>Username</th>
                    <th>Password</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                </tr>
                <cfoutput query="MyInfo">
                <tr>
                    <td><input type="text" name="username" value="#HTMLEditFormat(USERNAME)#" required></td>
                    <td><input type="password" name="password" value="#HTMLEditFormat(PASSWORD)#" required></td>
                    <td><input type="text" name="firstname" value="#HTMLEditFormat(FIRSTNAME)#" required></td>
                    <td><input type="text" name="lastname" value="#HTMLEditFormat(LASTNAME)#" required></td>
                </tr>
                <tr>
                    <th>ADDRESS1</th>
                    <th>ADDRESS2</th>
                    <th>CITY</th>
                    <th>STATE</th>
                    <th>PHONE</th>
                </tr>
                <tr>
                    <td>
                    <input type="text" name="address1" value="#HTMLEditFormat(ADDRESS1)#" required>
                    </td>
                    <td>
                    <input type="text" name="address2" value="#HTMLEditFormat(ADDRESS2)#">
                    </td>
                    <td>
                    <input type="text" name="city" value="#HTMLEditFormat(CITY)#" required>
                    </td>
                    <td>
                    <input type="text" name="state" value="#HTMLEditFormat(STATE)#" required>
                    </td>
                    <td>
                    <input type="text" name="phone" value="#HTMLEditFormat(PHONE)#">
                    </td>

                </tr>
                <tr>
                    <td>
                        <input type="submit" name="updateEmployeeInfo" value="Update" class="btn">
                        <a href="employee_dashboard.cfml" class="btn" style="margin-left:0.5em;">Cancel</a>
                    </td>
                </tr>
                </cfoutput>
            </table>
            <input type="hidden" name="returnUrl" value="employee_dashboard.cfml">
        </form>
    <cfelse>
        <!-- Display as plain text -->
        <table class="custom-table2" style="width:100%; max-width:1400px;">
            <tr>
                <th>Username</th>
                <th>Password</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Address 1</th>
                <th>Address 2</th>
                <th>City</th>
                <th>State</th>
                <th>Phone</th>
                <th>Action</th>
            </tr>
            <cfoutput query="MyInfo">
            <tr>
                <td>#HTMLEditFormat(USERNAME)#</td>
                <td>••••••••</td>
                <td>#HTMLEditFormat(FIRSTNAME)#</td>
                <td>#HTMLEditFormat(LASTNAME)#</td>
                <td>#HTMLEditFormat(ADDRESS1)#</td>
                <td>#HTMLEditFormat(ADDRESS2)#</td>
                <td>#HTMLEditFormat(CITY)#</td>
                <td>#HTMLEditFormat(STATE)#</td>
                <td>#HTMLEditFormat(PHONE)#</td>
                <td>
                    <a href="employee_dashboard.cfml?edit=1" class="btn">Edit</a>
                </td>
            </tr>
            </cfoutput>
        </table>
    </cfif>
</div>


<div style="display:flex; gap:0.5em; margin-top:0.5em; max-width:700px;">
    <a href="#" class="btn" style="flex:1; text-align:center;" onclick="setQuickRange('week');return false;">Week to Date</a>
    <a href="#" class="btn" style="flex:1; text-align:center;" onclick="setQuickRange('month');return false;">Month to Date</a>
    <a href="#" class="btn" style="flex:1; text-align:center;" onclick="setQuickRange('year');return false;">Year to Date</a>
</div>
<script>
function setQuickRange(type) {
    var now = new Date();
    var start, end;
    end = now.toISOString().slice(0,10);
    if(type === 'week') {
        var day = now.getDay() || 7;
        now.setDate(now.getDate() - day + 1);
        start = now.toISOString().slice(0,10);
    } else if(type === 'month') {
        start = now.getFullYear() + '-' + String(now.getMonth()+1).padStart(2,'0') + '-01';
    } else if(type === 'year') {
        start = now.getFullYear() + '-01-01';
    }
    document.getElementById('startDate').value = start;
    document.getElementById('endDate').value = end;
    document.getElementById('searchForm').submit();
}
</script>

<cfquery name="FilteredSales" datasource="calicoknottsdsn">
    SELECT EMPLOYEEINFO.FIRSTNAME, EMPLOYEEINFO.LASTNAME, EMPLOYEESALES.HOURS, EMPLOYEESALES.AMOUNT, EMPLOYEESALES.SALEDATE
    FROM EMPLOYEESALES
    INNER JOIN EMPLOYEEINFO ON EMPLOYEESALES.EID = EMPLOYEEINFO.EID
    WHERE EMPLOYEEINFO.FIRSTNAME = <cfqueryparam value="#trim(session.username)#" cfsqltype="cf_sql_varchar">
      AND EMPLOYEEINFO.LASTNAME = <cfqueryparam value="#trim(session.lastname)#" cfsqltype="cf_sql_varchar">
    <cfif structKeyExists(url, "searchDate") AND len(trim(url.searchDate))>
        AND EMPLOYEESALES.SALEDATE = <cfqueryparam value="#url.searchDate#" cfsqltype="cf_sql_date">
    </cfif>
    <cfif structKeyExists(url, "startDate") AND len(trim(url.startDate))>
        AND EMPLOYEESALES.SALEDATE >= <cfqueryparam value="#url.startDate#" cfsqltype="cf_sql_date">
    </cfif>
    <cfif structKeyExists(url, "endDate") AND len(trim(url.endDate))>
        AND EMPLOYEESALES.SALEDATE <= <cfqueryparam value="#url.endDate#" cfsqltype="cf_sql_date">
    </cfif>
    ORDER BY EMPLOYEESALES.SALEDATE DESC
</cfquery>

<!-- Sales Table Example -->
<h3 style="margin-top:2em;">Your Recent Sales</h3>
<cfset totalHours = 0>
<cfset totalAmount = 0>
<cfoutput query="FilteredSales">
    <cfset totalHours = totalHours + val(HOURS)>
    <cfset totalAmount = totalAmount + val(AMOUNT)>
</cfoutput>



<table class="custom-table2" style="margin-bottom:2em; width:100%; max-width:700px;">
    <tr>
        <td colspan="4" style="text-align:right; font-weight:bold; background:#222; color:white;">
        <cfoutput>
    <div>
    <strong>Total Hours:</strong> <cfoutput>#numberFormat(totalHours, "9.99")#</cfoutput>
    &nbsp;
    <strong>Total Sales:</strong> <cfoutput>#dollarFormat(totalAmount)#</cfoutput>
    </div>
        </cfoutput>
        </td>
    </tr>
    <tr>
        <th>Date</th>
        <th>Name</th>
        <th>Hours</th>
        <th>Amount</th>
    </tr>
    <cfoutput query="FilteredSales">
        <tr>
            <td>#dateFormat(SALEDATE, "mm/dd/yyyy")#</td>
            <td>#FIRSTNAME# #LASTNAME#</td>
            <td>#HOURS#</td>
            <td>#dollarFormat(AMOUNT)#</td>
        </tr>
    </cfoutput>
</table>


</body>
</html>