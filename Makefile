tei:
	@if [ ! -e tei ]; then make update_tei; fi

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