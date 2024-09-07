tei:
	@if [ ! -e tei ]; then make update_tei; fi

update_tei: pdf_xml
	if [ ! -e tei ]; then mkdir tei; fi;
	for file in pdf_xml/*xml; do \
		echo $$file;\
	done;

	# rm -rf pdf_xml

pdf_xml: pdf
	if [ ! -e pdf_xml ]; then \
		mkdir -p pdf_xml/pdf; \
		for file in pdf/*pdf; do \
			tgt=pdf_xml/`basename $$file`.xml;\
			echo $$file '>' $$tgt 1>&2; \
			pdftohtml -nodrm -xml -hidden -stdout $$file > $$tgt;\
			for img in `echo $$file | sed s/'\.pdf'//`*.jpg `echo $$file | sed s/'\.pdf'//`*.png; do \
				if [ -e $$img ]; then \
					mv $$img pdf_xml/pdf; \
				fi;\
			done;\
			echo 1>&2;\
		done;\
	fi;
