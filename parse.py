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


f = open("fib.txt")
inst= {}
inst["lw"]="100011"
inst["sw"]="101011"
inst["beq"]="000100"
inst["addi"]="001000"
inst["j"] = "000010"
funct={}
funct["add"] = "100000"
funct["sub"] = "100010"
funct["and"] = "100100"
funct["or"] = "100101"
funct["slt"] = "101010"
instkeys = inst.keys()
for lines in f:
    bytecode = ""
    decode = lines.split()
    if(len(decode)==2):
        bytecode = inst[decode[0]]+binary(int(decode[1]),26)
    elif decode[0] in instkeys:
        rt = int(decode[1][1:])
        rs = int(decode[2][1:])
        imm = int(decode[3])
        bytecode = inst[decode[0]]+ binary(rs) + binary(rt) + binary(imm,16)
        

    else:
        bytecode = bytecode+"000000"
        rd = int(decode[1][1:])
        rs = int(decode[2][1:])
        rt = int(decode[3][1:])
        bytecode =bytecode+binary(rs)+binary(rt)+binary(rd)+"00000"
        bytecode = bytecode+funct[decode[0]]
    print bytecode
        

    
