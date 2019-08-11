//get user email address from TWUser Object
function retrieveUserEmailByLoginName( /* String */ userLoginName ){
    var userEmail = "";
 
    if (!userLoginName) return "";
     
    // use BPM API to access user information by login name
    var userObj = tw.system.org.findUserByName( userLoginName );
         
   // if user found, look for his email in the attributes record
    if ( userObj && userObj.attributes){
        userEmail = userObj.attributes["Task Email Address"];
    }
 
    return userEmail;
}
 
// use the helper function above to get current user's email
//   and store it in a service variable for future use
tw.local.currentUserEmail = retrieveUserEmailByLoginName( tw.system.user_loginName );

