var cordova = require('cordova');

/**
 * Venmo plugin for Cordova
 * 
 * @constructor
 */
function Venmo () {};

/**
 * Send osme crap
 *
 * @param {String}   text      The content to copy to the clipboard
 * @param {Function} onSuccess The function to call in case of success (takes the copied text as argument)
 * @param {Function} onFail    The function to call in case of error
 */

Venmo.prototype.send = function (appId, appName, recipients, amount, note, txn, onSuccess, onFail) {
  if (typeof text === "undefined" || text === null) text = "";
	cordova.exec(onSuccess, onFail, "Venmo", "send", [appId,appName,recipients,amount,note,txn]);
};

// Register the plugin
var venmo = new Venmo();
module.exports = venmo;
