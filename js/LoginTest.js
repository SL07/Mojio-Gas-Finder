
 (function() {
  var MojioClient, config, mojio_client;
  MojioClient = this.MojioClient;
  config = {
    application: '434f01ce-504b-4f72-a919-5a81dee7d506', // Fill in your app id here!
    redirect_uri: 'https://mojio.herokuapp.com/', // Fill in you redirect uri here! (Ex. 'http://localhost:4093/index.html')
    hostname: 'api.moj.io',
    version: 'v1',
    port: '443',
    scheme: 'https',
    live: false // This will connect your app to the sandbox environment, change it to true to go live.
  };
  mojio_client = new MojioClient(config);
 // mojio_client.authorize(config.redirect_uri);  //may need to change this line somewhere else 
}).call(this);



//Initialzing MOJIO client
alert("initializing MOJIO client configurations");
var App, MojioClient, config, mojio_client;
config = {    
    application: '434f01ce-504b-4f72-a919-5a81dee7d506', // Fill in your app id here!
    redirect_uri: 'https://mojio.herokuapp.com/', // Fill in you redirect uri here! (Ex. 'http://localhost:4093/index.html')
    //sample test URI
    //http://localhost:5000/app/views/welcome/index.erb
    hostname: 'api.moj.io',
    version: 'v1',
    port: '443',
    scheme: 'https',
    live: false // This will connect your app to the sandbox environment, change it to true to go live.
  };
mojio_client = new MojioClient(config);

//grabbing a token from MOJIO API
alert("grabbing token from MOJIO server");
mojio_client.token(function(error, result) {
  if (error) {
    alert("Authorization token could not be retreived:" + error);
  } else {
    alert("Authorization Successful.");
    div = $("#welcome");
    div.html('Authorization Result:');
    div.append(JSON.stringify(result));
  }
});


