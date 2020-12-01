TEXFILE ?= plone-and-volto-in-jamstack-project

.PHONY: all
all: $(TEXFILE).pdf build

$(TEXFILE).nav: $(TEXFILE).tex
	@latexmk -shell-escape -quiet $(TEXFILE)

$(TEXFILE).pdf: $(TEXFILE).tex images
	@latexmk -pdf -recorder -interaction=nonstopmode -shell-escape -use-make -quiet $(TEXFILE)

build: plone-and-volto-in-jamstack-project.pdf
	mkdir -p build
	mv *.pdf build
	echo '<meta http-equiv="refresh" content= "0;url=plone-and-volto-in-jamstack-project.pdf" />' > build/index.html
	touch build/.nojekyll

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
