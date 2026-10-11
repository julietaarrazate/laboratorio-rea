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
- Si REA no aparece, el script de configuración no corrió: ver `scripts/setup-rea.sh` y verificar con `GHIDRA_INSTALL_DIR=/opt/ghidra npx -y rea-agents@6.4.0 doctor`.
- Los archivos a analizar van en `muestras/` (ignorada por git). Exportar hallazgos de REA a `notas/<proyecto>/` si son útiles para retomar.

## Reglas

- **El repo es público.** No guardar notas de proyectos privados (por ejemplo `control-operativo`), ni claves, ni datos personales.
- Analizar solo software que la dueña tenga derecho a estudiar (código abierto, propio, o con permiso).
- Nueva nota: copiar `notas/_plantilla.md` a `notas/<nombre-del-proyecto>.md`.

## Índice de análisis

| Proyecto | Nota | Estado | Última actualización |
|---|---|---|---|
| Rebill (sitio web) | [notas/rebill.md](notas/rebill.md) | en curso | 2026-10-11 |
