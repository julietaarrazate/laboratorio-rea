# Qwick (app para profesionales de gastronomía)

- **Origen:** APK público de Android `com.qwickmobile` 4.12.0 (versionCode 596), firma verificada (O=Qwick, Phoenix). Copia local en `muestras/qwick/` (no se sube).
- **Tipo:** programa compilado (React Native + Hermes; análisis de manifest con REA/JADX y textos del bundle)
- **Estado:** en curso
- **Última actualización:** 2026-10-11

## En una frase

Marketplace de EE.UU. que conecta restaurantes y hotelería con profesionales freelance (mozos, bartenders, cocina) para cubrir turnos; es el producto más parecido a Oído.

## Tecnologías

- **App:** Expo + React Native con Hermes; actualizaciones "por aire" (expo-updates) sin pasar por la tienda.
- **Backend:** API REST propia (turnos, postulaciones, hojas de horas, pausas, disponibilidad semanal, certificados, registro de ubicación de fichajes).
- **Servicios:** login por código SMS (SuperTokens), feature flags (LaunchDarkly), chat (Sendbird), imágenes (Cloudinary), pagos (Stripe Connect), nómina de empleados (Zeal), certificados (Certifly).
- **Avisos:** FCM + Notifee (notificaciones locales) + Braze (marketing).
- **Mapas:** búsqueda de direcciones con Google Places; el feed se ordena por distancia en línea recta, no es un mapa central.
- Restos de **Gigpro**: Qwick absorbió esa app.

## Arquitectura

No se pudo decompilar la lógica (está en bytecode Hermes v98, que el parser disponible no lee). Lo de abajo sale de nombres de rutas del servidor, nombres de estado y textos de pantalla. Cada profesional pertenece a un **mercado** (ciudad) que define qué turnos ve.

## Flujos clave

**Tomar un turno (varias modalidades según el caso)**
- **Confirmación instantánea:** el primero que confirma se lo queda, sin aprobación del negocio.
- **Postulación:** el pro aplica y el negocio elige.
- **Oferta directa** e **invitación** del negocio a un pro.
- **Paquetes** de varios turnos, con re-ofertas.
- **Turnos abiertos en locales donde ya trabajaste:** funciona como "favoritos" sin botón de favorito.
- **Último momento:** alertas propias, confirmación explícita y turnos con **bono fijo visible** ("boosted").

**Asistencia**
- Fichaje de entrada/salida con **ubicación**; algunos turnos piden además un **código de 4 dígitos que da el encargado**. Hay locales que fichan con su propio sistema.
- No se puede fichar más de 5 minutos antes; recordatorios si no fichaste a los 15 y 30 minutos.
- Si el pro edita sus horas, pasa a revisión manual y el pago se demora.
- Control de pausas y comidas (reglas laborales de EE.UU.).
- Servicio de ubicación en primer plano **solo durante el turno**; no pide ubicación en segundo plano.

**Cancelaciones**
- Cancelar con menos de 24 h baja mucho la calificación y puede suspender la cuenta.
- 15 minutos de gracia después de confirmar.
- Flujo de "aviso que no voy" con motivo y adjunto (por ejemplo, certificado médico).
- El no-show lo reporta el negocio; sanciones de suspensión temporal a permanente.

**Calidad**
- Perfil por puesto con años de experiencia, habilidades, herramientas propias y disponibilidad semanal por bloques.
- Verificación de identidad, antecedentes y certificados con vencimiento: si vence, deja de recibir turnos que lo exigen.
- Entrevista inicial (con IA o con el equipo) antes de habilitar al pro.
- Calificación en ambos sentidos.
- **Niveles Bronce / Plata / Oro:** el premio es **ver antes los turnos nuevos** y más visibilidad.
- Uniforme definido por cada negocio (o provisto en el local).

**Pagos**
- El negocio aprueba la hoja de horas y paga; llega en 1 a 3 días hábiles.
- **Pago instantáneo** a tarjeta de débito con comisión, si la salida se fichó en el local.
- Bono por referidos.

## Lo que aprendí

- La rapidez no depende de una sola modalidad: **la forma de tomar el turno cambia según la urgencia** (instantáneo cuando apura, aprobación cuando hay tiempo).
- En gastronomía el mejor "favorito" es **quien ya trabajó en ese local**.
- Un **código que da el encargado + ubicación** resuelve el fichaje sin hardware.
- Los **niveles con un premio concreto** (ver turnos antes) incentivan a no cancelar mejor que los castigos.
- Los **requisitos por turno** (certificados, uniforme, herramientas) filtran el matching de entrada.

## Ideas para mis proyectos

- Oído: "confirmación instantánea" para turnos urgentes y aprobación del comercio para los planificados.
- Avisar primero a quienes ya trabajaron en ese restaurante.
- Fichaje con PIN del encargado + ubicación guardada para auditar.
- Niveles con acceso anticipado de unos minutos a turnos nuevos.
- Política de cancelación simple: 24 h, 15 minutos de gracia, aviso con motivo.
- Requisitos por turno: carnet de manipulador de alimentos con vencimiento, uniforme, herramientas.
- Bono fijo que el comercio activa cuando falta poco; pago rápido opcional con comisión.
- Adaptar a Argentina: monotributo/encuadre laboral y pagos con Mercado Pago (validar con abogado).

## Pendientes

- Decompilar la lógica Hermes v98 con una herramienta compatible para confirmar reglas (tiempos, prioridad de niveles).
- Confirmar si existe fichaje por QR (hay un lector de códigos en el manifest).
- Catálogo de puestos (viene del servidor).
