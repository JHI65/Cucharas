# Lanzamiento de Spoony a las tiendas

Auditoría del 2026-09-17 sobre el commit `ddf1743`, hecha leyendo `index.html` entero.
Decisión tomada el 2026-09-17: **Spoony se publica en App Store y Google Play**. Esto
sustituye a la distribución directa que decían `PRODUCT.md` y `brief-cucharas.md`.

Estado: la base está bien. El modelo de energía funciona, no hay rachas ni vergüenza,
los datos no salen del dispositivo y la parte sensorial está afinada. Lo que frena la
publicación son tres bloqueantes y una lista de arreglos que se notarían en el uso
diario. Estimación: 1–2 semanas de trabajo más una beta con personas autistas.

Orden recomendado: **persistencia → primer arranque → resto de arreglos → beta → tienda.**

---

## 1. Bloqueantes

### 1.1 El historial se puede perder entero

Todo vive en `localStorage`. Tanto en una PWA como dentro de una app envuelta con
Capacitor, el sistema puede borrar ese almacenamiento; en iOS basta con quitar el icono.
Lo que da valor a la app (Patrones, "sueles gastar X") necesita semanas de datos
acumulados, así que perderlos rompe la promesa central.

El objeto `store` (`index.html:1000`) ya es el punto exacto donde enchufar un guardado
nativo en archivo:

```js
const FS = window.Capacitor?.isNativePlatform?.() ? Capacitor.registerPlugin('Filesystem') : null;

// get():
// if(FS){ try{ const r = await FS.readFile({path:'spoony.json', directory:'DATA', encoding:'utf8'}); return JSON.parse(r.data); }catch(e){ return null; } }

// set():
// if(FS){ await FS.writeFile({path:'spoony.json', directory:'DATA', encoding:'utf8', data:s}); return; }
```

Pendiente de verificar al integrarlo: el acceso al plugin sin empaquetador
(`Capacitor.registerPlugin`) y el nombre del directorio. La primera vez que arranque en
nativo hay que copiar lo que ya hubiera en `localStorage`.

### 1.2 "Cucharas" no se explica en ningún sitio, y la teoría no tiene crédito

Quien abre la app por primera vez ve "¿Con cuántas cucharas te levantas?" sin contexto
previo. Va contra el principio 2 del propio proyecto (nada de metáforas sin explicar).
Además, ni Miserandino ni Toudal/Attwood aparecen en el código: usar vocabulario de la
comunidad en un producto público sin dar crédito es justo lo que destruye la confianza
(N10, editorial).

Arreglo: una pantalla que salga solo la primera vez, antes del check-in, saltable, con un
botón "Entendido", guardando `state.settings.introSeen`. Más una fila "Acerca de" en
Ajustes con los créditos.

Texto propuesto:

> Una cuchara es una unidad de energía. Cada día tienes un número distinto; las tareas
> gastan cucharas y descansar las recupera. La idea es de Christine Miserandino (teoría
> de las cucharas) y de Maja Toudal y Tony Attwood (*Energy Accounting*).

### 1.3 La fase del ciclo se puede leer como predicción de fertilidad

`renderCycle()` muestra "Fase estimada: Ovulación" a partir de un cálculo de calendario,
sin ninguna advertencia. Alguien podría fiarse de ella para evitar un embarazo. Además,
las tiendas revisan con lupa las apps que tocan datos de salud.

Arreglo, en `renderCyclePrediction()` (`index.html:1565`):

```js
<p>No sirve para evitar ni para buscar un embarazo.</p>
```

Alternativa: quitar la etiqueta de fase y dejar solo el día del ciclo.

---

## 2. Importantes

### 2.1 Los check-in saltados cuentan como respuestas

`budgetUnanswered` se escribe (`index.html:1878`) pero no se lee nunca. `typicalBudget()`
promedia días no contestados, y el patrón de picos compara contra ellos, lo que empuja el
resultado hacia "no se nota diferencia". Un día sin respuesta no es un dato (principio 6).

