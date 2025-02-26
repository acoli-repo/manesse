# Manesse

Internal development repository for Digitization of Codex Manesse (Große Heidelberger Liederhandschrift). 

**DO NOT DISSEMINATE**

The content will be released under an open (Creative Commons) license, but this represents an intermediate snapshot that is not ready for release, yet.

## Content

- **MANUSCRIPT AND TRANSCRIPTION**
	- The data transcribed and annotated can be accessed via a designated [table of contents file](overview.md). Note that this is for illustration, only, in particular, it does not meet the quality standards required from a proper digital publication.
- **FOR PHILOLOGICAL PURPOSES**
	- [`html/`](overview.md) **partial** transcription data, HTML export, for human consultation
		- each page provides a scan of the page, followed by the transcription
		- **warning**: does not contain annotations
		- **warning**: for technical reasons, images were compressed
		- uncompressed images can be found under [`xml/`](img)/*/*.jpg, e.g., under [`xml/Spervogel`](xml/Spervogel) for Spervogel, usw..
		- **note**: If accessed directly, you will be shown HTML source code in `raw` mode, for proper rendering, please access these files via the [table of contents file](overview.md)
- **FOR DH PURPOSES**
	- [`tei/`](tei) **full** transcription data, Transcribus TEI/XML export
		- **warning**: The Transkribus TEI export contains XML-valid image information, bounding boxes, transliteration and annotations -- but it does not provide TEI compliant data structures for project-specific annotations. The post-processing of these annotations is addressed in the next project phase.
		- **note**: Transkribus TEI provides visual information first (under `/TEI/facsimile`), then followed by text and annotations (under `/TEI/text`), connected by XPointers. For manually inspecting the validity of annotations and transliteration, please **scroll down** to the first `<text>` element.
	- [`xml/`](xml) **full** transcription data, Transkribus Page XML format ("Page XML"), also includes source images. (This is for subsequent processing/technically interested colleagues.)

## How to (re)build from scratch (for developers)

To build everything in one go, run

	$> make

### How to (re)build  `tei/` from scratch 

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

### How to (re)build `html/` from scratch (for developers)

- requirements
	- Unix-style command-line with `bash`, `make` (tested under Ubuntu 22.04L)
	- `pdftohtml`
- deposit the Transkribus PDF export in [`pdf/`](pdf)
- run `make html` (or `make update_html`)

## Acknowledgments

- Images generated from original scans published into Public Domain by the Universitätsbibliothek Heidelberg
  -  DOI: https://doi.org/10.11588/diglit.2222
  -  URN: urn:nbn:de:bsz:16-diglit-22223
  -  URL: https://digi.ub.uni-heidelberg.de/diglit/cpg848
- Transliteration and annotation provided by Kathrin Bleuler (U Augsburg, then U Graz), Andreas Hammer (U Konstanz) and collaborators in the D-A-CH-Projekt "Codex Manesse. Sammlungsaufbau und Kontextualisierung der Autorcorpora", funded by FWF (lead agency) and DFG (2021-2024)
- This repository and the accompanying conversion scripts have been developed in preparation of the next project phase by Christian Chiarcos (U Augsburg)
- For the TEI export, we rely on the original [Transkribus converter](https://github.com/dariok/page2tei) created by @tboenig, @peterstadler, @tillgrallert, partially supported by German BMBF, project ID 16TOA015A. Note that this is slightly dated, and failed to convert two sub-documents.
