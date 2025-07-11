<cfapplication name="CWSKnottsApp" sessionmanagement="yes">
<!DOCTYPE html>
<html>
<head>
    <title>Edit Employee Info</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
<cfinclude template="nav.cfm">

<h2>Edit Employee Information</h2>

<cfif structKeyExists(url, "eid")>
    <cfquery name="Emp" datasource="calicowoodsignsdsn">
        SELECT EID, USERNAME, PASSWORD, FIRSTNAME, LASTNAME, ADDRESS1, ADDRESS2, CITY, STATE, PHONE, ACCESSLEVEL
        FROM EMPLOYEEINFO
        WHERE EID = <cfqueryparam value="#url.eid#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif Emp.recordCount>
    <cfoutput query="Emp">
        <form method="post" action="edit_employee_info.cfml?eid=#Emp.EID#">
            <table class="summary-table" style="font-size:0.80em;">
                <tr>
                    <td><label for="username">Username:</label></td>
                    <td><input type="text" id="username" name="username" value="#HTMLEditFormat(Emp.USERNAME)#" required></td>
                </tr>
                <tr>
                    <td><label for="password">Password:</label></td>
                    <td><input type="text" id="password" name="password" value="#HTMLEditFormat(Emp.PASSWORD)#" required></td>
                </tr>
                <tr>
                    <td><label for="firstname">First Name:</label></td>
                    <td><input type="text" id="firstname" name="firstname" value="#HTMLEditFormat(Emp.FIRSTNAME)#" required></td>
                </tr>
                <tr>
                    <td><label for="lastname">Last Name:</label></td>
                    <td><input type="text" id="lastname" name="lastname" value="#HTMLEditFormat(Emp.LASTNAME)#" required></td>
                </tr>
                <tr>
                    <td><label for="address1">Address 1:</label></td>
                    <td><input type="text" id="address1" name="address1" value="#HTMLEditFormat(Emp.ADDRESS1)#" required></td>
                </tr>
                <tr>
                    <td><label for="address2">Address 2:</label></td>
                    <td><input type="text" id="address2" name="address2" value="#HTMLEditFormat(Emp.ADDRESS2)#"></td>
                </tr>
                <tr>
                    <td><label for="city">City:</label></td>
                    <td><input type="text" id="city" name="city" value="#HTMLEditFormat(Emp.CITY)#" required></td>
                </tr>
                <tr>
                    <td><label for="state">State:</label></td>
                    <td><input type="text" id="state" name="state" value="#HTMLEditFormat(Emp.STATE)#" required></td>
                </tr>
                <tr>
                    <td><label for="phone">Phone:</label></td>
                    <td><input type="text" id="phone" name="phone" value="#HTMLEditFormat(Emp.PHONE)#"></td>
                </tr>
                <tr>
                    <td><label for="accesslevel">Access Level:</label></td>
                    <td><input type="number" id="accesslevel" name="accesslevel" value="#Emp.ACCESSLEVEL#" min="1" max="9"></td>
                </tr>
                <tr>
                    <td></td>
                    <td><input type="submit" name="updateEmployee" value="Update" class="btn"></td>
                </tr>
            </table>
        </form>
        </cfoutput>
    </cfif>
    <div style="margin-top:1em;"><a href="edit_employee_info.cfml" class="btn">&larr; Back to Employee List</a></div>
    <!-- Handle update -->
    <cfif structKeyExists(form, "updateEmployee")>
        <cfquery datasource="calicowoodsignsdsn">
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
                PHONE = <cfqueryparam value="#form.phone#" cfsqltype="cf_sql_varchar">,
                ACCESSLEVEL = <cfqueryparam value="#form.accesslevel#" cfsqltype="cf_sql_integer">
            WHERE EID = <cfqueryparam value="#Emp.EID#" cfsqltype="cf_sql_integer">
        </cfquery>
        <div class="success-msg">Employee updated!</div>
        <cflocation url="edit_employee_info.cfml" addtoken="false">
    </cfif>
<cfelse>
    <!-- List all employees with all columns and edit links -->
    <cfquery name="AllEmployees" datasource="calicowoodsignsdsn">
        SELECT EID, USERNAME, PASSWORD, FIRSTNAME, LASTNAME, ADDRESS1, ADDRESS2, CITY, STATE, PHONE, ACCESSLEVEL
        FROM EMPLOYEEINFO
        ORDER BY LASTNAME, FIRSTNAME
    </cfquery>
    <table class="custom-table2" style="font-size:0.80em; table-layout:fixed; width:100%;">
        <tr>
            <th style="width:4em;">EID</th>
            <th style="width:7em;">Username</th>
            <th style="width:7em;">Password</th>
            <th style="width:7em;">First</th>
            <th style="width:7em;">Last</th>
            <th style="width:10em;">Address 1</th>
            <th style="width:7em;">Address 2</th>
            <th style="width:6em;">City</th>
            <th style="width:4em;">State</th>
            <th style="width:7em;">Phone</th>
            <th style="width:4em;">Level</th>
            <th style="width:5em;">Action</th>
        </tr>
        <cfoutput query="AllEmployees">
            <tr>
                <td>#EID#</td>
                <td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">#HTMLEditFormat(USERNAME)#</td>
                <td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">#HTMLEditFormat(PASSWORD)#</td>
                <td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">#HTMLEditFormat(FIRSTNAME)#</td>
                <td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">#HTMLEditFormat(LASTNAME)#</td>
                <td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">#HTMLEditFormat(ADDRESS1)#</td>
                <td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">#HTMLEditFormat(ADDRESS2)#</td>
                <td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">#HTMLEditFormat(CITY)#</td>
                <td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">#HTMLEditFormat(STATE)#</td>
                <td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">#HTMLEditFormat(PHONE)#</td>
                <td>#ACCESSLEVEL#</td>
                <td><a href="edit_employee_info.cfml?eid=#EID#" class="btn" style="padding:0.3em 0.7em; font-size:0.9em;">Edit</a></td>
            </tr>
        </cfoutput>
    </table>
</cfif>
</div>
</body>
</html>