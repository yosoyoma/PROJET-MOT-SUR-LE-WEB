#!/usr/bin/python
import sys, getopt
from konlpy.tag import Okt

def tokenize(text):
    
    #Initialize the class as an object
    okt=Okt()
    return okt.morphs(text.replace('\n',' '))

def set_getops(argv):
    global input_file
    global process

    input_file=""
    process=""

    try:
        opts, args = getopt.getopt(argv,"hi:g:",["in_file=","get="])

    except getopt.GetoptError:
      print('script.py -i <inputfile> -g <frequecy/bigrams>')
      sys.exit(2)
    
    for opt, arg in opts:
      if opt == '-h':
         print('script.py -i <input_file> -g <index/bigrams>')
         sys.exit()
      elif opt in ("-i", "--ifile"):
         input_file = arg
      elif opt in ("-g", "--get"):
         process = arg


def read_file(file_path):
    with open(file_path,'r',encoding="UTF-8") as file :
        return file.read()

def get_frequency(tokens, reverse=True):
    return sorted(set([(tokens.count(i),i) for i in tokens]), reverse=reverse)

def make_bigrams(words):
    return [(i,j) for (i,j) in zip(*[words[i:] for i in range(2)])]

def main(argv):

    set_getops(argv)
    #print(input_file)
    text = read_file(input_file)

    words = tokenize(text)

    if process=='index':
        #print('-----------------')
        for (f,w) in get_frequency(words):
            print('{0}\t{1}'.format(f,w))
    elif process=='bigrams':
        for (w1,w2) in make_bigrams(words):
            print('{0}\t{1}'.format(w1,w2))

if __name__ == "__main__":
    
    main(sys.argv[1:])



