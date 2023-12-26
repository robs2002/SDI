file1 = open("CRC//crc_result.txt", "r")
file2 = open("CRC//crc_test_output.txt", "r")

n=0
errori = 0
for riga1 in file1:
    
    riga2=file2.readline()
    n=n+1

    if ( riga1 != riga2 ):
        print("Errore alla riga ", n, "\tcrc atteso:", riga2, "\tcrc calcolato: ", riga1)
        errori=errori+1
    
print(n, "elementi processati con", errori, "errori")


file1.close()
file2.close()

print("FINITO")