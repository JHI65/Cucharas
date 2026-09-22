# DESIGN_LOG — Spoony

Registro vivo de decisiones. Claude lo lee al empezar cada sesión con la skill `autism-app-design` y lo actualiza solo con decisiones tomadas por ti.

## Ficha
- **Qué hace (una frase literal):** Organiza el día por energía disponible (cucharas), no por horas, para adultos autistas y perfiles cercanos (TDAH, fatiga crónica, disfunción ejecutiva).
- **Para quién exactamente:** Adultos autistas (y perfiles adyacentes). No clínica, no diagnóstica. Español e inglés. iOS y Android (Capacitor sobre un único `index.html`), más versión web/PWA secundaria.
- **Qué NO es:** No es una app clínica ni diagnóstica. No hace seguimiento para terceros (sin dashboards de cuidadores/familiares).
- **Fase actual:** Publicada / en camino a App Store y Google Play.
- **Modelo de datos y privacidad:** Local por defecto (archivo en el dispositivo, sin servidor). Cuenta opcional con copia en la nube (Supabase, Frankfurt) que sincroniza entre dispositivos. Export/import JSON siempre disponible.
- **Modelo de negocio:** Freemium. Núcleo local (tareas, cucharas, check-in/check-out, pico sensorial, espacio de calma, módulo de Ciclo, accesibilidad/sensorial, export/import) gratis siempre. De pago: sync en la nube entre dispositivos; pestaña Patrones; Días tipo; módulo de Finanzas; aprendizaje de costes más allá de un cupo dinámico de 2 actividades-gasto + 1 actividad-recarga (ver Decisiones).
- **Participación autista:** Sin validar todavía con personas autistas fuera del propio desarrollador y su pareja (autista). Ver "Preguntas abiertas".

## Principios que esta app prioriza
- **P6 — No depender de la autolectura en tiempo real:** el motor de aprendizaje de costes reales y Patrones existen para revelar agotamiento antes de que la persona lo note. Es el "para qué" central del producto.
- **P9 — Energía y burnout, descanso no es fallo:** capacidad diaria variable, sin métricas de productividad ni narrativa de "superautista".
- **P10 — Sin mecánicas de castigo:** sin rachas, sin comparación, sin estados de "has fallado".
- **P11 — Seguridad y privacidad asumiendo entorno hostil:** local-first, datos de salud (Ciclo) tratados con cuidado especial, nada se comparte sin consentimiento explícito.
- **P3 — El espectro no es un slider:** ajustes sensoriales/de accesibilidad granulares y reversibles, nunca un único "modo autista" impuesto.

