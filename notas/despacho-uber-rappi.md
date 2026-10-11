# Despacho en tiempo real: Uber, Rappi y pares (fuentes públicas)

- **Origen:** blogs de ingeniería, centros de ayuda, patentes, estudios y prensa (links abajo). No se descompiló ninguna app.
- **Tipo:** investigación de fuentes públicas (no código)
- **Estado:** en curso
- **Última actualización:** 2026-10-11

## En una frase

Cómo encuentran Uber, Rappi, PedidosYa e iFood a la persona más cercana, le ofrecen un pedido y se aseguran de que alguien lo acepte rápido; referencia para una app de turnos gastronómicos urgentes.

## Tecnologías

- **Uber:** H3 (grilla de hexágonos, abierta) para zonas; antes S2 + Ringpop para repartir el mapa entre servidores; DISCO (despacho); Spanner para ofertas y viajes; DeepETA (ML que corrige el ETA del motor de rutas); RAMEN (conexión abierta SSE → gRPC para mandar ofertas al celular).
- **Rappi / PedidosYa / iFood:** no publicaron su índice geográfico. Rappi expone eventos de asignación y ETA a las tiendas por su API.

## Flujos clave

| Paso | Uber | Rappi / PedidosYa / iFood |
|---|---|---|
| Ubicación | El celular manda posición cada ~4 s | GPS permanente; PedidosYa usa "zonas de logueo" con radio |
| "Cerca" | Celda H3 + anillos vecinos; ranking por **ETA real**, no línea recta | Cercanía al local, tipo de vehículo, nivel del repartidor (Rappi, según Fundar) |
| Matching | **Por lotes**: junta pedidos y conductores y empareja en grupo | Automático, uno por pedido; iFood suma una **lista para elegir** (asignación −7 %) |
| Oferta | **Exclusiva, ~15 s** para aceptar; si no, pasa al siguiente. Patente para ofrecer a varios a la vez cuando conviene | Autoaceptación opcional; segundos para aceptar no publicados |
| Rechazos | Baja la tasa de aceptación; 3 ignoradas seguidas → desconexión | PedidosYa: baja el % de aceptación y el grupo |
| Avisos | Conexión siempre abierta, latido cada 4 s, reconexión a los ~7 s | Push; en segundo plano no autoacepta |
| Privacidad | Zona aproximada antes de aceptar; direcciones borradas después | Rappi le da a la tienda el ETA, no el GPS en vivo |
| Equilibrio | Surge y mapa de ganancias | **Turnos reservados por grupos** (PedidosYa: G1 elige primero), liberar turno con plazos (>8 h libre, <1 h no), "Repartir ahora" sin reserva |

## Lo que aprendí

- La rapidez no sale del algoritmo sofisticado sino de **tres cosas simples**: oferta con plazo corto, pasar al siguiente automáticamente y avisos que llegan sí o sí.
- Rankear por **tiempo de llegada** y no por kilómetros.
- **Ubicación aproximada antes, exacta después** del acuerdo, y retención corta.
- Combinar **disponibilidad reservada** (turnos) con **"disponible ahora"** para urgencias.
- Castigar rechazos es lo más criticado y, en Argentina, un indicio de relación laboral (estudio Fundar 2022).

## Ideas para mis proyectos

- Turno urgente: ofrecer a 5-10 cercanos a la vez, gana el primero que acepta (transacción en Postgres), plazo de pocos minutos y siguiente tanda automática.
- Push con prioridad alta y tiempo de vida + respaldo por WhatsApp/SMS.
- No penalizar rechazos; premiar cumplimiento.
- Validar el encuadre laboral con un abogado (CCT 389/04 gastronómico, empresas de servicios eventuales); el régimen de plataformas de reparto probablemente no aplica.

## Fuentes principales

- Uber: https://www.uber.com/blog/h3/ · https://www.uber.com/us/en/marketplace/matching/ · https://www.uber.com/blog/real-time-push-platform/ · https://www.uber.com/blog/deepeta-how-uber-predicts-arrival-times/ · https://www.uber.com/blog/building-ubers-fulfillment-platform/ · https://www.infoq.com/news/2015/03/uber-realtime-market-platform · patente US 12,250,264
- PedidosYa riders AR: https://riders.repartosya.com.ar/categorias/horarios.html · https://riders.repartosya.com.ar/categorias/pedidos.html
- Rappi: https://dev-portal.rappi.com/en/managing-user-orders/ · Fundar 2022: https://fund.ar/wp-content/uploads/2022/11/Gestion_algoritmica_Plataformas-Doc2.pdf
- iFood: https://canaltech.com.br/apps/ifood-lanca-funcao-que-deixa-entregador-escolher-a-propria-rota/

## Pendientes

- Varias páginas de Uber y el blog de Rappi no se pudieron leer completas (bloqueo de descarga); se usaron resúmenes del buscador.
- Verificar en el Boletín Oficial la ley de plataformas citada en prensa (27.802) y su alcance.
- Practicar REA con apps abiertas equivalentes (Traccar Client, app de Fleetbase).
