DHBW Ultimate
=============
## LaTEX Template for DHBW Stuttgart papers
_DHBW Ultimate_ is a LaTEX template for writing writing papers or reports within the style guidelines from the DHBW Stuttgart (computer science).
It has an makefile which fully controls all features.

Features
  + Render LaTEX with title page, contents, abstract, declaration, bibliography, list of Tables/Figures, acronyms and glossary
  + Version control with backup system
  + Difference PDF to last version
  + Renders automatically a _print_ and _screen_ Version. The _screen_ version has highlited and working hyperlinks to _urls_, _refs_, etc.

## How to start
1. Rename the _dhbw-ultimate.tex_ file into your favorite file name (this won't the document name or title of your work).
2. Change the *DOCUMENT_NAME* variable in the **makefile** to the chosen file name (without .tex).
3. Run **\make init**.
4. Change the Logo in the *images* to your company's logo.
5. Include own Frameworks in *ownFrameworks.tex*
6. Now you can create new files in *Content/*, edit the information in the main tex-file and start to work on your paper.

## Usage with makefile
	\make init			Initialize environment (saves first version to have a difference to the next version)
	\make open			Opens Main .tex, all contents/.tex, literatur.bib and header.tex in gedit
	\make all			Generated PDF in /output, deletes all temporary files and opens PDF
	\make clean			Deletes output
	\make version			Backup your work, build PDF with differences to the last version
	\make differ			Builds PDF with differences to the last version
	\make cleanup			Deletes all generated files (Recommended if errors occurred while \make all)

## Support
Currently supported systems:
   + Linux

## Thanks to
 - *[Chrrel](https://github.com/chrrel)*  for providing the base for the _print_/_screen_ version.

BASED ON [DHBW-HORB's template from 2011](https://github.com/dhbw-horb/latexVorlageEnglisch)
