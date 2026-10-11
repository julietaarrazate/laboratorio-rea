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

# 2) REA: conecta el servidor MCP e instala su habilidad para Claude Code
npx -y rea-agents@6.4.0 setup --client claude_code --yes

# 3) Le dice al servidor de REA dónde está Ghidra
node -e '
const fs = require("fs"), f = process.env.HOME + "/.claude.json";
const c = JSON.parse(fs.readFileSync(f, "utf8"));
for (const s of Object.values(c.mcpServers || {})) {
  if ((s.args || []).some(a => String(a).startsWith("rea-agents"))) {
    s.env = { ...(s.env || {}), GHIDRA_INSTALL_DIR: "/opt/ghidra" };
  }
}
fs.writeFileSync(f, JSON.stringify(c, null, 2));
'

echo "REA + Ghidra listos"
