%% caso T = 20

clear 
close all 
clc


filep=load('Parte2_dir1\PI_Temp20,00_IStart0,10_IStop12,00_IStep0,10.txt');
filev=load('Parte2_dir1\VI_Temp20,00_IStart0,10_IStop12,00_IStep0,10.txt');
figure(1)
subplot(1,2,1)
plot(filep(:,1),10.*filep(:,2))
subplot(1,2,2)
plot(filev(:,1),filev(:,2))

figure(1)
subplot(1,2,1)
title("Potenza d'uscita")
xlabel("I [mA]")
ylabel("P [W]")
subplot(1,2,2)
title("Tensione del diodo")
xlabel("I [mA]")
ylabel("V [V]")

%% caso no T

filep=load('Parte2_dir2\PI_IStart0,00_IStop50,00_IStep1,00.txt');
filev=load('Parte2_dir2\VI_IStart0,00_IStop50,00_IStep1,00.txt');
figure(2)
subplot(1,2,1)
plot(filep(:,1),10.*filep(:,2))
subplot(1,2,2)
plot(filev(:,1),filev(:,2))

figure(2)
subplot(1,2,1)
title("Potenza d'uscita")
xlabel("I [mA]")
ylabel("P [W]")
subplot(1,2,2)
title("Tensione del diodo")
xlabel("I [mA]")
ylabel("V [V]")

%% caso vari T 

I_th=zeros([1 11]);
R_s=zeros([1 11]);
T=20:30;

for k = 20:30
    filep=load("Parte2_dir3\PI_Temp"+k+",00_IStart0,00_IStop40,00_IStep0,50.txt");
    filev=load("Parte2_dir3\VI_Temp"+k+",00_IStart0,00_IStop40,00_IStep0,50.txt");
    P=filep(:,2);
    I=filep(:,1);
    V=filev(:,2);
    figure(3)
    hold on
    subplot(1,2,1)
    plot(I,P)
    figure(3)
    hold on
    subplot(1,2,2)
    plot(I,V)
    WPE=P./(V.*I*1e-3);
    figure(4)
    hold on
    plot(I,WPE)
    dWPE = diff(WPE(3:end)) ./ diff(I(3:end));
    [~,th] = maxk(dWPE, 1);
    I_th(k-19)=I(th+2);  
    R_s(k-19)=V\I; 
end

figure(3)
subplot(1,2,1)
title("Potenza d'uscita")
xlabel("I [mA]")
ylabel("P [W]")
subplot(1,2,2)
title("Tensione del diodo")
xlabel("I [mA]")
ylabel("V [V]")

figure(4)
title("Wall Plug Efficiency")
xlabel("I [mA]")
ylabel("WPE")
xlim([I(3) I(end)])

figure(5)
plot(T,I_th,'ro-') 
title("Corrente di soglia")
xlabel("T [°C]")
ylabel("I_{th} [mA]")

figure(6)
plot(T,R_s,'bo-')   
title("Reistenza serie del diodo")
xlabel("T [°C]")
ylabel("R_s [Ω]")


