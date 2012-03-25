temp = open("instruction.txt",'w')
for i in range(32):
    hexValue=hex(i)[2:]
    if len(hexValue)==1:
        temp.write("0000000"+hexValue)
    else:
        temp.write("000000"+hexValue)
    temp.write("\n")




