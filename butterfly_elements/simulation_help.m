clc % pulire command window
clear % pulire tutte le variabili
close all % chiudiamo tutti i programmi matlab

%% presimulazione

matrice_vettori=[-0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5;
           -0.5 0 0.5 0 -0.5 0 0.5 0 -0.5 0 0.5 0 -0.5 0 0.5 0;
           0.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
           -0.5 -0.5 0.5 0.5 -0.5 -0.5 0.5 0.5 -0.5 -0.5 0.5 0.5 -0.5 -0.5 0.5 0.5;
           0.25 0.25 0.25 0.25 0.25 0.25 0.25 0.25 0.25 -0.25 -0.25 -0.25 -0.25 -0.25 -0.25 -0.25;
           0 0 0 0 0 0 0 0 0.375 0 0 0 0 0 0 0]; % vettori di prova generici

n_elementi_totali = 16; % numero di elementi per vettore
num_prove = 44; % numero di prove da effettuare oltre le generiche
num_vettori = 6 + num_prove; % numero totale dei vettori di prova
matrice_vettori(7:num_vettori,:) = rand(num_prove, n_elementi_totali) - 0.5; % generazione degli altri vettori di prova randomici

fileID = fopen('xin.txt', 'w');
if fileID == -1   % apro e controllo se il file è stato aperto senza errori
    error('Impossibile aprire il file per la scrittura.');
end

for riga = 1:num_vettori
    for colonna = 1:n_elementi_totali % cicli annidati per lavorare elemento per elemento
        numero_decimale=matrice_vettori(riga,colonna); % numero decimale della matrice
        bit_totali = 24; % numero di bit totali del numero da creare
        bit_frazionari = 23; % numero di bit frazionari
        numero_sfixed = fi(numero_decimale, 1, bit_totali, bit_frazionari); % trasformazione in sfixed
        numero_binario = bin(numero_sfixed); % trasformazione in binario
        fprintf(fileID, '%s\n', numero_binario); % scrittura sul file
    end
    for j = 1:16 % scrivo sul file tutti zeri ogni 16 valori per non avere parti immaginarie
        fprintf(fileID, '000000000000000000000000\n'); 
    end
end

fclose(fileID); % chiudo il file

nome_file = 'xout.txt'; 
fileID = fopen(nome_file, 'w');
if fileID == -1 % apro in scrittura per eliminare tutto quello che ci stava scritto e controllo se il file è stato aperto senza errori
    error('Impossibile aprire il file per la scrittura.');
end
fclose(fileID); % chiudo il file

%% simulazione Modelsim

projectPath = 'C:/Users/manue/Desktop/SDI/butterfly'; % path del progetto modelsim
modelsimPath = 'C:/intelFPGA_lite/18.1/modelsim_ase/win32aloem/modelsim.exe'; % path dell'eseguibile di modelsim
compileScriptPath = fullfile(projectPath, 'compile.do'); % path del file per controllsre l'esecuzione di modelsim
simulationCommand = sprintf('"%s" -do "%s"', modelsimPath, compileScriptPath); % comando per runnare modelsim
cd(projectPath); % cambio di directory
status = system(simulationCommand); % mando al sistema il comando
if status ~= 0 % controllo se il comando è stato mandato con successo
    disp('Si è verificato un errore durante la simulazione.');
end

disp('Premere invio quando si chiude Modelsim.');
pause; % aspetto la chiusura di modelsim e chiedo di premere invio all'utente 

%% postsimulazione

n=1; % primo valore di indice del vettore delle letture
vettore_numeri=zeros([num_vettori*16 1]); % inizializzazione del vettore delle letture
fileID = fopen('xout.txt', 'r'); % apro il file in lettura

while ~feof(fileID) % controllo riga per riga fino alla fine del file
    numero_binario = fgetl(fileID); % prendo il numero binario
    numero_decimale = -bin2dec(numero_binario(1)) + bin2dec(numero_binario(2:end)) / (2^(length(numero_binario) - 1)); % trasformo in decimale il numero
    vettore_numeri(n) = numero_decimale*16; % inserisco e normalizzo il valore nel vettore delle letture 
    n=n+1; % aumento l'indice del vettore delle letture
