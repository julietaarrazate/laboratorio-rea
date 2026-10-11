# Instawork (app de trabajadores)

- **Origen:** APK público de Android `com.instaworkmobile` 2.242.2, firma verificada (O=Instawork, San Francisco). Copia local en `muestras/instawork/` (no se sube).
- **Tipo:** programa compilado (React Native + Hermes; manifest y clases nativas con REA/JADX, textos del bundle)
- **Estado:** en curso
- **Última actualización:** 2026-10-11

## En una frase

El marketplace de turnos por hora más grande de EE.UU. (gastronomía, eventos, depósitos): el modelo de Oído a gran escala.

## Tecnologías

- **App:** React Native con Hermes, Redux. Lo único nativo propio es la parte de llamadas (VoIP) y la recepción de push.
- **Pantallas definidas por el servidor (Hyperview):** framework abierto creado por Instawork. El backend manda cada pantalla (feed, detalle, reserva) en XML y la app la dibuja. Por eso esos flujos casi no están dentro de la app.
- **Backend:** API propia en formato JSON:API; archivos en S3.
- **Avisos:** FCM + Notifee; marketing con Iterable; SMS; llamadas VoIP con timbre a pantalla completa.
- **Chat:** Sendbird, con **grupo por turno** y encargado ("shift lead").
- **Ubicación:** SDK de HyperTrack para geocercas, con servicio en primer plano.
- **Pagos:** Hyperwallet (PayPal) a tarjeta de débito.

## Flujos clave

**Encontrar y reservar turnos**
- El trabajador elige sus puestos (con un quiz por puesto) y un **radio de distancia** o "voy a cualquier lado".
- Reserva directa del turno (no postulación) y un paso de **reconfirmación** aparte antes del turno (inferido).
- Botón para agregar el turno al calendario. Muestra si el turno es como empleado o independiente.
- Felicitaciones por los primeros turnos reservados.

**Asistencia**
- **Geocerca** con radio definido por el servidor: entrada y salida **automáticas** al llegar e irse del local.
- Respaldos: código, QR o fichaje supervisado por el encargado.
- La ubicación se usa **solo durante el turno y 1 hora antes**, y la app lo explica así ("para que el comercio sepa cuándo llegás").
- Registra la tardanza en minutos.
- Una ausencia sin aviso lleva a desactivar la cuenta; antes avisa "cuenta en riesgo".

**Reputación**
- **Cuatro indicadores visibles** en el perfil: calificación promedio, tasa de cancelación, puntualidad y ausencias, cada uno marcado como bueno, malo o sin datos.
- Buenas calificaciones dan acceso antes a los turnos mejor pagos.
- **Nivel Gold** a partir de 10 turnos: bonos y acceso temprano a todos los turnos.
- Alta: código SMS, video de presentación, experiencia y referencias, certificados (manipulación de alimentos, venta de alcohol), foto con la vestimenta exigida.

**Pagos**
- **Cobro rápido** a pocas horas de terminar el turno, en turnos marcados.
- Bono por referidos condicionado a trabajar una cantidad de turnos.

## Lo que aprendí

- **Pantallas desde el servidor**: cambian reglas, textos y flujos sin publicar versión nueva de la app.
- **Fichaje automático por geocerca**, con códigos o QR como respaldo.
- Explicar el uso de la ubicación con una ventana concreta ("1 hora antes y durante el turno") genera confianza.
- Reputación en **cuatro métricas simples y visibles**, en vez de un único puntaje opaco.
- El **chat grupal del turno** coordina a varios trabajadores del mismo evento.

## Ideas para mis proyectos

- Oído: tarjeta y detalle del turno armados por el servidor (coincide con lo visto en Rappi).
- Perfil del trabajador con las cuatro métricas y un nivel a los 10 turnos que da acceso antes a los urgentes.
- Ubicación acotada a "1 hora antes y durante el turno", explicada en esas palabras; fichaje por geocerca con PIN/QR de respaldo (requiere app nativa para la geocerca).
- Chat grupal por turno con encargado, útil en eventos y cierres tarde.
- Cobro rápido opcional por turno, vía Mercado Pago o CVU.
- Ofertas críticas con timbre a pantalla completa (app nativa).

## Pendientes

- El detalle de reserva, cancelaciones y multas vive en las pantallas que manda el servidor: no se ve en la app.
- Comisiones del cobro rápido.
- Hyperview es de código abierto: estudiar su repositorio para evaluar si sirve en la app React Native de Oído.
