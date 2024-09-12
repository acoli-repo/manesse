tei:
	@if [ ! -e tei ]; then make update_tei; fi

pandoc:
	@if pandoc -h > /dev/null; then \
		echo pandoc found 1>&2;\
	else \
		echo did not find pandoc, install from https://pandoc.org/ and make sure to add it to the path 1>&2; \
		exit 1;\
	fi;

html: pdf
	@if [ ! -e html ]; then \
		mkdir html;\
		cd html;\
		for file in `find ../pdf/ | grep 'pdf$$'`; do \
			ln -s $$file .;\
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
	fi;\

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