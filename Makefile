all: overview.md

tei:
	@if [ ! -e tei ]; then make update_tei; fi

pandoc:
	@if pandoc -h > /dev/null; then \
		echo pandoc found 1>&2;\
	else \
		echo did not find pandoc, install from https://pandoc.org/ and make sure to add it to the path 1>&2; \
		exit 1;\
	fi;
	
html: update_html

pdf:
	if [ ! -e pdf ]; then \
		echo "The current HTML export is generated from Transkribus PDF. For converting additional data, please deposit them under pdf/";\
	fi;

update_html: pdf
	@if [ ! -e html ]; then \
		mkdir html;\
	fi;\
	cd html;\
	for file in `find ../pdf/ | grep 'pdf$$'`; do \
		if [ ! -e `basename $$file` ]; then \
			ln -s $$file .;\
		fi;\
	done;\
	cd ..;\
	for file in html/*.pdf; do \
		if [ -L $$file ]; then \
			tgt=`echo $$file | sed s/'\.pdf$$'//`.html;\
			if [ ! -e $$tgt ]; then \
				src=$$(realpath html/`ls -l $$file | egrep '\->' | cut -f 2 -d '>' | sed s/'^\s*'//`);\
				echo $$src '>' $$tgt;\
				pdftohtml -hidden -nodrm -noframes -dataurls $$file > $$file.log;\
				rm $$file $$file.log;\
			fi;\
		fi;\
	done;\

overview.md: metadata.jsonl update_tei update_html
	(echo "# Teilkorpora "; \
	echo;\
	echo "| Autor | Dokumentenansicht (vorläufig)\* | TEI/XML (vorläufig)\*\* | Arbeitsgruppe | ";\
	echo "| ----- | ------------------ | -------- | ------------- | ";\
	cat metadata.jsonl \
	| cut -f 4,8,12 -d '"' \
	| sed s/'^\([^"]*\)"\([^"]*\)"\([^"]*\)'/'\| **\1** \| [html](https:\/\/html-preview.github.io\/?url=https:\/\/github.com\/acoli-repo\/manesse\/blob\/main\/html\/\2.html) \| [xml](tei\/\2.xml) \| \3 \|'/;\
	echo;\
	echo "> \* Die Dokumentenansicht ist vorläufig und dient nur der Veranschaulichung der Natur des Materials. Sie erfüllt weder die technischen noch philologischen Ansprüche an eine adäquate digitale Publikation.";\
	echo;\
	echo "> \*\* Die TEI/XML ist automatisch *und mit Transkribus-Bordmitteln* aus Transkribus heraus erzeugt, die Projektannotationen sind enthalten, werden allerdings nicht TEI-konform exportiert. Für einige wenige Dateien ist der Export mit Bordmitteln aufgrund von Fehlern der Transkribus-eigenen Konvertern gescheitert. Beides muss im Rahmen der nächsten Projektphase neu erarbeitet werden.";\
	) > overview.md
	
html_from_docx: pandoc
	@if [ ! -e docx ]; then \
		echo HTML export currently requires Transkribus docx export 1>&2; \
	else \
		for file in `find docx/* | grep 'docx$$'`; do \
			if [ -e $$file ]; then \
				tgt=html/`basename $$file | sed s/'\.docx$$'//`.html;\
				if [ ! -e $$tgt ]; then \
					if [ ! -e `dirname $$tgt` ]; then mkdir -p `dirname $$tgt`; fi;\
					echo $$file '>' $$tgt 1>&2;\
					pandoc $$file -t html > $$tgt;\
				fi;\
			fi;\
		done;\
	fi;\

scripts:
	if [ ! -e scripts ]; then mkdir scripts; fi

scripts/page2tei: scripts
	if [ ! -e scripts/page2tei ]; then \
		cd scripts;\
		git clone https://github.com/dariok/page2tei;\
	fi;

scripts/saxon: scripts
	if [ ! -e scripts/saxon ]; then \
		cd scripts;\
		wget -nc https://github.com/Saxonica/Saxon-HE/releases/download/SaxonHE12-5/SaxonHE12-5J.zip;\
		unzip SaxonHE12-5J.zip -d saxon;\
	fi;

update_tei: xml scripts/saxon scripts/page2tei
	for file in `find xml | grep 'mets.xml$$'`; do \
		tgt=tei/`basename $$(dirname $$file)`.xml;\
		echo -n $$file '>' $$tgt ...' ' 1>&2;\
		if [ -e $$tgt ]; then \
			echo SKIPPED '('$$tgt found')' 1>&2;\
		else \
			if [ ! -e `dirname $$tgt` ]; then mkdir -p `dirname $$tgt`; fi;\
			bash -e scripts/saxon-he -xsl:scripts/page2tei/page2tei-0.xsl -s:$$file -o:$$tgt "withoutBaseline=true()" "withoutTextLine=true()";\
			if [ -e $$tgt ]; then \
				echo OK 1>&2;\
			else \
				echo ERROR 1>&2;\
			fi; \
		fi;\
	done;