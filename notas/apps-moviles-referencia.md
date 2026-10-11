# Apps móviles de referencia: Uber Driver, Rappi, Morfy, Pasito

- **Origen:** APKs públicos de Android (Uber Driver 4.600, Rappi clientes 8.40, Morfy 4.3.0, Pasito 2.4.7), firmas verificadas con `apksigner`. Copias locales en `muestras/` (no se suben).
- **Tipo:** programas compilados (análisis estático con REA + lectura del manifest, nombres de clases y textos)
- **Estado:** en curso
- **Última actualización:** 2026-10-11

## En una frase

Cómo resuelven cuatro apps reales la ubicación, los avisos urgentes y el seguimiento en vivo, para aplicarlo en una app de turnos gastronómicos.

## Tecnologías

| App | Hecha con | Backend / tiempo real | Push |
|---|---|---|---|
| **Uber Driver** | Kotlin nativo, arquitectura **RIBs** (abierta de Uber), DI con Motif | Conexión persistente **RAMEN sobre gRPC** + polling de respaldo; H3 dentro de la app | FCM + RAMEN |
| **Rappi (clientes)** | Kotlin nativo, Compose, Dagger; módulo Flutter para pagos | Posición del repartidor por **Firebase Realtime Database**, con REST de respaldo | FCM (+ Huawei), Braze |
| **Morfy** | **React Native** (Hermes) + Redux | API propia; búsqueda por zona del mapa en el servidor | OneSignal sobre FCM |
| **Pasito** | **Flutter** | **Supabase** (base, auth, Edge Functions) | FCM |

## Flujos clave

**Oferta urgente (Uber Driver)**
- La oferta llega por la conexión abierta; si falla, por polling; además por push. La app confirma recepción ("ack").
- El vencimiento de la oferta lo manda el servidor; la app muestra la cuenta regresiva, suena un sonido propio y puede leerla en voz alta.
- Notificación de alta prioridad, a pantalla completa, con botones **Aceptar / Rechazar** sin abrir la app.
- Antes de ponerse "en línea", la app exige permisos de ubicación, notificaciones, GPS prendido y red ("bloqueos para conectarse").

**Ubicación sin permiso de segundo plano (las cuatro)**
- Ninguna pide `ACCESS_BACKGROUND_LOCATION`.
- Uber: servicio en primer plano de tipo ubicación que arranca al ponerse en línea con la app visible. Separa cada cuánto **toma** la ubicación de cada cuánto la **sube**, sube en lotes, guarda en disco si no hay red y espacia las subidas según la batería. Todos los intervalos son configurables desde el servidor.
- Rappi, Morfy: una lectura de ubicación al momento, de precisión equilibrada.
- Pasito: cuenta pasos con Health Connect y el sensor del teléfono en un servicio en primer plano; sincroniza con WorkManager solo con red y batería no baja.

**Seguimiento en vivo (Rappi)**
- El servidor le dice a la app **qué canal escuchar**; la app se suscribe, recibe como mucho una posición por segundo y, si falla, consulta un endpoint REST.
- El marcador se desliza entre posiciones, gira según el rumbo e ignora saltos chicos. Si no llegan datos en un rato, se considera desactualizado.
- La pantalla de seguimiento se arma con "widgets" que define el servidor (estado, ETA, ruta).

**Comercios y canjes (Morfy, Pasito)**
- Morfy busca locales por el rectángulo visible del mapa (filtro en el servidor) y confirma canjes con un código o QR que abre un link de la app.
- Pasito confirma canjes en el mostrador con un **PIN de 4 dígitos** que da el cajero; controla stock por sucursal y límites diarios; los puntos vencen a los 60 días.

## Lo que aprendí

- La confiabilidad sale de **varios canales + confirmación + respaldo**, no de un único canal perfecto.
- **Todo lo ajustable vive en el servidor**: vencimientos, intervalos de ubicación, pantallas. Se cambia sin publicar una versión.
- Se puede hacer seguimiento útil **sin ubicación en segundo plano**, que es lo que más revisan las tiendas y lo que más desconfianza genera.
- Una PWA cubre push, cuenta regresiva y ubicación con la app abierta; **no** puede mostrar una oferta a pantalla completa con el teléfono bloqueado, sonar con sonido propio de forma fiable ni seguir la ubicación con la pantalla apagada. Para eso hace falta app nativa (React Native con FCM de alta prioridad y servicio en primer plano).

