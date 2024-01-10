clc
clear
close all

%% presimulazione

matrice_vettori=[-0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5;
           -0.5 0 0.5 0 -0.5 0 0.5 0 -0.5 0 0.5 0 -0.5 0 0.5 0;
           0.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
           -0.5 -0.5 0.5 0.5 -0.5 -0.5 0.5 0.5 -0.5 -0.5 0.5 0.5 -0.5 -0.5 0.5 0.5;
           0.25 0.25 0.25 0.25 0.25 0.25 0.25 0.25 0.25 -0.25 -0.25 -0.25 -0.25 -0.25 -0.25 -0.25;
           0 0 0 0 0 0 0 0 0.375 0 0 0 0 0 0 0];

n_elementi_totali = 16;
num_prove=4;
num_vettori = 6+num_prove; 
matrice_vettori(7:num_vettori,:) = rand(num_prove, n_elementi_totali) - 0.5;

fileID = fopen('xin.txt', 'w');
if fileID == -1
    error('Impossibile aprire il file per la scrittura.');
end

for riga = 1:num_vettori
    for colonna = 1:n_elementi_totali
        numero_decimale=matrice_vettori(riga,colonna);
        bit_totali = 24;
        bit_frazionari = 23;
        numero_sfixed = fi(numero_decimale, 1, bit_totali, bit_frazionari);
        numero_binario = bin(numero_sfixed);
        fprintf(fileID, '%s\n', numero_binario);
    end
    for j = 1:16
        fprintf(fileID, '000000000000000000000000\n');
    end
end

fclose(fileID);

nome_file = 'xout.txt';
fileID = fopen(nome_file, 'w');
if fileID == -1
    error('Impossibile aprire il file per la scrittura.');
end
fclose(fileID);

%% postsimulazione

n=1;
vettore_numeri=zeros([num_vettori*32 1]);
fileID = fopen('xout.txt', 'r');

while ~feof(fileID)
    numero_binario = fgetl(fileID);
    numero_decimale = -bin2dec(numero_binario(1)) + bin2dec(numero_binario(2:end)) / (2^(length(numero_binario) - 1));
    vettore_numeri(n) = numero_decimale;
    n=n+1;
end

fclose(fileID);

n=1;
riga=1;
matrice_reali=zeros(size(matrice_vettori));
matrice_immaginari=zeros(size(matrice_vettori));

for k = 1:length(vettore_numeri)
    resto = mod(fix((n-1)/16),2);
    if resto == 0 
        matrice_reali(riga,n)=vettore_numeri(k);
    else
        matrice_immaginari(riga,n-16)=vettore_numeri(k);
        if n == 32
            n=0;
            riga=riga+1;
        end
    end
    n=n+1;
end

matrice_risultati = (matrice_reali + matrice_immaginari*1i)*32;

matrice_risultati_teorici = fft(matrice_vettori, [], 2)*2;

result = matrice_risultati - matrice_risultati_teorici;

for riga = 1:num_vettori
    if max(abs(result(riga,:))) < 5e-6 
        disp(['simulazione ' num2str(riga) ' OK'])
        disp(['Il massimo errore nella simulazione ' num2str(riga) ' è: ' num2str(max(abs(result(riga,:))))])
    else
        disp(['simulazione ' num2str(riga) ' KO'])
        disp(['Il massimo errore nella simulazione ' num2str(riga) ' è: ' num2str(max(abs(result(riga,:))))])
    end
end






    