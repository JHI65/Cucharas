---
name: Spoony
description: Organización diaria por energía, no por tiempo, para personas autistas y perfiles de disfunción ejecutiva.
colors:
  cotton-pink: "#FBF2F3"
  warm-white: "#FFF8F9"
  misty-pink: "#ECD2D8"
  dusty-pink: "#AD7C88"
  plum-brown: "#4B3A3F"
  muted-mauve: "#7A6167"
  spoon-pink: "#B87385"
  soft-plum: "#9E5266"
  warm-terracotta: "#9C5A39"
  moss-green: "#4F7566"
  hc-cotton-pink: "#FFF7F8"
  hc-warm-white: "#FFFFFF"
  hc-misty-pink: "#E9BEC9"
  hc-dusty-pink: "#A8838D"
  hc-plum-brown: "#241A1D"
  hc-muted-mauve: "#5A464B"
  hc-spoon-pink: "#96455C"
  hc-soft-plum: "#7E3550"
  hc-warm-terracotta: "#7A3F22"
  hc-moss-green: "#2F5A46"
typography:
  display:
    fontFamily: "system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif"
    fontSize: "32px"
    fontWeight: 700
    lineHeight: 1.1
    letterSpacing: "normal"
  headline:
    fontFamily: "system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif"
    fontSize: "27px"
    fontWeight: 400
    lineHeight: 1.2
    letterSpacing: "-0.01em"
  sheet-title:
    fontFamily: "system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif"
    fontSize: "21px"
    fontWeight: 400
    lineHeight: 1.3
    letterSpacing: "normal"
  count:
    fontFamily: "system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif"
    fontSize: "20px"
    fontWeight: 700
    lineHeight: 1.3
    letterSpacing: "normal"
  title:
    fontFamily: "system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif"
    fontSize: "18px"
    fontWeight: 400
    lineHeight: 1.3
    letterSpacing: "normal"
  body:
    fontFamily: "system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif"
    fontSize: "17px"
    fontWeight: 400
    lineHeight: 1.5
    letterSpacing: "normal"
  action:
    fontFamily: "system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif"
    fontSize: "16px"
    fontWeight: 400
    lineHeight: 1.4
    letterSpacing: "normal"
  control:
    fontFamily: "system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif"
    fontSize: "15px"
    fontWeight: 400
    lineHeight: 1.4
    letterSpacing: "normal"
  label:
    fontFamily: "system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif"
    fontSize: "14px"
    fontWeight: 400
    lineHeight: 1.4
    letterSpacing: "normal"
  meta:
    fontFamily: "system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif"
    fontSize: "13px"
    fontWeight: 400
    lineHeight: 1.4
    letterSpacing: "normal"
  axis:
    fontFamily: "system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif"
    fontSize: "11px"
    fontWeight: 400
    lineHeight: 1.2
    letterSpacing: "normal"
rounded:
  hair: "1px"
  focus: "6px"
  stepper: "11px"
  control: "13px"
  cell: "14px"
  row: "15px"
  block: "18px"
  card: "20px"
  nav: "26px"
  pill: "999px"
cornerShape: squircle
spacing:
  page: "18px"
components:
  button-primary:
    backgroundColor: "{colors.soft-plum}"
    textColor: "{colors.warm-white}"
    rounded: "{rounded.control}"
    padding: "15px"
  button-secondary:
    backgroundColor: "{colors.warm-white}"
    textColor: "{colors.plum-brown}"
    rounded: "{rounded.control}"
    padding: "10px 15px"
  chip:
    backgroundColor: "{colors.warm-white}"
    textColor: "{colors.plum-brown}"
    rounded: "{rounded.pill}"
    padding: "9px 14px"
  chip-active:
    backgroundColor: "{colors.soft-plum}"
    textColor: "{colors.warm-white}"
    rounded: "{rounded.pill}"
    padding: "9px 14px"
---

# Design System: Spoony

## Overview

**Creative North Star: "La Sala de Estar"**

