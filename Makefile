TEXFILE ?= plone-and-volto-in-jamstack-project

.PHONY: all
all: build

%.nav: %.tex
	@latexmk -shell-escape -quiet $<

%.pdf: %.tex images
	@latexmk -pdf -recorder -interaction=nonstopmode -shell-escape -use-make -quiet $<

%.pdf: %.tex images
	@latexmk -pdf -recorder -interaction=nonstopmode -shell-escape -use-make -quiet $<

build: plone-and-volto-in-jamstack-project.pdf deploying-plone-and-volto-hard-way.pdf
	mkdir -p build/alt
	mv *.pdf build
	echo '<meta http-equiv="refresh" content= "0;url=plone-and-volto-in-jamstack-project.pdf" />' > build/index.html
	echo '<meta http-equiv="refresh" content= "0;url=../deploying-plone-and-volto-hard-way.pdf" />' > build/alt/index.html
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
