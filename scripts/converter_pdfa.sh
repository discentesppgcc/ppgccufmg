#!/usr/bin/env bash
#
# Converte um PDF comum (não PDF/A) para PDF/A usando o Ghostscript.
#
# Útil quando a ficha catalográfica (fornecida pela biblioteca) ou a folha
# de aprovação (fornecida pela secretaria/colegiado) não estão em PDF/A: a
# classe ppgccufmg insere esses arquivos como estão no documento final, então
# se algum deles não for PDF/A, a tese/dissertação gerada também deixa de
# ser PDF/A -- veja a seção "PDF/A" do README.
#
# Uso:
#   ./scripts/converter_pdfa.sh <entrada.pdf> [saida.pdf] [nivel]
#
# Exemplos:
#   ./scripts/converter_pdfa.sh folhadeaprovacao.pdf
#   ./scripts/converter_pdfa.sh ficha.pdf ficha_pdfa.pdf 1
#
# nivel: 1, 2 (padrão) ou 3 -- deve casar com a opção de classe usada na
# compilação (pdfa1b, pdfa2b ou pdfa3b). saida, se omitido, vira
# "<entrada>_pdfa.pdf".
#
# Importante: apenas rodar "gs -dPDFA=2 -sDEVICE=pdfwrite ..." sem mais nada
# gera um PDF que parece PDF/A (tem um stream de metadados) mas costuma
# FALHAR a validação real, por não incluir um perfil de cor (OutputIntent).
# Este script usa o arquivo de prefixo PDFA_def.ps que acompanha o
# Ghostscript para incluir esse perfil corretamente.

set -euo pipefail

if [ "$#" -lt 1 ]; then
	echo "Uso: $0 <entrada.pdf> [saida.pdf] [nivel]" >&2
	echo "  nivel: 1, 2 (padrão) ou 3" >&2
	exit 1
fi

ENTRADA="$1"
NIVEL="${3:-2}"
SAIDA="${2:-$(basename "$ENTRADA" .pdf)_pdfa.pdf}"

if [ ! -f "$ENTRADA" ]; then
	echo "Erro: arquivo '$ENTRADA' não encontrado." >&2
	exit 1
fi

case "$NIVEL" in
	1|2|3) ;;
	*)
		echo "Erro: nível '$NIVEL' inválido. Use 1, 2 ou 3." >&2
		exit 1
		;;
esac

if [ "$(cd "$(dirname "$ENTRADA")" && pwd)/$(basename "$ENTRADA")" = "$(cd "$(dirname "$SAIDA")" 2>/dev/null && pwd)/$(basename "$SAIDA")" 2>/dev/null ]; then
	echo "Erro: o arquivo de saída não pode ser igual ao de entrada ('$ENTRADA')." >&2
	exit 1
fi

if ! command -v gs >/dev/null 2>&1; then
	cat >&2 <<'EOF'
Erro: o comando 'gs' (Ghostscript) não foi encontrado no PATH.

Instale o Ghostscript antes de rodar este script:
  - macOS (Homebrew): brew install ghostscript
  - Linux (Debian/Ubuntu): sudo apt install ghostscript
  - Windows: baixe em https://ghostscript.com/releases/gsdnld.html
EOF
	exit 1
fi

# Localiza os arquivos PDFA_def.ps e srgb.icc que acompanham o Ghostscript.
# Sem eles o PDF resultante não inclui um perfil de cor (OutputIntent) e
# falha a validação de PDF/A, mesmo compilando sem erros no Ghostscript.
BUSCA_BASES=(
	"$(command -v brew >/dev/null 2>&1 && brew --prefix ghostscript 2>/dev/null || true)"
	/opt/homebrew/Cellar/ghostscript
	/usr/share/ghostscript
	/usr/local/share/ghostscript
	/usr/lib/ghostscript
)

PDFA_DEF=""
ICC_PROFILE=""
for base in "${BUSCA_BASES[@]}"; do
	[ -n "$base" ] && [ -d "$base" ] || continue
	if [ -z "$PDFA_DEF" ]; then
		PDFA_DEF="$(find "$base" -iname 'PDFA_def.ps' 2>/dev/null | head -n1)"
	fi
	if [ -z "$ICC_PROFILE" ]; then
		ICC_PROFILE="$(find "$base" -iname 'srgb.icc' 2>/dev/null | head -n1)"
	fi
done

if [ -z "$PDFA_DEF" ] || [ -z "$ICC_PROFILE" ]; then
	cat >&2 <<EOF
Erro: não foi possível localizar automaticamente os arquivos PDFA_def.ps
e/ou srgb.icc que acompanham a instalação do Ghostscript.

Localize-os manualmente (geralmente dentro da pasta de instalação do
Ghostscript, em algo como .../lib/PDFA_def.ps e .../iccprofiles/srgb.icc)
e rode o comando abaixo a partir do diretório onde eles estão, substituindo
srgb.icc pelo caminho completo do perfil dentro de PDFA_def.ps:

  gs -dNOSAFER -dPDFA=${NIVEL} -dBATCH -dNOPAUSE -dNOOUTERSAVE \\
     -sColorConversionStrategy=RGB -sProcessColorModel=DeviceRGB \\
     -sDEVICE=pdfwrite -dPDFACompatibilityPolicy=1 \\
     -sOutputFile="$SAIDA" PDFA_def.ps "$ENTRADA"
EOF
	exit 1
fi

# PDFA_def.ps referencia o perfil de cor por um caminho relativo (srgb.icc).
# Geramos uma cópia temporária do prefixo já com o caminho absoluto do
# perfil encontrado, para não depender do diretório onde o script é chamado.
TMPDIR_CONV="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_CONV"' EXIT

TITULO="$(basename "$SAIDA" .pdf)"
sed -e "s|(srgb\.icc)|($ICC_PROFILE)|" \
    -e "s|/Title (Title)|/Title ($TITULO)|" \
    "$PDFA_DEF" > "$TMPDIR_CONV/PDFA_def.ps"

echo "Ghostscript: $(gs --version)"
echo "PDFA_def.ps: $PDFA_DEF"
echo "Perfil de cor: $ICC_PROFILE"
echo "Convertendo '$ENTRADA' para PDF/A-${NIVEL}b..."
echo

# -dNOSAFER é necessário para o Ghostscript conseguir ler o perfil de cor
# acima. Use este script apenas com PDFs em que você confia (seus próprios
# documentos institucionais), não com arquivos de origem desconhecida.
gs -dNOSAFER -dPDFA="$NIVEL" -dBATCH -dNOPAUSE -dNOOUTERSAVE \
   -sColorConversionStrategy=RGB -sProcessColorModel=DeviceRGB \
   -sDEVICE=pdfwrite -dPDFACompatibilityPolicy=1 \
   -sOutputFile="$SAIDA" "$TMPDIR_CONV/PDFA_def.ps" "$ENTRADA"

echo
echo "Arquivo gerado: $SAIDA"
echo "Recomendado: valide o resultado com ./scripts/validar_pdfa.sh \"$SAIDA\" ${NIVEL}b"
