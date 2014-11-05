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

# Find out the directory that this script is working within
DIR=`dirname "$1"`

# Go there
cd "$DIR"

# Extract meta data from the file called '1_meta_data.mmd'
title=`/usr/local/bin/multimarkdown 1_meta_data.mmd --extract="Title"`
revision=`/usr/local/bin/multimarkdown 1_meta_data.mmd --extract="Revision"`
short_title=`/usr/local/bin/multimarkdown 1_meta_data.mmd --extract="ShortTitle"`
author=`/usr/local/bin/multimarkdown 1_meta_data.mmd --extract="Author"`
series=`/usr/local/bin/multimarkdown 1_meta_data.mmd --extract="Series"`
series_index=`/usr/local/bin/multimarkdown 1_meta_data.mmd --extract="SeriesIndex"`
tags=`/usr/local/bin/multimarkdown 1_meta_data.mmd --extract="Tags"`
cover=`/usr/local/bin/multimarkdown 1_meta_data.mmd --extract="Cover"`

# LOG Date
echo "" >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt
echo `date` $revision >> Publication_Ready/Log.txt 
echo "" >> Publication_Ready/Log.txt

# Concatenate all the files passed to this script
cat "$@" > $short_title.mmd 

# LOG
echo "" >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt
echo ******* Compiling HTML from Multimarkdown... >> Publication_Ready/Log.txt

# Run 'multimarkdown' to produce HTML, smart mode, appending result to log
/usr/local/bin/multimarkdown $short_title.mmd --output=$short_title.html --smart >> Publication_Ready/Log.txt

# LOG
echo "" >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt
echo ******* Compiling MOBI… >> Publication_Ready/Log.txt

# Make MOBI
ebook-convert $short_title.html Publication_Ready/$short_title[$revision].mobi --authors="$author" --series="$series" --series-index=$series_index --title="$title" --tags="$tags" --output-profile=kindle >> Publication_Ready/Log.txt

# LOG
echo "" >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt
echo ******* Compiling PDF… >> Publication_Ready/Log.txt

# Make PDF
ebook-convert $short_title.html Publication_Ready/$short_title[$revision].pdf --authors="$author" --series="$series" --series-index=$series_index --title="$title" --tags="$tags" >> Publication_Ready/Log.txt

# LOG
echo "" >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt
echo ******* Compiling EPUB… >> Publication_Ready/Log.txt

# Make EPUB
ebook-convert $short_title.html Publication_Ready/$short_title[$revision].epub --remove-first-image --authors="$author" --series="$series" --series-index=$series_index --title="$title" --tags="$tags" --output-profile=ipad >> Publication_Ready/Log.txt 

# LOG
echo "" >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt
echo Cleaning up temporary files... >> Publication_Ready/Log.txt

# Clean up the temporary HTML and mmd files
rm $short_title.html $short_title.mmd >> Publication_Ready/Log.txt

# LOG
echo "" >> Publication_Ready/Log.txt
echo "" >> Publication_Ready/Log.txt
echo Job done bish bash `date` >> Publication_Ready/Log.txt
