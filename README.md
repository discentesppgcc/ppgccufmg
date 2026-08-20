# Classe LaTeX ppgccufmg
Uma classe $\LaTeX$ para dissertações, teses e propostas do Programa de Pós-Graduação em Ciência da Computação (PPGCC) da Universidade Federal de Minas Gerais (UFMG). A classe foi feita de modo a atender todas as diretrizes para normalização de trabalhos acadêmicos da UFMG determinadas pelo Reposiório Institucional da UFMG (versão 2025) (arquivo ```diretrizes/Diretrizes - Repositorio Institucional UFMG - versao 2025.pdf```).

A criação desta classe foi inspirada na classe criada por Vilar Fiuza da Camara Neto e Eduardo Freire Nakamura.

# Orientações da biblioteca
Para que seu trabalho seja aceito, deve-se seguir as seguintes orientações para formatação:
- **Imagens:**
    - A legenda da imagem deve estar **acima** dela. Para isto o comando ```\caption``` deve vir antes do comando ```\includegraphics``` dentro do ambiente ```\begin{figure}...\end{figure}```.
    - A fonte deve estar **abaixo** da imagem e em tamanho menor. O texto deve ser incluído dentro do comando ```\small{}``` logo após o comando ```\includegraphics``` e dentro do comando ```\begin{figure}...\end{figure}```. 
    - Exemplo de uso:
    ```
    \begin{figure}[h]
        \centering
        \caption{Diagrama de Venn.}
        \label{fig:exemplo}
        \includegraphics[width=\textwidth]{img/diagrama_de_venn.jpg}
        \small{Fonte: Elaborado pelo autor(a).}
    \end{figure}
    ```
- **Palavras-chave:** Tanto no resumo em português quanto no *abstract* em inglês, elas devem ser redigidas com a inicial maiúscula, separadas entre si com ponto final e finalizadas
também com ponto final.
- **Referências:** Para trabalhos escritos em português, o título da seção de referências deve ser *"Referências"* e não *"Referências Bibliográficas"*, que é o padrão do pacote ```natbib```. No arquivo de exemplo há o comando ```\renewcommand\bibname{Referências}``` que faz esta mudança.

