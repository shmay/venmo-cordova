package com.slice.cordova.venmo;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;

import org.apache.cordova.CordovaWebView;

import android.app.Activity;
import android.content.Intent;

import android.util.Log;
import android.content.Context;

import org.json.JSONArray;
import org.json.JSONException;

public class Venmo extends CordovaPlugin {
  public static final String TAG = "VenmoPlugin";
  private Context context;
  private CallbackContext cbContext;
  private VenmoLibrary venmoLib;

   /**
     * @param cordova
     *            The context of the main Activity.
     * @param webView
     *            The associated CordovaWebView.
     */
  @Override
  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
      super.initialize(cordova, webView);
      context = this.cordova.getActivity().getApplicationContext();
  }

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    Log.d(TAG, "VenmoPlugin execute action: " + action + " args: " + args.toString());

    cbContext = callbackContext;

    if (VenmoLibrary.isVenmoInstalled(context)) {
      if (action.equals("send")) {
        String myAppId = args.getString(0);
        String myAppName = args.getString(1);
        String recipients = args.getString(2);
        String amount = args.getString(3);
        String note = args.getString(4);
        // transaction type: charge|pay
        String txn = args.getString(5);

        try {
          Intent venmoIntent = venmoLib.openVenmoPayment(myAppId,myAppName,recipients,amount,note,txn);
          cordova.getActivity().startActivityForResult(venmoIntent, 123);

          return true;
        } catch (Exception e) {
          callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, e.toString()));
        }

      } else {
        Log.d(TAG, "send a valid action breh");
      }
    } else {
      Log.d(TAG, "venmo aint installed breh");
    }

    return false;
  }

  @Override
  public void onActivityResult(int requestCode, int resultCode, Intent data) {

    Log.d(TAG, "onActivityResult breh");

    switch(requestCode) {
        case 123: {
            if(resultCode == -1) {
                String signedrequest = data.getStringExtra("signedrequest");

                Log.d(TAG, "result is A OK");

                if(signedrequest != null) {
                    VenmoLibrary.VenmoResponse response = (new VenmoLibrary()).validateVenmoPaymentResponse(signedrequest, "qzXgnaB4XbJQx3y8vQtB76PTGSKqbPU");
                    if(response.getSuccess().equals("1")) {
                        //Payment successful.  Use data from response object to display a success message
                        String note = response.getNote();
                        String amount = response.getAmount();
                        cbContext.success(amount);
                    }
                }
                else {
                    String error_message = data.getStringExtra("error_message");
                    Log.d(TAG, "error crap");

                    // cbContext.error(error_message);
                    //An error ocurred.  Make sure to display the error_message to the user
                }                               
            }
            else if(resultCode == 0) {
              Log.d(TAG, "cancelled that crap");

                //The user cancelled the payment
            }
        break;
        }           
    }
  }
}