Spoony se ve como un espacio doméstico, no como una herramienta de productividad ni un panel clínico. La superficie es casi silenciosa: color pastel cálido, bordes finos de 1px, sin sombra ni relieve, sin nada que compita por atención. El sistema existe para que la persona pueda mirarlo sin esfuerzo el día entero — cada elemento tiene una sola posición, un solo color de estado, y no cambia de sitio de una sesión a otra.

La calidez viene del color (rosas y ciruela suaves), no del gesto. No hay confeti, no hay barra de progreso festiva: el registro es honesto sobre cómo ha ido el día, incluso cuando ha ido mal, sin dramatizarlo ni celebrarlo de más. Esto excluye explícitamente dos mundos visuales: la estética clínica/médica (fría, gris, con iconografía de diagnóstico) y la estética de gamificación tipo Duolingo (rachas, insignias, refuerzo positivo ruidoso).

> **Excepción documentada (2026-09-16):** el usuario pidió explícitamente un logo de mascota (cuchara 3D antropomorfizada, render pulido, azul fuera de la paleta) para la marca "Spoony", pese a que contradice la frase anterior y la Regla de la Quietud. Se usa tal cual, solo como logo/favicon — no se extiende el estilo de mascota al resto de la interfaz.

Los componentes son suaves y silenciosos: superficie casi plana, borde fino como único límite, radio de esquina generoso pero discreto (14px en tarjetas). Un componente no debe "llamar" — debe estar ahí, legible, y desaparecer cuando no hace falta mirarlo.

**Quietud no es lo mismo que insipidez.** Sin movimiento, el carácter tiene que venir de otros tres sitios: color con convicción (el acento no es tímido donde aparece — botón primario, cuchara llena, pestaña activa — aunque sea el único), una forma propia y reconocible (la cuchara como glifo, no como icono genérico de "energía"), y contraste tipográfico marcado entre tamaños (Display 32px/700 frente a Label 14px/400 es un salto grande, y es a propósito). Si el sistema se siente soso, la corrección nunca es añadir movimiento — es subir la convicción del color o la nitidez de la forma en el punto exacto donde se necesita, sin tocar la Regla de la Quietud.

**Key Characteristics:**
- Paleta pastel cálida y doméstica, nunca clínica ni corporativa
- Superficies planas: borde de 1px es la única señal de profundidad
- Un color de acento (ciruela) usado con moderación para lo interactivo
- Radio de esquina consistente y generoso, sin esquinas vivas
- Tipografía del sistema únicamente, sin peso decorativo

## Colors

Paleta pastel cálida de un solo acento, con roles de estado (aviso, recarga) separados del acento interactivo para que nunca se confundan.

Todos los valores por defecto cumplen WCAG AA para su uso (4,5:1 en texto, 3:1 en marcas gráficas y bordes de control, verificado con cálculo real de luminancia relativa, no a ojo). La paleta original era más clara y no llegaba: el texto secundario se quedaba en 4,16:1, el acento en 3,80:1, y el borde en 1,95:1 — un borde por debajo de 3:1 falla incluso siendo el único método de separación entre superficies, precisamente el caso de este sistema. Se oscurecieron lo justo para pasar el umbral conservando el carácter pastel — "contraste bajo" significa suave, no ilegible.

### Primary
- **Ciruela Suave** (`#9E5266`): el único acento interactivo — botones primarios, chips activos, pestaña activa, foco de teclado, enlaces, iconos de control. Se usa con moderación; el resto de la interfaz es neutro.

### Secondary
- **Verde Musgo** (`#4F7566`): recarga. Marca todo lo que suma cucharas — coste en verde cuando una actividad recarga en vez de gastar, y la serie de tolerancia sensorial en la gráfica de patrones.
- **Terracota Templada** (`#9C5A39`): aviso. Reservado para "día por encima de tu media" y "por debajo de cero" — el único naranja del sistema, y por eso mismo debe seguir siendo raro.

