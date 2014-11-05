#!/usr/bin/env python
# encoding: utf-8
"""
Make a catalogue of Finnish numbers.
"""
from __future__ import print_function, unicode_literals

import fino
import argparse

# pip install fino inflect roman sympy

WORDS = {}
LIMIT = 10000
TITLE_MMD = "2_title_page.mmd"
TOC_MMD = "3_table_of_contents.mmd"


def init():
    """Fill a dict with 10,000 numbers"""
    for i in range(1, LIMIT+1):
        WORDS[i] = fino.to_finnish(i)


def print_title(title, subtitles=None, subsubtitles=None, format="text"):
    global title_page
    if format == "mmd":
        title_page.write("# " + title + "\n")
        if subtitles:
            for sub in subtitles:
                title_page.write("## " + sub + "\n")
        if subsubtitles:
            for sub in subsubtitles:
                title_page.write("### " + sub + "\n")
    else:
        print(title)
        if subtitles:
            for sub in subtitles:
                print(sub)
        if subsubtitles:
            for sub in subsubtitles:
                print(sub)


def print_chapter((number, title, text), format="text"):
    global toc
    title = "Chapter " + str(number) + ": " + title
    toc.write("[" + title + "][]\n\n")
    if format == "mmd":
        print("## " + title)
        print(text.encode("utf-8"))
    else:
        print(title)
        print(text.encode("utf-8"))


def book(format):
    print_title("50 000 Finnish Numbers",
                ["And 5 000 Each of Roman and English"],
                ["by hugovk", "For NaNoGenMo 2014"],
                format=format)
    print_chapter(chapter(1), format)
    print_chapter(chapter(2), format)
    print_chapter(chapter(3), format)
    print_chapter(chapter(4), format)
    print_chapter(chapter(5), format)
    print_chapter(chapter(6), format)


def chapter(number):
    if number == 1:
        title = "10 000 Finnish Numbers"
        text = " ".join(WORDS.values())

    elif number == 2:
        title = "10 000 Finnish Numbers by Length of Word"
        text = " ".join(sorted(WORDS.values(), key=len))

    elif number == 3:
        title = "10 000 Finnish Numbers in Alphabetical Order"
        text = " ".join(sorted(WORDS.values()))

    elif number == 4:
        title = "5 000 Roman Numerals and 5 000 Finnish Numbers"
        import roman
        out = []
        for i in range(1, 4999+1):
            out.append(roman.toRoman(i))
            out.append(WORDS[i])
        out.append("MMMMM")
        out.append(WORDS[5000])

        text = " ".join(out)

    elif number == 5:
        title = "10 000 Alternating Finnish and English Numbers"
        import inflect
        p = inflect.engine()
        out = []
        for i in range(1, LIMIT+1):
            if i % 2:
                out.append(WORDS[i])
            else:
                out.append(p.number_to_words(i))

        text = " ".join(out)

    elif number == 6:
        title = "10 000 Digits of Pi in Finnish"
        from sympy.mpmath import mp
        mp.dps = LIMIT  # number of digits
        words = WORDS.copy()
        words[0] = fino.to_finnish(0)
        out = []
        for c in str(mp.pi):
            if c == ".":
                out.append("pilkku")
            else:
                out.append(words[int(c)])

        text = " ".join(out)

    return (number, title, text)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Make a catalogue of Finnish numbers.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-f', '--format', default="text", help="text or mmd")
    args = parser.parse_args()

    init()
    title_page = open(TITLE_MMD, 'w+')
    toc = open(TOC_MMD, 'w+')
    toc.write("##Table of Contents\n\n")
    book(format=args.format)
    title_page.close()
    toc.close()


# End of file
