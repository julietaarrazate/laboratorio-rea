# inDrive (negociación de precio)

- **Origen:** APK público de Android `sinet.startup.inDriver`, firma verificada (O=sinet, Yakutsk). Copia local en `muestras/indrive/` (no se sube).
- **Tipo:** programa compilado (Kotlin nativo + partes Flutter; REA con JADX y Apktool)
- **Estado:** en curso
- **Última actualización:** 2026-10-11

## En una frase

App de viajes donde el pasajero propone el precio y los conductores aceptan o contraofertan; se estudió como inspiración para turnos urgentes donde el comercio puede subir el pago.

## Tecnologías

- **App:** Kotlin nativo, organizada en módulos por negocio (ciudad, interurbano, envíos, carga), con partes en Flutter.
- **Tiempo real:** cliente de **Centrifugo** (servidor abierto de mensajería en tiempo real sobre WebSocket); las ofertas le llegan al pasajero empujadas por ese canal (inferido).
- **Respaldo:** consulta periódica al servidor, con intervalos configurados **por ciudad** y por pantalla.
- **API:** casi todas las acciones llevan **clave de idempotencia** (un reintento no cuenta dos veces). Push solo con Firebase.

## Flujos clave

**Pasajero**
- El servidor sugiere un precio con **mínimo y máximo por ciudad** (y recargo en hora pico); la pantalla avisa si llegaste al mínimo y cómo afecta el precio a la cantidad de ofertas.
- Mientras busca: botones para **subir la oferta** con un paso fijo que define la ciudad; subir modifica el mismo pedido.
- Si nadie responde: el servidor sugiere subir, permite **volver a avisar** a conductores que ofertaron antes y, al vencer, propone recrear el pedido con otro precio. Los tiempos los manda el servidor como fechas de vencimiento.
- Cada oferta de conductor trae precio, minutos de llegada, distancia, calificación, viajes hechos y **su propia cuenta regresiva**. También se ven los conductores que están mirando el pedido.
- Al elegir una oferta se crea el viaje; las demás pasan a inactivas con motivo (vencida, rechazada, "otro aceptó"). Hay aceptación automática con un tiempo de llegada máximo y protección contra doble toque.

**Conductor**
- Lista de pedidos cercanos (actualizada por consultas periódicas) con precio propuesto, precio por km, distancia y **cuánta competencia hay**.
- Puede **aceptar al precio propuesto**, elegir entre montos preparados por el servidor o poner uno libre dentro de un rango; también elige su tiempo de llegada entre opciones.
- Puede tener **varias ofertas abiertas** hasta un tope; si una se acepta, las otras se cancelan solas.
- Si no lo eligen, la oferta vence y la app le sugiere ofrecer de nuevo.

**Protecciones visibles:** precio mínimo y máximo, tope de contraoferta, tope de ofertas simultáneas, motivos y cargo por cancelación, calificaciones con etiquetas.

## Lo que aprendí

- Toda la negociación (pasos de precio, límites, tiempos) **la controla el servidor** y se configura por ciudad.
- **Cada oferta tiene su propio vencimiento**, no solo el pedido.
- Mostrar al que ofrece **cuánta competencia hay** acelera la respuesta.
- Cuando no hay respuesta, el sistema **propone acciones concretas** (subir, volver a avisar, recrear) en lugar de solo esperar.
- WebSocket + consultas periódicas de respaldo + idempotencia en cada acción.

## Ideas para mis proyectos

Flujo propuesto para un **turno urgente en Oído** (cubrir en menos de 10 minutos):

| Momento | Qué pasa |
|---|---|
| t=0 | El comercio publica con un **pago sugerido** y un **piso que fija el servidor** (nunca debajo del convenio) |
| Respuesta | Trabajadores cercanos: **aceptar** el pago (asignación inmediata si el comercio activó "el primero que acepta") o **contraofertar solo hacia arriba** con 2-3 montos preparados y un tope |
| Cada contraoferta | Vence en ~90 s; el comercio la ve con cuenta regresiva, calificación, turnos hechos y tiempo de llegada |
| t=3 min | Sugerencia "subí el pago" con paso fijo; volver a avisar a quienes ofertaron |
| t=6 min | Segunda suba sugerida y mayor alcance |
| t=9 min | Vence, con opción de republicar |
| Al elegir | Las demás ofertas se cierran con motivo; máximo 2 ofertas abiertas por trabajador |

- **Técnica:** canal en vivo (Centrifugo o Supabase Realtime) + consultas cada 5-10 s de respaldo, idempotencia en cada acción y asignación con transacción atómica.
- **Riesgos:** carrera hacia abajo (se evita con piso y contraofertas solo hacia arriba), sesgos en la elección (auditar), y **encuadre laboral en Argentina** (convenio gastronómico CCT 389/04, salario mínimo, aportes, ART): **revisar con abogado** antes de implementar precio negociable.

## Pendientes

- El orden de la lista de ofertas y los valores de los tiempos vienen del servidor; no se ven en la app.
- Evaluar Centrifugo (abierto) frente a Supabase Realtime para Oído.