### Neutral
- **Rosa Algodón** (`#FBF2F3`): fondo de página.
- **Blanco Cálido** (`#FFF8F9`): superficie de tarjetas, filas de tarea, botones — el "papel" sobre el fondo.
- **Rosa Niebla** (`#ECD2D8`): superficie secundaria — panel de ajuste desplegado bajo una tarea, círculo de check sin marcar. Subida desde un tono casi idéntico a Blanco Cálido (1,16:1, indistinguible) a 1,36:1: suficiente para leerse como una superficie propia sin volverse un bloque de color que compita con el resto de la pantalla.
- **Rosa Polvo** (`#AD7C88`): borde. Único método de separación entre superficies; no hay sombra. Subido desde un rosa que no llegaba a 2:1 a 3,17:1 sobre fondo y 3,33:1 sobre superficie — cumple el 3:1 de WCAG 1.4.11 para límites de componente, que aquí no es opcional: el borde no es decoración, es la única señal estructural del sistema.
- **Marrón Ciruela** (`#4B3A3F`): texto principal.
- **Malva Apagado** (`#7A6167`): texto secundario — fecha, metadatos, hints, etiquetas de escala.
- **Rosa Cuchara** (`#B87385`): la cuchara. Relleno cuando está llena, contorno cuando está gastada, marcas de carga del calendario, serie de capacidad en la gráfica, y el aro del círculo de marcar tarea.

### Variante de alto contraste
Los mismos tokens con los mismos roles, remapeados a valores de mayor separación (prefijo `hc-` en el frontmatter, `:root[data-contrast="alto"]` en el código). No es una paleta distinta: es la misma paleta subida de intensidad, para quien necesite más definición. Texto principal a 16,9:1, secundario a 8,8:1, bordes de control a 3,4:1. Se elige en Ajustes y sobrevive al borrado de datos, porque es una preferencia de accesibilidad, no un dato.

### Named Rules
**La Regla del Acento Único.** Ciruela Suave es el único color que significa "interactivo/activo" en todo el sistema. Verde y terracota nunca son clicables — son estado, no acción. Si un color de estado empieza a usarse en un botón, se ha roto la regla.

**La Regla del Color Que No Va Solo.** Ningún estado se comunica solo por color. El día cargado cambia de color **y** de forma de marca (raya alta en vez de punto); la cuchara gastada cambia a contorno **y** conserva la silueta; las dos series de la gráfica se distinguen por círculo frente a cuadrado. Si un estado nuevo solo se distingue por tono, está sin terminar.

## Typography

**Body Font:** system-ui (con -apple-system, "Segoe UI", Roboto, "Helvetica Neue", sans-serif)

**Character:** Una sola familia tipográfica, la del sistema operativo, sin pesos decorativos ni pares display/body distintos. La jerarquía se construye por tamaño, no por personalidad tipográfica — coherente con el principio de "sin sorpresas" del producto.

### Hierarchy
Diez pasos, cada uno con un trabajo. La escala se consolidó: había catorce tamaños, con cuatro pares separados por medio píxel (15,5 / 15 / 14,5 / 14 / 13,5 / 12,5) que no eran jerarquía sino deriva.

- **Display** (700, 32px, 1.1): el número grande de cucharas en las hojas modales (check-in matinal, ajuste de coste). El momento de "esto es lo importante ahora mismo".
- **Headline** (400, 27px, 1.2, letter-spacing -0.01em): título de pantalla ("Hoy", "Cuánto cuesta", "Calendario", "Ajustes"). Uno por pantalla, siempre en la misma posición.
- **Sheet title** (400, 21px, 1.3): título de hoja modal.
- **Count** (700, 20px): las cucharas que quedan, en el medidor de Hoy.
- **Title** (400, 18px, 1.3): cabecera de sección ("Tareas", "Patrones").
- **Body** (400, 17px, 1.5): texto de tarea, contenido general. Es también el tamaño base del `body`.
- **Action** (400, 16px): texto de botón de bloque ("Añadir tarea", "Check-out de hoy").
- **Control** (400, 15px): botones pequeños, chips, celdas de calendario, coste de una tarea.
- **Label** (400, 14px, color Malva Apagado): etiquetas de campo, texto secundario de tarjeta, hints.
- **Meta** (400, 13px, color Malva Apagado): metadatos de tarea, leyenda del calendario, etiquetas de pestaña.
- **Axis** (400, 11px, color Malva Apagado): solo los números de eje de la gráfica de patrones.

