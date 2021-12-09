# USER INPUTS
# =============================================================================

NAME = petersburg

FIGEXT = png
LATEXMK = latexmk -pdf -interaction=nonstopmode -pdflatex=lualatex

figs = \
figures/distribution.$(FIGEXT) \
# figures/windmap.$(FIGEXT) \

texs = \
tex/include/world.tex \
tex/include/lotto.tex

TEXDEPS = $(figs) $(texs)

pdf: $(TEXDEPS)
	$(LATEXMK) -jobname=build/$(NAME) tex/$(NAME).tex
	cp build/$(NAME).pdf $(NAME).pdf

figures/%.$(FIGEXT): src/figures/%.py
	python $< $@

tex/include/%.tex: src/tex/%.jl
	julia $< $@

continuous:
	$(LATEXMK) -pvc -jobname=build/$(NAME) tex/$(NAME).tex

clean:
	rm -rf data/*
	rm -rf build/*
	rm -rf abridged_build/*
