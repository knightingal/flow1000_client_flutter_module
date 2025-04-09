
String apiHost() => "http://192.168.2.12:8000"; 

String albumIndexUrl() => "${apiHost()}/local1000/picIndexAjax";
String albumContentUrl(int index) => "${apiHost()}/local1000/picDetailAjax?id=$index";