### Named Rules
**La Regla del Peso Único.** La negrita existe en exactamente tres sitios: el número grande de las hojas modales, el recuento de cucharas del medidor y la etiqueta de la pestaña activa. Ni uno más. En los tres el peso carga información (lo importante ahora, el estado del día, dónde estás), nunca énfasis decorativo.

### Named Rules (cabeceras)
**La Regla del Título Primero.** Ningún texto se sienta encima del `<h1>` de pantalla — eso es un kicker/eyebrow, y está prohibido sin excepción. El título va primero; el texto secundario (fecha, instrucción, nota de confianza), si existe, va **después**, como `.sub`. Donde ese texto secundario era un rótulo puramente redundante con la pestaña ya activa (como "Calculadora" sobre "Cuánto cuesta"), se elimina en vez de reordenarse.

## Layout

Columna única, ancho máximo 520px centrado, padding lateral de 18px (`--pad`). Sin grid multi-columna salvo la rejilla fija de 7 columnas del calendario. El ritmo vertical entre bloques usa pasos de 8-14px entre elementos relacionados (tarea con tarea, chip con chip) y 16-26px entre bloques distintos (medidor → sección de tareas). La barra de pestañas inferior es fija (`position:fixed`) y respeta el área segura del dispositivo (`env(safe-area-inset-bottom)`); el contenido reserva 96px de espacio inferior para no quedar tapado por ella.

## Elevation & Depth

> **Excepción documentada (2026-09-16):** el usuario levantó explícitamente la Regla de la Quietud para permitir la barra de pestañas flotante de cristal. El documento pedía confirmarlo antes de tocarlo y está confirmado. Alcance de lo permitido: sombra proyectada bajo la barra flotante y fundidos de color en los cambios de estado (180ms). Sigue vetado todo lo que se desplace o rebote, y `prefers-reduced-motion` se respeta como suelo — es WCAG, no parte de esta regla.

Fuera de esa excepción el sistema sigue siendo plano: sin `box-shadow`, sin `transition` ni `animation` en ninguna otra regla. La única señal de profundidad es el borde de 1px (Rosa Polvo) entre una superficie y otra, y el cambio de fondo (Blanco Cálido sobre Rosa Algodón). Esto corresponde al principio de "control sensorial" del producto: el movimiento en pantalla consume atención y puede resultar desregulador para el usuario objetivo.

Los cambios de estado (pulsar un chip, marcar una tarea, pestaña activa) son instantáneos — cambio directo de color de fondo/borde, sin fundido ni desplazamiento. Esto no es una limitación temporal del prototipo: es la regla, con una única salvedad admitida — un cambio de estado instantáneo (color o borde, nunca movimiento) puede añadirse donde haga falta, pero sombra, transición animada y `animation` siguen prohibidas sin excepción.

### Named Rules
**La Regla de la Quietud** *(levantada parcialmente el 2026-09-16, ver arriba)*. Nada se desliza ni se desplaza. Los cambios de estado pueden fundir color durante 180ms, pero nada cambia de posición ni de tamaño, y la única sombra del sistema es la de la barra flotante. Si una revisión de diseño quiere ampliar esto, sigue siendo un conflicto con un principio de accesibilidad del producto y no solo con una preferencia visual — confirmar con el usuario antes de tocarlo.

**La Regla de la Convicción.** La quietud no es la única palanca de personalidad del sistema, es la más restringida. Cuando algo se sienta soso, la respuesta correcta es subir la convicción del color y la forma en ese punto concreto (acento más presente, glifo más propio, salto tipográfico más marcado) — nunca añadir movimiento para compensar. Ver también la variante de alto contraste pendiente (brief, punto 7): es la palanca reservada para quien necesite más intensidad visual sin tocar esta regla.

## Shapes

**La esquina es superelíptica, no circular** (`corner-shape: squircle` sobre el `border-radius`). La superelipse entra en la curva antes y sale después, de modo que el borde no tiene el corte seco del arco circular. Donde el navegador no conoce `corner-shape` la propiedad se ignora y queda el radio circular de siempre: no hay degradación funcional, solo una esquina menos.

