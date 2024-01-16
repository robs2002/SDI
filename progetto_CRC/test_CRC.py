import serial
import random
import crcmod.predefined

# ----- funzioni --------------------------------
def risposta_scheda():
    while (ser.in_waiting == 0):    # aspetta fino a quando hai dati in ricezione
        i=0     # do nothing
    riga_rx = ser.read(ser.in_waiting).decode()   # leggo 
    #print(riga_rx)
    messaggio = riga_rx.split()[len(riga_rx.split())-2].upper()   # prendo solo la penultima parte della stringa che sono i 4 numeri in esadecimale che mi interessano
    return messaggio

#------------------------------------------------
NUMERO_PROVE = 1000000
LUNGHEZZA_MASSIMA_MESSAGGIO = 10

# Configura la porta seriale
ser = serial.Serial('COM12', 9600)  # Abilito la seriale
crc16_func = crcmod.predefined.mkCrcFun('crc-ccitt-false')
errori = False

for test in range(NUMERO_PROVE):  
    print("TEST", test+1)

    # RESET CRC => inserisco 1 nel LSB del registro 2
    data_to_send = ("W020001").encode('utf-8')  # converte il messaggio inserito dall'utente in byte
    ser.write(data_to_send)     # invio dati tramite seriale
    risposta_scheda()    # ignoro la risposta

    lunghezza_word = random.randint(1, LUNGHEZZA_MASSIMA_MESSAGGIO)
    crc_input = ""
    for word in range(lunghezza_word): 
        numero_casuale = random.randint(0, 65535)   # genere un numero casuale tra 0 e 2^16-1
        numero_casuale_hex = format(numero_casuale, f'0{4}X')   # trasforma il numero interno in una striga formata da 4 numeri in esadecimale
        #print(numero_casuale_hex)

        crc_input = crc_input + numero_casuale_hex
        #xprint(crc_input)

        # mando il crc_input alla scheda
        data_to_send = ("W00"+numero_casuale_hex).encode('utf-8')  # converte il messaggio inserito dall'utente in byte
        ser.write(data_to_send)     # invio dati tramite seriale
        risposta_scheda()    # ignoro la risposta

        # calcolo crc teorico 
        result = crc16_func(bytes.fromhex(crc_input))  # restituisce il valore del CRC in numero intero
        crc_out_teorico = format(result, f'0{4}X')   # trasforma il numero interno in un numero esadecimale su 4 bit

        # leggo crc_output dalla scheda
        data_to_send = "R01".encode('utf-8')  # converte il messaggio inserito dall'utente in byte
        ser.write(data_to_send)     # invio dati tramite seriale
        crc_out = risposta_scheda()    # ignoro la risposta
        #print("crc_out_teorico:", crc_out_teorico,"\tcrc_out:", crc_out)

        # confronto crc_output scheda con quello calcolato
        if (int(crc_out_teorico,16) != int(crc_out,16)):
            print("Errore TEST",test, "WORD", word, ": crc atteso:", crc_out_teorico,"\tcrc calcolato: ", crc_out)
            errori = True

if errori==False:
   print("\nTEST ESEGUITO CON SUCCESSO")
   print("Nessun errore rilevato\n")

# Chiusura della porta seriale
ser.close()