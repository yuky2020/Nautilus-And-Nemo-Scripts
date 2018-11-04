#!/usr/bin/python

#short mark, dot or 'dit' (.) = .
#longer mark, dash or 'dah' (-) = -
#intra-character gap (between the dots and dashes within a character) = no space
#short gap (between letters) = single space
#medium gap (between words) = double space

import sys
__author__="Aanand Natarajan"

#morse code dictionary
codes = {'1':".----",'2':"..---",'3':"...--",'4':"....-",'5':".....",'6':"-....",'7':"--...",'8':"---..",
'9':"----.",'0':"-----",'A':".-",'B':"-...",'C':"-.-.",'D':"-..",'E':".",'F':"..-.",'G':"--.",
'H':"....",'I':"..",'J':".---",'K':"-.-",'L':".-..",'M':"--",'N':"-.",'O':"---",'P':".--.",
'Q':"--.-",'R':".-.",'S':"...",'T':"-",'U':"..-",'V':"...-",'W':".--",'X':"-..-",'Y':"-.--",
'Z':"--..",
#punctuations
',':"--..--",'.':".-.-.-",'?':"..--..",';':"-.-.-",':':"---...",'/':"-..-.",
'-':"-....-","'":".----.",'(':"-.--.",')':"-.--.-",'!':"-.-.--",'&':".-...",
'=':"-...-",'+':".-.-.",'_':"..--.-",'"':".-..-.",'$':"...-..-",'@':".--.-.",
#space
' ':"|"}

binary = {'.':'.','-':'-',',':' ','|':'  '}


def encode(value):
    """ encodes the value into morse code """
    morse_value=""
    value.replace('*', 'X')
    value.replace('^', 'XX')
    for c in value:
       try :
               morse_value += codes[c.upper()]+','
       except :
         print "Unintended character " + c + " omitted"
    return _get_binary(morse_value)

def decode(morse_code_value):
    """ decodes the morse bytes """
    decoded_value = _decode_binary(morse_code_value)
    ascii_value=""
    for v in decoded_value.split(","):
        ascii_value += _get_key(v)
    return ascii_value

def _get_binary(value):
     binary_value = ""
     for c in value:
         binary_value += binary[c]
     return binary_value

def _get_key(value):
     """ returns the key for the given value """
     for k,v in codes.items():
         if v == value:
            return k
     return ''

def _decode_binary(binary):
    dah_replaced = binary.replace('-', '-')
    dit_replaced = dah_replaced.replace('.', '.')
    comma_replaced = dit_replaced.replace(' ', ',')
    zero_replaced = comma_replaced.replace('', '|,')
    return zero_replaced

def _do_decode(value):
    print "Decoded : "+decode(value)

def _do_encode(value):
    print "Encoded : "+encode(value)

if __name__ == "__main__":
   if len(sys.argv) > 2:
      if sys.argv[1] == 'd' :
         print "decoding"
         _do_decode(sys.argv[2])
      else:
         print "encoding"
         _do_encode(sys.argv[2])
   elif len(sys.argv) > 1:
        print "encoding"
        _do_encode(sys.argv[1])
   else:
        print "Usage : "+sys.argv[0]+" [d (decode) |e (encode)] [input string]"
