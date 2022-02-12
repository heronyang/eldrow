#!/usr/bin/python3
import urllib.request

with open('assets/dictionary.txt', 'w') as fout:
    for line in urllib.request.urlopen(
            'https://raw.githubusercontent.com/dwyl/english-words/master/words.txt'
    ):
        word = line.decode('utf-8').strip().upper()
        if len(word) != 5:
            continue
        if not word.isalpha():
            continue
        fout.write(word + '\n')
