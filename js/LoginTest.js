
 (function() {
  var MojioClient, config, mojio_client;
  MojioClient = this.MojioClient;
  config = {
    application: '609713d5-1a75-43e3-a6ad-c33cd4336715', // Fill in your app id here!
    redirect_uri: 'https://mojio.herokuapp.com/', // Fill in you redirect uri here! (Ex. 'http://localhost:4093/index.html')
    hostname: 'api.moj.io',
    version: 'v1',
    port: '443',
    scheme: 'https',
    live: false // This will connect your app to the sandbox environment, change it to true to go live.
  };
  mojio_client = new MojioClient(config);
  mojio_client.authorize(config.redirect_uri);
}).call(this);