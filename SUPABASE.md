# Cuenta opcional y copia en la nube (Supabase)

Decidido el 2026-09-21: **cuenta opcional con sincronización**, sobre Supabase. Más
adelante será de pago. Sustituye a la decisión anterior de `LANZAMIENTO.md §3`, que
descartaba cualquier servidor.

## Cómo funciona

- **Sin cuenta, nada cambia.** La app guarda en el móvil, funciona sin conexión y los
  datos no salen del teléfono. Exportar e importar siguen ahí.
- **Con cuenta**, el estado entero de la app se sube a una fila de la tabla
  `spoony_state` y se baja en otros móviles.
- **Manda el móvil.** La nube es una copia. Sin conexión todo sigue igual y los cambios
  se suben cuando vuelve la red (dos segundos después del último cambio, al volver a
  la app y al recuperar la conexión).
- **Nunca se sustituyen datos en silencio.** Si este móvil y la cuenta tienen cambios
  distintos, se abre una hoja que enseña los dos (días con datos, tareas, último día) y
  pregunta cuáles guardar. "Decidir más tarde" deja la sincronización parada, con una
  fila en Ajustes para volver a elegir.
- **La versión la pone la base de datos.** Cada subida lleva la condición "si la
  versión sigue siendo la que vi"; si otro móvil subió algo entretanto, no se pisa.
- **Borrar la cuenta** está dentro de la app (Apple lo exige, guideline 5.1.1(v)).
  Borra la cuenta y la copia en la nube; lo del móvil se queda.

Se habla con la API REST de Supabase con `fetch`, sin su librería JS: la app sigue
siendo un único `index.html`, no depende de un CDN para arrancar y funciona sin red.

## Montar el proyecto (lo haces tú, una vez)

1. Crea una cuenta en supabase.com y un proyecto nuevo. **Región: Frankfurt
   (eu-central-1)**. El módulo de Ciclo guarda datos de salud, categoría especial en el
   RGPD: que estén en la UE simplifica todo.
2. En **SQL Editor**, pega y ejecuta `supabase/schema.sql`.
3. En **Authentication → URL Configuration → Site URL**, pon
   `https://jhi65.github.io/Cucharas/auth.html`. Es `docs/auth.html` de este
   repositorio, servido con GitHub Pages. Sin esto, el enlace de confirmación del
   correo lleva al `localhost:3000` de fábrica de Supabase, y la persona ve un error
   aunque la cuenta se haya confirmado igual por debajo.
4. En **Project Settings → API**, copia la **Project URL** y la clave **anon public**, y
   pégalas en `index.html`:

   ```js
   const SUPABASE_URL = 'https://xxxxxxxx.supabase.co';
   const SUPABASE_ANON_KEY = 'eyJ...';
   ```

   La clave `anon` es pública por diseño: va dentro de la app y cualquiera puede verla.
   Lo que protege los datos son las políticas RLS del esquema (cada persona solo lee y
   escribe su propia fila). **Nunca pongas aquí la clave `service_role`.**
5. `npm run sync`.

Mientras las dos constantes estén vacías, el grupo "Tu cuenta" no aparece y la app se
comporta exactamente como antes.

## De pago, más adelante

`syncAllowed()` en `index.html` es el único punto que decide si hay copia en la nube.
Hoy devuelve `true` si el proyecto está configurado. Cuando haya suscripción, la
comprobación va ahí. Recordatorio de `LANZAMIENTO.md §4`: lo que se cobre no puede ser
el pico sensorial, el espacio de calma ni la accesibilidad.

## Qué cambia en las tiendas

La ficha de privacidad deja de ser "Datos no recopilados". Con cuenta se recogen, **solo
si la persona la crea**:

- Correo electrónico (para la cuenta).
- Datos de salud, si usa el módulo de Ciclo.
- El contenido que apunta (tareas, notas, gastos).

Todo vinculado a la identidad, sin rastreo ni publicidad. Hace falta una política de
privacidad que diga dónde están los datos (Supabase, UE), para qué, cuánto tiempo y
cómo borrarlos, y rellenar con cuidado los cuestionarios de datos de salud de Apple y
Google. Supabase actúa como encargado del tratamiento: firma su DPA desde el panel.

