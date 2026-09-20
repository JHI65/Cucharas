# Lanzamiento de Spoony a las tiendas

Auditoría del 2026-09-17 sobre el commit `ddf1743`, hecha leyendo `index.html` entero.
Decisión tomada el 2026-09-17: **Spoony se publica en App Store y Google Play**. Esto
sustituye a la distribución directa que decían `PRODUCT.md` y `brief-cucharas.md`.

Estado: la base está bien. El modelo de energía funciona, no hay rachas ni vergüenza,
los datos no salen del dispositivo y la parte sensorial está afinada. Lo que frena la
publicación son tres bloqueantes y una lista de arreglos que se notarían en el uso
diario. Estimación: 1–2 semanas de trabajo más una beta con personas autistas.

Orden recomendado: **persistencia → primer arranque → resto de arreglos → beta → tienda.**
La persistencia (§1.1) está hecha; queda probarla en un dispositivo real.

---

## 1. Bloqueantes

### 1.1 El historial se puede perder entero — hecho el 2026-09-17

Todo vivía en `localStorage`. Tanto en una PWA como dentro de una app envuelta con
Capacitor, el sistema puede borrar ese almacenamiento; en iOS basta con quitar el icono.
Lo que da valor a la app (Patrones, "sueles gastar X") necesita semanas de datos
acumulados, así que perderlos rompe la promesa central.

Escrito en el objeto `store` (`index.html:998`). Dentro de la app nativa los datos van a
un archivo, `spoony.json` en `Directory.Data` (en iOS la carpeta Documents de la app, en
Android la de archivos internos: sobrevive a las actualizaciones, se borra al
desinstalar). Fuera de la app nativa no cambia nada: `window.storage` dentro de Claude,
`localStorage` en el navegador.

- El plugin se resuelve la primera vez que se usa, no al cargar el script, porque el
  puente nativo puede no estar listo todavía.
- Primer arranque en nativo: si no hay archivo, se copia lo que hubiera en `localStorage`
  y se escribe el archivo ya, sin esperar al primer cambio.
- Manda el archivo. `localStorage` queda solo como copia de rescate.
- Si el archivo no se puede leer como JSON, se guarda aparte como `spoony-danado.json`
  antes de que el primer guardado lo pise.
- Las escrituras van en cola y se agrupan: `writeFile` es asíncrono y `save()` se llama
  muchas veces seguidas; sin cola, dos escrituras pueden solaparse y dejar en el archivo
  un estado viejo.

Verificado ejecutando el bloque real contra un Capacitor falso (13 casos: navegador,
primer arranque, arranques siguientes, archivo ilegible, vacío, guardados seguidos) y con
una captura del arranque en navegador. **Queda probarlo en un dispositivo de verdad** al
montar Capacitor: que `Capacitor.registerPlugin('Filesystem')` funcione sin empaquetador y
que el archivo aparezca donde se espera.

### 1.2 "Cucharas" no se explica en ningún sitio, y la teoría no tiene crédito — hecho el 2026-09-17

Quien abre la app por primera vez veía "¿Con cuántas cucharas te levantas?" sin contexto
previo. Iba contra el principio 2 del propio proyecto (nada de metáforas sin explicar).
Además, ni Miserandino ni Toudal/Attwood aparecían en el código: usar vocabulario de la
comunidad en un producto público sin dar crédito es justo lo que destruye la confianza
(N10, editorial).

Arreglo: una guía de 10 pasos (`#tour`, `TOUR_STEPS` en `index.html`) donde cada paso
señala el elemento del que habla con un foco y un bocadillo anclado — así queda claro no
solo qué es una cuchara sino dónde está cada cosa. Los dos primeros no tienen ancla: qué
es Spoony y para qué sirve, y después qué es una cuchara, con el crédito pedido. Los ocho
restantes señalan el medidor, "He tenido un pico sensorial ahora", "Añadir tarea", "Días
tipo", "Editar cuánto cuesta cada actividad", "Check-out de hoy" y las pestañas de
Calendario y Ajustes. Una idea por paso, en lenguaje literal, sin animación ni desplazamiento suave:
el recorrido salta de sitio y solo cuando el elemento no se ve entero. Saltable en
cualquier paso ("Saltar" siempre visible, Escape también) y recuperable después desde
Ajustes → Ayuda → "Cómo funciona la app", así saltarla no pierde nada para siempre.
Guarda `state.settings.introSeen`. Un paso cuyo elemento esté oculto se cae del recorrido
en vez de señalar al vacío.

Quien ya tenía historial antes de que existiera esta guía no se la encuentra de
sorpresa: solo se muestra sin pedirlo a quien instala la app de cero (`state.days` vacío
al arrancar por primera vez tras la actualización). Fila "Acerca de" añadida en Ajustes
con los créditos, aparte de la guía.

