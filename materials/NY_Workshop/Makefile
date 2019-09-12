SOURCES=$(shell find . -name *.Rmd)
SOURCES := $(wildcard *.Rmd)
pdfTARGETS=$(SOURCES:%.Rmd=%.pdf)
RTARGETS=$(SOURCES:%.Rmd=%.R)

%.R: %.Rmd
	@echo "$< -> $@"
	@Rscript -e "knitr::purl('$<')"

%.pdf: %.Rmd header.tex
	@echo "$< -> $@"
	@Rscript -e "rmarkdown::render('$<')"

default: $(pdfTARGETS) $(RTARGETS)

clean:
	rm -rfv $(TARGETS)
	latexmk -c
	rm -rf *_cache/
	rm -rf *_files/
	rm -rf Rfigs/*

deploy:
	rsync -zrvce 'ssh -p 18765' $(pdfTARGETS) robjhynd@m80.siteground.biz:public_html/nyc2018