Cinco pasos de uso general, cada uno con un trabajo: **control** (13px) en botones pequeños y campos, **cell** (14px) en celdas de calendario y escalas, **row** (15px) en filas dentro de un grupo, **block** (18px) en botones de bloque, estados vacíos y `textarea`, y **card** (20px) en tarjetas y contenedores de grupo. Aparte quedan **pill** (999px) para chips y píldoras, **nav** (26px) para la barra de pestañas flotante y **stepper** (11px) para los botones de paso. Los radios subieron respecto a la escala anterior porque la superelipse lee más ceñida al mismo número. La hoja modal (`dialog`) redondea solo las dos esquinas superiores, ya que nace pegada al borde inferior de la pantalla.

### Named Rules
**La Regla Concéntrica.** Cuando una forma redondeada vive dentro de otra, el radio de dentro es el de fuera menos el padding que los separa: un grupo de 20px con 5px de padding lleva filas de 15px. Así las dos curvas corren paralelas en vez de cruzarse. Si un radio interior se elige "a ojo", se ha roto la regla.

El borde discontinuo (`dashed`) es vocabulario, no decoración: significa "aquí no hay nada todavía" o "esto añade algo". Lo llevan los botones de añadir y los estados vacíos, y nada más.

## Components

### Buttons
- **Shape:** radio 10px (`{rounded.control}`); los botones de bloque usan 12px o 14px según el contenedor
- **Primary:** fondo Ciruela Suave, texto Blanco Cálido, padding 15px — reservado para la acción principal de cada hoja modal ("Empezar el día", "Guardar")
- **Secondary:** fondo Blanco Cálido, borde 1px Rosa Polvo, texto Marrón Ciruela — acción secundaria o neutra (exportar, botones de paso +/−)
- **Add (patrón distintivo):** mismo fondo que Secondary pero con borde discontinuo (`dashed`) en vez de sólido, texto Ciruela Suave — señala específicamente "esto añade algo nuevo", distinto de cualquier otra acción
- **Closer:** borde sólido, texto Ciruela Suave, ancho completo — el cierre del día; ver *Cierre del día*
- **Warn:** variante de texto en Terracota Templada sobre el mismo fondo Secondary — solo para "Borrar todo"
- **Estados:** sin hover ni transición; el único cambio de estado visual es `aria-pressed`/`aria-current` cambiando fondo y color de golpe

### Chips
- **Style:** fondo Blanco Cálido, borde 1px Rosa Polvo, radio 999px (cápsula completa)
- **State:** `aria-pressed="true"` invierte a fondo Ciruela Suave y texto Blanco Cálido, sin transición

### Grupo (contenedor de filas)
Las filas relacionadas (tareas, actividades de la biblioteca, ajustes) no son tarjetas sueltas separadas 9px: viven en un contenedor único de radio 20px y 5px de padding, con separadores de 1px a **100% de Rosa Polvo** —3,33:1 sobre Blanco Cálido, porque el separador es la única señal estructural y le aplica el 3:1 de WCAG 1.4.11— sangrados hasta donde empieza el texto. Un borde en vez de seis. Los estados vacíos quedan **fuera** del grupo: su borde discontinuo ya es su propio contenedor.

### Cards / Containers
- **Corner Style:** radio 20px
- **Background:** Blanco Cálido sobre fondo Rosa Algodón
- **Shadow Strategy:** ninguna — ver Elevation & Depth
- **Border:** 1px sólido Rosa Polvo (discontinuo en estados "vacío" o "añadir")
- **Internal Padding:** 13-18px
- **Texto sobre Rosa Niebla:** Marrón Ciruela, nunca Malva Apagado. Malva sobre Rosa Niebla da 3,96:1 y el panel de ajuste es texto de 14px; Marrón Ciruela lo sube a 7,48:1.

### Inputs / Fields
- **Style:** fondo Blanco Cálido, borde 1px Rosa Polvo, radio 10px, padding 13px
- **Focus:** contorno de 3px en Ciruela Suave con 2px de separación (`outline`), nunca cambio de fondo — es la única señal de foco en todo el sistema, y debe mantenerse visible siempre (nunca `outline:none`)
- **Error / Disabled:** no implementado en el prototipo actual

