# Tegu y Clickie (servicios para el hogar, Argentina)

- **Origen:** sitios públicos tegu.ar (+ app.tegu.ar) y clickie.com.ar, inspeccionados como un visitante (sin login ni formularios). Apps Android `com.teguinc.tegu.app` y `com.casaclick.android` todavía sin analizar (no están en APKPure). Copias locales en `muestras/tegu-web/` y `muestras/clickie-web/` (no se suben).
- **Tipo:** sitio web
- **Estado:** en curso
- **Última actualización:** 2026-10-11

## En una frase

Dos marketplaces argentinos de servicios para el hogar (plomería, electricidad, etc.) con modelos opuestos: **Tegu por ofertas** (los profesionales compiten) y **Clickie por precio cerrado** (va el primero disponible).

## Tecnologías

| | Tegu | Clickie |
|---|---|---|
| Sitio | Next.js detrás de Cloudflare (inferido: hosting en Vercel) | Next.js en Vercel |
| Web app | Aparte (`app.tegu.ar`), login con Firebase Auth, API propia | La home es la app: chat con IA para pedir |
| Analítica | Vercel, Meta Pixel, Clarity (graba sesiones) | GA4, Umami, Vercel, PostHog (graba sesiones), Sentry |
| Mapas | Google Maps (zonas) | Google Maps |

## Flujos clave

**Tegu: subasta inversa**
- El cliente describe el problema con foto, audio o texto; una IA arma el pedido y **se puede publicar antes de registrarse** (según ellos, duplicó las publicaciones de usuarios nuevos).
- Los profesionales cercanos del rubro reciben aviso y deciden si ofertar; el cliente compara precio, perfil y reseñas.
- Problema que ellos mismos reconocen: **el cliente recibía ofertas y no elegía**; sumaron una recomendación con IA.
- Pago directo entre las partes. El profesional paga un **monto fijo por cada trabajo ganado** (0% de comisión, sin abono).
- Cobertura: Córdoba Capital y Palermo; cupos de profesionales por rubro y zona.

**Clickie: híbrido con precio cerrado**
- Chat con IA que diagnostica el problema.
- Trabajos comunes: **precio cerrado** calculado con precios históricos y va **el primer profesional verificado disponible** (tipo Uber). Trabajos a medida: presupuestos con plazo de 72 h.
- Lo "instantáneo" es saber el precio, no la llegada.
- Seguimiento: confirmado → en camino → terminado, con chat obligatorio dentro de la app.
- Clickie cobra y retiene el pago; comisión al profesional y al cliente. **Garantía de devolución** solo si se pagó por la plataforma (evita arreglos por fuera).
- Cobertura en varias ciudades; lista de espera para zonas sin cobertura.

**Confianza (ambas):** verificación de identidad, antecedentes y matrícula; reseñas de ida y vuelta; chat sin compartir teléfonos.

**Marketing:** muchísimas páginas por servicio y barrio para SEO. Tegu publica sus métricas y su registro de decisiones ("building in public") y una página con los pedidos abiertos del momento para atraer profesionales. Clickie publica precios de referencia por trabajo y herramientas gratis (comparador de presupuestos).

## Lo que aprendí

- **Las ofertas dan control pero son lentas**: el que pide tiene que decidir, y muchas veces no decide.
- **La velocidad sale de estandarizar** precio y trabajo, para que pueda ir "el primero disponible".
- Una garantía atada a operar dentro de la plataforma protege a las dos partes y desalienta arreglar por fuera.
- Publicar precios de referencia con datos propios sirve para SEO y para dar confianza.
- Mostrar la demanda abierta recluta del otro lado del mercado.

## Ideas para mis proyectos

- Oído: el riesgo de Tegu (el que pide no elige) es el mismo que el paso "el comercio asigna". Medir cuánto tarda el comercio en elegir antes de decidir un "primero que acepta" o una sugerencia por defecto con cuenta regresiva.
- Precios de referencia por puesto y zona, públicos (Oído ya calcula la mediana por puesto: ADR-0012).
- Página pública de "turnos abiertos ahora" para reclutar trabajadores, con registro después.
- Chat dentro de la plataforma y garantía ("si no se presenta, te reponemos") para desalentar arreglos por fuera.
- No copiar: comisión alta para ambos lados, plazos largos para presupuestos, WhatsApp como canal principal de pedidos (Tegu lo probó y lo cerró), cancelación escondida, grabación de sesiones sin avisar.

## Pendientes

- Analizar las apps (lado del profesional: avisos, aceptación, penalidades, "en camino", verificación). Hay que exportarlas desde un celular Android.
- No son competencia de Oído (otro rubro y otro cliente), pero comparten los problemas de un marketplace de dos lados.
