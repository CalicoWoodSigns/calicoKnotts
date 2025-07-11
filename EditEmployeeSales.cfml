<cfapplication name="CWSKnottsApp" sessionmanagement="yes">
<cfparam name="url.firstname" default="">
<cfparam name="url.startdate" default="">
<cfparam name="url.enddate" default="">
<!DOCTYPE html>
<html>
<head>
    <title>Edit Employee Sales</title>
    <link rel="stylesheet" href="style.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
    @media (max-width: 700px) {
        .custom-table2, .custom-table2 th, .custom-table2 td {
            font-size: 0.9em;
            padding: 0.3em;
        }
        .custom-table2 {
            width: 100%;
            overflow-x: auto;
            display: block;
        }
    }
    </style>
</head>
<body>
<div class="container">
    <h1>Edit Employee Sales</h1>
<cfinclude template="nav.cfm">
    <!-- Filter Form -->
    <form method="get" style="margin-bottom:2em;">
        <label>First Name:
            <input type="text" name="firstname" value="#HTMLEditFormat(url.firstname)#" style="width:120px;">
        </label>
        <label>Start Date:
            <input type="date" name="startdate" value="#HTMLEditFormat(url.startdate)#">
        </label>
        <label>End Date:
            <input type="date" name="enddate" value="#HTMLEditFormat(url.enddate)#">
        </label>
        <button type="submit" class="btn">Filter</button>
        <a href="EditEmployeeSales.cfml" class="btn">Clear</a>
    </form>

    <!-- Handle update -->
    <cfif structKeyExists(form, "update")>
        <cfquery datasource="calicowoodsignsdsn">
            UPDATE EMPLOYEESALES
            SET 
                SALEDATE = <cfqueryparam value="#form.saledate#" cfsqltype="cf_sql_date">,
                AMOUNT = <cfqueryparam value="#form.amount#" cfsqltype="cf_sql_decimal">,
                HOURS = <cfqueryparam value="#form.hours#" cfsqltype="cf_sql_integer">,
                NOTES = <cfqueryparam value="#form.notes#" cfsqltype="cf_sql_varchar">
            WHERE SALEID = <cfqueryparam value="#form.saleid#" cfsqltype="cf_sql_integer">
        </cfquery>
        <div style="color:green; font-weight:bold; margin:1em 0;">
            Sale #<cfoutput>#form.saleid#</cfoutput> updated.
        </div>
    </cfif>

    <!-- Handle delete -->
    <cfif structKeyExists(form, "delete")>
        <cfquery datasource="calicowoodsignsdsn">
            DELETE FROM EMPLOYEESALES
            WHERE SALEID = <cfqueryparam value="#form.saleid#" cfsqltype="cf_sql_integer">
        </cfquery>
        <div style="color:red; font-weight:bold; margin:1em 0;">
            Sale #<cfoutput>#form.saleid#</cfoutput> deleted.
        </div>
    </cfif>

    <!-- Get all sales with filters -->
    <cfquery name="AllSales" datasource="calicowoodsignsdsn">
        SELECT ES.SALEID, ES.EID, ES.SALEDATE, ES.AMOUNT, ES.HOURS, ES.NOTES, EI.FirstName, EI.LastName
        FROM EMPLOYEESALES ES
        INNER JOIN EMPLOYEEINFO EI ON ES.EID = EI.EID
        WHERE 1=1
        <cfif len(trim(url.firstname))>
            AND EI.FirstName LIKE <cfqueryparam value="%#trim(url.firstname)#%" cfsqltype="cf_sql_varchar">
        </cfif>
        <cfif len(trim(url.startdate))>
            AND ES.SALEDATE >= <cfqueryparam value="#url.startdate#" cfsqltype="cf_sql_date">
        </cfif>
        <cfif len(trim(url.enddate))>
            AND ES.SALEDATE <= <cfqueryparam value="#url.enddate#" cfsqltype="cf_sql_date">
        </cfif>
        ORDER BY ES.SALEDATE DESC, ES.SALEID DESC
    </cfquery>

    <table class="custom-table2">
        <tr>
            <th>Sale ID</th>
            <th>Employee</th>
            <th>Date</th>
            <th>Amount</th>
            <th>Hours</th>
            <th>Notes</th>
            <th>Actions</th>
        </tr>
        <cfoutput query="AllSales">
            <tr>
                <td>#SALEID#</td>
                <td>#FirstName# #LastName#</td>
                <td>
                    <input type="date" name="saledate" value="#dateFormat(SALEDATE, 'yyyy-mm-dd')#" style="width:130px;" form="form#SALEID#">
                </td>
                <td>
                    <input type="number" name="amount" value="#AMOUNT#" step="0.01" style="width:90px;" form="form#SALEID#">
                </td>
                <td>
                    <input type="number" name="hours" value="#HOURS#" step="1" style="width:70px;" form="form#SALEID#">
                </td>
                <td>
                    <input type="text" name="notes" value="#HTMLEditFormat(NOTES)#" style="width:140px;" form="form#SALEID#">
                </td>
                <td>
                    <form method="post" action="EditEmployeeSales.cfml" id="form#SALEID#">
                        <input type="hidden" name="saleid" value="#SALEID#">
                        <input type="submit" name="update" value="Update" class="btn" style="padding:0.3em 1em;">
                        <input type="submit" name="delete" value="Delete" class="btn" style="padding:0.3em 1em;">
                    </form>
                </td>
            </tr>
        </cfoutput>
    </table>

    <!-- Bulk Edit/Delete Form -->
    <form method="post" action="EditEmployeeSales.cfml" id="bulkForm">
        <table class="custom-table2">
            <tr>
                <th><input type="checkbox" id="checkAll" onclick="toggleAll(this)"></th>
                <th>Sale ID</th>
                <th>Employee</th>
                <th>Date</th>
                <th>Amount</th>
                <th>Hours</th>
                <th>Notes</th>
            </tr>
            <cfoutput query="AllSales">
                <tr>
                    <td>
                        <input type="checkbox" name="selectedRows" value="#SALEID#">
                    </td>
                    <td>#SALEID#</td>
                    <td>#FirstName# #LastName#</td>
                    <td>
                        <input type="date" name="saledate_#SALEID#" value="#dateFormat(SALEDATE, 'yyyy-mm-dd')#" style="width:130px;">
                    </td>
                    <td>
                        <input type="number" name="amount_#SALEID#" value="#AMOUNT#" step="0.01" style="width:90px;">
                    </td>
                    <td>
                        <input type="number" name="hours_#SALEID#" value="#HOURS#" step="1" style="width:70px;">
                    </td>
                    <td>
                        <input type="text" name="notes_#SALEID#" value="#HTMLEditFormat(NOTES)#" style="width:140px;">
                    </td>
                </tr>
            </cfoutput>
        </table>
        <div style="margin-top:1em;">
            <button type="submit" name="bulkUpdate" class="btn">Update Selected</button>
            <button type="submit" name="bulkDelete" class="btn" onclick="return confirm('Delete selected sales?');">Delete Selected</button>
        </div>
    </form>

    <script>
    function toggleAll(source) {
        checkboxes = document.getElementsByName('selectedRows');
        for(var i=0, n=checkboxes.length;i<n;i++) {
            checkboxes[i].checked = source.checked;
        }
    }
    </script>

    <!--- Bulk Update/Delete Handler --->
    <cfif structKeyExists(form, "bulkUpdate") AND isArray(form.selectedRows)>
        <cfloop array="#form.selectedRows#" index="saleid">
            <cfquery datasource="calicowoodsignsdsn">
                UPDATE EMPLOYEESALES
                SET 
                    SALEDATE = <cfqueryparam value="#form['saledate_' & saleid]#" cfsqltype="cf_sql_date">,
                    AMOUNT = <cfqueryparam value="#form['amount_' & saleid]#" cfsqltype="cf_sql_decimal">,
                    HOURS = <cfqueryparam value="#form['hours_' & saleid]#" cfsqltype="cf_sql_integer">,
                    NOTES = <cfqueryparam value="#form['notes_' & saleid]#" cfsqltype="cf_sql_varchar">
                WHERE SALEID = <cfqueryparam value="#saleid#" cfsqltype="cf_sql_integer">
            </cfquery>
        </cfloop>
        <div style="color:green; font-weight:bold; margin:1em 0;">
            Selected sales updated.
        </div>
    </cfif>

    <cfif structKeyExists(form, "bulkDelete") AND isArray(form.selectedRows)>
        <cfloop array="#form.selectedRows#" index="saleid">
            <cfquery datasource="calicowoodsignsdsn">
                DELETE FROM EMPLOYEESALES
                WHERE SALEID = <cfqueryparam value="#saleid#" cfsqltype="cf_sql_integer">
            </cfquery>
        </cfloop>
        <div style="color:red; font-weight:bold; margin:1em 0;">
            Selected sales deleted.
        </div>
    </cfif>
</div>
</body>
</html>