## Qué está comprobado y qué no

Comprobado el 2026-09-21 en el simulador de iOS, con la app real hablando con un
**servidor falso** en el Mac que imita a Supabase. Lo real es el `fetch`, CORS desde
`capacitor://localhost`, el guardado local y la máquina de estados; lo imitado es el
servidor.

- [x] Crear cuenta con datos en el móvil y la nube vacía: sube todo sin preguntar.
- [x] Relanzar la app: la sesión se mantiene y un cambio se sube solo.
- [x] Sin conexión: el aviso lo dice y el cambio queda pendiente.
- [x] Otro móvil sube algo mientras este tiene cambios: no se pisa nada y se pregunta.
- [x] "Guardar los de la cuenta" y "Guardar los de este móvil": los dos funcionan.
- [x] Móvil nuevo sin datos entra con la cuenta: se baja todo sin preguntar.
- [x] Contraseña incorrecta: mensaje literal.
- [x] Borrar la cuenta: se va la cuenta y la fila; lo del móvil se queda.

**Comprobado el mismo día contra el proyecto real** (`fcmrwfpekzgtsgktyvwk`, Frankfurt),
con una cuenta de prueba en un buzón público (mailinator), confirmada siguiendo el enlace
del correo de verdad: crear cuenta, iniciar sesión, subir un cambio local (`version` subió
sola de 1 a 2 por el trigger), RLS bloqueando sin token y dejando pasar con el suyo, y
`delete_my_account` borrando la cuenta y la fila (comprobado con el mismo token después:
ya no ve nada). Las claves reales ya están en `index.html`.

**"Confirm email" se queda activado.** El Site URL de fábrica (`localhost:3000`) se
sustituyó por `https://jhi65.github.io/Cucharas/auth.html` — decisión tomada con el
usuario el 2026-09-21. Esa página es `docs/auth.html`, estática y sin JS externo, servida
con GitHub Pages desde `/docs` en `main` (con un `.nojekyll`: el pipeline "legacy" de
Pages pasa todo por Jekyll si no se le dice lo contrario, y hacía fallar el build sin más
detalle que "Page build failed"). Lee el fragmento de la URL que manda Supabase
(`#access_token=...`, `#error=...`) y dice qué ha pasado en lenguaje literal; no hace nada
con el token, que es de otro origen y no lo comparte con la sesión de la app nativa.

Comprobado sirviendo la página real con `#access_token=x&type=signup` en el fragmento:
responde 200 y el HTML es el esperado. **Ojo con el nombre del archivo si se vuelve a
tocar**: GitHub Pages cachea los 404 de builds fallidos por ruta exacta, sin tener en
cuenta la cadena de consulta; el archivo se llamó primero `confirm.html` y hubo que
renombrarlo a `auth.html` porque ese 404 viejo se había quedado en el borde de su CDN
varios minutos después de que el build ya estuviera bien.

**Pendiente de construir**: recuperar la contraseña (hoy, quien la olvida conserva los
datos del móvil pero pierde el acceso a la nube) y Android en emulador.

## Login con Google y Apple (opcional, 2026-09-21)

Decidido con el usuario: **Google y Apple en iOS, solo Google en Android.** No sustituye
al correo/contraseña, se añade como alternativa dentro de la misma hoja "Tu cuenta".

Apple exige "Sign in with Apple" si se ofrece cualquier login social de terceros (App
Store Review Guideline 4.8) — por eso Apple aparece en iOS y en Android no, donde esa
regla no aplica.

### Cómo funciona

Sin librería de Supabase ni SDK de Google/Apple, con los mismos plugins nativos que ya
usa el resto de la app (`@capacitor/browser` para abrir la pantalla de login dentro de
la propia app — Custom Tabs en Android, SFSafariViewController en iOS — y
`@capacitor/app` para escuchar la vuelta):

1. Se abre `${SUPABASE_URL}/auth/v1/authorize?provider=google` (o `apple`) con
   `redirect_to=com.spoony.app://login-callback`.
