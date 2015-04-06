Cordova Venmo plugin.

API looks like:

```javascript

var success = function(json) {
  // json:
  // {amount: "0.01", note: "hey", code: "1"}
  console.log(JSON.parse(json));
};
var error = function(err) {
  console.log('err: ' + err);
  if (err === 'not installed') {
    alert('venmo app not installed');
  } 
};

var appId = '1234';
var appName = "Demo";
var recipients = "andrew@andrew-blah.com";
var amount = "0.01";
var note = "heyo";
var txn = "pay"; // txn aka transaction: pay|charge

cordova.plugins.venmo.send(success, error, appId, appName, recipients,amount,note,txn);
```

if app is not installed, the error callback will be called with the message 'not installed' (lowercase)
