<cfset csvPath = expandPath("./2024 Knotts Daily Numbers-1-9-25(Sales).csv")>
<cffile action="read" file="#csvPath#" variable="csvData">

<!--- Split into lines --->
<cfset lines = listToArray(csvData, chr(10))>

<cfparam name="form.insertData" default="">
<cfset insertCount = 0>

<!--- Find the header row (dates) and the 2024 Actual row --->
<cfset headerRow = listToArray(lines[4], ",")>
<cfset actualRow = []>
<cfloop from="1" to="#arrayLen(lines)#" index="i">
    <cfset row = listToArray(lines[i], ",")>
    <cfif arrayLen(row) GT 0 AND trim(row[1]) EQ "2024 Actual">
        <cfset actualRow = row>
        <cfbreak>
    </cfif>
</cfloop>

<cfset year = 2024>
<cfif structKeyExists(form, "insertData") AND arrayLen(actualRow)>
    <cfloop from="5" to="#arrayLen(actualRow)#" index="col">
        <cfset saleDate = trim(headerRow[col])>
        <cfset amount = trim(actualRow[col])>
        <!--- Parse date --->
        <cfset parsedDate = "">
        <cftry>
            <cfset dayPart = listFirst(saleDate, "-")>
            <cfset monthPart = listLast(saleDate, "-")>
            <cfset parsedDate = createDate(year, monthAsNumber(monthPart), dayPart)>
            <cfset parsedDate = dateFormat(parsedDate, "yyyy-mm-dd")>
        <cfcatch>
            <cfset parsedDate = "">
        </cfcatch>
        </cftry>
        <cfif len(amount) AND isNumeric(amount) AND len(saleDate) AND len(parsedDate)>
            <cfquery datasource="calicowoodsignsdsn" username="calicowoDBArich" password="Leslie@0311">
                INSERT INTO EmployeeSales (
                    EID,
                    SALEDATE,
                    AMOUNT,
                    NOTES,
                    HOURS,
                    FIRSTNAME
                ) VALUES (
                    <cfqueryparam value="5" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#parsedDate#" cfsqltype="cf_sql_date">,
                    <cfqueryparam value="#amount#" cfsqltype="cf_sql_decimal">,
                    <cfqueryparam value="" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="0" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="Adam" cfsqltype="cf_sql_varchar">
                )
            </cfquery>
            <cfset insertCount = insertCount + 1>
        </cfif>
    </cfloop>
</cfif>

<cffunction name="monthAsNumber" output="false">
    <cfargument name="mon" type="string" required="true">
    <cfset var months = "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec">
    <cfreturn listFindNoCase(months, left(arguments.mon,3))>
</cffunction>

<!--- You can run this once, then remove it for safety --->
<cfquery datasource="calicowoodsignsdsn" username="calicowoDBArich" password="Leslie@0311">
    DELETE FROM EmployeeSales
    WHERE EID = 5
      AND FIRSTNAME = 'Adam'
      AND SALEDATE >= '2025-01-01'
      AND SALEDATE < '2026-01-01'
</cfquery>

<!DOCTYPE html>
<html>
<head>
    <title>CSV Spreadsheet Viewer</title>
    <style>
        .success { color: green; font-weight: bold; }
    </style>
</head>
<body>
    <h2>CSV Spreadsheet Data</h2>
    <cfif structKeyExists(form, "insertData")>
        <div class="success">
            Successfully inserted <strong>#insertCount#</strong> rows into EmployeeSales.
        </div>
    </cfif>
    <form method="post">
        <button type="submit" name="insertData" value="1">Insert Data</button>
    </form>

    <!--- Display remaining EmployeeSales rows for Adam, 2024 --->
    <cfquery name="getSales" datasource="calicowoodsignsdsn" username="calicowoDBArich" password="Leslie@0311">
        SELECT SALEDATE, AMOUNT, NOTES, HOURS, FIRSTNAME
        FROM EmployeeSales
        WHERE EID = 5
          AND FIRSTNAME = 'Adam'
          AND SALEDATE >= '2024-01-01'
          AND SALEDATE < '2025-01-01'
        ORDER BY SALEDATE
    </cfquery>

    <cfif getSales.recordCount GT 0>
        <h3>Remaining EmployeeSales Rows for Adam (2024)</h3>
        <table border="1" cellpadding="4" cellspacing="0">
            <tr>
                <th>SALEDATE</th>
                <th>AMOUNT</th>
                <th>NOTES</th>
                <th>HOURS</th>
                <th>FIRSTNAME</th>
            </tr>
            <cfloop query="getSales">
                <tr>
                    <td>#dateFormat(SALEDATE, "yyyy-mm-dd")#</td>
                    <td>#AMOUNT#</td>
                    <td>#NOTES#</td>
                    <td>#HOURS#</td>
                    <td>#FIRSTNAME#</td>
                </tr>
            </cfloop>
        </table>
    <cfelse>
        <p>No EmployeeSales rows for Adam (2024) remain.</p>
    </cfif>
</body>
</html>