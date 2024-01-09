# Questo programma inserisce nel registro 00 tutti i valori possibili su 16 bit (65536 valori). Va poi a leggere dal registro 01
# il risultato del CRC calcolato dalla scheda, calcola il CRC teorico e infine va a controntare il CRC teorico con quello calcolato
# dalla scheda. Se trova errori lo evidenzia

import serial

#----------funzioni------------------------------------------------------------
def xor(a, b):
    if a==b:
        return '0'
    else:
        return '1'
    
def CRC_calculator(numero):
    numero_bin = format(numero, f'0{16}b')  # trasforma il numero interno in un numero binario su 16 bit

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
    
    return (risultato, risultato_bin)
#------------------------------------------------------------------------

# Configura la porta seriale
ser = serial.Serial('COM12', 9600)  # Abilito la seriale
errori=False

for dato in range(65536):     # per tutti i campioni possibili in 16bit
    print(dato)

    # CRC terorico
    (risultato, risultato_bin) = CRC_calculator(dato)  # funzione che calcola il CRC
    teorico = format(risultato, f'0{4}x')  # trasforma il numero interno in un numero esadecimale su 4 bit

    # CRC calccolato dalla scheda
    # write
    dato_hex = format(dato, f'0{4}x')  # trasforma il numero interno in un numero esadecimale su 4 bit
    data_to_send = ("w00" + str(dato_hex)).encode('utf-8')  # converte "w00"+dato in byte
    ser.write(data_to_send)     # invio dati tramite seriale
    while (ser.in_waiting == 0):    # aspetta fino a quando hai dati in ricezione
        i=0 
    riga_rx = ser.read(ser.in_waiting) #leggo per svuotare il buffer

    #read
    data_to_send = "r01".encode('utf-8')  # converte il messaggio inserito dall'utente in byte
    ser.write(data_to_send)     # invio dati tramite seriale

    while (ser.in_waiting == 0):    # aspetta fino a quando hai dati in ricezione
        i=0 
    riga_rx = ser.read(ser.in_waiting).decode()   # leggo 
    calcolato = riga_rx.split()[len(riga_rx.split())-2]   # prendo solo la penultima parte della stringa che sono i 4 numeri in esadecimale che mi interessano
    
    if (calcolato != teorico):
        print("CRC teorico:", teorico, "\tcalcolato:", calcolato)
        errori=True

if (errori==False):
    print("Errori non rilevati")

# Chiusura della porta seriale
ser.close()
