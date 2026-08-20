#!/usr/bin/env bash
#
# Valida se um PDF gerado pela classe ppgccufmg está em conformidade com o
# nível de PDF/A configurado, usando o veraPDF (https://verapdf.org).
#
# Uso:
#   ./scripts/validar_pdfa.sh <arquivo.pdf> [flavour]
#
# Exemplos:
#   ./scripts/validar_pdfa.sh exemplo/exemplo.pdf
#   ./scripts/validar_pdfa.sh exemplo/exemplo.pdf 1b
#
# O "flavour" (nível de PDF/A a validar) é opcional e deve casar com a opção
# de classe usada na compilação (pdfa1b, pdfa2b ou pdfa3b). Padrão: 2b, que
# é o nível padrão da classe.

set -euo pipefail

if [ "$#" -lt 1 ]; then
	echo "Uso: $0 <arquivo.pdf> [flavour]" >&2
	echo "  flavour: 1b, 2b (padrão) ou 3b" >&2
	exit 1
fi

ARQUIVO="$1"
FLAVOUR="${2:-2b}"

if [ ! -f "$ARQUIVO" ]; then
	echo "Erro: arquivo '$ARQUIVO' não encontrado." >&2
	exit 1
fi

if ! command -v verapdf >/dev/null 2>&1; then
	cat >&2 <<'EOF'
Erro: o comando 'verapdf' não foi encontrado no PATH.

Instale o veraPDF antes de rodar este script:
  - macOS (Homebrew): brew install verapdf
  - Linux/Windows: baixe o instalador em https://verapdf.org/software/
    e siga as instruções (requer Java).
EOF
	exit 1
fi

echo "Validando '$ARQUIVO' contra PDF/A-${FLAVOUR}..."
echo

verapdf --flavour "$FLAVOUR" --format text "$ARQUIVO"
