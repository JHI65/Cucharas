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

**Queda un hueco conocido**: `color-mix()` necesita Safari 16.2, y "Color de la
interfaz" (Ajustes → Cómo se ve) lo usa para retiñir toda la paleta. En un iPhone con
iOS 15.4–16.1 esa función no dará error, pero tampoco hará nada visible. Son iPhone 6s,
7 y SE de primera generación, que se quedaron en iOS 15. Dos salidas posibles, sin
decidir todavía:

1. Ocultar la fila de color donde `CSS.supports('color', 'color-mix(...)')` sea falso,
   y mantener el mínimo en 15.4. Más inclusivo, una rama más que probar.
2. Subir el mínimo a 16.4 y quitar el problema. Deja fuera esos modelos.

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

Nada de lo de abajo se ha comprobado nunca fuera del navegador. Es el motivo de montar
esto ahora:

- [ ] Que `spoony.json` se crea en `Directory.Data` y sobrevive a cerrar y reabrir.
- [ ] Que al actualizar desde una versión con datos en `localStorage` se copian al archivo.
- [ ] Exportar: que la hoja de compartir aparece y el archivo se puede guardar en Archivos.
- [ ] Importar: que el selector de archivos abre y el JSON se lee.
- [ ] Tamaño del texto: `zoom` sobre la barra de pestañas `position:fixed` y sobre las
      hojas `<dialog>`, en los tres pasos.
- [ ] Áreas seguras: notch y barra inferior con `viewport-fit=cover`.
- [ ] Que el corte de día configurable (Ajustes → Cuándo empieza tu día) se comporta al
      volver de segundo plano.
