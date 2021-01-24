all: clean copy addmd2ipynb html 

addmd2ipynb:
	python3 build/utils/md2ipynb.py README_CN.md build/README_CN.ipynb
	python3 build/utils/md2ipynb.py README.md build/README.ipynb
	python3 build/utils/md2ipynb.py example/tutorials/README.md build/example/tutorials/README.ipynb
	python3 build/utils/md2ipynb.py example/millionaire/README.md build/example/millionaire/README.ipynb
	python3 build/utils/md2ipynb.py example/tutorials/code/README.md build/example/tutorials/code/README.ipynb

run:all 
	sphinx-autobuild build build/_build/html

clean:
	rm -rf build/*
	# rm -rf build/chapter* build/_build build/img build/data $(PKG) build/index.rst build/conf.py build/_static/ build/frontpage.html
	# rm -rf build/examples  build/getting-started.rst
	# rm -rf build/README_CN.md build/README.md build/doc build/example

# .PHONY：copy
copy:
	cp -r _static/utils build/utils
	cp -r _static/Makefile build/Makefile
	mkdir build/_build/ build/_build/html/ build/_build/html/_static/
	cp -r _static/sphinx_materialdesign_theme.css build/_build/html/_static/sphinx_materialdesign_theme.css
	cp -r _static/ build/_static/
	cp -r examples/ build/examples/
	cp -r doc/ build/doc/
	rm -rf build/doc/*.md
	cp -r example/ build/example/
	rm -rf build/example/*.md
	rm -rf build/build build/example/*/*.md build/example/tutorials/code/README.md

build/%.ipynb: %.md $(wildcard rosettazh/*)
	@mkdir -p $(@D)
	cd $(@D); python3 ../utils/md2ipynb.py ../../$< ../../$@

build/%.md: %.md
	@mkdir -p $(@D)
	@cp $< $@

MARKDOWN = $(wildcard */index.md)
NOTEBOOK = $(filter-out $(MARKDOWN), $(wildcard */*.md))

OBJ = $(patsubst %.md, build/%.md, $(MARKDOWN)) \
	$(patsubst %.md, build/%.ipynb, $(NOTEBOOK))

FRONTPAGE_DIR = img/frontpage
FRONTPAGE = $(wildcard $(FRONTPAGE_DIR)/*)
FRONTPAGE_DEP = $(patsubst %, build/%, $(FRONTPAGE))

IMG_NOTEBOOK = $(filter-out $(FRONTPAGE_DIR), $(wildcard img/*))
ORIGIN_DEPS = $(IMG_NOTEBOOK) $(wildcard data/* rosettazh/*) index.rst getting-started.rst conf.py index_en.rst frontpage.html frontpage_en.html
DEPS = $(patsubst %, build/%, $(ORIGIN_DEPS))

PKG = build/_build/html/rosetta-zh.zip

pkg: $(PKG)

build/_build/html/rosetta-zh.zip: $(OBJ) $(DEPS)
	cd build; zip -r $(patsubst build/%, %, $@ $(DEPS)) chapter*/*md chapter*/*ipynb

# Copy XX to build/XX if build/XX is depended (e.g., $(DEPS))
build/%: %
	@mkdir -p $(@D)
	@cp -r $< $@

html: $(DEPS) $(FRONTPAGE_DEP) $(OBJ)
	make -C build html
	python3 build/utils/post_html.py
	cp -r _static/frontpage/ build/_build/html/_images/
	# Enable horitontal scrollbar for wide code blocks
	sed -i s/white-space\:pre-wrap\;//g build/_build/html/_static/sphinx_materialdesign_theme.css

TEX=build/_build/latex/rosetta-zh.tex

build/_build/latex/%.pdf: img/%.svg
	@mkdir -p $(@D)
	rsvg-convert -f pdf -z 0.80 -o $@ $<

SVG=$(wildcard img/*.svg)

PDFIMG = $(patsubst img/%.svg, build/_build/latex/%.pdf, $(SVG))

pdf: $(DEPS) $(OBJ) $(PDFIMG)
	@echo $(PDFIMG)
	make -C build latex
	sed -i s/\\.svg/.pdf/g ${TEX}
	sed -i s/\}\\.gif/\_00\}.pdf/g $(TEX)
	sed -i s/{tocdepth}{0}/{tocdepth}{1}/g $(TEX)
	sed -i s/{\\\\releasename}{发布}/{\\\\releasename}{}/g $(TEX)
	sed -i s/{OriginalVerbatim}\\\[commandchars=\\\\\\\\\\\\{\\\\}\\\]/{OriginalVerbatim}\\\[commandchars=\\\\\\\\\\\\{\\\\},formatcom=\\\\footnotesize\\\]/g $(TEX)
	sed -i s/\\\\usepackage{geometry}/\\\\usepackage[paperwidth=187mm,paperheight=235mm,left=20mm,right=20mm,top=20mm,bottom=15mm,includefoot]{geometry}/g $(TEX)
	# Allow figure captions to include space and autowrap
	sed -i s/Ⓐ/\ /g ${TEX}
	# Remove un-translated long table descriptions
	sed -i /\\\\multicolumn{2}{c}\%/d $(TEX)
	sed -i /\\\\sphinxtablecontinued{Continued\ on\ next\ page}/d $(TEX)
	sed -i /{\\\\tablename\\\\\ \\\\thetable{}\ --\ continued\ from\ previous\ page}/d $(TEX)
	sed -i s/\\\\maketitle/\\\\maketitle\ \\\\pagebreak\\\\hspace{0pt}\\\\vfill\\\\begin{center}本书稿为测试版本（\ 生成日期：\\\\zhtoday\ ）。\\\\\\\\\ 访问\\\\url{https:\\/\\/github.com}，获取最新版本。\\\\end{center}\\\\vfill\\\\hspace{0pt}\\\\pagebreak/g $(TEX)

	python3 build/utils/post_latex.py zh

	cd build/_build/latex && \
	bash ../../utils/convert_output_svg.sh && \
	buf_size=10000000 xelatex rosetta-zh.tex && \
	buf_size=10000000 xelatex rosetta-zh.tex

setup_pdf:
	sudo apt-get install texlive-xetex latex-cjk-all
	sudo apt-get install texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra
	sudo apt-get install texmaker
	# bash build/utils/install_fonts.sh

gitpullmerge:
	git pull origin main
	git merge origin/main

deploy:all
	rm -rf /var/www/build/* /var/www/html/*
	cp -r build /var/www/build
	cp -r build/_build/html /var/www/html
	sphinx-autobuild /var/www/build /var/www/html