# Carcasa nativa (Capacitor)

Spoony se publica en App Store y Google Play envuelta con Capacitor. **El código de
la app sigue siendo un único `index.html` sin compilación**: lo que se añade aquí es la
capa nativa, que es otra cosa. No hay framework, ni bundler, ni paso de build del HTML.

Montado el 2026-09-21 con Capacitor 8.5.2.

## Cómo está organizado

```
index.html          <- la app. Fuente única, se edita aquí y solo aquí.
www/                <- copia generada de index.html (ignorada por git)
android/            <- proyecto Android
ios/                <- proyecto Xcode
capacitor.config.json
```

`www/` existe solo porque Capacitor necesita una carpeta de la que copiar. La genera
`npm run prep` con un `cp`. **Nunca edites `www/index.html`**: se borra y se regenera en
cada sincronización.

## Comandos

| Comando | Qué hace |
|---|---|
| `npm run prep` | Regenera `www/` a partir de `index.html`. |
| `npm run sync` | `prep` + `cap sync`: copia el HTML a los dos proyectos y actualiza plugins. |
| `npm run ios` | `sync` + abre Xcode. |
| `npm run android` | `sync` + abre Android Studio. |

**Después de tocar `index.html` hay que ejecutar `npm run sync`**, o los proyectos
nativos siguen con la versión vieja. Es el único paso manual que añade Capacitor.

## Identidad

- **appId**: `com.spoony.app` — no se puede cambiar una vez publicado en las tiendas.
- **appName**: `Spoony`.
- Pendiente antes de invertir en la ficha: buscar "Spoony" en ambas tiendas y en
  OEPM/EUIPO. El appId da por hecho que el nombre está libre.

## Versiones mínimas, y por qué

**iOS 15.4**, subido desde el 15.0 que pone Capacitor por defecto. No es arbitrario:
`<dialog>` y `showModal()` no existen antes de Safari 15.4, y la app los usa en 16
sitios (check-in, añadir tarea, check-out, calculadora, pico sensorial...). Por debajo
de 15.4 no se abriría ni el check-in. `:has()`, que se usa una vez en el CSS del grupo
de Ciclo, llega en esa misma versión.

**El hueco de `color-mix()` está resuelto** (2026-09-21). `color-mix()` necesita Safari
16.2 y "Color de la interfaz" (Ajustes → Cómo se ve) lo usa para retiñir toda la paleta,
así que en un iPhone con iOS 15.4–16.1 la fila habría aparecido sin hacer nada: los
`setProperty()` con un valor inválido se ignoran y la paleta se habría quedado en el
rosa de fábrica. Se descartó subir el mínimo a 16.4, que habría dejado fuera al iPhone
6s, al 7 y al SE de primera generación, en un público donde el 42,7% declara estar mal
de dinero (N4). En su lugar, `CAN_COLOR_MIX` comprueba el soporte con `CSS.supports()` y
donde no lo hay se ocultan las dos filas (`#colorPickRow` y `#colorInfoRow`) y no se
intenta aplicar nada.

El color guardado en `state.settings.customColor` **no se borra** en ese caso: es una
preferencia de la persona, y si restaura la copia en un móvil que sí puede, vuelve a
aplicarse. El borde de la última fila visible del grupo lo resuelve solo la regla
`.group .row:not(:has(~ .row:not([hidden])))` que ya existía.

**Android: minSdk 24** (Android 7), el valor por defecto de Capacitor. Importa menos que
en iOS porque el WebView se actualiza solo desde Play Store, así que un móvil viejo
puede tener un motor moderno igualmente.

## Java para compilar Android

Capacitor 8 exige **JDK 21**. Android Studio trae el suyo y lo usa solo; desde la
terminal hay que apuntarlo a mano:

```sh
cd android
JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home" ./gradlew assembleDebug
```

No está fijado en `gradle.properties` a propósito: es una ruta de esta máquina, y
clavarla en un archivo del repositorio rompe el proyecto en cualquier otra.

## Plugins instalados

- `@capacitor/filesystem` — el almacén real de la app (`spoony.json` en `Directory.Data`)
  y el archivo de paso al exportar.
- `@capacitor/share` — la hoja de compartir del sistema al exportar.

Deliberadamente **no** hay analítica ni informes de fallos. Ese "no recogemos nada" es el
argumento del producto y lo que sostiene la ficha de privacidad de las dos tiendas.

## Qué falta probar en un dispositivo real

Marcado lo que ya se ha comprobado en el simulador de iOS (iPhone 16e, iOS 26.2). El
simulador no sustituye a un móvil de verdad para lo sensorial ni para la hoja de
compartir, pero sí vale para la lógica.

- [x] Que `spoony.json` se lee y se escribe en `Directory.Data`. Verificado el
      2026-09-21, y **encontró el fallo**: `registerPlugin()` no existe en el puente que
      inyecta Capacitor, así que todo iba a `localStorage`. Ver §1.1 de `LANZAMIENTO.md`.
      Comprobadas las dos direcciones: un archivo sembrado a mano se lee y se muestra, y
      un archivo corrupto se aparta como `spoony-danado.json`.
- [ ] Que al actualizar desde una versión con datos en `localStorage` se copian al archivo.
- [ ] Exportar: que la hoja de compartir aparece y el archivo se puede guardar en Archivos.
- [ ] Importar: que el selector de archivos abre y el JSON se lee.
- [x] Tamaño del texto en Ajustes y en la barra de pestañas (2026-09-21). Encontró tres
      fallos, los tres arreglados: chips de Ajustes que se salían (también en "Muy
      grande"), Contraste estrangulado con el texto ampliado, y las etiquetas de la barra
      casi tocándose con cinco pestañas (hueco mínimo de ~4 px, ahora 7,5 px; se limita el
      zoom de la barra a 1,15 en ese caso). Medido con cada pestaña activa por turnos.
- [ ] Tamaño del texto sobre las hojas `<dialog>` (Añadir tarea, Check-in, Check-out...),
      en "Grande" y "Muy grande". Sin mirar todavía.
- [x] Área segura superior: el título quedaba pegado al reloj; arreglado y comprobado en
      captura (2026-09-21). Sigue pendiente la barra inferior y un iPhone con Dynamic Island.
- [ ] Que el corte de día configurable (Ajustes → Cuándo empieza tu día) se comporta al
      volver de segundo plano.
