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
  //these gets called first on all page loads
  mojio_client = new MojioClient(config);
  mojioAuthentication();
  isLoggedIn = mojio_client.isLoggedIn();
  console.log("isLoggedIn status before change icon() is:"+isLoggedIn);
  changeLogoutIcon();
});  


function changeLogoutIcon(){
  if(isLoggedIn == true) {
    $("#loginButton").replaceWith("<a id=\"logoutButton\" onClick=\"mojioLogout()\">Logout</a>");
    redirectURL = 'https://mojio.herokuapp.com'; 
  }
  else {
  	$("#logoutButton").replaceWith("<a id=\"loginButton\" onClick=\"mojioLogin()\">Login</a>");
    redirectURL = 'https://mojio.herokuapp.com/map';
  }
    
}

function mojioAuthentication(){
	var mojio_token;
	if (mojio_client.isLoggedIn() == false){  //use this to test for login status
	  console.log("checking for login token");
	  mojio_client.token(function(error, result) {
	    if (error) {
	      console.log(error);             
	    } else { 

	      if (sessionStorage["mojio_token"] == null)  {  //first time loading into map page 
		      div = $("#welcome");
		      div.html('Authorization Result:');
		      div.append(JSON.stringify(result));
		      console.log(JSON.stringify(result));
		      mojio_token = JSON.stringify(result);
		      sessionStorage["mojio_token"] = JSON.stringify(result);  //save the token into session storage
	      }
	      else {  //token already stored in session Storage 
	      		console.log("sessionToken aleady created, loading from session storage");
	      		mojio_token = sessionStorage["mojio_token"];
	      }       

	    }
	    //mojio_client.auth_token = JSON.parse(mojio_token); //need to destring before passing in
	    mojio_client.auth_token = JSON.parse(sessionStorage["mojio_token"]);
	    isLoggedIn = mojio_client.isLoggedIn();
	    //changeLogoutIcon();
	    //getVehicleData(); //update all long, lat and fuel level data on first load
	    console.log("isLoggedIn= " + isLoggedIn + "Token " + mojio_token);
	  });            
	}
	else if(mojio_client.isLoggedIn() == true){
	  console.log("already logged in to Mojio");
	  console.log("value of token is: " + sessionStorage["mojio_token"]);
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
  //  console.log("log out redirrect URL is: "+ config.redirect_uri);
    mojio_client.unauthorize(config.redirect_uri);
    if (mojio_client.isLoggedIn() == false)
    console.log("Logged out of Mojio API");
    else console.log("still logged in to Mojio");
        console.log("localStoreage token is:" +  localStorage["mojio_token"]);
}
