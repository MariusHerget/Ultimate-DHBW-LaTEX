#######################################################
#                   DHBW ULTIMATE                     #
#          LaTEX template for english papers          #
#           optimized for DHBW Stuttagrt              #
#                  computer science                   #
#                                                     #
#                                                     #
# based on: github.com/dhbw-horb/latexVorlageEnglisch #
#       by: t-kopp                                    #
#           (kevinkepp, ZaiLynch)                     #
#   author: Tobias Dreher, Yves Fischer (2011)        #
#                                                     #
#                                                     #
#     Marius Herget, me@mariusherget.de, TINF14A      #
#######################################################

####### INSERT FILE NAME HERE #######
DOCUMENT_NAME = dhbw-ultimate
################################
OUTPUT_DIR    = output
BACKUPNAME    = Backup/$(shell date --iso=seconds)
LASTVERSION_D = Backup/lastVersion
BACKUPBEAUTIFER = Backup/beautifer


########################################################################################
########################################################################################
### You don't need to work here if you are not familiar with latex and this template ###
########################################################################################
########################################################################################
########################################################################################
########################################################################################
########################################################################################
########################################################################################
########################################################################################
########################################################################################

# Build the LaTeX document.
all: outputdir contents report openPDF cleanup
short: outputdir contents reportSHORT openPDFSHORT cleanup

# Init PDF and last Version
init: outputdir contents report cleanup cpSave initOwnFramework

# Saves new Version, build differences PDF
version: outputdir contents differ backup cleanup save
differences: outputdir contents differ cleanup

# Remove output directory.
clean:
	@rm -rf $(OUTPUT_DIR)
	@rm -rf $(BACKUPBEAUTIFER)

