Ci sono 3 CARTELLE:
• fpga-user: contiene tutto il necessario per compilare il progetto su quartus e quindi creare il file RBF da caricare sulla VirtLab
• testbench: contiene 2 testbench (ne parlo dopo di cosa fanno), e il file "CRCconPI.vhd" che serve per far funzionare l'ononima testbench
• SLAVE_CRC: cartella che è presente in entrambe le cartelle precedenti (deve essere la stessa cartella quindi se ne modifichi una poi devi cambiare anche l'altra). Essa contiene tutti i file vhd che servono per il progetto (NO testbench e NO fpga-user.vhd). L'idea di questa cartella e non avere file vhd in giro che altrimenti si perdono.

SIMULAZIONI
• tb_CRC.vhd:
fa il test del solo CRC provandone tutte le funzionalità:
	- resetta la scheda;
	- fa una lettura in tutti i registri (da o a 5);
	- scrive nel registro 0 per calcolare il CRC di una word (word=16bit);
	- scrive di nuovo nel registro 0 in modo che il CRC sia calcolato su 2 word (quella precedente più questa appena inserita);
	- scrive un 1 nel LSB del registo 2 in modo da resettare il CRC;
	- scrive nuovamente nel registro 0 per calcolare il CRC di una word (word=16bit). Questo serve per vedere se il reset del CRC ha avuto successo.
• tb_CRCconSPI.vhd:
fa il test di tutto il progetto qundi del CRC con l'SPI. Tutte le funzionalità del CRC sono state testate nellla testbench precedente quindi provo solo a fare una scrittura e due letture per vedere che tutto sia collegato bene:
	- scittura nel registro 0;
	- lettura dal registro 0;
	- lettura dal registro 1.

PROGRAMMA PYTHON
• test_CRC.py: fa un test su larga scala del corretto calcolo del CRC. Nel programma vanno impostate 2 variabili:
	- NUMERO_PROVE
	- LUNGHEZZA_MASSIMA_MESSAGGIO
Vengono teste un numero di messaggi pari al NUMERO_PROVE. Ogni messaggio è composta da un numero casuale di word compresa tra 0 e LUNGHEZZA_MASSIMA_MESSAGGIO. Ogni word è a sua olta un numero casuale tra 0 e 65535 (16bit)
Il programma controlla che la scheda VirtLab calcoli correttamente il CRC di ogni singolo messaggio e nel caso evidenzia l'errore. Inoltre, in ognuno dei messaggi, controlla che sia eseguito correttamente il CRC di ogni pezzo del messaggio (esempio: word0, word0+word1, word0+word1+word2)
