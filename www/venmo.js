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

Venmo.prototype.send = function (onSuccess, onFail, appId, appName, recipients, amount, note, txn) {
  console.log('amount1:');
  console.log(amount);
  if (typeof amount === 'string' && cordova.platformId === 'ios') {
    amount = '' + (parseFloat(amount) * 100);
  }

  console.log('amount2:');
  console.log(amount);
	cordova.exec(onSuccess, onFail, "Venmo", "send", [appId,appName,recipients,amount,note,txn]);
};

// Register the plugin
var venmo = new Venmo();
module.exports = venmo;
