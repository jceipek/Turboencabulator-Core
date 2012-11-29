from decimal import *
from math import *

def flip(x):
    if x == '1': return '0'
    if x == '0': return '1'

def sext(x, sgn):
    return str(int(sgn))*(32 - len(x)) + x

def dec_to_i1q31(x):
    string = ''
    isneg = x < 0
    x = abs(x)
    for b in range(-1,-32,-1):
        mask = 2.0**b
        if (x >= mask):
            string = string + '1'
            x = x - fix(mask)
        else:
            string = string + '0'
    if isneg:
        flip_string = ''
        for a in string:
            flip_string = flip_string + flip(a)
        string = bin(int(flip_string, 2) + 1)[2:]
    return sext(string, isneg)

def dec_to_i2q30(x):
    string = ''
    isneg = x < 0
    x = abs(x)
    for b in range(0,-31,-1):
        mask = 2.0**b
        if (x >= mask):
            string = string + '1'
            x = x - fix(mask)
        else:
            string = string + '0'
    if isneg:
        flip_string = ''
        for a in string:
            flip_string = flip_string + flip(a)
        string = bin(int(flip_string, 2) + 1)[2:]
    return sext(string, isneg)

def dec_to_i3q29(x):
    string = ''
    isneg = x < 0
    x = abs(x)
    for b in range(1,-30,-1):
        mask = 2.0**b
        if (x >= mask):
            string = string + '1'
            x = x - fix(mask)
        else:
            string = string + '0'
    if isneg:
        flip_string = ''
        for a in string:
            flip_string = flip_string + flip(a)
        string = bin(int(flip_string, 2) + 1)[2:]
    return sext(string, isneg)

def dec_to_i7q25(x):
    string = ''
    isneg = x < 0
    x = abs(x)
    for b in range(5,-26,-1):
        mask = 2.0**b
        if (x >= mask):
            string = string + '1'
            x = x - fix(mask)
        else:
            string = string + '0'
    if isneg:
        flip_string = ''
        for a in string:
            flip_string = flip_string + flip(a)
        string = bin(int(flip_string, 2) + 1)[2:]
    return sext(string, isneg)

def dec_to_i16q16(x):
    string = ''
    isneg = x < 0
    x = abs(x)
    for b in range(14,-17,-1):
        mask = 2.0**b
        if (x >= mask):
            string = string + '1'
            x = x - fix(mask)
        else:
            string = string + '0'
    if isneg:
        flip_string = ''
        for a in string:
            flip_string = flip_string + flip(a)
        string = bin(int(flip_string, 2) + 1)[2:]
    return sext(string, isneg)

def dec_to_i32(x):
    string = ''
    isneg = x < 0
    x = abs(x)
    for b in range(30,-1,-1):
        mask = 2.0**b
        if (x >= mask):
            string = string + '1'
            x = x - fix(mask)
        else:
            string = string + '0'
    if isneg:
        flip_string = ''
        for a in string:
            flip_string = flip_string + flip(a)
        string = bin(int(flip_string, 2) + 1)[2:]
    return sext(string, isneg)

def i1q31_to_dec(x): #cheating because this actually does u1q31, but the seeds behave well
    dec = 0
    for b, v in enumerate(x):
        dec = dec + int(v) * (2.0**(0-b))
    return fix(dec)

def i16q16_to_dec(x): #cheating because this actually does u16q16, but the seeds behave well
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
    seed = '01111111111111'
    for i in range(2**18):
        l.append(seed + str(0)*(20-len(bin(i))) + str(bin(i))[2:])
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
                f.write(fstring)
                g.write(gstring)
                fstring = ''
                gstring = ''
    f.write(fstring)
    g.write(gstring)

def convert_coeffs():
    e = open("asin_coeffs_raw_p1.txt", 'r')
    estring = ''
    E = open("asin_coeffs_p1.dat", 'w')
    
    for line in e: 
        if (line[0] not in ['#','\n']):
            estring = estring + dec_to_i16q16(fix(line)) + '\n'
    
    f = open("asin_coeffs_raw_p2.txt", 'r')
    fstring = ''
    F = open("asin_coeffs_p2.dat", 'w')
    
    for line in f: 
        if (line[0] not in ['#','\n']):
            fstring = fstring + dec_to_i32(fix(line)) + '\n'
            
    E.write(estring)
    F.write(fstring)
    
    g = open("sqrt_coeffs_raw.txt", 'r')
    gstring = ''
    G = open("sqrt_coeffs.dat", 'w')
    
    for line in g:
        if (line[0] not in ['#','\n']):
            gstring = gstring + dec_to_i7q25(fix(line)) + '\n'
    
    G.write(gstring)

getcontext().prec = 12 + 20
#asin_LUT()
#sqrt_LUT()
#convert_coeffs()

#print i1q31_to_dec('01111111111111100000000000000000')
#print dec_to_i1q31(Decimal('0.001'))
#print dec_to_i7q25(fix('-9.467e-08'))
#print dec_to_i7q25(fix('-3.347e-08'))

#pi
#print dec_to_i3q29(fix(pi))