## Ideas para mis proyectos

- Oferta urgente con `expira_en` decidido por el servidor, enviada por push + canal en vivo (SSE/WebSocket o Supabase Realtime) + polling, con "recibido".
- Botones Aceptar/Rechazar en la notificación.
- "Bloqueos para estar disponible": revisar notificaciones y ubicación antes de marcarse disponible.
- "En camino" solo durante el trayecto, con subida en lotes e intervalos según batería; mapa con marcador interpolado.
- Búsqueda de turnos por zona del mapa en el servidor; fichaje con QR o PIN en el local.
- Retención: puntos con vencimiento, rachas, rankings por barrio, referidos.

## Segunda pasada con JADX: seguimiento en vivo de Rappi

Lógica leída del código decompilado (resumida con palabras propias; detalle de Evidence IDs en la sesión de REA).

**Canal y datos**
- El servidor manda, dentro del modelo del mapa, en qué base y en qué canal escuchar. La app solo se suscribe.
- Cada actualización trae latitud, longitud y rumbo. **No trae hora**, así que la app no puede descartar posiciones viejas o desordenadas (punto débil).

**Filtros**
- Como mucho una posición por segundo; descarta (0,0), posiciones repetidas y movimientos de 10 m o menos.
- Si falta el rumbo, lo calcula con la posición anterior.
- Solo mueve el marcador cuando el pedido está en camino.

**Respaldo**
- Si el tiempo real falla, consulta una vez al servidor por REST y **a los 60 s vuelve a intentar** el tiempo real.
- Un "vigilante" genérico ejecuta el respaldo si no llega nada en un tiempo límite y se reinicia con cada evento real.

**Animación del marcador**
- Tres modos: línea recta (1 s, con aceleración y frenado suaves y giro por el lado más corto), recorrido por un camino y **cola pegada a la ruta**.
- En la cola, cada tramo dura distancia ÷ 9,5 m/s (entre 0,1 y 2 s). Si se juntan 15 o más puntos, entra en modo "ponerse al día" y los recorre todos en 2-3 s.
- Se pega a la ruta **solo hacia adelante**; si el repartidor se aleja 30 m o más, recalcula la ruta.
- Al entrar o salir de 50 m del local o del cliente, el ícono hace una pequeña animación.
- El ícono gira según rumbo menos rumbo de la cámara, se achica con el zoom e ignora cambios de rumbo menores a 5°.
- La cámara encuadra repartidor + local o repartidor + cliente según el estado, y no se mueve si la persona está tocando el mapa (inferido).

**Estado y ETA**
- La pantalla es una lista de **widgets que manda el servidor**, cada uno con un tipo.
- El ETA puede ser una **cuenta regresiva hacia una hora exacta** que manda el servidor, calculada en el teléfono.

**Notificaciones**
- Un único punto reparte cada push según su tipo; **cada push confirma su recepción** al servidor.
- Canales separados (general, chat, estado del pedido, llamada, seguimiento), todos de importancia alta.
- La notificación fija del pedido muestra una **barra de progreso calculada en el teléfono** (hora de inicio vs. hora estimada) y se actualiza cada minuto solo si cambió 2% o más. No necesita un push por cada cambio.

**Aplicación en Oído ("en camino" en la PWA)**
- Al marcar "en camino", el backend crea una sesión de seguimiento con canal y vencimiento, y le da al local solo el canal y un token (por ejemplo, canal privado de Supabase Realtime con permisos por local).
- Cada posición: latitud, longitud, rumbo, precisión, **hora y número de secuencia** (lo que le falta a Rappi).
- Trabajador: envía como mucho una cada 5 s, solo durante el trayecto, descartando lecturas imprecisas.
- Local: descarta posiciones viejas o repetidas, limita a 1 por segundo, ignora saltos menores a 10 m, marca "desactualizado" a los 30 s y "sin señal" a los 90 s.
- Respaldo: si el canal cae, consulta cada 15 s y reintenta el tiempo real cada 60 s.
- Marcador en MapLibre con animación por cuadro, duración según distancia y modo "ponerse al día"; recentrar solo si la persona no movió el mapa.
- Web Push por cambio de estado que reemplaza la notificación anterior del mismo turno, con cuenta regresiva calculada en el cliente.

