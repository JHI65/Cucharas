# Cucharas — brief de producto para diseño UX/UI

## Qué es

App móvil de organización diaria y gestión de energía para personas autistas, construida sobre la teoría de las cucharas y el *energy accounting* de Maja Toudal y Tony Attwood. La persona no planifica por tiempo disponible sino por energía disponible, que varía cada día.

Producto público, de distribución directa (no App Store). Hoy existe un prototipo funcional en HTML/JS de un solo archivo.

## A quién sirve

Adultos autistas que gestionan su día a día. Perfiles adyacentes que se benefician: TDAH, fatiga crónica, cualquiera con disfunción ejecutiva. No es una app clínica ni diagnóstica.

## Conceptos del modelo

| Concepto | Qué es |
|---|---|
| **Cuchara** | Unidad de energía. Fraccionable en medias. |
| **Presupuesto del día** | Cuántas cucharas tiene la persona hoy. Se fija cada mañana, no es fijo. |
| **Gasto** | Actividad que resta cucharas. |
| **Recarga** | Actividad que suma cucharas. Mitad del método, no una excepción. |
| **Coste real** | Lo que costó de verdad, corregido al marcar la tarea. Alimenta el aprendizaje. |
| **Tiempo de recuperación** | Cuánto se tardó en volver a la línea base tras una actividad. |
| **Check-out** | Registro nocturno de capacidad y tolerancia sensorial, 1 a 5. |
| **Día tipo** | Plantilla de tareas reutilizable. |

## Principios de diseño no negociables

Salen de la literatura de accesibilidad para usuarios autistas (GAIA, AutismGuide, COGA) y de la investigación sobre burnout autista.

1. **Predictibilidad.** La navegación y la disposición no se mueven entre versiones. Mover una pestaña tiene un coste real para este usuario.
2. **Lenguaje literal.** Sin ironía, sin metáforas sin explicar, sin iconos sin etiqueta.
3. **Cero mecánicas de vergüenza.** Nada de rachas, insignias, celebraciones ni "has fallado". Ningún patrón oscuro ni presión gamificada.
4. **Control sensorial.** Sin animaciones, sin autoplay, sin sonidos. Contraste bajo por defecto y paleta configurable.
5. **Puntuar, no etiquetar.** La alexitimia hace que pedir "¿cómo te sientes?" falle. Se pide una nota del 1 al 5.
6. **Baja carga cognitiva.** Una decisión por pantalla. Nada de formularios largos.
7. **La app como prótesis de interocepción.** Muchas personas autistas no notan el agotamiento hasta que es tarde. El valor del producto está en que los datos lo vean antes que la persona.

## Estructura actual

Cuatro pestañas con etiqueta de texto, siempre visibles.

**Hoy** — la pantalla principal.
- Medidor de cucharas: fila de cucharas que se vacían, más "Gastadas 6 · recuperadas 2".
- Lista de tareas del día. Al marcar una se despliega el ajuste de coste real y la escala de recuperación.
- Botón de check-out al final.

**Cucharas** — la calculadora. Dos secciones: lo que gasta y lo que recarga. Cada actividad muestra lo que estimabas frente a lo que gastas de verdad, y su tiempo de recuperación.

**Calendario** — rejilla mensual con la carga de cada día en puntos. Al tocar un día se abre su ficha: previsión, tareas, nota. Debajo, tarjeta de patrones con la evolución de capacidad y tolerancia sensorial.

**Ajustes** — tope de cucharas, exportar, importar, borrar.

## Flujos clave

1. **Check-in matinal.** Al abrir por primera vez cada día: "¿con cuántas cucharas te levantas?", deslizador más cuatro atajos. Bloquea el resto hasta responder.
2. **Marcar una tarea.** Un toque en el círculo. Después, dos ajustes opcionales en línea: coste real y tiempo de recuperación.
3. **Planificar a futuro.** Desde el calendario, añadir tareas a un día concreto, con repetición (solo ese día, L-V, diario, días sueltos) durante N semanas.
4. **Check-out nocturno.** Dos escalas de 1 a 5 más una nota corta.

## Sistema visual actual

- Paleta rosa pastel clara. Fondo `#FBF2F3`, superficie `#FFF8F9`, línea `#EDD5D9`, texto `#4B3A3F`.
- Acento rosa oscuro `#B36A7C`, cuchara `#E2A6B3`, recarga verde `#6F9D88`, aviso terracota `#A7623F`.
- Tipografía del sistema, sin fuentes externas.
- Radio 14 px, una columna, ancho máximo 520 px.
- Todo por variables CSS en `:root`.

## Restricciones técnicas

- Un solo archivo HTML. Sin framework, sin build.
- Datos solo en el dispositivo, sin cuenta ni servidor. Exportables a JSON.
- Pendiente: manifest, service worker y dominio para que sea instalable.

## Qué necesito del diseño

1. **Jerarquía de la pantalla Hoy.** Compiten el medidor, las tareas y el check-out. ¿Cuál manda?
2. **Cómo representar las cucharas.** Hoy son una fila de glifos que se vacía. ¿Aguanta con 14 cucharas y media? ¿Hay algo mejor que una fila?
3. **El aviso de día cargado sin que parezca un reproche.** El color de alerta es lo más delicado de toda la interfaz.
4. **La tarjeta de patrones.** Ahora mismo es texto. Es el dato más valioso de la app y el peor presentado.
5. **Sistema de iconos.** Todos necesitan etiqueta. ¿Merece la pena que las actividades tengan icono propio?
6. **Estados vacíos.** La app no sirve de nada hasta que hay dos semanas de datos. Cómo sostener ese hueco.
7. **Variantes de paleta.** Al menos una alternativa de alto contraste, manteniendo los mismos tokens.
