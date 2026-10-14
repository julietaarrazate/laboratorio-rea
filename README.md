# Laboratorio REA

Espacio para aprender cómo funcionan otros proyectos (ingeniería inversa) y anotar ideas para mejorar los propios.

## Qué hay acá

| Carpeta / archivo | Para qué sirve |
|---|---|
| `CLAUDE.md` | Lo que Claude lee al empezar cada sesión: reglas de trabajo e índice de lo ya analizado. |
| `notas/` | Un archivo por proyecto analizado: arquitectura, flujos, ideas. |
| `notas/_plantilla.md` | Plantilla para empezar una nota nueva. |
| `scripts/setup-rea.sh` | Copia del script de configuración del entorno (Ghidra + REA). |
| `muestras/` | Programas o archivos a analizar. **No se suben a GitHub** (están en `.gitignore`). |

## Herramientas

- **REA** (`rea-agents` 6.5.0): ingeniería inversa desde Claude Code (servidor MCP + habilidad).
- **Ghidra 12.1.4**: decompilador gratuito que REA usa para analizar programas compilados (`.exe`, `.so`, apps, firmware).

Para leer **código fuente** (repos de GitHub) no hacen falta: Claude lo lee directamente.

## Configurar el entorno en la nube

El script `scripts/setup-rea.sh` va pegado en la configuración del entorno:
menú del entorno (arriba en la sesión) → **Edit** → **Setup script**.
Se ejecuta solo al iniciar cada sesión nueva (~20 segundos).

Si cambia la versión de REA, revisar qué versión de Ghidra pide con:

```bash
GHIDRA_INSTALL_DIR=/opt/ghidra npx -y rea-agents@6.5.0 doctor
```

## Cómo pedir un análisis

- "Analizá el repo X y armá la nota" → lee el código y crea `notas/x.md`.
- "Seguí con la nota de X" → lee solo la nota, sin releer todo el proyecto.
- "Decompilá este programa" (dejándolo en `muestras/`) → usa REA + Ghidra.