# Como utilizar a classe
Para utilizar os recursos da classe, o arquivo ```pgccufmg.cls``` deve estar no mesmo diretório que o arquivo ```.tex``` principal. Há um exemplo de utilização da classe no diretório ```exemplo``` deste repositório. A classe foi testada tanto com o [TeXstudio](https://www.texstudio.org/) para compilações locais tanto com o [Overleaf](https://overleaf.com/).

## Opções da classe
 Para se utilizar a classe, deve-se declarar o tipo do documento com o comando

    \documentclass[<opções>]{ppgccufmg}

Há 6 opções relacionadas ao tipo e ao idioma do documento que podem ser passadas para a classe:
- Tipo do documento:
    - ```msc```: Dissertação de mestrado.
    - ```phd```: Tese de doutorado.
    - ```mscproposta```: Proposta de dissertação de mestrado.
    - ```phdproposta```: Proposta de tese de doutorado.
- Idioma do documento:
    - ```portugues```: Define o idioma geral para português. 
    - ```english```: Adiciona a folha de rosto em inglẽs e define o idioma geral para inglês.

Obs.: Deve ser passado **somente** um tipo de documento e um idioma. Caso essa regra seja quebrada, a classe poderá apresentar um comportamento inesperado.

## Parâmetros
A classe consta com uma lista de parâmetros que modifica os principais elementos textuais e pré-textuais do documento. Todos os parâmetros devem ser passados no comando ```\ppgccufmg{}``` que deve estar localizado logo após o comando ```\begin{document}```. Os parâmetros disponíveis são:

| Parâmetro | Descrição | Tipo  |
| :---     | :---      | :--- |
| ```autor``` | Autor(a) do documento | Obrigatório |
| ```titulo``` | Título do documento (em inglês ou português) | Obrigatório |
| ```cidade``` | A cidade aparecerá na capa e na(s) folha(s) de rosto | Obrigatório |
| ```ano``` | O ano aparecerá na capa e na(s) folha(s) de rosto | Obrigatório |
| ```versao``` | Versão do documento. Deverá ser "Final" quando a  dissertação/tese estiver sendo entregue. Poderá ser, por exemplo, "temporária", "inicial". O texto passado como parâmetro será incluído logo após a palavra "Versão" na folha de rosto (caso o idioma do documento seja português) ou antes da palavra "Version" (caso o idioma do documento seja inglês) | Obrigatório |
| ```orientador``` | Nome do orientador | Obrigatório quando não houver uma orientadora |
| ```orientadora``` | Nome da orientadora | Obrigatório quando não houver um orientador |
| ```coorientador``` | Nome do orientador | Opcional |
| ```coorientadora``` | Nome da orientadora | Opcional |
| ```fichacatalografica``` | Arquivo PDF contendo a ficha catalográfica que será fornecida pela biblioteca. **⚠️ Deve ser um PDF/A** — veja [PDF/A](#pdfa) | Opcional |
| ```folhadeaprovacao``` | Arquivo PDF contendo a folha de aprovação. **⚠️ Deve ser um PDF/A** — veja [PDF/A](#pdfa) | Opcional |
| ```resumo``` | Arquivo .tex contendo o resumo em português | Obrigatório |
| ```abstracten``` | Arquivo .tex contendo o abstract em inglês | Obrigatório |
| ```palavraschave``` | Palavras-chave do resumo em português | Obrigatório |
| ```keywords``` | Palavras-chave do abstract em inglês | Obrigatório |
| ```dedicatoria``` | Arquivo .tex contendo a dedicatória | Opcional
| ```agradecimentos``` | Arquivo .tex contendo os agradecimentos | Opcional |
| ```epigrafe``` | Arquivo .tex contendo o epígrafe | Opcional |
| ```epigrafeautor``` | Nome do(a) autor(a) do epígrafe | Opcional |
| ```listadefiguras``` | Comando que funciona como uma *flag* que indica se a lista de figuras será gerada ou não. Passe o parâmetro com algum argumento (por exemplo, "sim") para gerar a lista de figuras ou não passe-o caso não queria gerar a lista. | Opcional |
| ```listadetabelas``` | Comando que funciona como uma *flag* que indica se a lista de tabelas será gerada ou não. Passe o parâmetro com algum argumento (por exemplo, "sim") para gerar a lista de tabelas ou não passe-o caso não queria gerar a lista. | Opcional |
| ```listascustomizadas``` | Comando para a lista customizada. No arquivo de exemplo há instruções de como criar uma lista customizada | Opcional |

## Outros recursos
Para adicionar apêncices ao documento, a classe fornece o ambiente ```apendices```. Todos os apêncices devem ser adicionados após a inclusão das referências bibliográficas (comando ```\bibliography```). Todos os apêncies deverão estar dentro dos comandos ```\begin{appendices}``` e ```\end{appendices}```, conforme exemplo abaixo:

    \begin{apendices}
        \chapter{Meu primeiro apêncice}
            ...
        
        \chapter{Meu segundo apêndice}
            ...
    \end{apendices}

O comando ```\chapter{}``` define o início de um novo apêndice.

## Como alterar as opções do `hyperref`
Como a classe já carrega o pacote ```hyperref``` internamente (com as opções necessárias para PDF/A), **não** use ```\usepackage{hyperref}``` no seu arquivo ```.tex``` — isso pode gerar conflito de opções. Para configurar cores de link, metadados extras etc., use ```\hypersetup{}``` diretamente no preâmbulo, como no arquivo de exemplo:
```
\hypersetup{
	colorlinks=true,
	linkcolor=blue, %% Cor dos links do sumário
	citecolor=red, %% Cor dos links das citações
	urlcolor=magenta, %% Cor das urls
}
```

## PDF/A
A partir da versão 2025 das diretrizes do Repositório Institucional da UFMG, o arquivo final da dissertação/tese deve ser entregue em formato **PDF/A**. A classe ```ppgccufmg``` gera PDF/A automaticamente (padrão a-2b, usando o pacote [```pdfx```](https://ctan.org/pkg/pdfx)) — não é necessário fazer nada além do uso normal da classe.

## ⚠️ Ficha catalográfica e folha de aprovação
Os arquivos passados nos parâmetros ```fichacatalografica``` e ```folhadeaprovacao``` são inseridos no documento como estão (via ```\includepdf```). A classe **não consegue convertê-los** para PDF/A — se algum deles não for PDF/A (por exemplo, um PDF escaneado comum, ou exportado por outro sistema sem esse cuidado), **o documento final deixa de ser um PDF/A válido**, mesmo que todo o resto tenha sido gerado corretamente. Em alguns casos (por exemplo, PDF protegido/criptografado) isso pode até impedir a compilação.

Portanto, **sempre verifique que a ficha catalográfica (fornecida pela biblioteca) e a folha de aprovação (fornecida pelo colegiado/secretaria) já estão em formato PDF/A** antes de compilar a versão final — caso contrário a classe ```ppgccufmg``` não vai gerar um PDF/A válido, mesmo com todo o resto correto.

Se algum dos dois só estiver disponível em PDF comum, use o script auxiliar ```scripts/converter_pdfa.sh``` deste repositório para convertê-lo:
```
./scripts/converter_pdfa.sh folhadeaprovacao.pdf
```
Isso gera ```folhadeaprovacao_pdfa.pdf``` já em PDF/A, pronto para ser usado no parâmetro ```folhadeaprovacao``` do comando ```\ppgccufmg{}```. Também é possível escolher o nome do arquivo de saída:
```
./scripts/converter_pdfa.sh ficha.pdf ficha_pdfa.pdf
```
O script exige o [Ghostscript](https://ghostscript.com) instalado (```brew install ghostscript``` no macOS, ```sudo apt install ghostscript``` no Linux). Depois de converter, **sempre valide o resultado** com ```./scripts/validar_pdfa.sh``` (veja a próxima seção) — não confie apenas na ausência de erros do Ghostscript.

## Validando o PDF/A gerado
Compilar sem erros **não** garante conformidade com o PDF/A — a validação real exige inspecionar a estrutura do arquivo já compilado. Depois de gerar o PDF, valide-o com o script auxiliar deste repositório:
```
./scripts/validar_pdfa.sh exemplo/exemplo.pdf
```
O script usa o [veraPDF](https://verapdf.org), a ferramenta de validação de PDF/A de referência open source. Caso não esteja instalado:
- macOS (Homebrew): ```brew install verapdf```
- Linux/Windows: baixe o instalador em [verapdf.org/software](https://verapdf.org/software/) (requer Java).

# License
[MIT](https://choosealicense.com/licenses/mit)