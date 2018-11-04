#!/usr/bin/env python

romanize = lambda y,x=[],nums={ 1000:"M",900:"CM",500:"D",400:"CD",100:"C",90:"XC",50:"L",40:"XL",10:"X",9:"IX",5:"V",4:"IV",1:"I"}: (lambda
ry=x.__delslice__(0,40),ro=(lambda : map(lambda g,r=lambda b:x.append(y[-1]/b),t=lambda v:y.append(y[-1]%v):map(eval,["r(g)","t(g)"])
,sorted(nums.keys())[::-1]))():"".join(map(lambda fg: map(lambda ht: nums[ht],sorted(nums.keys())[::-1])[fg]
* x[fg],range(len(x)))))()

def main():
    while True:
        number = raw_input("Please enter a number between 1 and 5000 to convert to Roman numerals or the word \"exit\" to leave: ")
        if number.lower() == 'exit': exit()
        try: number = int(number)
        except:
            print "%s is not a valid number. Please try again" % number, "\n"
            continue
        if number > 5000:
            print "%s is too high. Please try again" % number, "\n"
            continue
        if number <= 0:
            print "%s is too low. Please try again" % number, "\n"
            continue
        print "%d  :  %s" % (number,romanize([number])), "\n"

if __name__=='__main__':
    main()
