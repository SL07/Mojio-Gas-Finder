// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree 

//var isLogin = false;

var isLive = false;
var isLoggedIn = false; //for mojioLogin() and mojioLogout() 
var App, MojioClient, config, mojio_client;
var redirectURL = 'https://mojio.herokuapp.com/map';  //to be changed 

config = {
            application: '434f01ce-504b-4f72-a919-5a81dee7d506', // Fill in your app id here!
            redirect_uri: redirectURL, // Fill in you redirect uri here! (Ex. 'http://localhost:4093/index.html')
            hostname: 'api.moj.io',
            version: 'v1',
            port: '443',
            scheme: 'https',
            live: isLive // This will connect your app to the sandbox environment, change it to true to go live. 
        };

$(document).ready(function(){
  mojio_client = new MojioClient(config);
  isLoggedIn = mojio_client.isLoggedIn();
  console.log("isLoggedIn status before change icon() is:"+isLoggedIn);  //alwaays gets executed first on new page!
  changeLogoutIcon();
});  



function changeLogoutIcon(){
  if(isLoggedIn == true) {
    $("#loginButton").replaceWith("<a id=\"logoutButton\" href=\"https://mojio.herokuapp.com\" onClick=\"\">Logout</a>");
    redirectURL = 'https://mojio.herokuapp.com';
  }
  else {
  	$("#logoutButton").replaceWith("<a id=\"loginButton\" href=\"https://mojio.herokuapp.com\" onClick=\"\">Login</a>");
    redirectURL = 'https://mojio.herokuapp.com/map';
  }
    
}

function mojioLogout (){

    localStorage.removeItem("mojio_token");
    localStorage.removeItem("longitude");
    localStorage.removeItem("latitude");

    sessionStorage.removeItem("mojio_token");
    sessionStorage.removeItem("longitude");
    sessionStorage.removeItem("latitude");

    isLoggedIn = false;
    //redirectURL = 'https://mojio.herokuapp.com';
    //mojio_client = new MojioClient(config);
   	//mojio_client.unauthorize(config.redirect_uri);
    
    if (mojio_client.isLoggedIn() == false)
    	console.log("Logged out of Mojio API");
    else console.log("still logged in to Mojio");
        console.log("localStoreage token is:" +  localStorage["mojio_token"]);
}



function mojioLogin2(){
	console.log("redirecting to mojio login");
	redirectURL = 'https://mojio.herokuapp.com/map';
	mojio_client = new MojioClient(config);
   	mojio_client.authorize(config.redirect_uri);   
}
