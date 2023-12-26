def xor(a, b):
    if a==b:
        return '0'
    else:
        return '1'

# apertura documento su cui salvare i valori
ifile = open("CRC//crc_test_input.txt", "w")
ofile = open("CRC//crc_test_output.txt", "w")

#numero = 50469     # INSERISCI QUI IL NUMERO DA TESTARE IN BASE 10

for numero in range(65536):

    numero_bin = format(numero, f'0{16}b')  # trasforma il numero interno in un numero binario su 16 bit
    numero_hex = format(numero, f'0{4}X')   # trasforma il numero interno in un numero esadecimale su 4 bit
    #print("Input: ", numero_bin)
    #print("Input: ", numero)
    #print("Input: ", numero_hex)
    ifile.write(numero_bin)
    ifile.write("\n")


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
    #print("Risultato: ", stringa_binaria)
    risultato = int(risultato_bin, 2)
    risultato_hex = format(risultato, f'0{4}X')   # trasforma il numero interno in un numero esadecimale su 4 bit
    #print("Risultato: ", risultato)
    print("Risultato: ", risultato_bin)
    ofile.write(risultato_bin)
    ofile.write("\n")

ifile.close()
ofile.close()

print("FINITO")