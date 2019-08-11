tw.local.role = new tw.object.listOf.String();
var teams = tw.system.org.getAllRoles();
for(var i = 0; i<teams.length;i++){
    tw.local.role[i] = teams[i].name;
}