Texto del primer paso:

> Una cuchara es una unidad de energía. Cada día tienes un número distinto; las tareas
> gastan cucharas y descansar las recupera. La idea es de Christine Miserandino (teoría
> de las cucharas) y de Maja Toudal y Tony Attwood (Energy Accounting).

Verificado con Chrome headless: primer arranque (10 pasos → check-in), usuario con
historial (no la ve), repaso desde Ajustes (vuelve a Hoy, no reabre el check-in) y una
pasada con `window.onerror` enganchado, sin errores. La atenuación cubre la pantalla
también en el paso sin ancla, para que el fondo no parezca usable cuando no responde.

### 1.3 La fase del ciclo se puede leer como predicción de fertilidad — hecho el 2026-09-20

`renderCycle()` mostraba "Fase estimada: Ovulación" a partir de un cálculo de calendario,
sin ninguna advertencia junto a la etiqueta. El único aviso vivía en el tour de Ciclo
(`CICLO_TOUR_STEPS`), que se ve una vez y es saltable, así que quien volvía a la pestaña
más adelante veía "Ovulación" desnudo. Las tiendas además revisan con lupa las apps que
tocan datos de salud.

Arreglo: aviso fijo junto al encabezado (`#cycleFaseAviso`, `index.html:591`), visible
cada vez que hay un día de ciclo calculado (mismo criterio que la propia etiqueta de
fase: `dayNum != null`), no solo en el onboarding.

```js
document.getElementById('cycleFaseAviso').hidden = dayNum == null;
```

```html
<p class="legend" id="cycleFaseAviso" hidden>No sirve para evitar ni para buscar un embarazo.</p>
```

---

## 2. Importantes

### 2.1 Los check-in saltados cuentan como respuestas — hecho el 2026-09-20

`budgetUnanswered` se escribía (`index.html:2206`, botón "Ahora no") pero no se leía en
ningún sitio. `typicalBudget()` promediaba días no contestados, y el patrón de picos
comparaba contra ellos, lo que empujaba el resultado hacia "no se nota diferencia". Un día
sin respuesta no es un dato (principio 6).

```js
// typicalBudget (1789)
.map(k => state.days[k]).filter(d => d.budget != null && !d.budgetUnanswered).map(d => d.budget);

// peakNextDayInsight (1856)
if(next && next.budget != null && !next.budgetUnanswered) acc.push(next.budget - typical);
```

### 2.2 A medianoche la app muestra el día equivocado — hecho el 2026-09-20

`#todayDate` solo se rellenaba al arrancar y nada escuchaba `visibilitychange`. En un
móvil la app vuelve del segundo plano sin reiniciarse: la fecha decía ayer, las tareas ya
eran de hoy y el check-in no aparecía.

Decisión al resolverlo: el corte de día no es medianoche sino **las 04:00**. Quien se
acuesta tarde sigue viendo "hoy" el día que empezó — a las 00:30 no le conviene un check-in
en blanco ni un medidor a cero — y solo a partir de las 04:00 se considera que ha empezado
un día nuevo. Cambiado en `todayKey()` (`index.html:1171`), de donde cuelga toda la app
(tareas, check-in, patrones, ciclo), no solo el encabezado:

```js
const todayKey = () => {
  const d = new Date();
  if(d.getHours() < 4) d.setDate(d.getDate() - 1);
  return localDateKey(d);
};
```

Y el aviso de que el día cambió mientras la app estaba en segundo plano
(`index.html:3106`), con el mismo criterio de corte al venir de `todayKey()`:

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

### 2.5 Finanzas es una pestaña fija ajena al modelo de energía — hecho el 2026-09-17

Arreglo: módulo opcional como Ciclo (`state.finEnabled`, `ensureFinanzas()` en
`index.html`), apagado por defecto para instalaciones nuevas; se activa solo para quien
ya tenía gastos apuntados, con la misma guarda propuesta arriba, para no quitarle la
pestaña a quien ya la usa (principio de predictibilidad). Ajustes tiene ahora un grupo
"Finanzas" idéntico en forma al de "Ciclo" (`#finPick`, chips Activado/Desactivado);
`applyFinUI()` muestra/oculta `#tabFin` y, si se apaga estando en esa pestaña, vuelve a
Hoy. La barra de pestañas pasa a modo compacto (`updateTabsCompact()`) solo cuando Ciclo
y Finanzas están los dos encendidos a la vez (5 pestañas); con uno solo caben holgadas.
Sigue sin resolver el € escrito a mano (deja fuera a Latinoamérica) — no era parte de
este arreglo.

