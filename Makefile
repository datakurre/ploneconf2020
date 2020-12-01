TEXFILE ?= plone-and-volto-in-jamstack-project

all: $(TEXFILE).pdf

$(TEXFILE).nav: $(TEXFILE).tex
	@latexmk -shell-escape -quiet $(TEXFILE)

$(TEXFILE).pdf: $(TEXFILE).tex images
	@latexmk -pdf -recorder -interaction=nonstopmode -shell-escape -use-make -quiet $(TEXFILE)

watch:
	@latexmk -pvc -pdf -recorder -interaction=nonstopmode -shell-escape -use-make $(TEXFILE)

clean:
	@latexmk -C -quiet
	@rm -f *.nav *.snm *.fls *.vrb _minted-$(TEXFILE)/*
	@if [ -d _minted-$(TEXFILE) ]; then rmdir _minted-$(TEXFILE); fi

.PHONY: all clean watch
