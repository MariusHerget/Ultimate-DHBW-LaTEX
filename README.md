DHBW Ultimate
=============
## LaTEX Template for DHBW Stuttgart papers
_DHBW Ultimate_ is a LaTEX template for writing writing papers or reports within the styleguidelines from the DHBW Stuttgart (computer science).
It has an makefile which fully controlls all features.

* Features
  + Render LaTEX with title page, contents, abstract, declaration, bibliography, list of Tables/Figures, ayronyms and glossary
  + Version control with backupsystem
  + Difference PDF to last version

## How to start
1. Rename the _dhbw-ultimate.tex_ file into your favorite file name (this won't the document name or title of your work).
2. Change the *DOCUMENT_NAME* variable in the **makefile** to the chosen file name (without .tex).
3. Run **\make init**.
4. Now you can create new files in *Content/*, edit the information in the main tex-file and start to work on your paper. 

## Usage with makefile
	\make init			Initialize environment (saves first version to have a difference to the next version)
	\make open			Opens Main .tex, all contents/.tex, literatur.bib and header.tex in gedit (ONLY LINUX YET!!!)
	\make all			Genereated PDF in /output, deletes all temporary files and opens PDF
	\make clean			Deletes output
	\make version			Backup your work, build PDF with differences to the last version
	\make differ			Builds PDF with differences to the last version 
	\make cleanup			Deletes all generated files (Recommended if error occured while \make all)
	




BASED ON [DHBW-HORB's template from 2011](https://github.com/dhbw-horb/latexVorlageEnglisch/commits/master)