# TitoFree (empleo en gastronomía y hotelería, Argentina)

- **Origen:** APK público de Android `com.titofree.app` 2.0.7 (build 189), firma válida con clave de Google Play; paquete y dominios propios confirmados. Sitio titofree.com (3 páginas públicas). Copia local en `muestras/titofree/` (no se sube).
- **Tipo:** programa compilado (Flutter; manifest con REA, textos y recursos de la app)
- **Estado:** en curso
- **Última actualización:** 2026-10-11

## En una frase

Portal de empleo argentino "100% gastronomía y hotelería" donde los locales publican ofertas y los trabajadores se postulan por cercanía; es el competidor local más cercano a Oído, aunque con otro modelo.

## Tecnologías

- **App:** Flutter (Dart) con GetX; una sola app con dos perfiles (negocio y trabajador).
- **Backend:** API REST propia + Firebase (chat en tiempo real, archivos, errores).
- **Avisos:** OneSignal + FCM; alertas también por WhatsApp.
- **Mapas:** flutter_map con mapas de AWS Location, búsqueda de direcciones con Google Places.
- **Cobro:** suscripciones con RevenueCat (tiendas) y Mercado Pago. **No maneja pagos a trabajadores.**
- **Analítica:** Mixpanel, UXCam (graba sesiones), Facebook.

## Flujos clave

**Modelo de negocio:** freemium por suscripción, "sin comisiones". El plan pago del local amplía ofertas abiertas, preguntas filtro, acceso a perfiles y reseñas de otros locales y quita publicidad. El trabajador puede pagar un plan para destacar su perfil y recibir alertas con prioridad. Hay referidos y publicidad dentro de la app.

**Publicar y postularse (es reclutamiento, no turnos)**
- El local crea una **oferta por sucursal** con puesto, descripción y **preguntas filtro** (con respuesta correcta e importancia). Puede pausarla, cerrarla o renovarla.
- El trabajador ve las ofertas en **mapa y lista por cercanía** (con radio en km), filtra por puesto, desliza tarjetas y recibe **alertas de ofertas nuevas en su zona**.
- Se postula con un toque tras responder las preguntas. El local ve a los postulantes ordenados por un **puntaje calculado** (distancia, experiencia, reportes de otros locales).
- El proceso tiene muchos estados: preselección, contacto, entrevista, negociación, **prueba**, contratación. Hay entrevistas por videollamada.
- Existe una opción de "contratar ahora" con horas de trabajo (inferido: contratación rápida), pero **no hay escalada automática ni asignación instantánea**. La urgencia es de marketing ("primeros postulantes en menos de 60 segundos").

**Confianza**
- Verificación con fotos del documento, video de presentación revisado por TitoFree y CV.
- Reseña del local al trabajador, notas privadas, favoritos y **lista negra** (rechaza solas las postulaciones de esa persona).
- Reportes: no se presentó, llegó tarde, mala conducta, información falsa.

**Asistencia:** la app no tiene fichaje. El sitio promete **fichaje con QR de la sucursal**, aviso de "llego tarde", horas exportables y **experiencia validada por el local** (inferido: función nueva o solo web).

**Escala declarada en su sitio:** más de 1.700 empresas y cientos de miles de postulaciones.

## Comparación con Oído

| Tema | TitoFree | Oído |
|---|---|---|
| Promesa | Postulantes rápido | Turno **cubierto** en menos de 10 minutos |
| Flujo | Reclutamiento largo (entrevista, prueba) | Postula → asigna → confirma |
| Si nadie responde | Nada automático | Escalada a los 8 minutos |
| Confianza | Puntaje calculado y lista negra | Cuatro dominios, sin puntaje público |
| Ubicación | Búsqueda por cercanía | Solo al compartir "en camino" |
| Dinero | Suscripción; no maneja pagos | Pago dividido con Mercado Pago |
| Plataforma | App nativa en tiendas | Web app instalable |

- **TitoFree va adelante en:** tamaño de red, mapa de ofertas, preguntas filtro, video de presentación, alertas por zona y WhatsApp, comunidad (academia, club, sello para locales).
- **Oído va adelante en:** cobertura de turnos con tiempos y escalada, pago integrado, menos datos de ubicación, confianza sin un puntaje que estigmatice.

## Lo que aprendí

- El competidor local ya usa el discurso de "cubrir en minutos", pero su producto es un **portal de empleo**: la diferencia de Oído está en la **cobertura garantizada**, no en la velocidad de postulación.
- Las **preguntas filtro** y las **alertas por zona configurables** resuelven calidad y alcance sin agregar pasos al momento urgente.
- Se están moviendo hacia la gestión del equipo del local (fichaje, horas).

## Ideas para mis proyectos

- Oído: alertas de zona configurables por el trabajador (radio y puestos), además de favoritos.
- Preguntas filtro cortas y opcionales al publicar (por ejemplo, "¿tenés libreta sanitaria?").
- "Experiencia validada por el local" como señal de confianza, sin puntaje público.
- Cartel o PDF con QR para que el local invite a su gente a Oído.
- Comunicar con **métricas de cumplimiento** (turnos cubiertos y en cuánto tiempo), no de postulaciones.
- Amenaza: si TitoFree suma cobertura urgente con pago, compite de frente. Conviene moverse rápido en la beta.

## Pendientes

- Ver si el fichaje con QR y la "experiencia validada" ya están en una versión más nueva.
- Precios de los planes (vienen de las tiendas en el momento).
