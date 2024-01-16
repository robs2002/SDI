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

%% simulazione Modelsim

projectPath = 'C:/Users/manue/Desktop/SDI/butterfly';
modelsimPath = 'C:/intelFPGA_lite/18.1/modelsim_ase/win32aloem/modelsim.exe';
compileScriptPath = fullfile(projectPath, 'compile.do');
simulationCommand = sprintf('"%s" -do "%s"', modelsimPath, compileScriptPath);
cd(projectPath);
status = system(simulationCommand);
if status == 0
    disp('Simulazione completata con successo.');
else
    disp('Si è verificato un errore durante la simulazione.');
end

pause(15); % dipende da specifiche del PC

%% postsimulazione

n=1;
vettore_numeri=zeros([num_vettori*16 1]);
fileID = fopen('xout.txt', 'r');

while ~feof(fileID)
    numero_binario = fgetl(fileID);
    numero_decimale = -bin2dec(numero_binario(1)) + bin2dec(numero_binario(2:end)) / (2^(length(numero_binario) - 1));
    vettore_numeri(n) = numero_decimale*16;
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

matrice_risultati = (matrice_reali + matrice_immaginari*1i);
matrice_risultati_teorici = fft(matrice_vettori, [], 2);
result = matrice_risultati - matrice_risultati_teorici;

for riga = 1:num_vettori
    if max(abs(result(riga,:))) < 4e-6 
        disp(['simulazione ' num2str(riga) ' OK'])
        disp(['Il massimo errore nella simulazione ' num2str(riga) ' è: ' num2str(max(abs(result(riga,:))))])
    else
        disp(['simulazione ' num2str(riga) ' KO'])
        disp(['Il massimo errore nella simulazione ' num2str(riga) ' è: ' num2str(max(abs(result(riga,:))))])
    end
end

matrice_reali_th=real(matrice_risultati_teorici);
matrice_immaginari_th=imag(matrice_risultati_teorici);
vettore_numeri_th=zeros(size(vettore_numeri));

for k = 1:num_vettori
    vettore_numeri_th(32*k-31:32*k-16) = matrice_reali_th(k,:);
    vettore_numeri_th(32*k-15:32*k) = matrice_immaginari_th(k,:);
end

diff_max = 0;

for k = 1:length(vettore_numeri)
        numero_decimale = vettore_numeri(k)/16;
        numero_decimale_th = vettore_numeri_th(k)/16;
        diff_decimale = abs(numero_decimale - numero_decimale_th);
        if diff_decimale > diff_max
            diff_max = diff_decimale;
            diff_sfixed = fi(diff_max, 1, bit_totali, bit_frazionari);
            diff_binario = bin(diff_sfixed);
        end
end
   
if strcmp(diff_binario, '000000000000000000000000') == 0
    disp(['La differenza binaria massima della FFT implementata è: ' diff_binario])
end
