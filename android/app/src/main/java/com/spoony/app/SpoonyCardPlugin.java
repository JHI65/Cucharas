package com.spoony.app;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.provider.Settings;

import androidx.core.app.NotificationManagerCompat;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

/* Puente para los pagos de Google Wallet: saber si hay acceso a
   notificaciones, abrir el ajuste del sistema para darlo o quitarlo, y
   encender o apagar la captura según Finanzas. */
@CapacitorPlugin(name = "SpoonyCard")
public class SpoonyCardPlugin extends Plugin {

    @PluginMethod
    public void status(PluginCall call) {
        JSObject r = new JSObject();
        r.put("granted", NotificationManagerCompat.getEnabledListenerPackages(getContext())
                .contains(getContext().getPackageName()));
        call.resolve(r);
    }

    @PluginMethod
    public void setEnabled(PluginCall call) {
        getContext().getSharedPreferences(PaymentListenerService.PREFS, Context.MODE_PRIVATE).edit()
                .putBoolean(PaymentListenerService.KEY_ENABLED, Boolean.TRUE.equals(call.getBoolean("enabled", false)))
                .apply();
        call.resolve();
    }

    @PluginMethod
    public void openSettings(PluginCall call) {
        Intent i;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            i = new Intent(Settings.ACTION_NOTIFICATION_LISTENER_DETAIL_SETTINGS);
            i.putExtra(Settings.EXTRA_NOTIFICATION_LISTENER_COMPONENT_NAME,
                    new ComponentName(getContext(), PaymentListenerService.class).flattenToString());
        } else {
            i = new Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS);
        }
        i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        try {
            getActivity().startActivity(i);
        } catch (Exception e) {
            getActivity().startActivity(new Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
        }
        call.resolve();
    }
}
