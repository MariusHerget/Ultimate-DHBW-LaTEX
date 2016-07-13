DHBW Ultimate
=============
## LaTEX Template for DHBW Stuttgart papers

## Usage with makefile
	\make init			Initialize environment (saves first version to have a difference to the next version)
	\make open			Opens Main .tex, all contents/.tex, literatur.bib and header.tex in gedit (ONLY LINUX YET!!!)
	\make all			Genereated PDF in /output, deletes all temporary files and opens PDF
	\make clean			Deletes output
	\make version			Backup your work, build PDF with differences to the last version
	\make differ			Builds PDF with differences to the last version 
	\make cleanup			Deletes all generated files (Recommended if error occured while \make all)
	




BASED ON https://github.com/dhbw-horb/latexVorlageEnglisch/commits/master
