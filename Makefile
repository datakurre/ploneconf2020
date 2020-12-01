TEXFILE ?= plone-and-volto-in-jamstack-project

.PHONY: all
all: $(TEXFILE).pdf

$(TEXFILE).nav: $(TEXFILE).tex
	@latexmk -shell-escape -quiet $(TEXFILE)

$(TEXFILE).pdf: $(TEXFILE).tex images
	@latexmk -pdf -recorder -interaction=nonstopmode -shell-escape -use-make -quiet $(TEXFILE)

.PHONY: watch
watch:
	@latexmk -pvc -pdf -recorder -interaction=nonstopmode -shell-escape -use-make $(TEXFILE)

.PHONY: cache
cache:
	nix-store --query --references $(nix-instantiate shell.nix) |\
	xargs nix-store --realise | xargs nix-store --query --requisites |\
	cachix push datakurre

.PHONY: clean
clean:
	@latexmk -C -quiet
	@rm -f *.nav *.snm *.fls *.vrb _minted-$(TEXFILE)/*
	@if [ -d _minted-$(TEXFILE) ]; then rmdir _minted-$(TEXFILE); fi
