// Anirudh Patch for argv/argc support
var myArgs = process.argv.slice(2);
console.log('myArgs: ', myArgs);

// Get APN Libs
var apn = require('apn');

// Set up apn with the APNs Auth Key
var apnProvider = new apn.Provider( {
token: {
key: 'apns.p8', // Path to the key p8 file
keyId: '2KVTHB3FS2', // Key ID
teamId: '743LU673R8', // Team ID of Developer Account
},
production: false // Set to true if sending notification to a production app
});

// Enter the device token from the Xcode console
//var deviceToken = 'EF55DB368007063F186C7ACE2CCD920BA1FB58BA98879306AF466A261DE95928';
var deviceToken = myArgs[0];

// Prepare a new notification
var notification = new apn.Notification();

// Specify your iOS app's Bundle ID
notification.topic = 'UniVentApp.UniVent';

// Set expiration to 1 hour from now (in case device is offline)
notification.expiry = Math.floor(Date.now() / 1000) + 3600;

// Set app badge indicator
notification.badge = 1;

// Play ping.aiff sound when notification is recieved
notification.sound = 'ping.aiff';

// Display the following message
//notification.alert = 'Hello World \u270C';
notification.alert = myArgs[1];

// Send any extra payload data with the notification which will be accessible
// to your app in didReceiveRemoteNotification 
// { ... , newData: value, ...} to add to the payload
notification.payload = {eventID: '59fb995a039cb'};

// Actually send the notification
apnProvider.send(notification, deviceToken).then(function(result) {
		// Check the result for any failed devices
		console.log(result);

		// Anirudh Patch for Exit Call
		process.exit();
		});
