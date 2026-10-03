package com.spoony.app;

import android.app.Notification;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;

import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/* Apunta los pagos de Google Wallet sin abrir la app. Android entrega al
   servicio todas las notificaciones; aquí se descartan de inmediato las que
   no son de Wallet, y de esas solo se guarda importe y comercio (nunca el
   texto completo). Cada pago queda como un archivo en files/SpoonyGastos,
   la misma cola que recoge la web en iOS. */
public class PaymentListenerService extends NotificationListenerService {

    static final String PREFS = "spoony_card";
    static final String KEY_ENABLED = "enabled";
    static final String DIR = "SpoonyGastos";
    private static final String WALLET = "com.google.android.apps.walletnfcrel";
    private static final long SAME_PAYMENT_MS = 10 * 60 * 1000;

    private static final String CUR = "(?:€|\\$|£|EUR|USD|GBP)";
    private static final String NUM = "\\d{1,3}(?:[.,\\s\\u00A0\\u202F]\\d{3})*(?:[.,]\\d{1,2})?|\\d+(?:[.,]\\d{1,2})?";
    private static final Pattern AMOUNT = Pattern.compile(
            CUR + "[\\s\\u00A0\\u202F]?(?:" + NUM + ")|(?:" + NUM + ")[\\s\\u00A0\\u202F]?" + CUR);
    private static final Pattern AT = Pattern.compile(
            "\\u0000\\s+(?:en|at|in)\\s+(.+?)(?:\\s+(?:con|with)\\s|\\n|$)");

    @Override
    public void onNotificationPosted(StatusBarNotification sbn) {
        if (sbn == null || !WALLET.equals(sbn.getPackageName())) return;
        SharedPreferences prefs = getSharedPreferences(PREFS, Context.MODE_PRIVATE);
        if (!prefs.getBoolean(KEY_ENABLED, false)) return;
        Notification n = sbn.getNotification();
        if (n == null || (n.flags & Notification.FLAG_GROUP_SUMMARY) != 0) return;
        Bundle ex = n.extras;
        String title = text(ex, Notification.EXTRA_TITLE);
        String body = text(ex, Notification.EXTRA_BIG_TEXT);
        if (body.isEmpty()) body = text(ex, Notification.EXTRA_TEXT);

        Matcher m = AMOUNT.matcher(title + "\n" + body);
        if (!m.find()) return;   // avisos de Wallet que no son un pago
        String amount = m.group().trim();
        // "3,40 € en Panadería" / "€4.20 at Starbucks": lo que sigue al importe manda.
        Matcher at = AT.matcher(m.replaceFirst("\u0000"));
        String merchant = at.find() ? clean(at.group(1)) : clean(title.replace(amount, ""));
        if (merchant.isEmpty()) merchant = clean(body.replace(amount, "").split("\n")[0]);
        if (merchant.length() > 60) merchant = merchant.substring(0, 60).trim();

        try {
            save(prefs, sbn.getKey() + "|" + amount, amount, merchant);
        } catch (Exception ignored) {
        }
    }

    /* Wallet a veces vuelve a publicar la misma notificación al completar los
       datos del pago: si llega igual en poco tiempo, se reescribe el mismo id
       en vez de crear un gasto nuevo. */
    private void save(SharedPreferences prefs, String sig, String amount, String merchant) throws Exception {
        long now = System.currentTimeMillis();
        String id = sig.equals(prefs.getString("lastSig", null)) && now - prefs.getLong("lastTime", 0) < SAME_PAYMENT_MS
                ? prefs.getString("lastId", null) : null;
        if (id == null) id = UUID.randomUUID().toString();
        prefs.edit().putString("lastSig", sig).putString("lastId", id).putLong("lastTime", now).apply();

        SimpleDateFormat iso = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.US);
        iso.setTimeZone(TimeZone.getTimeZone("UTC"));
        JSONObject item = new JSONObject();
        item.put("id", id);
        item.put("importe", amount);
        item.put("comercio", merchant);
        item.put("fecha", iso.format(new Date(now)));
        item.put("origen", "wallet");

        File dir = new File(getFilesDir(), DIR);
        if (!dir.exists() && !dir.mkdirs()) return;
        File tmp = new File(dir, id + ".tmp");
        try (FileOutputStream out = new FileOutputStream(tmp)) {
            out.write(item.toString().getBytes(StandardCharsets.UTF_8));
        }
        File dest = new File(dir, id + ".json");
        if (!tmp.renameTo(dest)) {
            dest.delete();
            tmp.renameTo(dest);
        }
    }

    private static String text(Bundle ex, String key) {
        if (ex == null) return "";
        CharSequence cs = ex.getCharSequence(key);
        return cs == null ? "" : cs.toString().trim();
    }

    private static String clean(String s) {
        return s.replaceAll("^[\\s·•\\-–—:,]+|[\\s·•\\-–—:,]+$", "").trim();
    }
}
