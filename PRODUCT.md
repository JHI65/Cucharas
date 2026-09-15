# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Stack

Un solo archivo HTML, sin framework y sin build (`index.html`). Restricción deliberada, no una etapa temporal a resolver: no hay plan de introducir un framework o un paso de compilación. Pendiente para hacerla instalable: manifest, service worker y dominio (PWA).

## Users

Adultos autistas que gestionan su día a día. Perfiles adyacentes que se benefician del mismo modelo: TDAH, fatiga crónica y, en general, cualquier persona con disfunción ejecutiva. No es una app clínica ni diagnóstica.

## Product Purpose

App de organización diaria y gestión de energía basada en la teoría de las cucharas (*spoon theory*) y el *energy accounting* de Maja Toudal y Tony Attwood. La persona no planifica por tiempo disponible sino por energía disponible, que varía cada día. Éxito significa que la persona detecta el agotamiento antes de llegar a él, en lugar de después.

## Positioning

Planifica por energía, no por tiempo: la diferencia estructural frente a cualquier gestor de tareas o calendario convencional. El valor central no es la lista de tareas sino la prótesis de interocepción — muchas personas autistas no notan el agotamiento hasta que es tarde, y los datos de la app lo detectan antes que la persona. Producto público de distribución directa (no App Store).

## Operating Context

- **Check-in matinal**: al abrir la app por primera vez cada día, se pregunta cuántas cucharas tiene la persona hoy (deslizador + cuatro atajos); bloquea el resto de la app hasta responder.
- **Marcar una tarea**: un toque en el círculo despliega dos ajustes opcionales en línea — coste real y tiempo de recuperación.
- **Planificar a futuro**: desde el calendario, añadir tareas a un día concreto con repetición (solo ese día, L-V, diario, días sueltos) durante N semanas.
- **Check-out nocturno**: dos escalas de 1 a 5 (capacidad y tolerancia sensorial) más una nota corta.
- Estructura actual de cuatro pestañas con etiqueta de texto, siempre visibles: Hoy, Cucharas (calculadora de gasto/recarga), Calendario (carga mensual y patrones), Ajustes.

## Capabilities and Constraints

- Datos solo en el dispositivo, sin cuenta ni servidor; exportables/importables en JSON.
- Un solo archivo HTML, sin framework ni build (ver Stack).
- Pendiente de hacerse instalable como PWA (manifest, service worker, dominio) — no resuelto todavía.
- Principios de diseño no negociables, derivados de literatura de accesibilidad para autismo (GAIA, AutismGuide, COGA) y de investigación sobre burnout autista — ver Accessibility & Inclusion.
- Prototipo funcional en `index.html` implementa ya las cuatro pestañas y los cuatro flujos descritos arriba.

## Brand Commitments

Nombre del producto: **Cucharas**, asentado.

## Evidence on Hand

Prototipo funcional de un solo archivo HTML/JS (`index.html`) que implementa las cuatro pestañas y los cuatro flujos clave. No hay investigación de usuarios, testimonios, casos de estudio ni prensa: no inventar ninguno de estos en trabajo futuro.

## Product Principles

1. **La energía, no el tiempo, es la unidad de planificación.** Todo el modelo (presupuesto, gasto, recarga, coste real, tiempo de recuperación) gira en torno a cucharas, no a horas.
2. **Predictibilidad y consistencia son requisitos de accesibilidad, no preferencia estética.** La navegación y la disposición no cambian entre versiones; mover algo tiene un coste real para este usuario.
3. **Cero mecánicas de vergüenza o gamificación.** Nada de rachas, insignias, celebraciones ni "has fallado"; ningún patrón oscuro ni presión.
4. **El valor central es la prótesis de interocepción.** El producto vale por detectar patrones de agotamiento antes que la propia persona, no por la lista de tareas en sí.
5. **Privacidad por diseño.** Todo el dato vive en el dispositivo; sin cuenta, sin servidor, exportable por la propia persona.

## Accessibility & Inclusion

Estándar doble, explícitamente ambos:

1. **Los 7 principios no negociables del brief**, derivados de GAIA, AutismGuide, COGA e investigación sobre burnout autista: predictibilidad; lenguaje literal (sin ironía, sin metáforas sin explicar, sin iconos sin etiqueta); cero mecánicas de vergüenza; control sensorial (sin animaciones, sin autoplay, sin sonido, contraste bajo por defecto y paleta configurable); puntuar en vez de etiquetar (escalas 1–5 en lugar de preguntas abiertas de estado emocional, por la alexitimia); baja carga cognitiva (una decisión por pantalla, sin formularios largos); la app como prótesis de interocepción.
2. **WCAG 2.1 AA** como línea base formal adicional, confirmada por el usuario — no sustituye a los principios anteriores, se suma a ellos.
