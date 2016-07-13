#######################################################
#                   DHBW ULTIMATE                     #
#          LaTEX template for english papers          #
#           optimized for DHBW Stuttagrt              #
#                                                     #
#                                                     #
# based on: github.com/dhbw-horb/latexVorlageEnglisch #
#       by: t-kopp                                    #
#           (kevinkepp, ZaiLynch)                     #
#   author: Tobias Dreher, Yves Fischer (2011)        #
#                                                     #
#                                                     #
#     Marius Herget, info@herget.design, TINF14A      #
#######################################################

####### INSERT NAME HERE #######
DOCUMENT_NAME = dhbw-ultimate
################################
OUTPUT_DIR    = output
BACKUPNAME    = Backup/$(shell date --iso=seconds)
LASTVERSION_D = Backup/lastVersion

# Init PDF and last Version
init: outpurdir report cleanup cpSave

# Build the LaTeX document.
all: outputdir report openPDF cleanup 

# Saves new Version, build differences PDF
version: outputdir differ backup cleanup save 
differences: outputdir differ cleanup

# Remove output directory.
clean:
	rm -rf $(OUTPUT_DIR)

# cleanup tempfiles
cleanup:
	rm -f *.aux rm -f *.acn *.glo *.ist *.lof *.log *.lot *.lol *.toc *.alg *.glg *.gls *.acr *.pdf *out 
	rm -f $(OUTPUT_DIR)/*.aux rm -f $(OUTPUT_DIR)/*.acn $(OUTPUT_DIR)/*.glo $(OUTPUT_DIR)/*.ist $(OUTPUT_DIR)/*.lof $(OUTPUT_DIR)/*.log $(OUTPUT_DIR)/*.lot $(OUTPUT_DIR)/*.lol $(OUTPUT_DIR)/*.toc $(OUTPUT_DIR)/*.alg $(OUTPUT_DIR)/*.glg $(OUTPUT_DIR)/*.gls $(OUTPUT_DIR)/*.acr $(OUTPUT_DIR)/*.gz $(OUTPUT_DIR)/*out
	rm -r -f tmp
	rm -f *.*~

# Create LaTeX output directory.
outputdir:
	# create all dirs
	$(shell mkdir $(OUTPUT_DIR) 2>/dev/null)
	$(shell mkdir Backup 2>/dev/null)
	$(shell mkdir $(LASTVERSION_D) 2>/dev/null)

# Build Bib
bibtex:
	bibtex $(DOCUMENT_NAME)

glos:
	makeglossaries -q $(DOCUMENT_NAME).glo
	makeglossaries -q $(DOCUMENT_NAME).acn

build:
	pdflatex -interaction=nonstopmode $(DOCUMENT_NAME) > error.txt


# Generate PDF output from LaTeX input files.
report: 
	pdflatex -interaction=nonstopmode $(DOCUMENT_NAME) > error.txt
	makeglossaries -q $(DOCUMENT_NAME).glo
	makeglossaries -q $(DOCUMENT_NAME).acn
	bibtex $(DOCUMENT_NAME)
	pdflatex -interaction=nonstopmode $(DOCUMENT_NAME) > error.txt
	cp $(DOCUMENT_NAME).pdf $(OUTPUT_DIR)

# Opens PDF
openPDF:
	 gnome-open $(OUTPUT_DIR)/$(DOCUMENT_NAME).pdf
openPDFdifferences:
	 gnome-open $(OUTPUT_DIR)/differences.pdf

# Opens all files in texteditor
open:
	$(shell gedit -s $(DOCUMENT_NAME).tex content/*.tex literatur.bib header.tex & echo OPENED!) 
# TBD opens in favourite editor

# Publish new Version
backup:
	# Backup old files
	$(shell mkdir -p $(BACKUPNAME))
	$(shell cp -r $(LASTVERSION_D)/* $(BACKUPNAME))
	# finished backup

save: delSave cpSave

delSave: 
	$(shell rm -r $(LASTVERSION_D); mkdir $(LASTVERSION_D) 2>/dev/null)

cpSave:
	# Save new Version
	$(shell cp -r *.tex $(LASTVERSION_D)/.)
	$(shell cp -r *.bib $(LASTVERSION_D)/.)
	$(shell mkdir $(LASTVERSION_D)/content 2>/dev/null)
	$(shell cp -r content/*.tex $(LASTVERSION_D)/content/.)
	# finished save

differ: 
	# Pand old and new tex
	$(shell mkdir tmp; cd $(LASTVERSION_D); latexpand $(DOCUMENT_NAME).tex > ../../tmp/$(DOCUMENT_NAME)-old.tex; cd ../..)
	latexpand $(DOCUMENT_NAME).tex > tmp/$(DOCUMENT_NAME).tex
	# Create difference file
	latexdiff --exclude-textcmd="section,subsection,chapter,subsubsection,part" tmp/$(DOCUMENT_NAME)-old.tex tmp/$(DOCUMENT_NAME).tex >  $(OUTPUT_DIR)/differences.tex
	pdflatex -interaction=nonstopmode $(OUTPUT_DIR)/differences.tex
	cp differences.pdf $(OUTPUT_DIR)
differ: openPDFdifferences
