%% Identificação da classe %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ppgccufmg}[2022/05/26 Classe Uma classe LaTeX para dissertações, teses e propostas do Programa de Pós-Graduação em Ciência da Computação (PPGCC) da Universidade Federal de Minas Gerais (UFMG).]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% DECLARAÇÕES PRELIMINARES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Comandos auxiliares ======================
\newenvironment{recuoesquerdaoitocm}{	
	\begin{flushleft} %% Alinha o texto à esquerda
	\leftskip=5cm %% Adiciona 5cm além da margem esquerda de 3cm, totalizando 8cm
}{\end{flushleft}}
%% ==========================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%  OPÇÕES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Obs.: os corpos dos \DeclareOption abaixo usam \def\algumaflag{} (com
%% chaves vazias), e não \def\algumaflag sozinho. Sem as chaves, \def fica
%% incompleto e, ao ser executado dentro de \ProcessOptions, "rouba" os
%% tokens seguintes do fluxo de processamento das opções à procura de um
%% corpo -- o que corrompe o processamento de qualquer opção declarada
%% depois dela na mesma compilação (bug real encontrado ao testar as novas
%% opções de PDF/A abaixo, que só se manifestava quando havia opções
%% suficientes em uso simultaneamente).
\DeclareOption{portugues}{\def\idiomapt{}} %% Define português como sendo o idioma do documento
\DeclareOption{english}{\def\idiomaen{}} %% Define inglês como sendo o idioma do documento
\DeclareOption{msc}{\def\msc{}} %% Dissertação de mestrado
\DeclareOption{phd}{\def\phd{}} %% Tese de doutorado
\DeclareOption{mscproposta}{\def\mscproposta{}} %% Proposta de dissertação de mestrado
\DeclareOption{phdproposta}{\def\phdproposta{}} %% Proposta de tese de doutorado

%% Nível de conformidade PDF/A exigido pelo RI-UFMG (padrão: a-2b) =========
\newif\ifppgccufmgpdfa
\ppgccufmgpdfatrue
\def\ppgccufmgpdfalevel{a-2b}
\DeclareOption{pdfa1b}{\def\ppgccufmgpdfalevel{a-1b}}
\DeclareOption{pdfa2b}{\def\ppgccufmgpdfalevel{a-2b}}
\DeclareOption{pdfa3b}{\def\ppgccufmgpdfalevel{a-3b}}
\DeclareOption{semvalidacaopdfa}{\ppgccufmgpdfafalse} %% Desliga a geração de PDF/A (ex.: rascunhos)
%% ==========================================================================

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}
\ProcessOptions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\LoadClass[a4paper, %% Tipo da folha
	12pt, %% Tamanho da fonte
	oneside
]{memoir}

%% OUTRAS DECLARAÇÕES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Geração de PDF/A =========================
%% pdfx precisa ser o primeiro pacote carregado no documento (antes de
%% hyperref e de qualquer outro pacote), por isso vem logo após o \LoadClass.
%% Ele carrega o hyperref internamente já configurado para PDF/A: não
%% carregue o hyperref novamente no seu .tex, use \hypersetup{} (veja README).
\ifppgccufmgpdfa
	\RequirePackage[\ppgccufmgpdfalevel]{pdfx}
\else
	%% Com a opção semvalidacaopdfa o pdfx não é carregado, mas o hyperref
	%% ainda é necessário (para \hypersetup{} funcionar, links, sumário, etc.)
	\RequirePackage{hyperref}
\fi
%% ==========================================

%% Pacotes ==================================
\RequirePackage[T1]{fontenc} %% Garante fontes com acentuação incorporável (necessário para PDF/A)
\RequirePackage{lmodern} %% Fontes Latin Modern vetoriais (evita fallback bitmap)
\RequirePackage[
	a4paper,
	left=3cm,
	right=2cm,
	top=3cm,
	bottom=2cm
]{geometry} %% Usado para definir tamanho das margens
\RequirePackage{fancyhdr} %% Usado para colocar a numeração no canto superior direito da página
\RequirePackage{pdfpages} %% Inclusão de pdfs
\RequirePackage{xkeyval} %% Utilizar keys no comando ppgccufmg
\RequirePackage{xstring} %% Utilizar \IfStrEq
%% ==========================================