```js
// typicalBudget (1634)
.map(k => state.days[k]).filter(d => d.budget != null && !d.budgetUnanswered).map(d => d.budget);

// peakNextDayInsight (1701)
if(next && next.budget != null && !next.budgetUnanswered) acc.push(next.budget - typical);
```

### 2.2 A medianoche la app muestra el día equivocado

`#todayDate` solo se rellena al arrancar (`index.html:2770`) y nada escucha
`visibilitychange`. En un móvil la app vuelve del segundo plano sin reiniciarse: la fecha
dice ayer, las tareas ya son de hoy y el check-in no aparece.

```js
let bootDay = todayKey();
document.addEventListener('visibilitychange', () => {
  if(document.hidden || todayKey() === bootDay) return;
  bootDay = todayKey();
  document.getElementById('todayDate').textContent = fmtDate(bootDay);
  collapsedTasks.clear(); day().tasks.forEach(t => { if(t.done) collapsedTasks.add(t.id); });
  renderAll();
  if(day().budget == null) openCheckin();
});
```

### 2.3 `confirm`, `alert` y `prompt` nativos

- Al borrar una serie (`index.html:2119` y `2496`), "Cancelar" significa "bórrala solo de
  este día": un toque por error borra algo. El mapeo no es literal.
- `prompt()` para el nombre del día tipo (`index.html:2440`) puede fallar o no aparecer
  dentro de una app envuelta.
- Son ventanas del sistema, ajenas al resto del diseño.

Arreglo: hojas propias. Para la serie, tres botones — "Solo este día", "Todos los días de
la serie", "Cancelar". Para el día tipo, un campo de texto.

### 2.4 No hay tamaño de texto ni modo oscuro

Los tamaños están fijos en px y la app declara `color-scheme: light only`. El zoom queda
desactivado por decisión tomada y no se reabre, pero sumado a lo anterior una persona con
baja visión o fotofobia no tiene ninguna salida (principio 4 / P3).

Mínimo para la v1, un ajuste "Tamaño del texto":

```css
.app, dialog, .tabs{ zoom: var(--text-scale, 1); }
```

Hay que probarlo con la barra de pestañas fija y con las hojas. El modo oscuro puede
esperar a la v1.1 (implica una tercera variante de tokens, no solo invertir).

### 2.5 Finanzas es una pestaña fija ajena al modelo de energía

Desdibuja el mensaje de "planifica por energía", ocupa sitio permanente y, con Ciclo
activo, obliga a bajar las etiquetas a 11px. El € está escrito a mano, lo que deja fuera a
Latinoamérica.

Arreglo: módulo opcional como Ciclo (`state.finEnabled`), apagado por defecto. Para no
quitarle la pestaña a quien ya la usa (principio de predictibilidad):

```js
if(typeof state.finEnabled !== 'boolean')
  state.finEnabled = !!(state.finanzas?.gastosFijos?.length
    || state.finanzas?.gastosVariables?.length
    || state.finanzas?.historial?.length);
```

### 2.6 Importar no valida el archivo

La importación (`index.html:2702`) sustituye el estado entero sin repetir las reparaciones
que hace `init()`: un archivo sin `library` rompe el render. Además `t.time` y `t.est`
entran en el HTML sin escapar (`1210`, `2477`, `2478`), así que un archivo manipulado
podría ejecutar código — algo que pesa más dentro de una app nativa con plugins.

Arreglo: extraer a `normalize(state)` lo que hace `init()` y llamarlo en los dos sitios;
cambiar a `${esc(t.time)}` y `${fmtN(+(t.real ?? t.est) || 0)}`.

---

## 3. Mejoras

- "Cierra cuando estés listo" (`index.html:892`) asume género → "Cierra cuando quieras".
- `PRODUCT.md` y `brief-cucharas.md` describen la pestaña "Cucharas" (ya no existe; la
  calculadora es una hoja desde Hoy), un check-in que bloquea (ya no bloquea) y no
  mencionan Finanzas. Actualizar antes de escribir la ficha de tienda a partir de ellos.
