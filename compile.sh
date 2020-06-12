#!/bin/sh

#
# Required Packages
# sudo apt-get install texlive-lang-portuguese

#parentdir="$(dirname "$(pwd)")"
parentdir="$(pwd)"
generateBib=$1

mkdir -p LATEX/tmp/Capitulos
mkdir -p LATEX/tmp/Paginas

# export lyx to latex
lyx --force-overwrite --export pdflatex Principal.lyx

if [ "$generateBib" = "--bib" ]
then
	# references
	cp references.bib LATEX/tmp/
	TEXINPUTS=$parentdir//:$TEXINPUTS:  pdflatex -output-directory LATEX/tmp LATEX/main.tex

	# compile bibtex
	cd LATEX/tmp
	bibtex main
	cd $parentdir
	TEXINPUTS=$parentdir//:$TEXINPUTS:  pdflatex -output-directory LATEX/tmp LATEX/main.tex
fi

# generate PDF
TEXINPUTS=$parentdir//:$TEXINPUTS:  pdflatex -output-directory LATEX/tmp  LATEX/main.tex

mv $parentdir/LATEX/tmp/main.pdf $parentdir/OpenDevice-MasterThesis.pdf
rm Capitulos/*.tex
rm Paginas/Resumo.tex
rm Paginas/Apendice.tex
rm Principal.tex
rm -rf LATEX/tmp
evince OpenDevice-MasterThesis.pdf
