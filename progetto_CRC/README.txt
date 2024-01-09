Se si vuole testare solo il modulo CRC andare sulla cartella CRC e creare li un workspace modelsim o quartus
Se si vuole testare il blocco completo (SPI + CRC) andare sulla cartella "CRC con SPI" e creare li un workspace modelsim o quartus

PROGRAMMI PYTHON
Ci sono 5 programmi python che generano/usano dei file txt:
• crc_creazione_test.py: 
se lanciato genera i file "crc_test_input.txt" e "crc_test_output.txt". Il primo file contiene tutti i numeri in binario a 0 a 65365 (2^16 numeri) che verranno usati come dati di test da inviare al blocco crc durante la simulazione modelsim. Il secondo file contine la codifica crc in binario dei numeri presenti nel primo file.
• verifica_crc.py: 
file che confronta riga per riga il file "crc_test_output.txt" e il file "crc_result.txt" (quest ultimo è generato dalla simulazione modelsim come spiegato dopo) e serve per verificare che il blocco crc abbia calcolato bene tutti i dati. Se il programma trova degli errori ritorna la riga in cui ha trovato un errore.
• CRC_calculator.py: 
serve per calcolare il CRC di un dato. Chiede in input un numero intero e restituisce il valore del CRC calcolato con quel numero in intero, binario e esadecimale
• crc_testall_seriale.py:
inserisce nel registro 00 tutti i valori possibili con 16 bit. Va poi a leggere il risultato ottenuto dal calcolo nel registro 1 e lo confronta con il valore teorico. Se trova errori gli evidenzia.
• terminale.py:
funziona come putty con l'unica differenza che se scrivo nel registro 0 in automatico va a leggere il risultato del crc nel registro 1 e stampa a video il valore del CRC teorico e quello calcolato dalla scheda


SIMULAZIONI
• CRC//tb_CRC: l'obiettivo è quello di verificare che il blocco crc svolga correttamente tutte le operazioni di calcolo del crc. La simulazione invia riga per riga i dati presenti nel file "crc_test_input.txt" al registro 0 del blocco crc in modo da avviarne il calcolo, legge poi il risultato dal registro 1 e lo salva nel file "crc_result.txt". Finita questa simulazione va lanciato il programma python "verifica_crc.py".
• CRC//tb_reg: l'obiettivo e quello di vedere se fuziona la scrittura e la lettura in tutti i registri del blocco crc. In particolare viene eseguita la scrittura nel registro 0, si legge il registro 1 per verificare che sia stato eseguito correttamente il crc, si scrive nel registro 1 per resettare il crc, si legge nel registro 1 per verificare che il reset sia avvenuto, si legge nel registro 0, poi nel 2 e infine nel 3.
• CRC con SPI//tb_CRCconSPI: l'obiettivo è quello di verificare che il tutto funzioni anche introducendo il modulo SPI. In particolare si fa una scrittura nel registro 0, poi si legge dal registro 0 e infine si legge dal registro 1.