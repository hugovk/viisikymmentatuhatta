###########################################

## MULTIMARKDOWN FILES > MOBI, PDF AND EPUB

## IH, 23 JUNE 2013

## This script takes a group of files in Multimarkdown,
## combines them into a single file, and then produces
## MOBI, EPUB and PDF. Also runs an epub check program.

## Expects in a file called 1_meta_data.md

## Expects to have a directory called Publication_Ready.
## Will pipe command output to Publication_Ready/Log.txt

## Unusual commands used (i.e. you'll need to install these):
## ebook-convert [http://manual.calibre-ebook.com/cli/ebook-convert.html]
## multimarkdown [http://fletcherpenney.net/multimarkdown/use/]

###########################################

# NaNoGemMo: Generate the actual book contents
./viisikymmentatuhatta.py -f mmd > 4_main.mmd
mkdir Publication_Ready

# Find out the directory that this script is working within
DIR=`dirname "$1"`

# Go there
cd "$DIR"

# Extract meta data from the file called '1_meta_data.mmd'
title=`/usr/local/bin/multimarkdown 1_meta_data.mmd --extract="Title"`
short_title=`/usr/local/bin/multimarkdown 1_meta_data.mmd --extract="ShortTitle"`
author=`/usr/local/bin/multimarkdown 1_meta_data.mmd --extract="Author"`
tags=`/usr/local/bin/multimarkdown 1_meta_data.mmd --extract="Tags"`
cover=`/usr/local/bin/multimarkdown 1_meta_data.mmd --extract="Cover"`

# LOG Date
echo "" >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt
echo `date` >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt

# Concatenate all the files passed to this script
cat *.mmd > Publication_Ready/$short_title.mmd

# LOG
echo "" >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt
echo ******* Compiling HTML from Multimarkdown... >> Publication_Ready/Log.txt

# Run 'multimarkdown' to produce HTML, smart mode, appending result to log
echo "HTML"
/usr/local/bin/multimarkdown Publication_Ready/$short_title.mmd --output=Publication_Ready/$short_title.html --smart >> Publication_Ready/Log.txt

# LOG
echo "" >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt
echo ******* Compiling PDF… >> Publication_Ready/Log.txt

# Make PDF
echo "PDF"
/Applications/calibre.app/Contents/MacOS/ebook-convert Publication_Ready/$short_title.html Publication_Ready/$short_title.pdf --authors="$author" --title="$title" --tags="$tags" --paper-size a4 --pdf-page-numbers --margin-top 72 --margin-left 72 --margin-right 72 --margin-bottom 72 --disable-font-rescaling --pdf-default-font-size 16 --pdf-header-template "_SECTION_" >> Publication_Ready/Log.txt

# LOG
echo "" >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt
echo ******* Compiling MOBI… >> Publication_Ready/Log.txt

# Make MOBI
echo "MOBI"
/Applications/calibre.app/Contents/MacOS/ebook-convert Publication_Ready/$short_title.html Publication_Ready/$short_title.mobi --authors="$author" --title="$title" --tags="$tags" --output-profile=kindle >> Publication_Ready/Log.txt

# LOG
echo "" >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt
echo ******* Compiling EPUB… >> Publication_Ready/Log.txt

# Make EPUB
echo "EPUB"
/Applications/calibre.app/Contents/MacOS/ebook-convert Publication_Ready/$short_title.html Publication_Ready/$short_title.epub --remove-first-image --authors="$author" --title="$title" --tags="$tags" --output-profile=ipad >> Publication_Ready/Log.txt

# LOG
echo "" >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt
echo Cleaning up temporary files... >> Publication_Ready/Log.txt

# Clean up the temporary HTML and mmd files
# rm $short_title.html $short_title.mmd >> Publication_Ready/Log.txt

# LOG
echo "" >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt
echo Job done bish bash `date` >> Publication_Ready/Log.txt
