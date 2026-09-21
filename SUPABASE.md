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