## Decisiones
| Fecha | Decisión | Motivo | Principio / evidencia | Estado |
|---|---|---|---|---|
| 2026-09-21 | Cuenta opcional con sync en la nube (Supabase); la sync en sí será de pago más adelante. Sin cuenta, nada cambia. | Sostenibilidad: la infraestructura de sync tiene coste real. Export/import manual sigue gratis como copia de seguridad de verdad, no de mentira. | — | vigente |
| 2026-09-23 | La pestaña **Patrones** (Calendario → tarjeta Patrones: gráfica de cucharas vs. tolerancia sensorial, "tardas más en recuperarte de X", patrón de picos día-siguiente) pasa a ser de pago. | Compromiso entre sostenibilidad y equidad: es una pantalla concreta y vendible, no el motor de datos en sí. | P6 · N4 (42,7% dice tener mal las finanzas) | vigente |
| 2026-09-23 | El aviso reactivo puntual "sueles gastar/recuperar N" que aparece al ajustar una tarea se queda **gratis siempre**, para todo el mundo. | Es el motor de coste real (`state.library`, `l.avg`), no una pantalla aparte. Sin él, el presupuesto de cucharas deja de ser honesto desde el primer uso, y sería repartir precisión por capacidad de pago. | P6 | vigente |
| 2026-09-23 | El módulo de **Ciclo** queda excluido del paywall, pase lo que pase con el resto de Patrones/planes futuros. | Dato de salud, categoría especial RGPD. Cobrar por trackear salud reproductiva en privado manda un mensaje muy malo además de plantear un problema de confianza. | P11 | vigente |
| 2026-09-23 | **Días tipo** (plantillas de día repetido) pasan a ser de pago, sin cupo gratis. | Convenience/ahorro de repetición, no autoconocimiento — no toca P6. Reserva expresada: sí reintroduce fricción diaria para quien repite rutina fija (P4, "regla de los dos pasos"), aceptada como coste de negocio consciente. | P4 (reserva, no bloqueo) | vigente |
| 2026-09-23 | La **librería de aprendizaje de costes** (`editar cuánto cuesta cada actividad`) tiene un cupo gratis: aprendizaje activo (promedio + aviso "sueles gastar/recuperar N") en las **2 actividades que restan cucharas + 1 que suma** que más se repiten, recalculado dinámicamente por frecuencia de uso (no fijado por las 3 primeras que se escriban alguna vez). Añadir y marcar tareas nunca tiene límite, con o sin cuota: lo único que se cae más allá del cupo es el aprendizaje/promedio para esa actividad concreta, no la posibilidad de apuntarla. | Cupo fijo por orden de aparición se descartó: con <2 repeticiones no hay promedio (`learned()`), así que un cupo estático podría llenarse con tareas que nunca se repiten y la persona no llegaría a ver el aprendizaje funcionar ni una vez — mal para todos, no solo para quien no paga. La versión dinámica (`byUse()`, ya existente en el código) garantiza que el cupo gratis esté siempre en lo que de verdad se repite. | P6 | vigente |
| 2026-09-23 | El módulo de **Finanzas** pasa a ser de pago entero. | Decisión del usuario. Reserva expresada: la misma cifra usada hoy para justificar cautela con paywalls (42,7% con finanzas mal, N4) es el motivo por el que alguien querría un módulo de gastos — cobrar por esa herramienta concreta a esta comunidad es una tensión real con esa evidencia, no un bloqueo. No es dato de salud (no al nivel de Ciclo). | N4 (reserva, no bloqueo) | vigente |
| 2026-09-23 | Ningún usuario real ha usado Patrones gratis todavía — cierra la pregunta de migración/gracia para usuarios existentes. | Confirmado por el usuario: solo `jaimelillobenito@gmail.com` (cuenta del propio desarrollador) tiene datos hasta ahora. | — | vigente |
| 2026-09-23 | La cuenta `jaimelillobenito@gmail.com` tendrá acceso total a todo lo de pago, gestionado como un campo de derecho de acceso en su fila de Supabase (marcado a mano), no como una lista de emails con privilegio especial escrita en el cliente. | `index.html` es un único archivo sin build ni ofuscación, visible a cualquiera — un check tipo `if(email===...)` en el JS expondría cómo funciona el sistema. Un campo en servidor prueba el mismo camino que seguirá un cliente de pago real. | — | vigente |
| 2026-09-23 | Precio: **36€/año** (suscripción anual) y **3,99€/mes** (mensual); sin opción de pago único por ahora. | Decisión del usuario. El anual sale ~25% más barato que 12 meses sueltos (3,99×12=47,88€), incentivo normal hacia la opción que evita el riesgo de "me olvidé de cancelar" (P5). | — | vigente |
| 2026-09-23 | Proveedor de pagos: **RevenueCat**, vía plugin `@revenuecat/purchases-capacitor` (mismo patrón que `@capacitor/browser`, ya en uso). | Unifica StoreKit (iOS) y Google Play Billing (Android) sin programar validación de recibos a mano; sincroniza el estado de suscripción al campo de derecho de acceso en Supabase. Nota técnica: el pago no puede ir por "Apple Pay"/"Google Pay" directamente — Apple exige In-App Purchase/StoreKit (Guideline 3.1.1) y Google exige Play Billing para desbloquear contenido dentro de una app nativa; lo que verá quien pague es la hoja de compra nativa (Face ID/Touch ID o el método ya guardado en su cuenta), no un botón nuestro. | — | vigente |
| 2026-09-23 | Prueba gratuita de **14 días** antes de cobrar, con todo activado. | Decisión del usuario. | P3 | vigente |
| 2026-09-23 | Cuando una actividad se queda sin aprendizaje por superar el cupo gratis, se muestra el tag **"No aprende de esta actividad · Premium"** en el mismo sitio donde saldría "sueles gastar N", sin icono de candado ni color de alarma. | Se descartó "Actividad sin guardar" (propuesta inicial): no es literal — la tarea sí se guarda, solo falta el aprendizaje — y reutiliza el verbo "guardar" que en el resto de la app significa otra cosa, rompiendo la regla de verbos consistentes (`language.md`). Se usa "aprende" porque ya es el verbo que conoce quien ha visto el tour. | P2 · P10 (tono neutro, sin regañina) | vigente |

## Descartado y por qué
- **Limitar el histórico de Patrones por antigüedad** (ver solo los últimos N días gratis) — descartado: rompe P6 (el valor es ver el patrón completo) y perjudica más a quien menos puede pagar.
- **Cerrar del todo la librería de aprendizaje de costes** (sin cupo gratis alguno, con o sin UI visible) — descartado: es la plontería que alimenta media app (`record()` se ejecuta en cada tarea registrada, se abra o no esa pantalla); cerrarla entera, aunque sea "limpiamente" desde el principio, repartía autoconocimiento por capacidad económica sin dar ni una muestra gratis. Se sustituyó por el cupo dinámico de la tabla de arriba.
- **Cupo gratis fijo por orden de aparición** (las 3 primeras actividades que se escriban, para siempre) — descartado a favor del cupo dinámico por frecuencia de uso: uno estático podía llenarse con tareas que nunca se repiten, dejando a la persona sin ver el aprendizaje funcionar ni una vez antes del muro de pago.
- **App íntegramente de pago, sin ningún tier gratis** — descartada por ahora a favor de freemium con núcleo gratis genuino; quedó como alternativa válida si el freemium no sostiene el proyecto más adelante.

## Preguntas abiertas / por validar con personas autistas
- Validar con personas autistas si de verdad pagarían por Patrones específicamente, o si el gancho real está en otro sitio (sync, apoyo al desarrollo, capa predictiva) — pendiente, no hecho.
- Diseño de la comprobación de derecho de acceso con RevenueCat ya elegido: qué se guarda exactamente en Supabase, cómo lo lee el cliente, qué pasa sin conexión (¿se cachea el último estado conocido, por cuánto tiempo?) — sin decidir.
- Cuenta de desarrollador en App Store Connect / Google Play Console + cuenta en RevenueCat, y dar de alta ahí los productos (36€/año, 3,99€/mes) antes de poder probar nada real — paso manual pendiente del usuario.

## Deuda de accesibilidad conocida
- Hardcodeo de € en el módulo de Finanzas (detectado en la auditoría de lanzamiento del 2026-09-17, sigue abierto).

## Grupos fuera de la evidencia a validar aparte
- No hablantes, personas con altas necesidades de apoyo, niñes, hombres, personas mayores, racializadas — la base de evidencia del skill está sesgada hacia adultas autistas tardíamente identificadas, mayormente mujeres/género diverso, hispanohablantes. Ninguna decisión de este log está validada fuera de ese perfil.
