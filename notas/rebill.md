# Rebill (sitio web de marketing)

- **Origen:** https://www.rebill.com/es (sitio público, se inspeccionó lo que recibe cualquier navegador)
- **Tipo:** sitio web (HTML/CSS/JS servido al navegador)
- **Estado:** en curso
- **Última actualización:** 2026-10-11

## En una frase

Sitio de marketing de Rebill (pagos en Latinoamérica) en 3 idiomas: páginas estáticas generadas con Astro, contenido e imágenes desde el CMS Sanity, publicado en Vercel, con formularios que pasan por una función propia y terminan en Make.

## Tecnologías

| Pieza | Qué es | Cómo se detectó |
|---|---|---|
| **Astro** | Generador de sitios: arma el HTML de antemano ("estático"), casi sin JavaScript | Hoja de estilos en `/_astro/…css` |
| **Vercel** | Hosting con caché en el borde (servidores cerca del usuario) | Cabeceras `server: Vercel`, `x-vercel-cache: HIT` |
| **Sanity** | CMS "headless": se carga el contenido en un panel y el sitio lo consulta al compilar | ~440 links a `cdn.sanity.io` (imágenes, también la de redes sociales) |
| **Webflow (origen)** | Constructor visual donde estaba antes el sitio | Clases `w-nav`, `w-form`, `w-layout-grid` y un comentario en `/js/interacciones.js` que dice que recrea interacciones de Webflow "que el clonado no carga" |
| **jQuery + Splide** | Librería clásica de JS + carrusel/slider | `/js/jquery.min.js`, `/js/splide.min.js` |
| **Google Tag Manager** | Contenedor que carga Google Analytics 4 y Google Ads (DoubleClick) | Script de GTM; cookies `_ga`, `_gcl_au`; pedidos a `analytics.google.com` y `doubleclick.net` |
| **Make** (ex Integromat) | Automatizaciones sin código; recibe los formularios por webhook | Nombre de variable `MAKE_WEBHOOK_CONTACTO` en el script del formulario |

Fuente única: "SF Pro Display" servida desde el propio dominio.

## Arquitectura

```
Panel Sanity ──(al compilar)──► Astro genera HTML estático ──► Vercel (CDN)
                                                                   │
Navegador ◄────────────── HTML + 1 CSS + JS chico ◄────────────────┘
   │  imágenes ──► cdn.sanity.io (redimensiona/convierte al vuelo)
   │  analítica ──► GTM ► GA4 + Google Ads
   └─ formulario ─► POST /api/formularios (función en Vercel) ─► webhook de Make ─► (CRM / mail)
```

- **Un solo CSS** (~230 KB) para todo el sitio, compartido entre páginas (se cachea una vez).
- **Idiomas por carpeta:** inglés en `/`, español en `/es`, portugués en `/pt`. Cada página declara sus versiones con `hreflang` (le dice a Google qué página mostrar según el idioma).
- **Sitemap** con 337 URLs: blog (~85 notas en español), soluciones, mercados (países), clientes, precios, glosario, métodos de pago.
- **Subdominios** separados por función: `start.` (registro), `my.` (panel de clientes), `docs.` (documentación técnica), `status.` (estado del servicio), `product.` (changelog), `go.` (empleos).
- Casi todo el comportamiento son **scripts chicos escritos a mano dentro de la página**: rotar logos, carruseles, efecto en preguntas frecuentes, versiones mobile. Hay dos `console.log('test')` olvidados.

## Flujos clave

**Formulario de contacto** (página `/es/contact`; el script también se carga en la home):
1. Busca los formularios por nombre (`data-name`) y solo maneja los que están en una lista: hoy, `contact-form-v2` con nombre y email obligatorios.
2. Agrega un campo invisible llamado `trampa` (**honeypot**: los bots lo llenan y las personas no, así se filtra spam sin captcha).
3. Al enviar: valida en el navegador, deshabilita el botón ("Enviando…") y manda un JSON a `/api/formularios` con el nombre del formulario, los datos, la trampa y la URL de origen.
4. Si sale bien, oculta el formulario, muestra el mensaje de éxito en el idioma de la página (es/en/pt) y empuja el evento `formulario_enviado` a GTM para medir conversiones. Si falla, muestra el mensaje de error.
5. El servidor (no visible) reenvía a Make, que guarda la URL del webhook en una variable secreta, así nunca llega al navegador.

**Carga de la página:** HTML desde la caché de Vercel → CSS → imágenes de Sanity → al final GTM carga Analytics y Ads. Sin errores en la consola.

## Lo que aprendí

- **Migrar de Webflow a código** sin rediseñar: se exporta o copia el HTML/CSS de Webflow, se mantienen sus clases, y se reemplaza solo el JS de Webflow (`webflow.js`) por scripts mínimos (menú hamburguesa, acordeón). Así se gana control y costo sin tocar el diseño.
- **Astro + CMS headless** es la combinación típica para sitios de marketing rápidos: el equipo edita textos en Sanity y el sitio se regenera.
- **Formularios sin servicio pago:** función propia + webhook de Make + honeypot + evento a GTM. La URL del webhook queda escondida en el servidor.
- **Mensajes del formulario por idioma** según `<html lang>`, en vez de duplicar el script.
- **SEO cuidado:** `hreflang`, `canonical`, Open Graph, datos estructurados (schema.org) de tipo `Organization`, `WebSite` y `FAQPage` (las preguntas frecuentes pueden aparecer directo en Google).

## Ideas para mis proyectos

- Para un sitio de marketing: Astro (o similar) + un CMS headless + Vercel, en vez de un constructor visual pago.
- Copiar el patrón de formulario: endpoint propio → webhook de Make/n8n, honeypot y evento de conversión.
- Agregar datos estructurados `FAQPage` en las páginas con preguntas frecuentes.
- Lo que **no** conviene copiar: jQuery (pesa ~90 KB y casi no se usa), un CSS único enorme, scripts sueltos repetidos por página y logs de prueba en producción.

## Pendientes

- Ver cómo se arma una nota del blog y la página de precios (¿tablas desde Sanity?).
- Ver qué etiquetas dispara GTM (contenedor público en `googletagmanager.com`).
- Medir rendimiento (Lighthouse) para comparar con un sitio propio.
- La copia local está en `muestras/rebill/` (no se sube: tiene derechos de autor de Rebill).