## Segunda pasada con JADX: ofertas de Uber Driver

Lógica leída del código decompilado (resumida con palabras propias; Evidence IDs en la sesión de REA). No se estudiaron protecciones ni detección de fraude.

**Cómo llega la oferta**
- Tres vías: la conexión abierta (RAMEN, por gRPC o HTTP), el push de Google (FCM) y una consulta periódica de respaldo.
- **Dos confirmaciones distintas:** una de "recibí el mensaje" por cada mensaje de la conexión, enviadas en lote, y otra de "se mostró la oferta" apenas aparece en pantalla, con reintentos.
- Si llega un vencimiento o resultado de una oferta que no es la actual, se ignora.

**Cuenta regresiva y vencimiento**
- El servidor manda la **duración** de la ventana para aceptar; la app la cuenta desde que la muestra, con el reloj del teléfono.
- Si se vence sin respuesta, la app **le avisa al servidor** y cierra la pantalla. El servidor puede marcar que, al vencer, se acepte sola.
- Aceptar: corta sonido y vibración, opcionalmente pide confirmar si queda tiempo suficiente, adjunta la ubicación y envía con reintentos; la pantalla pasa enseguida a "aceptando". Rechazar: un solo intento, sin reintentos.

**Con el teléfono bloqueado o la app en segundo plano**
- La pantalla de oferta se muestra **sobre el bloqueo** y mantiene la pantalla prendida durante toda la ventana.
- Si hay permiso de superposición, la dibuja encima de otras apps.
- Además publica una notificación de alta prioridad con imagen de la oferta y **botones cuyo texto y acción manda el servidor**.
- Accesibilidad: flash de la cámara, vibración y lectura en voz alta.

**Bloqueos para conectarse**
- Cada bloqueo (ubicación, GPS, superposición, notificaciones, red) es una pantalla con su propio "arreglar"; se combinan con bloqueos que manda el servidor.
- Ya en línea, un sistema de diagnóstico de batería y red avisa en tres niveles que escalan: aviso → "no recibís viajes" → desconexión.

**Subida de ubicación**
- Un trabajo en primer plano con notificación fija que arranca al conectarse y se detiene al desconectarse.
- Sube en lotes con intervalo y tamaño configurables; con red mala espacia los envíos (8 veces más).
- **Alarma de "hombre muerto":** cada subida exitosa reprograma un aviso; si las subidas se cortan, el aviso dispara y le dice al conductor que su ubicación no se está enviando.

**Confiabilidad de la conexión:** cada mensaje o latido reinicia un temporizador; si vence, reconecta. Si la conexión no está "fresca", entra la consulta periódica.

**Aplicación en Oído**
- Oferta urgente con hora de vencimiento absoluta decidida por el servidor (mejor que la duración de Uber), y el vencimiento lo ejecuta el servidor.
- Envío por push de alta prioridad + canal en vivo con latido + consulta de respaldo mientras haya una oferta abierta; confirmación de "recibida".
- Aceptar idempotente, con reintentos y pantalla optimista; rechazar con un solo intento.
- Lista de "bloqueos para estar disponible" con su "arreglar" (en la PWA: notificaciones, ubicación y red; batería solo en nativo).
- "En camino": en nativo, servicio en primer plano solo durante el trayecto; en el servidor, alarma de "sin posiciones en X minutos" para avisar al local y al trabajador.
- En la PWA los botones Aceptar/Rechazar funcionan en Android con Chrome, pero no la pantalla completa sobre el bloqueo ni el sonido propio; en iPhone, menos.

## Pendientes

- Configurar JADX y apktool en REA (`REA_JADX_MCP_JAR`, `REA_APKTOOL_COMMAND`) para decompilar clases y métodos concretos; esta pasada usó manifest, nombres de clases y textos.
- Soy Rappi (app de repartidores) no está en las tiendas públicas; conseguirla desde un celular.
