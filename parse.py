def binary(x,bits=5):
    ans = ""
    if x >= 0: 
        temp = bin(x)[2:]
        ans = "0"*(bits-len(temp))+ temp
        return ans
    else:
        temp = abs(x)
        temp = 2**bits -temp
        temp = bin(temp)[2:]
        ans = "1"*(bits-len(temp))+ temp
        return ans


f = open("instr.txt")
inst= {}
inst["lw"]="1011"
inst["sw"]="1111"
inst["beq"]="1000"
inst["addi"]="0100"
inst["j"] = "0010"
funct={}
funct["add"] = "000"
funct["sub"] = "010"
funct["and"] = "100"
funct["or"] = "101"
funct["slt"] = "010"
instkeys = inst.keys()
for lines in f:
    bytecode = ""
    decode = lines.split()
    if(len(decode)==2):
        bytecode = inst[decode[0]]+binary(int(decode[1]),12)
    elif decode[0] in instkeys:
        rd = int(decode[1][1:])
        ra = int(decode[2][1:])
        imm = int(decode[3])
        bytecode = inst[decode[0]]+ binary(rd,3) + binary(ra,3) + binary(imm,6)
        

    else:
        bytecode = bytecode+"0000"
        rd = int(decode[1][1:])
        ra = int(decode[2][1:])
        rb = int(decode[3][1:])
        bytecode =bytecode+binary(rd,3)+binary(ra,3)+binary(rb,3)
        bytecode = bytecode+funct[decode[0]]
    print bytecode[:8]
    print bytecode[8:16]
        

    
