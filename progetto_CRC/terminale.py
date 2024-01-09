# funziona come un terminale. Per scrivere in un registro digitare "W"+"aa"+"dddd", per leggere digitare "r"+"aa" e verrà restituito "dddd"
# se scrivo nel registro 00, il CRC viene calcolato dalla scheda. In automatico viene fatta una lettura nel registro 01 e viene riportato
# il valore del CRC calcolato dalla scheda e quello teorico


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


while(True):
    messaggio = input("Dati da inviare alla scheda: ")   # chiedo all'utente di inserire un messaggio da mandare alla scheda
    if( messaggio.lower() == "exit" ):  # per uscire dal loop scrivere "exit"
        break
    else:
        # Dati da inviare
        
        comando = messaggio[0].lower()  # primo carattere digitato. Lo converto in minuscolo
        indirizzo = messaggio[1:3]      # secondo e terzo carattere
        dati = messaggio[3:7]           # dal terzo al settimo carattere
        l = len(messaggio) 

        if (comando=='r'):   # se mando il comando di read devo aspettare la risposta e scriverla su terminale
            if (l != 3):    # verifico che la lunghezze del messaggio è correta
                print("Formato di input errato. Prova ad inserire 'R' seguito da un numero da 2 cifre in esadecimario\n")
            else:
                data_to_send = str(comando+indirizzo).encode('utf-8')  # converte il messaggio inserito dall'utente in byte
                ser.write(data_to_send)     # invio dati tramite seriale

            while (ser.in_waiting == 0):    # aspetta fino a quando hai dati in ricezione
                i=0 
            riga_rx = ser.read(ser.in_waiting).decode()   # leggo 
            print(riga_rx)
            
        elif (comando=='w'):  # se mando i dati nell'indirizzo 0 significa che volgio eseguire il CRC. Vado a verificare se il calcolo è eseguito correttamente
            if (l != 7):    # verifico che la lunghezze del messaggio è correta
                print("Formato di input errato. Prova ad inserire 'W' seguito da un numero da 6 cifre in esadecimario\n")
            else:
                data_to_send = str(messaggio).encode('utf-8')  # converte il messaggio inserito dall'utente in byte
                ser.write(data_to_send)     # invio dati tramite seriale

                while (ser.in_waiting == 0):    # aspetta fino a quando hai dati in ricezione
                    i=0 
                riga_rx = ser.read(ser.in_waiting) #leggo per svuotare il buffer
                print(riga_rx.decode())

            if (indirizzo=="00"):   
                dato = int(dati, 16)    # trasforma la striga con i dati in esadecimale in un numero intero
            
                (risultato, risultato_bin) = CRC_calculator(dato)  # funzione che calcola il CRC
                risultato_hex = format(risultato, f'0{4}x')  # trasforma il numero interno in un numero esadecimale su 4 bit

                #scrivo sulla seriale per avere il risultato del CRC
                data_to_send = "r01".encode('utf-8')  # converte il messaggio inserito dall'utente in byte
                ser.write(data_to_send)     # invio dati tramite seriale

                while (ser.in_waiting == 0):    # aspetta fino a quando hai dati in ricezione
                    i=0 
                riga_rx = ser.read(ser.in_waiting).decode()   # leggo 
                dato_rx = riga_rx.split()[len(riga_rx.split())-2]   # prendo solo la penultima parte della stringa che sono i 4 numeri in esadecimale che mi interessano
                
                print("Dati ricevuti:", dato_rx, "\tTeorico:", risultato_hex)    # stampo su seriale i dati ricevuti



# Chiusura della porta seriale
ser.close()
