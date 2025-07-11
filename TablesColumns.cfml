<!DOCTYPE html>
<html>
<head>
    <title>Database Tables & Columns</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">

    <cfinclude template="nav.cfm">

    <h1>Database Tables & Columns</h1>

    <cfquery name="getColumns" datasource="calicoknottsdsn">
        SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME IN (
            SELECT TABLE_NAME
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_TYPE = 'BASE TABLE'
        )
        ORDER BY TABLE_NAME, ORDINAL_POSITION
    </cfquery>

    <cfset lastTable = "">
    <cfoutput query="getColumns">
        <cfif lastTable NEQ TABLE_NAME>
            <cfif lastTable NEQ "">
                </table>
            </cfif>
            <div style="display:flex; align-items:center; gap:1em;">
                <h2 style="margin-bottom:0;">#TABLE_NAME#</h2>
                <form method="get" action="ViewTableData.cfml" style="margin:0;">
                    <input type="hidden" name="table" value="#TABLE_NAME#">
                    <button type="submit" class="btn" style="font-size:0.9em;">View Data</button>
                </form>
            </div>
            <table class="custom-table2" style="margin-bottom:2em;">
                <tr>
                    <th>Column Name</th>
                    <th>Data Type</th>
                </tr>
            <cfset lastTable = TABLE_NAME>
        </cfif>
        <tr>
            <td>#COLUMN_NAME#</td>
            <td>#DATA_TYPE#</td>
        </tr>
        <!--- If this is the last row, close the table --->
        <cfif getColumns.currentRow EQ getColumns.recordCount>
            </table>
        </cfif>
    </cfoutput>

</div>
</body>
</html>