- Línea de "Última copia: hace N días" en Ajustes, sin notificaciones ni insistencia:
  reduce el riesgo de pérdida total sin montar servidor.

---

## 4. Ruta a las tiendas

Vía elegida: **Capacitor**, que envuelve la web en una app nativa. Usa el mismo
`index.html`, así que el código de la app sigue siendo un único archivo sin compilación;
lo que se añade es la capa nativa. La PWA (manifest + service worker) queda como vía
secundaria para distribución directa: instalar una PWA en iOS lleva varios pasos poco
evidentes y eso es una barrera real para este público.

- [ ] Guardado nativo en archivo (§1.1).
- [ ] Exportar con los plugins Filesystem + Share: en iOS `<a download>` con blob no
      funciona dentro de la app envuelta. El archivo aún se llama `cucharas-…json`.
- [ ] Sustituir `confirm`, `alert` y `prompt` por hojas propias (§2.3).
- [ ] Política de privacidad en una URL pública: la piden las dos tiendas aunque no se
      recoja nada.
- [ ] Ficha de privacidad de Apple: "Datos no recopilados". Formulario de seguridad de
      datos de Google Play: nada recopilado. **No añadir SDKs de analítica ni de informes
      de fallos** — ese "no recogemos nada" es el mejor argumento del producto.
- [ ] Cuestionario de datos de salud: rellenarlo con cuidado por el módulo de Ciclo.
- [ ] Icono de 1024×1024. El actual es un PNG de 180px incrustado en el HTML.
- [ ] Buscar "Spoony" en ambas tiendas y en OEPM/EUIPO antes de invertir en la ficha.
- [ ] Costes: Apple 99 USD/año, Google 25 USD pago único. Para iOS hace falta un Mac con
      Xcode.

### Texto de la ficha

Literal, sin promesas clínicas:

> Planifica tu día por la energía que tienes, no por las horas. Sin cuenta. Tus datos no
> salen del teléfono.

Nada de "detecta tu burnout": suena a diagnóstico. Mejor "te enseña patrones de lo que has
apuntado". Capturas reales, nada de mockups inventados. Decir con claridad que está
pensada para personas adultas que leen y puntúan por escrito: la evidencia disponible no
cubre a personas no hablantes ni con necesidades de apoyo altas.

### Precio

Gratis y sin anuncios. Un 42,7% de la comunidad declara estar mal de dinero (N4). Si en
algún momento se cobra, que sea un pago único por extras, nunca por el pico sensorial, el
espacio de calma ni el contraste.

---

## 5. Validación con personas autistas (antes de publicar)

1. **Beta cerrada y pagada, mínimo 3 semanas** (TestFlight y pruebas internas de Google
   Play), 8–12 adultos autistas. Tres semanas porque Patrones no dice nada hasta los 14
   check-outs. Buscar más variedad que la muestra de la revista: hombres, mayores de 45,
   Latinoamérica. Recoger opiniones por escrito y sin prisa. Pregunta clave: ¿lo que dijo
   Patrones te sonó a verdad?
2. **Prueba en frío con 5 personas que no conozcan la teoría de las cucharas.** Abren la
   app sin explicación previa; se observa en silencio si completan el check-in y añaden
   una tarea. Preguntas después, por escrito.
3. **Módulo de Ciclo** con personas que menstrúan, incluidas trans y no binarias: el texto
   del margen y si se mantiene o se quita "Fase estimada".

---

## 6. Planteamiento

La apuesta central sigue siendo correcta y las últimas semanas la han acercado a su
promesa: picos sensoriales, entorno de la tarea, patrón del día siguiente. Pero el alcance
se ha ensanchado (Finanzas, Ciclo) hacia un panel de "toda tu vida". Para salir al mercado
conviene recortarlo a energía y carga sensorial, con Ciclo y Finanzas como módulos
opcionales.

El mayor riesgo no es de diseño: el valor llega a partir del check-out número 14 y los
datos son frágiles. De ahí el orden — persistencia primero, primer arranque después.