%% Estilos de páginas =======================

%% Define o estilo padrão da maioria das páginas do documento. estilopadrao é uma modificação do estilo 'fancy', do pacote fancyhdr
\fancypagestyle{estilopadrao}[fancydefault]{
	\fancyhf{} %% Reseta o que tem no header e footer (deixa tudo em branco)
	\fancyhead[R]{\thepage} %% Coloca a numeração da página no canto direito do header
	\fancyhead[L]{\nouppercase{\rightmark}} %% Coloca o nome da seção no canto esquerdo do header
}

%% Altera o estilo plain que é o estilo padrão das páginas do início dos capítulos
\fancypagestyle{plain}{
	\fancyhf{}
	\renewcommand{\headrulewidth}{0pt} %% Remove a linha to header
	\fancyhead[R]{\thepage} %% Coloca a numeração da página no canto direito do header
}

%% Estilo da capa
\fancypagestyle{estilocapa}[plain]{
	\fancyhf{} %% Reseta estilo do header e footer
	\centering %% Centraliza o texto
	\SingleSpacing %% Define o espaçamento entre linhas para 1cm
}

%% ==========================================

%% Parâmetros ppgcc =========================
\define@key{ppgcc}{autor}{\defautor{#1}}
\define@key{ppgcc}{titulo}{\deftitulo{#1}} %% Título
\define@key{ppgcc}{cidade}{\defcidade{#1}}
\define@key{ppgcc}{ano}{\defano{#1}}
\define@key{ppgcc}{versao}{\defversao{#1}} %% Versão do documento
\define@key{ppgcc}{orientador}{\deforientador{#1}}
\define@key{ppgcc}{orientadora}{\deforientadora{#1}}
\define@key{ppgcc}{coorientador}{\defcoorientador{#1}}
\define@key{ppgcc}{coorientadora}{\defcoorientadora{#1}}
\define@key{ppgcc}{fichacatalografica}{\deffichacatalografica{#1}}
\define@key{ppgcc}{folhadeaprovacao}{\deffolhadeaprovacao{#1}}
\define@key{ppgcc}{resumo}{\defresumo{#1}}
\define@key{ppgcc}{abstracten}{\defabstracten{#1}}
\define@key{ppgcc}{palavraschave}{\defpalavraschave{#1}} %% Palavras-chave do resumo em português
\define@key{ppgcc}{keywords}{\defkeywords{#1}} %% Palavras-chave do abstract em inglês
\define@key{ppgcc}{epigrafe}{\defepigrafe{#1}} %% Texto do epígrafe
\define@key{ppgcc}{epigrafeautor}{\defepigrafeautor{#1}} %% Autor do epígrafe
\define@key{ppgcc}{dedicatoria}{\defdedicatoria{#1}}
\define@key{ppgcc}{agradecimentos}{\defagradecimentos{#1}}
\define@key{ppgcc}{listadefiguras}{\deflistadefiguras{#1}} %% Flag que decide se adiciona ou não a lista de figuras no documento
\define@key{ppgcc}{listadetabelas}{\deflistadetabelas{#1}} %% Flag que decide se adiciona ou não a lista de tabelas no documento
\define@key{ppgcc}{listascustomizadas}{\deflistascustomizadas{#1}}

%% Adiciona a palavra "Appendix" (ou "Apêndice") no sumário antes de "A", "B", ...
\renewcommand\cftappendixname{\appendixname~}

%% Definições dos parâmetros ppgcc
\newcommand{\defautor}[1]{\def\autor{#1}}
\newcommand{\deftitulo}[1]{\def\titulo{#1}}
\newcommand{\defcidade}[1]{\def\cidade{#1}}
\newcommand{\defano}[1]{\def\ano{#1}}
\newcommand{\defversao}[1]{\def\versao{#1}}
\newcommand{\deforientador}[1]{\def\orientador{#1}}
\newcommand{\deforientadora}[1]{\def\orientadora{#1}}
\newcommand{\defcoorientador}[1]{\def\coorientador{#1}}
\newcommand{\defcoorientadora}[1]{\def\coorientadora{#1}}
\newcommand{\deffichacatalografica}[1]{\def\fichacatalografica{#1}}
\newcommand{\deffolhadeaprovacao}[1]{\def\folhadeaprovacao{#1}}
\newcommand{\defresumo}[1]{\def\resumo{#1}}
\newcommand{\defabstracten}[1]{\def\abstracten{#1}}
\newcommand{\defpalavraschave}[1]{\def\palavraschave{#1}}
\newcommand{\defkeywords}[1]{\def\keywords{#1}}
\newcommand{\defepigrafe}[1]{\def\epigrafe{#1}}
\newcommand{\defepigrafeautor}[1]{\def\epigrafeautor{#1}}
\newcommand{\defdedicatoria}[1]{\def\dedicatoria{#1}}
\newcommand{\defagradecimentos}[1]{\def\agradecimentos{#1}}
\newcommand{\deflistadefiguras}[1]{\def\listadefiguras{#1}}
\newcommand{\deflistadetabelas}[1]{\def\listadetabelas{#1}}
\newcommand{\deflistascustomizadas}[1]{\def\listascustomizadas{#1}}
%% ==========================================


%% Comandos gerais ==========================

%% Comando para resetar o estilo plain (remover tudo do header e footer). Deve ser utilizado para as páginas de capítulos que devem estar sem numração. *** O comando deve ser utilizado dentro de \begingroup\endgroup ***
\newcommand{\resetaplain}{
	\fancypagestyle{plain}{
		\fancyhf{}
		\renewcommand{\headrulewidth}{0pt} %% Remove a linha to header
	}
}

%% Define o estilo do sumário, lista de figuras e lista de tabelas
\newcommand{\tocloftpagestyle}[1]{%
	\def\@cftpagestyle{\thispagestyle{#1}}}
\tocloftpagestyle{empty}

%% Definição da capa
\renewcommand{\maketitle}{
	\begingroup
	\pagestyle{estilocapa}
	\textbf{
		UNIVERSIDADE FEDERAL DE MINAS GERAIS\\
		Instituto de Ciências Exatas\\
		Programa de Pós-Graduação em Ciência da Computação\\
	}
	
	\vspace{5cm}

	\autor
	
	\vspace{4cm}

	\textbf{\titulo}
		
	\vfill
	
	\cidade\\
	\ano
	\clearpage %% Termina a página atual aqui
	\endgroup
}

%% Folha de rosto em português ou inglês
\newcommand{\folhaderosto}[1]{
	\begingroup
	\pagestyle{estilocapa}
	
	\autor
	
	\vspace{6cm}
	
	\textbf{\titulo}
		
	\vspace{2cm}
	
	\begin{recuoesquerdaoitocm}
		\IfStrEq{#1}{pt}{%
			\textbf{Versão} \textbf{\versao}
		}{%
			\textbf{\versao} \textbf{Version}	
		}
	\end{recuoesquerdaoitocm}

	\vspace{3cm}
	
	\hbox{ %% Comando utilizado para não ultrapassar a margem a direita
		\begin{minipage}{\textwidth}
			\leftskip=5cm
			
			%% Dissertações
			\ifx\msc\undefined\else
				\IfStrEq{#1}{pt}{%
					Dissertação apresentada ao Programa de Pós-Graduação em Ciência da Computação da Universidade Federal de Minas Gerais, como requisito parcial à obtenção do título de Mestre em Ciência da Computação.
				}{%
					Thesis presented to the Graduate Program in Computer Science of the Federal University of Minas Gerais in partial fulfillment of the requirements for the degree of Master in Computer Science.
				}
			\fi
			
			%% Tese
			\ifx\phd\undefined\else
				\IfStrEq{#1}{pt}{%
					Tese apresentada ao Programa de Pós-Graduação em Ciência da Computação da Universidade Federal de Minas Gerais, como requisito parcial à obtenção do título de Doutor em Ciência da Computação.
				}{%
					Dissertation presented to the Graduate Program in Computer Science of the Federal University of Minas Gerais in partial fulfillment of the requirements for the degree of Doctor in Computer Science.
				}
			\fi
			
			%% Proposta de dissertação
			\ifx\mscproposta\undefined\else
				\IfStrEq{#1}{pt}{%
					Proposta de dissertação apresentada ao Programa de Pós-Graduação em Ciência da Computação da Universidade Federal de Minas Gerais, como requisito parcial à obtenção do título de Mestre em Ciência da Computação.
				}{%
					Thesis proposal presented to the Graduate Program in Computer Science of the Federal University of Minas Gerais in partial fulfillment of the requirements for the degree of Master in Computer Science.
				}
			\fi
			
			%% Proposta de doutorado
			\ifx\phdproposta\undefined\else
				\IfStrEq{#1}{pt}{%
					Proposta de tese apresentada ao Programa de Pós-Graduação em Ciência da Computação da Universidade Federal de Minas Gerais, como requisito parcial à obtenção do título de Doutor em Ciência da Computação.
				}{%
					Dissertation proposal presented to the Graduate Program in Computer Science of the Federal University of Minas Gerais in partial fulfillment of the requirements for the degree of Doctor in Computer Science.
				}
			\fi
		\end{minipage}
	}

	\vspace{1.5cm}

	\begin{recuoesquerdaoitocm}
		\IfStrEq{#1}{pt}{%
			\ifx\orientador\undefined
				Orientadora: \orientadora\\
			\else
				Orientador: \orientador\\
			\fi
		}{%
			\ifx\orientador\undefined
				Advisor: \orientadora\\
			\else
				Advisor: \orientador\\
			\fi
		}
		
		\IfStrEq{#1}{pt}{%
			\ifx\coorientador\undefined
				\ifx\coorientadora\undefined\else
					Coorientadora: \coorientadora\\
				\fi
			\else
				Coorientador: \coorientador\\
			\fi
		}{%
			\ifx\coorientador\undefined
				\ifx\coorientadora\undefined\else
					Co-Advisor: \coorientadora\\
				\fi
			\else
				Co-Advisor: \coorientador\\
			\fi
		}
	\end{recuoesquerdaoitocm}

	\vfill
	
	\cidade\\
	\ano
	\clearpage %% Termina a página atual aqui
	\endgroup
}

%% Ficha catalográfica. O parâmetro deve ser o nome do arquivo com a extensão .pdf
\newcommand{\fazfichacatalografica}[1]{
	\includepdf[pages=-]{#1}
}

%% Folha de aprovação. O parâmetro deve ser o nome do arquivo com a extensão .pdf
\newcommand{\fazfolhadeaprovacao}[1]{
	\includepdf[pages=-]{#1}
}

%% Dedicatória. O parâmetro deve ser o nome do arquivo com a extensão .tex contendo a dedicatória.
\newcommand{\fazdedicatoria}[1]{
	\begingroup
		\pagestyle{empty}
		\leftskip=5cm % Somado a 3cm da margem esquerda = 8cm
		\vspace*{\fill}
		\noindent \textit{\input{#1}}
		\clearpage
	\endgroup
}

%% Agradecimentos. O parâmetro deve ser o nome do arquivo com a extensão .tex contendo os agradecimentos.
\newcommand{\fazagradecimentos}[1]{
	\begingroup
		\resetaplain
		\pagestyle{plain}
		\ifx\idiomapt\undefined
			\chapter*{Acknowledgments}
		\else
			\chapter*{Agradecimentos}
		\fi
		\input{#1}
		\clearpage
	\endgroup
}

%% Epígrafe. O primeiro parâmetro é o próprio epígrafe e o segundo parâmetro o autor.
\newcommand{\fazepigrafe}[2]{
	\begingroup
	\pagestyle{empty}
	\vspace*{\fill}
		\raggedleft
		``\textit{#1}''\\
		(#2)
	\clearpage
	\endgroup
}

%% Resumo. O primeiro parâmetro deve ser o nome do arquivo com a extensão .tex contendo o resumo, e o segundo parâmetro uma lista com as palavras-chave.
\newcommand{\fazresumo}[1]{
	\begingroup
		\resetaplain
		\pagestyle{plain}
		\chapter*{Resumo}
		\input{#1}
		
		\vspace{1cm}
		\noindent\textbf{Palavras-chave:} \palavraschave
		\clearpage
	\endgroup
}

%% Abstract. O primeiro parâmetro deve ser o nome do arquivo com a extensão .tex contendo o abstract, e o segundo parâmetro uma lista com as palavras-chave.
\newcommand{\fazabstracten}[1]{
	\begingroup
		\resetaplain
		\pagestyle{plain}
		\chapter*{Abstract}
		\input{#1}
		
		\vspace{1cm}
		\noindent\textbf{Keywords:} \keywords
		\clearpage
	\endgroup
}

%% Ambiente para apêndices
\newenvironment{apendices}{
	\appendix
}{}

%% Geração automática dos metadados XMP exigidos pelo pdfx (PDF/A) =========
%% O pdfx lê o arquivo \jobname.xmpdata no início da compilação (ao carregar
%% o pacote), ou seja, ANTES deste comando executar (que roda dentro de
%% \ppgccufmg{}, após \begin{document}). Por isso os metadados escritos aqui
%% só são de fato incorporados ao PDF a partir da 2ª compilação em diante —
%% mesmo comportamento de sumário/referências, que também exigem recompilar.
\newwrite\ppgccufmgxmpfile
\newcommand{\ppgccufmggerarxmpdata}{
	\ifppgccufmgpdfa
		\immediate\openout\ppgccufmgxmpfile=\jobname.xmpdata
		\immediate\write\ppgccufmgxmpfile{\string\Title{\titulo}}
		\immediate\write\ppgccufmgxmpfile{\string\Author{\autor}}
		\ifx\idiomapt\undefined
			\immediate\write\ppgccufmgxmpfile{\string\Language{en-US}}
			\immediate\write\ppgccufmgxmpfile{\string\Keywords{\keywords}}
		\else
			\immediate\write\ppgccufmgxmpfile{\string\Language{pt-BR}}
			\immediate\write\ppgccufmgxmpfile{\string\Keywords{\palavraschave}}
		\fi
		\immediate\write\ppgccufmgxmpfile{\string\Publisher{Universidade Federal de Minas Gerais}}
		\immediate\closeout\ppgccufmgxmpfile
	\fi
}
%% ==========================================================================

%% Verifica se todos os parâmetros obrigatórios foram passados
\newcommand{\verificaobrigatorios}{
	%% Verifica se o autor(a) foi definido
	\ifx\autor\undefined
		\ClassError{ppgccufmg}{Autor(a) não definido}{Defina o autor(a)}
	\fi
	
	%% Verifica se o título foi definido
	\ifx\titulo\undefined
		\ClassError{ppgccufmg}{Título não definido}{Defina o título}
	\fi
	
	%% Verifica se a cidade foi definida
	\ifx\cidade\undefined
		\ClassError{ppgccufmg}{Cidade não definida}{Defina a cidade}
	\fi
	
	%% Verifica se a cidade foi definida
	\ifx\ano\undefined
		\ClassError{ppgccufmg}{Ano não definido}{Defina o ano}
	\fi
	
	%% Verifica se a versão do documento foi definida
	\ifx\versao\undefined
		\ClassError{ppgccufmg}{Versão não definida}{Defina a versão}
	\fi
	
	%% Verifica se o resumo em português foi passado
	\ifx\resumo\undefined
		\ClassError{ppgccufmg}{Resumo em português não encontrado}{Indique o arquivo .tex contendo o resumo em português}
	\fi
	
	%% Verifica se o abstract em inglês foi passado
	\ifx\abstracten\undefined
		\ClassError{ppgccufmg}{Abstract em inglês não encontrado}{Indique o arquivo .tex contendo o abstract em inglês}
	\fi	
	
	%% Verifica se as palavras-chave em português foram definidas
	\ifx\palavraschave\undefined
		\ClassError{ppgccufmg}{Palavras-chave do resumo em português não definidas}{Defina as palavras-chave}
	\fi
	
	%% Verifica se as palavras-chave em português foram definidas
	\ifx\keywords\undefined
		\ClassError{ppgccufmg}{Palavras-chave do abstract em inglês não definidas}{Defina as palavras-chave}
	\fi
	
	%% ---------------------------------------------------------

	%% Verificar se algum orientador(a) foi definido
	\ifx\orientador\undefined
		\ifx\orientadora\undefined
			\ClassError{ppgccufmg}{Orientador(a) não definido}{Defina o(a) orientador(a)}
		\fi
	\fi
}

%% Comando principal que desenha todos os elementos pré-textuais (capa, folha de rosto, abstract, ...)
\newcommand{\ppgccufmg}[1]{%
	
	%% Executa os parâmetros passados pelo usuário
	\setkeys{ppgcc}{#1}
	
	\pagestyle{estilopadrao} %% Define 'estilopadrao' como sendo o estilo 'global' das páginas

	\verificaobrigatorios

	\ppgccufmggerarxmpdata %% Gera/atualiza o .xmpdata com os metadados PDF/A (ver observação acima)

	\maketitle %% Capa
	
	%% Comando utilizado para que a capa não conte na numeração das páginas
	\cleardoublepage
	\setcounter{page}{1}

	\ifx\idiomaen\undefined
		\folhaderosto{pt} %% Folha de rosto em português
	\else
		\folhaderosto{en} %% Folha de rosto em inglês
	\fi	
	
	\ifx\fichacatalografica\undefined\else
		\fazfichacatalografica{\fichacatalografica}
	\fi
	
	\ifx\folhadeaprovacao\undefined\else
		\fazfolhadeaprovacao{\folhadeaprovacao}
	\fi
	
	\ifx\dedicatoria\undefined\else
		\fazdedicatoria{\dedicatoria}
	\fi
	
	\ifx\agradecimentos\undefined\else
		\fazagradecimentos{\agradecimentos}
	\fi
	
	\ifx\epigrafe\undefined\else
		\ifx\epigrafeautor\undefined
			\ClassError{ppgccufmg}{Autor do epígrafe não definido}{Defina o autor do epígrafe.}
		\fi
		\fazepigrafe{\epigrafe}{\epigrafeautor}
	\fi
	
	\fazresumo{\resumo}
	
	\fazabstracten{\abstracten}
	
	\begingroup
	\resetaplain
	
	\ifx\listadefiguras\undefined\else
		\begingroup
			\pagestyle{empty}
			\listoffigures* %% Lista de figuras
			\clearpage
		\endgroup
	\fi
	
	\ifx\listadetabelas\undefined\else
		\begingroup
			\pagestyle{empty}
			\listoftables* %% Lista de tabelas
			\clearpage
		\endgroup
	\fi
	
	\begin{KeepFromToc}
		\addtocontents{toc}{\protect\thispagestyle{empty}}
		\pagestyle{empty}
		\ifx\listascustomizadas\undefined\else
			\listascustomizadas
			\clearpage
		\fi		
		\tableofcontents* %% Sumário
		\cleardoublepage
		\pagestyle{headings}
	\end{KeepFromToc}
	\endgroup
}

%% ==========================================

%% Comandos que serão exercutados logo após o comando \begin{document}
\AtBeginDocument{
	
	\setsecnumdepth{subsubsection} %% Define a profundidade das seções (permite capítulo, seção, sub-seção e sub-sub-seção)
	\OnehalfSpacing %% Espaçamento de 1,5cm entre linhas
	\setlength{\parindent}{1.25cm} %% Recuo de 1,25 cm à esquerda em parágrafos
	\setheadfoot{\baselineskip}{1.5cm} %% Define o tamanho do header e o espaço entre o header e o texto
	\setlength{\beforechapskip}{0cm} %% Remove o espaçamento adicional de 2cm antes dos títulos dos capítulos
	\setlength{\afterchapskip}{1.5cm} %% Espaçamento depois do título de um capítulo
	\setbeforesecskip{1.5cm} %% Espaçamento antes do título da seção
	\setaftersecskip{1.5cm} %% Espaçamento depois do título da seção
	\setbeforesubsecskip{1.5cm} %% Espaçamento antes do título da sub-seção
	\setaftersubsecskip{1.5cm} %% Espaçamento depois do título da sub-seção
	\setbeforesubsubsecskip{1.5cm} %% Espaçamento antes do título da sub-sub-seção
	\setaftersubsubsecskip{1.5cm} %% Espaçamento depois do título da sub-sub-seção
	\setcounter{tocdepth}{3} %% Profundidade dos elementos do sumário. 3 = sub-sub-seção
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

