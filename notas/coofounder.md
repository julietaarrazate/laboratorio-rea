# Coofounder (sitio web)

- **Origen:** https://coofounder.app/ (landing pública, sin iniciar sesión)
- **Tipo:** sitio web en producción (análisis pasivo con REA sobre una copia
  local abierta en Chromium, más los encabezados HTTP)
- **Estado:** en curso
- **Última actualización:** 2026-10-15

## En una frase

Plataforma argentina para encontrar co-founder: perfiles que "se leen
enteros" (qué construís, evidencia, cómo trabajás, una opinión propia) y un
match que explica por qué te conviene esa persona.

## Tecnologías

Observado en los encabezados HTTP y en el análisis de los 28 scripts de la
página con REA (`analyze_web_bundle`, todo parseado, nada ejecutado):

- **Alojamiento:** Vercel (`server: Vercel`, región `iad1`, Washington).
  Sin Cloudflare adelante.
- **Frontend:** Next.js con Turbopack (chunks en `/_next/static/immutable/`)
  y React.
- **Backend y datos:** Supabase. Lo dice la política de seguridad (CSP): las
  imágenes, la API y el WebSocket van a un proyecto `*.supabase.co`. O sea
  base Postgres, autenticación, archivos y tiempo real del mismo proveedor,
  sin servidor propio aparte.
- **Ingreso:** Google (accounts.google.com en la CSP) y Cloudflare Turnstile
  (el captcha invisible) para frenar bots en el registro.
- **Analítica:** PostHog con grabación de sesiones y encuestas, servido desde
  el propio dominio (`/ingest/...`) para que los bloqueadores de anuncios no
  lo corten. Errores con Sentry. Un script más con ruta ofuscada, probablemente
  la analítica de Vercel.
- **Movimiento:** Lenis (scroll suave) y Motion (ex Framer Motion). Los
  personajes del final se arrastran con el `drag` de Motion, con límites y
  rebote elástico (`dragConstraints`, `dragElastic`). No hay motor de física.
- **Seguridad de la página:** CSP estricta (lista cerrada de orígenes,
  `frame-ancestors 'none'`), HSTS con preload, `X-Frame-Options: DENY`,
  `Permissions-Policy` que apaga cámara, micrófono, ubicación y pagos.

## Arquitectura

Todo en dos proveedores: Vercel sirve el Next.js y Supabase hace de backend
completo. Es la arquitectura más barata y simple para una app de perfiles y
mensajes sin lógica pesada en el servidor.

## Lo visual (por qué se ve limpio)

Recorrido completo en 1440 y 390 px (capturas en `muestras/coofounder/`, no
van a git):

- **Fondo blanco liso** en casi toda la página. Una sola sección con fondo
  apenas gris y una sola tarjeta con degradado (azul a durazno). No alterna
  bandas de colores.
- **Un solo acento:** azul eléctrico, usado sólo en la palabra clave del
  título ("co-founder") y en el botón final. El resto es negro sobre blanco.
- **Una tipografía de títulos propia, redondeada y en minúscula**, con mucho
  aire alrededor. El texto chico, gris y corto. Casi no hay etiquetas en
  mayúscula ni pastillas.
- **Encabezado mínimo:** el logo y un solo botón negro chico ("Entrar").
- **Una idea por pantalla:** título, una línea y una imagen. Las imágenes son
  el producto real (la tarjeta de perfil, el bloque citado), no ilustraciones
  genéricas.
- **Personajes en línea negra** (stickers en SVG, unos 35) como identidad:
  aparecen poco (el mapa de founders y el final). El cierre es un "found"
  gigante en negro sobre un degradado azul, con los personajes encima que se
  pueden arrastrar y vuelven con rebote. Es el único momento de juego de la
  página, y está al final, donde no compite con el mensaje.
- **Hero con fotos reales en órbita** alrededor del título.

## Lo que aprendí

- Supabase + Vercel alcanza para lanzar una app de perfiles con login,
  archivos y chat sin escribir un backend.
- PostHog servido desde el propio dominio es la forma de no perder analítica
  por los bloqueadores.
- La sensación de "pulido" sale más de lo que se saca que de lo que se pone:
  un acento, un fondo, una tipografía de títulos, una idea por pantalla.
- El juego (arrastrar personajes) funciona porque es uno solo y está al
  final.

## Ideas para mis proyectos

Para Oído (comparación hecha el 2026-10-15):

- Bajar a un fondo blanco liso y sacar las bandas de color enteras (ámbar,
  celeste, noche) salvo un único momento oscuro.
- Un solo acento por pantalla de verdad: el ámbar sólo en el botón principal.
- Menos etiquetas en mayúscula, menos pastillas y menos sombras.
- Un cierre con juego: "oído" gigante con personajes de gastronomía (mozo,
  bartender, cocinera, bachero) que se puedan arrastrar, con Motion `drag`.
  Requiere ilustraciones propias.

## Pendientes

- Ver las pantallas de adentro (registro, perfil, match): requieren cuenta.
