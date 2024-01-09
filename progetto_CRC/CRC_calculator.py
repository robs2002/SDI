def xor(a, b):
    if a==b:
        return '0'
    else:
        return '1'




while(True):
    numero_hex = input("Inserisci il numero da convertire:")
    numero_int = int(numero_hex, 16)
    numero_bin = format(numero_int, f'0{16}b')  # trasforma il numero interno in un numero binario su 16 bit
    
    print("Input_bin: ", numero_bin)
    print("Input_int: ", numero_int)
    print("Input_hex: ", numero_hex)


    vettore = []
    for bit in numero_bin:              # aggiungo al vettore i bit del numero
        vettore.append(bit)
    vettore.append('0')                 # aggiungo uno 0 al vettore per fare il crc

    for i in range(16):
        msb = vettore[0]
        vettore[4] = xor(msb, vettore[4])
        vettore[11] = xor(msb, vettore[11])
        vettore[16] = xor(msb, vettore[16])
        vettore.pop(0)
        vettore.append('0')
        #print(vettore)

    vettore.pop(16)

    risultato_bin = ''.join(str(bit) for bit in vettore)
    print("Risultato_bin: ", risultato_bin)
    risultato = int(risultato_bin, 2)
    risultato_hex = format(risultato, f'0{4}X')   # trasforma il numero interno in un numero esadecimale su 4 bit
    print("Risultato_int: ", risultato)
    print("Risultato_hex: ", risultato_hex, "\n")

