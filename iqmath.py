from decimal import *
from math import *

def dec_to_i1q31(x):
    string = ''
    for b in range(0,-32,-1):
        mask = 2.0**b
        if (x >= mask):
            string = string + '1'
            x = x - fix(mask)
        else:
            string = string + '0'
    return string

def dec_to_i2q30(x):
    string = ''
    for b in range(1,-31,-1):
        mask = 2.0**b
        if (x >= mask):
            string = string + '1'
            x = x - fix(mask)
        else:
            string = string + '0'
    return string

def dec_to_i16q16(x):
    string = ''
    for b in range(15,-17,-1):
        mask = 2.0**b
        if (x >= mask):
            string = string + '1'
            x = x - fix(mask)
        else:
            string = string + '0'
    return string

def i1q31_to_dec(x):
    dec = 0
    for b, v in enumerate(x):
        dec = dec + int(v) * (2.0**(0-b))
    return fix(dec)

def i16q16_to_dec(x):
    dec = 0
    for b, v in enumerate(x):
        dec = dec + int(v) * (2.0**(15-b))
    return fix(dec)

def fix(x):
    return Decimal(x).quantize(Decimal('0.000000000001'))

def asin_fixed(x):
    return fix(asin(x))

def sqrt_fixed(x):
    return fix(sqrt(x))

def generate_asin_seeds():
    l = list()
    seed = '011111111111111'
    for i in range(2**17):
        l.append(seed + str(0)*(19-len(bin(i))) + str(bin(i))[2:])
    return l

def asin_LUT():
    seeds = generate_asin_seeds()
    print "seeds done"
    f = open("asin_LUT.dat", 'w')
    g = open("asin_LUT_seeds.dat", 'w')
    fstring = ''
    gstring = ''
    ind = 0
    
    for seed in seeds:
        ind = ind + 1
        res = dec_to_i2q30(asin_fixed(i1q31_to_dec(seed)))
        fstring = fstring + res + '\n'
        gstring = gstring + seed + '\n'
        if (ind % 2**16 == 0):
                f.write(fstring)
                g.write(gstring)
                fstring = ''
                gstring = ''
    f.write(fstring)
    g.write(gstring)
        
def generate_sqrt_seeds():
    l = list()
    seed = '00000000000'
    for i in range(2**21):
        l.append(seed + str(0)*(23-len(bin(i))) + str(bin(i))[2:])
    return l

def sqrt_LUT():
    seeds = generate_sqrt_seeds()
    print "seeds done"
    f = open("sqrt_LUT.dat", 'w')
    g = open("sqrt_LUT_seeds.dat", 'w')
    fstring = ''
    gstring = ''
    ind = 0
        
    for seed in seeds:
        ind = ind + 1
        res = dec_to_i16q16(sqrt_fixed(i16q16_to_dec(seed)))
        fstring = fstring + res + '\n'
        gstring = gstring + seed + '\n'
        if (ind % 2**16 == 0):
                print "here"
                f.write(fstring)
                g.write(gstring)
                fstring = ''
                gstring = ''
    f.write(fstring)
    g.write(gstring)
                
getcontext().prec = 12 + 20
#asin_LUT()
sqrt_LUT()

#print i1q31_to_dec('01111111111111100000000000000000')
#print dec_to_i1q31(Decimal('0.001'))