Verificado con Chrome headless: instalación nueva (los dos módulos ocultos), activar
Finanzas sola (sin modo compacto), activar también Ciclo (modo compacto), navegar a la
pestaña y volver a apagarla desde Ajustes, y una carga con datos de finanzas ya
existentes pero sin el campo `finEnabled` (lo enciende sola). Sin errores de JavaScript
en ningún caso.

**Extensión del 2026-09-17**: los dos módulos ahora se pueden activar desde dentro de la
propia guía de bienvenida (`TOUR_STEPS`, pasos "Ciclo (opcional)" y "Finanzas
(opcional)"), con un control Activar/Dejar apagado dentro del bocadillo — no hace falta
salir de la guía para encenderlos. Y cada módulo tiene ahora su propia guía corta
(`CICLO_TOUR_STEPS`, 4 pasos; `FIN_TOUR_STEPS`, 3 pasos), que se abre sola la primera vez
que se entra en esa pestaña con el módulo ya activo, y se puede repasar después desde
Ajustes → Ayuda ("Cómo funciona Ciclo" / "Cómo funciona Finanzas", visibles solo con el
módulo encendido). Quien ya tenía registros de ciclo o gastos apuntados antes de este
cambio no se encuentra la guía de esa sección sin pedirla (mismo criterio que
`introSeen`). Verificado con Chrome headless: recorrido completo activando ambos módulos
desde la guía principal, entrada automática en la guía de Ciclo y de Finanzas, cierre
que no vuelve a abrirse al revisitar la pestaña, botones de repaso en Ajustes, y una
carga con datos de ciclo/finanzas ya existentes (ninguna guía se abre sola). Sin errores
de JavaScript.

### 2.6 Importar no valida el archivo — hecho el 2026-09-20

La importación sustituía el estado entero sin repetir las reparaciones que hacía
`init()`: un archivo sin `library` o `templates` (de una versión vieja, o tocado a mano)
rompía el render. Además `t.time` entraba en el HTML sin escapar en dos sitios
(`renderTasks`, `renderDaySheet`) y `t.real ?? t.est` se interpolaba directo sin pasar por
`fmtN`, así que un archivo manipulado podía ejecutar código — algo que pesa más dentro de
una app nativa con plugins.

Arreglo: extraída a `normalize(state)` (`index.html:3129`) toda la reparación que antes
solo vivía en `init()` (library con sus ids, settings con sus defaults, templates,
introSeen); ahora la llaman tanto `init()` como el handler de importar. Y en los dos
sitios donde se pintaba una tarea:

```js
const timeTag = t.time ? `<span class="task-time">${esc(t.time)}</span> ` : '';
// ...
<span class="cost">${fmtN(+(t.real ?? t.est) || 0)}
```

Verificado con Node: `esc()` neutraliza un `t.time` con `<img onerror=...>`, y
`fmtN(+(t.real ?? t.est) || 0)` reduce un `t.est` no numérico a `0` en vez de imprimirlo
tal cual; `normalize()` repara un archivo mínimo (`{ days: {...} }` sin `library` ni
`templates`) sin lanzar error.

---

## 3. Mejoras

- "Cierra cuando estés listo" (`index.html:892`) asume género → "Cierra cuando quieras".
- `PRODUCT.md` y `brief-cucharas.md` describen la pestaña "Cucharas" (ya no existe; la
  calculadora es una hoja desde Hoy), un check-in que bloquea (ya no bloquea) y no
  mencionan Finanzas. Actualizar antes de escribir la ficha de tienda a partir de ellos.
- ~~Línea de "Última copia: hace N días" en Ajustes~~ — hecho el 2026-09-20. Sin
  notificaciones ni insistencia: `renderExportInfo()` (`index.html`) lee
  `state.settings.lastExportKey`, que se escribe al pulsar Exportar. Reduce el riesgo de
  perderlo todo si el móvil se rompe o lo roban, sin montar servidor ni cuenta — se evaluó
  y descartó una sincronización con Firebase/cuenta de Google por ese mismo motivo: rompía
  la ficha de privacidad "Datos no recopilados" que es el argumento de venta actual.

---

## 4. Ruta a las tiendas

Vía elegida: **Capacitor**, que envuelve la web en una app nativa. Usa el mismo
`index.html`, así que el código de la app sigue siendo un único archivo sin compilación;
lo que se añade es la capa nativa. La PWA (manifest + service worker) queda como vía
secundaria para distribución directa: instalar una PWA en iOS lleva varios pasos poco
evidentes y eso es una barrera real para este público.

- [x] Guardado nativo en archivo (§1.1) — escrito, pendiente de probar en dispositivo.
- [x] Bienvenida con crédito a la teoría de las cucharas (§1.2).
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
