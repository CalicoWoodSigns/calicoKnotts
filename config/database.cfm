<!--- 
Environment-based database configuration
This file detects the environment and sets the appropriate datasource
--->

<cfscript>
    // Detect environment based on server name or IP
    serverName = cgi.SERVER_NAME;
    serverIP = cgi.SERVER_ADDR;
    
    // Environment detection
    if (serverName == "localhost" || serverName == "127.0.0.1" || serverIP == "127.0.0.1") {
        // Local development environment
        request.environment = "local";
        request.datasource = "localKBFData";
    } else if (find("calicoknotts.com", serverName)) {
        // Production environment
        request.environment = "production";
        request.datasource = "calicoknottsdsn";
    } else {
        // Default to local for safety
        request.environment = "local";
        request.datasource = "localKBFData";
    }
    
    // Database configuration
    request.dbConfig = {
        local: {
            datasource: "localKBFData",
            dbType: "SQLite",
            dbFile: expandPath("./database/kbfdata.db")
        },
        production: {
            datasource: "calicoknottsdsn",
            dbType: "SQL Server",
            dbFile: ""
        }
    };
    
    // Set current database config
    request.currentDB = request.dbConfig[request.environment];
</cfscript>

<!--- Debug output (remove in production) --->
<cfif request.environment == "local">
    <cfoutput>
        <div style="background: #f0f0f0; padding: 10px; margin: 10px 0; border-left: 4px solid #007acc;">
            <strong>Environment:</strong> #request.environment#<br>
            <strong>Datasource:</strong> #request.datasource#<br>
            <strong>Database Type:</strong> #request.currentDB.dbType#<br>
            <strong>Server:</strong> #serverName# (#serverIP#)
        </div>
    </cfoutput>
</cfif>