end

% il vettore numeri è strutturato come il file xout, quindi ha le prime 16 parti reali e poi le successive 16 parti immaginarie

fclose(fileID); % chiudo il file

n=1; % numero di iterazioni
riga=1; % primo valore di riga della matrice delle letture
matrice_reali=zeros(size(matrice_vettori)); % inizializzazione della matrice dei numeri reali
matrice_immaginari=zeros(size(matrice_vettori)); % inizializzazione della matrice dei numeri immaginari

for k = 1:length(vettore_numeri) % leggo il vettore delle letture
    resto = mod(fix((n-1)/16),2); % determino se è un numero reale o immaginario
    if resto == 0 % numero reale
        matrice_reali(riga,n)=vettore_numeri(k); % inserisco il numero nella matrice dei reali
    else % numero immaginario
        matrice_immaginari(riga,n-16)=vettore_numeri(k); % inserisco il numero nella matrice degli immaginari
        if n == 32 % controllo se ho finito la prova e quindi i 32 valori
            n=0; % reinizzializo il numero di iterazioni
            riga=riga+1; % vado alla riga successiva e quindi alla prossima prova fatta
        end
    end
    n=n+1; % vado alla prossima iterazione
end

matrice_risultati = (matrice_reali + matrice_immaginari*1i); % matrice dei risultati effettivi della fft creata
matrice_risultati_teorici = fft(matrice_vettori, [], 2); % matrice dei risultati teorici
result = matrice_risultati - matrice_risultati_teorici; % matrice delle differenze riscontrate

for riga = 1:num_vettori % controllo prova per prova
    if max(abs(result(riga,:))) < 4e-6 % controllo se l'errore non è troppo grande
        disp(['simulazione ' num2str(riga) ' OK']) % simulazione nel range di errore
        disp(['Il massimo errore nella simulazione ' num2str(riga) ' è: ' num2str(max(abs(result(riga,:))))])
    else % simulazione errata o con errore troppo grande
        disp(['simulazione ' num2str(riga) ' KO'])
        disp(['Il massimo errore nella simulazione ' num2str(riga) ' è: ' num2str(max(abs(result(riga,:))))])
    end
end

matrice_reali_th=real(matrice_risultati_teorici); % matrice dei risultati reali teorici
matrice_immaginari_th=imag(matrice_risultati_teorici); % matrice dei risultati immaginari teorici
vettore_numeri_th=zeros(size(vettore_numeri)); 
% creo il vettore dei numeri nella stessa formattazione di quello delle letture
for k = 1:num_vettori 
    vettore_numeri_th(32*k-31:32*k-16) = matrice_reali_th(k,:); % inserisco nel vettore dei numeri teorici il numero reale
    vettore_numeri_th(32*k-15:32*k) = matrice_immaginari_th(k,:); % inserisco nel vettore dei numeri teorici il numero immaginario
end

diff_max = 0; % inizializzo a 0 la differenza massima

for k = 1:length(vettore_numeri) % controllo numero per numero
        numero_decimale = vettore_numeri(k)/16; % normalizzo il numero decimale come esce dalla fft
        numero_decimale_th = vettore_numeri_th(k)/16; % normalizzo il numero decimale teorico come quello effettivo
        diff_decimale = abs(numero_decimale - numero_decimale_th); % differenza tra i due valori decimali
        if diff_decimale > diff_max % controllo se la differenza è maggiore di quella massima
            diff_max = diff_decimale; % riscrivo la differenza massima
            diff_sfixed = fi(diff_max, 1, bit_totali, bit_frazionari); % trasformo la differenza massima in sfixed
            diff_binario = bin(diff_sfixed); % trasformo la differenza massima in binario
        end
end
   
if strcmp(diff_binario, '000000000000000000000000') == 0 % stampo se ho trovato una differenza maggiore di 0
    disp(['La differenza binaria massima della FFT implementata è: ' diff_binario])
end