# cleanup tempfiles
cleanup:
	@echo "Clean generated files"
	@rm -f *.aux 0 *.lox *.acn *.glo *.ist *.lof *.log *.lot *.lol *.toc *.alg *.glg *.gls *.acr $(DOCUMENT_NAME).pdf *out .TEX/contents.tex .TEX/appendices.tex *.run.xml *.blg *.bcf *.bbl $(DOCUMENT_NAME)-blx.bib
	@rm -f $(OUTPUT_DIR)/*.aux rm -f $(OUTPUT_DIR)/*.acn $(OUTPUT_DIR)/*.glo $(OUTPUT_DIR)/*.ist $(OUTPUT_DIR)/*.lof $(OUTPUT_DIR)/*.log $(OUTPUT_DIR)/*.lot $(OUTPUT_DIR)/*.lol $(OUTPUT_DIR)/*.toc $(OUTPUT_DIR)/*.alg $(OUTPUT_DIR)/*.glg $(OUTPUT_DIR)/*.gls $(OUTPUT_DIR)/*.acr $(OUTPUT_DIR)/*.gz $(OUTPUT_DIR)/*out
	@rm -r -f tmp
	@rm -r -f *.bak* content/**/*.bak0 content/*.bak0
	@rm -f *.*~
	@rm -f .TEX/printversion.tex

# Create LaTeX output directory.
outputdir: contents
	@echo "Create output directory."
	@$(shell mkdir -p $(OUTPUT_DIR) 2>/dev/null)
	@$(shell mkdir -p Backup 2>/dev/null)
	@$(shell mkdir -p $(LASTVERSION_D) 2>/dev/null)

# Build Bib
bibtex:
	@echo "Create Bibliography"
	@rm error.txt
	@bibtex $(DOCUMENT_NAME) > error.txt

glos:
	@echo "Make Glossaries"
	@makeglossaries -q $(DOCUMENT_NAME).glo
	@makeglossaries -q $(DOCUMENT_NAME).acn

build: contents
	@echo "Compiling LaTEX document. (1/3)"
	@pdflatex -interaction=nonstopmode $(DOCUMENT_NAME) >> error.txt


# Generate PDF output from LaTeX input files.
# make print and normal version
report: build glos bibtex build
	@echo "Compiling LaTEX document. (2/3)"
	@pdflatex -interaction=nonstopmode $(DOCUMENT_NAME) >> error.txt
	@echo "Compiling LaTEX document. (3/3)"
	@echo '\renewcommand{\isPrintVersion}{true}' > .TEX/printversion.tex
	@pdflatex -interaction=nonstopmode $(DOCUMENT_NAME) >> error.txt
	@cp $(DOCUMENT_NAME).pdf $(OUTPUT_DIR)/$(DOCUMENT_NAME)-print.pdf
	@rm -f .TEX/printversion.tex
	@echo "Print version completed. (3/3)"
	@echo '\renewcommand{\isPrintVersion}{false}' > .TEX/printversion.tex
	@pdflatex -interaction=nonstopmode $(DOCUMENT_NAME) >> error.txt
	@cp $(DOCUMENT_NAME).pdf $(OUTPUT_DIR)/$(DOCUMENT_NAME)-screen.pdf
	@echo "Screen version completed. (3/3)"

reportSHORT: build glos bibtex build
	@cp $(DOCUMENT_NAME).pdf $(OUTPUT_DIR)/PREVIEW-$(DOCUMENT_NAME).pdf

# Select all files from /content/
contents: appendices
	@rm -f .TEX/contents.tex
	@ls content/main/*.tex | awk '{printf "\\input{%s}\n", $$1}' > .TEX/contents.tex
	@echo "Content TEX files concluded in .TEX/contents.tex"

appendices:
	@rm -f .TEX/appendices.tex
	@if [ $(LANG=C ls -l content/appendices | cut -d ' ' -f 2) > 0 ]; \
	then\
		echo "No appendices recognized in content/appendices."; \
	else\
		echo "Appendices files concluded in .TEX/appendices.tex"; \
		ls content/appendices/*.tex | awk '{printf "\\input{%s}\n", $$1}' > .TEX/appendices.tex; \
	fi

# Opens PDF
openPDF:
# gnome-open $(OUTPUT_DIR)/$(DOCUMENT_NAME).pdf
openPDFSHORT:
# gnome-open $(OUTPUT_DIR)/PREVIEW-$(DOCUMENT_NAME).pdf
openPDFdifferences:
# gnome-open $(OUTPUT_DIR)/$(DOCUMENT_NAME)-differences.pdf


# Opens all files in texteditor
open:
	@$(shell gedit -s $(DOCUMENT_NAME).tex content/*.tex literatur.bib header.tex & echo OPENED!)
# TBD opens in favourite editor

# own Frameworks File
initOwnFramework:
	@test -e ownFrameworks.tex | touch ownFrameworks.tex && echo "%% Here you can include you own Frameworks (Doesnt get pushed to GIT!)" > ownFrameworks.tex

# Publish new Version
backup: contents
	@echo "Backup old files"
	@$(shell mkdir -p $(BACKUPNAME))
	@$(shell cp -r $(LASTVERSION_D)/* $(BACKUPNAME))
	@echo "Finished backup"

save: delSave cpSave

delSave:
	@$(shell rm -r $(LASTVERSION_D); mkdir $(LASTVERSION_D) 2>/dev/null)

cpSave:
	@echo "Save new Version"
	@$(shell cp -r *.tex $(LASTVERSION_D)/.)
	@$(shell cp -r *.bib $(LASTVERSION_D)/.)
	@$(shell mkdir $(LASTVERSION_D)/content 2>/dev/null)
	@$(shell cp -r content/*.tex $(LASTVERSION_D)/content/.)
	@echo "Finished save"

differ: createDiffer openPDFdifferences

createDiffer: contents
	# Pand old and new tex
	$(shell mkdir tmp; cd $(LASTVERSION_D); latexpand $(DOCUMENT_NAME).tex > ../../tmp/$(DOCUMENT_NAME)-old.tex; cd ../..)
	latexpand $(DOCUMENT_NAME).tex > tmp/$(DOCUMENT_NAME).tex
	# Create difference file
	latexdiff --exclude-textcmd="section,subsection,chapter,subsubsection,part" tmp/$(DOCUMENT_NAME)-old.tex tmp/$(DOCUMENT_NAME).tex >  $(OUTPUT_DIR)/$(DOCUMENT_NAME)-differences.tex
	pdflatex -interaction=nonstopmode $(OUTPUT_DIR)/$(DOCUMENT_NAME)-differences.tex
	cp $(DOCUMENT_NAME)-differences.pdf $(OUTPUT_DIR)

TEXFILES= $(wildcard *.tex) $(wildcard */*.tex)
TEXFILES:= $(filter-out $(addsuffix /%,$(OUTPUT_DIR)), $(TEXFILES))
beautiful: internalbeautiful cleanup

internalbeautiful:
	@echo "Beautifier for All tex files:"
	@echo $(TEXFILES)
	@$(shell mkdir -p $(BACKUPBEAUTIFER))
	@$(foreach texfile, $(TEXFILES), latexindent -s -w -c=$(BACKUPBEAUTIFER) $(texfile);)

DEBUG=$(wildcard *.bak*) $(wildcard */*.bak*)
debug:
	echo $(DEBUG)