### Navigation
- **Style:** barra **flotante** de 4 pestañas con icono + etiqueta de texto, siempre visibles, nunca solo icono. Separada 14px de los bordes y del inferior (sumado a `env(safe-area-inset-bottom)`), radio 26px, pastilla interior 19px por la Regla Concéntrica. El contenido pasa por debajo.
- **Cristal:** fondo Blanco Cálido al 70% con `backdrop-filter: blur(20px) saturate(1.4)` y sombra proyectada. Es la única superficie translúcida del sistema y la única sombra.
- **Etiqueta inactiva en Marrón Ciruela, no Malva Apagado.** Sobre un fondo variable el contraste deja de ser fijo: en Malva el peor caso cae a 3,14:1, y en Marrón Ciruela es 5,92:1. No es una preferencia, es la condición que hace legal el cristal.
- **Pestaña activa:** relleno Ciruela Suave con texto Blanco Cálido (5,20:1) y peso 700. Al ser opaca, su contraste no depende de lo que pase por debajo.
- **El cristal se apaga solo** en tres casos: variante de alto contraste (existe para quien necesita más definición, y un fondo variable la contradice), `prefers-reduced-transparency: reduce`, y donde no haya `backdrop-filter` — translúcido sin desenfocar es peor que opaco.

### Iconos
Todos dibujados como SVG propio, trazo 1,7, esquinas redondeadas, 18px en controles y 21px en la barra de pestañas. Ningún glifo Unicode hace de icono: `−`, `+`, `×`, `‹`, `›` son dibujos, no caracteres. Ningún icono va sin etiqueta de texto o `aria-label`. No hay iconos por actividad y no debe haberlos sin una necesidad demostrada: una metáfora visual mal entendida cuesta más que leer una palabra.

### Spoon Meter (componente insignia)
El componente más distintivo del sistema, y el único que representa el estado del día de un vistazo.

- **Llena:** silueta de cuchara rellena en Rosa Cuchara. **Gastada:** la misma silueta en contorno (trazo 1,8), sin relleno. **Media:** contorno con la mitad izquierda rellena.
- La diferencia entre llena y gastada es **de forma, no de color**: el relleno claro anterior se distinguía del lleno a 1,61:1, es decir, no se distinguía. Relleno frente a contorno se lee siempre, también con baja visión o daltonismo.
- **Agrupadas de cinco**, con separación mayor entre grupos (17px) que dentro (6px). Una fila continua deja de contarse de un vistazo pasadas ocho cucharas; en grupos, 14 son "cinco, cinco y cuatro" sin contar una por una. El presupuesto llega a 24.
- Debajo, el recuento en texto y el desglose ("Gastadas 7,5 · recuperadas 1"). El número siempre acompaña a la forma: nunca hay que contar cucharas para saber cuántas quedan.

### Task Row (componente insignia)
Círculo de marcado (26px, aro de 2px en Rosa Cuchara, se rellena de Ciruela Suave con la marca al completar) + nombre de tarea + coste en cucharas. Al marcar, despliega en línea (aparición instantánea, sin animación) un panel Rosa Niebla con el ajuste de coste real y la escala de recuperación — nunca en una pantalla o modal aparte, para mantener visible el contexto de la tarea mientras se corrige. La tarea hecha tacha el nombre y rellena el círculo de marcado; **no** cambia de fondo, porque dentro de un grupo Rosa Algodón sobre Blanco Cálido son 1,05:1, es decir, invisible. Los dos signos que quedan son de forma, no de tono, que es justo lo que pide La Regla del Color Que No Va Solo.

### Cierre del día
El check-out no es un "añadir": es el cierre. Botón de bloque de borde **sólido** (frente al discontinuo de "Añadir tarea"), separado por 30px del bloque de tareas, con una línea debajo que explica qué es y para qué sirve mientras no se haya hecho. Una vez hecho, el botón enuncia el resultado ("Check-out hecho · capacidad 3 de 5"), pasa a texto secundario y la explicación desaparece.

