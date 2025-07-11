<!DOCTYPE html>
<html>
<head>
    <title>View Table Data</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
    <cfinclude template="nav.cfm">
    <h1>Table Data: <cfoutput>#url.table#</cfoutput></h1>
    <cfif structKeyExists(url, "table")>
        <cfquery name="tableData" datasource="calicowoodsignsdsn">
            SELECT TOP 25 * FROM #preserveSingleQuotes(url.table)#
        </cfquery>
        <table class="custom-table2">
            <tr>
                <cfloop array="#listToArray(tableData.columnList)#" index="col">
                    <th><cfoutput>#col#</cfoutput></th>
                </cfloop>
            </tr>
            <cfoutput query="tableData">
                <tr>
                    <cfloop array="#listToArray(tableData.columnList)#" index="col">
                        <td>#evaluate("tableData." & col)#</td>
                    </cfloop>
                </tr>
            </cfoutput>
        </table>
    <cfelse>
        <div style="color:red;">No table selected.</div>
    </cfif>
</div>
</body>
</html>