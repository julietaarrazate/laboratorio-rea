#!/bin/bash
# Configuración del entorno: Ghidra + REA conectado a Claude Code
set -e

# 1) Ghidra (gratis, ~1 GB, versión que pide REA 6.4.0). Usa el Java 21 que ya trae el entorno.
GHIDRA_DIR=/opt/ghidra
if ! grep -q "application.version=12.1.4" "$GHIDRA_DIR/Ghidra/application.properties" 2>/dev/null; then
  rm -rf "$GHIDRA_DIR"
  curl -fsSL -o /tmp/ghidra.zip \
    https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_12.1.4_build/ghidra_12.1.4_PUBLIC_20260921.zip
  unzip -q /tmp/ghidra.zip -d /opt
  mv /opt/ghidra_12.1.4_PUBLIC "$GHIDRA_DIR"
  rm -f /tmp/ghidra.zip
fi
export GHIDRA_INSTALL_DIR="$GHIDRA_DIR"

# 1b) Herramientas de Android para REA (gratis, código abierto, Apache 2.0):
#     JADX headless MCP (decompilador, versión auditada por REA) y Apktool (recursos).
TOOLS_DIR=/opt/rea-tools
mkdir -p "$TOOLS_DIR"
JADX_JAR="$TOOLS_DIR/jadx-headless-mcp-0.7.1-all.jar"
if ! echo "6e5eacf500b64292bfb73c49797c1958f6ee44646e43e868039ae7feb573ff75  $JADX_JAR" | sha256sum -c --quiet - 2>/dev/null; then
  curl -fsSL -o "$JADX_JAR" \
    https://github.com/1013503897/jadx-headless-mcp/releases/download/v0.7.1/jadx-headless-mcp-0.7.1-all.jar
  echo "6e5eacf500b64292bfb73c49797c1958f6ee44646e43e868039ae7feb573ff75  $JADX_JAR" | sha256sum -c -
fi
APKTOOL_JAR="$TOOLS_DIR/apktool_2.12.1.jar"
if ! echo "66cf4524a4a45a7f56567d08b2c9b6ec237bcdd78cee69fd4a59c8a0243aeafa  $APKTOOL_JAR" | sha256sum -c --quiet - 2>/dev/null; then
  curl -fsSL -o "$APKTOOL_JAR" \
    https://github.com/iBotPeaches/Apktool/releases/download/v2.12.1/apktool_2.12.1.jar
  echo "66cf4524a4a45a7f56567d08b2c9b6ec237bcdd78cee69fd4a59c8a0243aeafa  $APKTOOL_JAR" | sha256sum -c -
fi
printf '#!/bin/sh\nexec java -jar %s "$@"\n' "$APKTOOL_JAR" > "$TOOLS_DIR/apktool"
chmod +x "$TOOLS_DIR/apktool"

# 2) REA: conecta el servidor MCP e instala su habilidad para Claude Code
npx -y rea-agents@6.4.0 setup --client claude_code --yes

# 3) Le dice al servidor de REA dónde están Ghidra, JADX y Apktool
node -e '
const fs = require("fs"), f = process.env.HOME + "/.claude.json";
const c = JSON.parse(fs.readFileSync(f, "utf8"));
for (const s of Object.values(c.mcpServers || {})) {
  if ((s.args || []).some(a => String(a).startsWith("rea-agents"))) {
    s.env = { ...(s.env || {}), GHIDRA_INSTALL_DIR: "/opt/ghidra",
      REA_JADX_MCP_JAR: "/opt/rea-tools/jadx-headless-mcp-0.7.1-all.jar",
      REA_APKTOOL_COMMAND: "/opt/rea-tools/apktool" };
  }
}
fs.writeFileSync(f, JSON.stringify(c, null, 2));
'

echo "REA + Ghidra listos"