### Aviso de día cargado
Una frase, no una alarma. Texto en Terracota Templada dentro del medidor, sin icono, sin recuadro, sin signos de exclamación: dice el hecho y los números ("Lo apuntado para hoy suma 15,5 y tienes 14"). Nunca valora ni recomienda. Prohibido el triángulo de advertencia y cualquier iconografía de urgencia.

### Gráfica de patrones
Dos series de 1 a 5 sobre los últimos 14 check-out: capacidad (línea Rosa Cuchara, marca circular) y tolerancia sensorial (línea Verde Musgo, marca cuadrada). Rejilla en 1, 3 y 5 con sus números; fechas en los dos extremos del eje. Debajo, cada serie repetida en texto con su media explícita y la comparación con el periodo anterior — **la forma nunca va sola, el número siempre está escrito**. Es el bloque focal de Calendario porque es el dato más valioso del producto.

### Celda de calendario
Número del día más las marcas de carga (una por cada dos cucharas, máximo cinco). Día normal: puntos redondos en Rosa Cuchara. Día por encima de tu media: rayas altas en Terracota Templada — cambia la forma además del color, y la leyenda lo explica con palabras. Hoy lleva aro de 2px en Ciruela Suave.

### Estados vacíos
Borde discontinuo, texto centrado, y siempre la misma estructura: qué falta y qué hacer, sin ánimo ni reproche. El de patrones es el más delicado, porque el hueco dura dos semanas: dice cuántos check-out hacen falta y la fecha concreta a partir de la cual habrá tendencia. Sin barra de progreso y sin contador de días — eso sería una racha, y las rachas están prohibidas.

## Do's and Don'ts

### Do:
- **Do** usar Ciruela Suave únicamente para lo interactivo/activo — La Regla del Acento Único.
- **Do** mantener cambios de estado instantáneos: color o borde, nunca animación ni sombra — La Regla de la Quietud.
- **Do** duplicar toda señal de color con una de forma — La Regla del Color Que No Va Solo.
- **Do** escribir el número junto a cualquier representación gráfica: la cuchara lleva su recuento, la gráfica lleva sus medias.
- **Do** etiquetar todo icono con texto; ningún icono va solo, ni siquiera en la barra de pestañas.
- **Do** mantener el `outline` de foco de 3px visible en todo elemento interactivo — es la única señal de foco del sistema.
- **Do** usar el borde discontinuo (`dashed`) exclusivamente para "añadir/vacío", nunca como decoración.
- **Do** tematizar también lo que pinta el navegador: selección de texto, cursor de escritura, barra de desplazamiento, `accent-color` y cifras tabulares en todo dato numérico.
- **Do** comprobar el contraste con números antes de dar por buena una paleta: 4,5:1 en texto, 3:1 en marcas y bordes de control.

### Don't:
- **Don't** añadir `box-shadow` fuera de la barra flotante, ni `transition` que desplace o redimensione, ni `animation` — rompe un principio de accesibilidad del producto, no solo una preferencia visual. Los fundidos de color de 180ms sí están permitidos desde la excepción del 2026-09-16.
- **Don't** elegir un radio interior a ojo: sale del exterior menos el padding — La Regla Concéntrica.
- **Don't** poner texto sobre una superficie translúcida sin calcular el peor caso: el contraste deja de ser fijo en cuanto el fondo se mueve.
- **Don't** introducir un segundo color de acento interactivo; Verde Musgo y Terracota Templada son solo estado.
- **Don't** usar iconos sin etiqueta de texto, ni metáforas visuales sin explicar.
- **Don't** introducir mecánicas de gamificación (rachas, insignias, confeti, mascotas) ni estética clínica/médica — ambas son anti-referencia explícita del sistema.
- **Don't** mover la posición de una pestaña, sección o control entre versiones sin que sea estrictamente necesario — la predictibilidad es un requisito de accesibilidad, no un lujo.
- **Don't** distinguir dos estados solo por tono, ni dejar una forma sin su número al lado.
- **Don't** usar iconografía de urgencia (triángulos, exclamaciones) en los avisos: el aviso es una frase con datos, no una alarma.
- **Don't** añadir tamaños de letra intermedios: la escala tiene diez pasos con un trabajo cada uno, y medio píxel de diferencia no es jerarquía.
