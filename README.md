# Manesse

Internal development repository for Digitization of Codex Manesse (Große Heidelberger Liederhandschrift). 

**DO NOT DISSEMINATE**

The content will be released under an open (Creative Commons) license, but this represents an intermediate snapshot that is not ready for release, yet.

**IMPORTANT NOTE**

- For technical reasons, HTML files are not properly rendered in GitHub, and [common solutions](https://htmlpreview.github.io/) do not apply to private repositories. For looking into these files, please download the entire repo as a ZIP file, decopress on your computer and open locally.
- For downloading the entire repository, click on "Code" on the main page, and "Download ZIP" as in the screenshot below:

	![](scripts/download.jpg?raw=true)

## Content

- **FOR PHILOLOGICAL PURPOSES**
	- [`html/`](html) **partial** transcription data, HTML export, for human consultation
		- each page provides a scan of the page, followed by the transcription
		- **warning**: does not contain annotations
		- **warning**: for technical reasons, images were compressed
		- uncompressed images can be found under [`xml/`](img)/*/*.jpg, e.g., under [`xml/Spervogel`](xml/Spervogel) for Spervogel, usw..
- **FOR DH PURPOSES**
	- [`tei/`](tei) **full** transcription data, Transcribus TEI/XML export
		- **warning**: The Transkribus TEI export contains XML-valid image information, bounding boxes, transliteration and annotations -- but it does not provide TEI compliant data structures for project-specific annotations. The post-processing of these annotations is addressed in the next project phase.
		- **note**: Transkribus TEI provides visual information first (under `/TEI/facsimile`), then followed by text and annotations (under `/TEI/text`), connected by XPointers. For manually inspecting the validity of annotations and transliteration, please **scroll down** to the first `<text>` element.
	- [`xml/`](xml) **full** transcription data, Transkribus Page XML format ("Page XML"), also includes source images. (This is for subsequent processing/technically interested colleagues.)

## How to (re)build  `tei/` from scratch (for developers)

- requirements
	- Unix-style command-line with `bash`, `make`, `wget`, `git` (tested under Ubuntu 22.04L)
	- Note: `make update_tei` will install [SaxonJ-HE 12.5](https://github.com/Saxonica/Saxon-HE/releases/download/SaxonHE12-5/SaxonHE12-5J.zip), see [Saxonica](https://www.saxonica.com/download/java.xml) for requirements regarding Java version, etc.
12.5 )
- deposit your XML files in [`xml/`](xml)
- run build process in one of the following variants
	- run `make tei` will only generate new TEI files if the target directory (`tei/`) does not exist yet
 	- run `make update_tei` will perform an incremental update (transform only files for which target TEI does not exist yet)
	- to build all from scratch, delete the `tei/` folder and run `make tei` (or `make update_tei`)
- if all goes well, find your output in [`tei/`](tei)
- if not, check the logs ;)

## How to (re)build `html/` from scratch (for developers)

- requirements
	- Unix-style command-line with `bash`, `make` (tested under Ubuntu 22.04L)
	- `pdftohtml`
- deposit your PDF export in [`pdf/`](pdf)
- run `make html`

## Acknowledgments

- **Image sources tba**
- Transliteration and annotation provided by @bleulean, **details tba**
- Build script by @chiarcos
- For the TEI export, we rely on the original [Transkribus converter](https://github.com/dariok/page2tei) created by @tboenig, @peterstadler, @tillgrallert, partially supported by German BMBF, project ID 16TOA015A.
