#!/usr/bin/env bash
set -euo pipefail

# Recolhe informação básica de sistema Linux e guarda num ficheiro.

OUTPUT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)/output"
mkdir -p "$OUTPUT_DIR"

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
OUTPUT_FILE="$OUTPUT_DIR/linux_inventory_${TIMESTAMP}.txt"

{
  echo "=== INVENTÁRIO LINUX ==="
  echo "Data: $(date)"
  echo "Hostname: $(hostname)"
  echo "Utilizador: $(whoami)"
  echo

  echo "=== SISTEMA ==="
  uname -a
  echo
  if command -v lsb_release >/dev/null 2>&1; then
    lsb_release -a 2>/dev/null || true
  fi
  echo

  echo "=== CPU / MEMÓRIA ==="
  grep "model name" /proc/cpuinfo | head -n 1 || true
  free -h
  echo

  echo "=== DISCOS ==="
  df -h
  echo

  echo "=== REDE ==="
  ip addr show || true
  echo
  ip route || true
  echo

  echo "=== DNS ==="
  cat /etc/resolv.conf || true
} > "$OUTPUT_FILE"

echo "Relatório criado em: $OUTPUT_FILE"
