# Laboratorio REA — instrucciones para Claude

Laboratorio de aprendizaje por ingeniería inversa. La dueña aprende cómo funcionan otros proyectos para mejorar los suyos.

## Idioma

Responder siempre en **español**, claro y simple, explicando los términos técnicos.

## Ahorro de contexto (importante)

- Antes de analizar un proyecto, mirar el **Índice** de abajo. Si ya tiene nota en `notas/`, leer **solo la nota** y continuar desde ahí; releer código solo para lo nuevo.
- Al terminar o pausar un análisis, **actualizar la nota** y el índice, y hacer commit. Lo que no esté en git se pierde al cerrar la sesión.
- Las notas resumen (arquitectura, flujos, decisiones, ideas); no copiar código largo, citar `archivo:línea` con el link al repo.

## Herramientas

- **Código fuente** (repos): leerlo directo con las herramientas normales. No usar REA.
- **Programas compilados** (`.exe`, `.so`, `.apk`, firmware, apps Electron empaquetadas): usar REA (servidor MCP `rea` + habilidad `reverse-engineer-anything`) con Ghidra en `/opt/ghidra`.
- Si REA no aparece, el script de configuración no corrió: ver `scripts/setup-rea.sh` y verificar con `GHIDRA_INSTALL_DIR=/opt/ghidra npx -y rea-agents@6.5.0 doctor`.
- Los archivos a analizar van en `muestras/` (ignorada por git). Exportar hallazgos de REA a `notas/<proyecto>/` si son útiles para retomar.

## Reglas

- **El repo es público.** No guardar notas de proyectos privados (por ejemplo `control-operativo`), ni claves, ni datos personales.
- Se puede estudiar **cualquier app, sistema o software** (incluidas apps cerradas de terceros), siempre con fines exclusivamente de estudio y aprendizaje.
- Con software cerrado de terceros:
  - Análisis estático de la copia local en `muestras/` (sin subirla a git).
  - No extraer ni usar claves o credenciales, no esquivar protecciones de pago o licencias, no atacar ni sobrecargar sus servidores.
  - Las notas explican con palabras propias cómo funciona; no copiar su código, textos ni recursos.
  - Si una nota revela fallas de seguridad de un tercero, no guardarla en este repo público.
- Nueva nota: copiar `notas/_plantilla.md` a `notas/<nombre-del-proyecto>.md`.

## Índice de análisis

| Proyecto | Nota | Estado | Última actualización |
|---|---|---|---|
| Rebill (sitio web) | [notas/rebill.md](notas/rebill.md) | en curso | 2026-10-11 |
| Despacho Uber / Rappi (fuentes públicas) | [notas/despacho-uber-rappi.md](notas/despacho-uber-rappi.md) | en curso | 2026-10-11 |
| Apps móviles: Uber Driver, Rappi, Morfy, Pasito | [notas/apps-moviles-referencia.md](notas/apps-moviles-referencia.md) | en curso | 2026-10-11 |
| Qwick (app de profesionales) | [notas/qwick.md](notas/qwick.md) | en curso | 2026-10-11 |
| Instawork (app de trabajadores) | [notas/instawork.md](notas/instawork.md) | en curso | 2026-10-11 |
| inDrive (negociación de precio) | [notas/indrive.md](notas/indrive.md) | en curso | 2026-10-11 |
| Tegu y Clickie (servicios para el hogar, web) | [notas/tegu-clickie.md](notas/tegu-clickie.md) | en curso | 2026-10-11 |
| TitoFree (empleo gastronómico, competidor) | [notas/titofree.md](notas/titofree.md) | en curso | 2026-10-11 |
