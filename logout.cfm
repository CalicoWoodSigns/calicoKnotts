<cfapplication name="CWSKnottsApp" sessionmanagement="yes">

<!--- Clear all session variables --->
<cfset structClear(session)>

<!--- Set session to logged out --->
<cfset session.loggedIn = false>

<!--- Redirect to home page --->
<cflocation url="index.cfm" addtoken="false">
