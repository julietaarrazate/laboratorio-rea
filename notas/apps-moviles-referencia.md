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

## Pendientes

- Configurar JADX y apktool en REA (`REA_JADX_MCP_JAR`, `REA_APKTOOL_COMMAND`) para decompilar clases y métodos concretos; esta pasada usó manifest, nombres de clases y textos.
- Soy Rappi (app de repartidores) no está en las tiendas públicas; conseguirla desde un celular.