2. Al terminar el login, el proveedor redirige a esa URL con el token en el fragmento.
   El sistema operativo reabre Spoony y dispara `appUrlOpen`.
3. Con el token, se pide `/auth/v1/user` para tener el correo y el id, y se entra igual
   que con correo/contraseña.

Solo aparece dentro de la app nativa: en un navegador de escritorio no hay ningún sitio
al que Google o Apple puedan redirigir de vuelta.

### Verificado (2026-09-21)

- **Android, por primera vez en un emulador** (`Medium_Phone_API_36.1`, API 36):
  arranca, se ve bien, y solo aparece "Continuar con Google" (Apple oculto). Pulsar el
  botón abre Chrome Custom Tabs de verdad con la URL de Supabase.
- El enlace de vuelta (`com.spoony.app://login-callback#...`), simulado con un intent de
  Android, dispara `appUrlOpen` con la app en segundo plano, abre la hoja "Tu cuenta" y
  muestra el error correcto según el caso: token inválido ("No se pudo completar...") y
  enlace caducado ("Ese enlace ha caducado...").
- **iOS**: `Info.plist` registra el esquema `com.spoony.app://` — confirmado porque el
  simulador reconoce la URL como propia de Spoony al abrirla desde fuera. La misma
  lógica (`completeOAuth`) se probó invocándola directamente y responde igual que en
  Android.
- **Google, verificado de principio a fin el 2026-09-21, con una cuenta real** (no un
  simulacro): Client ID creado en Google Cloud Console (tipo **Web application**, no
  Android/iOS — ese tipo pide un ID de paquete que aquí no hace falta), activado en
  Supabase, y probado en el emulador de Android. A la primera faltaba un paso y quedó
  documentado en caliente: sin `com.spoony.app://login-callback` en **Authentication →
  URL Configuration → Redirect URLs**, el login llegaba a completarse en Google pero
  Supabase lo mandaba de vuelta al Site URL (`auth.html`, la página web) en lugar de al
  esquema de la app — la sesión se quedaba fuera, en el navegador, sin volver a Spoony.
  Añadido ese Redirect URL, el círculo se cierra: la app recibe la sesión y entra.
- **Apple**: sigue sin probar, pendiente de la cuenta de pago de Apple Developer.

### Lo que falta, y solo lo puedes hacer tú

**Google** (Google Cloud Console, cuenta gratuita):
1. Crea un **OAuth 2.0 Client ID** de tipo **Web application**.
2. En **Authorized redirect URIs**, añade
   `https://fcmrwfpekzgtsgktyvwk.supabase.co/auth/v1/callback`.
3. En Supabase, **Authentication → Providers → Google**: actívalo y pega el Client ID y
   el Client Secret que te dé Google.

**Apple** (necesita cuenta de pago de Apple Developer, 99 USD/año — la misma que hace
falta para publicar en la App Store, así que no es un gasto aparte):
1. En developer.apple.com, crea un **Services ID** con "Sign in with Apple" activado, y
   una **Key** para Sign in with Apple.
2. En Supabase, **Authentication → Providers → Apple**: los campos exactos (Team ID, Key
   ID, Services ID, la clave) los tiene la propia documentación de Supabase para Apple,
   que conviene mirar en el momento porque estas pantallas cambian; lo único fijo de mi
   parte es el paso siguiente.

**El mismo paso para los dos, y es el que rompe todo si se olvida:**

En Supabase, **Authentication → URL Configuration → Redirect URLs**, añade

```
com.spoony.app://login-callback
```

Supabase solo redirige a las URLs de esa lista (o al Site URL). Sin esto, el login
"funciona" hasta el final y luego manda a la persona a `auth.html` en vez de dentro de
la app, y la sesión se pierde.

### Pendiente, sin decidir

- Los botones son texto plano ("Continuar con Google"/"Continuar con Apple"), no los
  logos oficiales que piden las guías de marca de Google y Apple. No bloquea nada, es
  una mejora visual para más adelante.
- La franja blanca de la barra de estado en Android (se ve sin temar, la app no la
  pinta) — vista de pasada al probar por primera vez el emulador, no es de este cambio.
