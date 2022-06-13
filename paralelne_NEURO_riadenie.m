
clc
clear
addpath("genetic")
%=========================================================================>
%               TRÉNOVANIE NEURÓNOVEJ SIETE - ANALÓGOVÁ FORMA
%=========================================================================>
%% %%%%%%%%%%%%%%%%%%   VOĽBA PARAMETROV GA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numgen = 400;          % počet generácii
lpop = 25;	            % počet chromozónov v populacii
lstring = 450;          % počet génov v chromozone (340+100+10)
M = 1;                  % maximálny prehladávací priestor
min_pp=inf;             % pre hľadanie jedinca s najlepšou fit funkciou 
Space = [ones(1,lstring) * (-M); ones(1,lstring)]; % prehladavaci priestor
Delta = Space(2,:) / 50;% krok aditivnej mutacie

%% %%%%%%%%%%%%%%%%%%%%   NASTAVENIE MAPY  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trasa_num = 2;          %vyber mapy: 1 = stvorec
                        %            2 = race track
                        %            3 = kruh
                        %            4 = osmicka
                        %            5 = sestuholnik
                        %            6 = race track_2
[start,cesta,checkpoints,prekazky] = vyber_trasy(trasa_num);
[riadok_cesta,stlpec_cesta] = size(cesta);

%% %%%%%%%%%%%%%   DĹŽKA POHYBU VOZIDLA PO DRÁHE  %%%%%%%%%%%%%%%%%%%%%%%%%                                          
kroky = 650;           % dt

%% %%%%%%%%%%%%   NASTAVENIE POHYBLIVÝCH PREKÁŽOK  %%%%%%%%%%%%%%%%%%%%%%%% 
prekazky_zapnute = 0;   % 0 = generovanie prekazok vypnute
                        % 1 = generovanie prekazok vypnute

%% %%%%%%%%%%%%%%%   INICIALIZÁCIA POPULÁCIE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NÁHODNÉ VYGENEROVANIE JEDINCOV
Pop = genrpop(lpop,Space);

%ODKOMENTOVAŤ PRE NAČíTANIE PREDTRÉNOVANEJ POPULÁCIE        
% Pop = load('pop');%genrpop(lpop,Space);
% Pop = Pop.Pop;

%%
%=========================================================================>
%           MAIN CYKLUS - cyklus pre jednotlivé generácie
%=========================================================================>

%pozeráme 10 krokov dozadu - aby sa vozidlo nezacyklilo na mieste
predchadzajuce_kroky = zeros(2,10);

kolizie_s_prekazkamy = 0;   %pre ukladanie počtu kolízii pri trénovaní
min_pp = inf;

finalevolution=zeros(1,numgen);
final_best_pozicia = zeros(numgen,2);
final_best_draha = zeros(numgen,riadok_cesta,stlpec_cesta);
finalPop = zeros(numgen,lpop,lstring);
X = 0;
parfor gen = 1:numgen
    [par_evolution,par_best_pozicia,par_best_draha,par_Pop]=test(Pop,lpop,prekazky_zapnute,riadok_cesta,stlpec_cesta,kroky,predchadzajuce_kroky,gen,start,cesta,checkpoints,prekazky,min_pp,Space,Delta);

    finalevolution(gen)= par_evolution(end);
    finalPop(gen,:,:)= par_Pop;
    final_best_pozicia(gen,:) = par_best_pozicia;
    final_best_draha(gen,:,:) = par_best_draha;
    X = X+1
    
    [temp,minpos]=min(finalevolution(gen)) 
    Pop=finalPop(minpos,:,:);
end

%% VYHODNOTENIE TRÉNOVANIA NS
%=========================================================================>
%                   ZOBRAZENIE VYSLEDKOV TRÉNOVANIA
%=========================================================================>
kolizie_s_prekazkamy
% Najlepsie riesenie - vykreslenie
figure(1)
plot(finalevolution) 

title('Evolúcia');
xlabel('Generácie');
ylabel('Fitnes');

[min_hodnota, pozicia_min_hodnoty] = min(finalevolution)

Vykreslovanie(riadok_cesta,stlpec_cesta,final_best_pozicia(pozicia_min_hodnoty,:),final_best_draha(pozicia_min_hodnoty,:),start,cesta,checkpoints)
if prekazky_zapnute == 1
    Vykreslovanie(riadok_cesta,stlpec_cesta,best_pozicia,trasa_prekazky,start,cesta,checkpoints)
end

save('NS_premenne-vystup_Trenovania')
