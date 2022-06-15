
clc
clear
addpath("genetic")
%=========================================================================>
%               TRÉNOVANIE NEURÓNOVEJ SIETE - ANALÓGOVÁ FORMA
%=========================================================================>
%% %%%%%%%%%%%%%%%%%%   VOĽBA PARAMETROV GA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numgen = 400;          % počet generácii
lpop = 50;	            % počet chromozónov v populacii
lstring = 690;          % počet génov v chromozone (340+100+10)
M = 1;                  % maximálny prehladávací priestor
min_pp=inf;             % pre hľadanie jedinca s najlepšou fit funkciou 
Space = [ones(1,lstring) * (-M); ones(1,lstring)]; % prehladavaci priestor
Delta = Space(2,:) / 50;% krok aditivnej mutacie

%% %%%%%%%%%%%%%%%%%%%%   NASTAVENIE MAPY  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trasa_num =2;          %vyber mapy: 1 = stvorec
                        %            2 = race track
                        %            3 = kruh
                        %            4 = osmicka
                        %            5 = sestuholnik
                        %            6 = race track_2
[start,cesta,checkpoints,prekazky] = vyber_trasy(trasa_num);
[riadok_cesta,stlpec_cesta] = size(cesta);

%% %%%%%%%%%%%%%   DĹŽKA POHYBU VOZIDLA PO DRÁHE  %%%%%%%%%%%%%%%%%%%%%%%%%                                          
kroky = 500;           % dt

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
predchadzajuce_kroky = zeros(2,20);

kolizie_s_prekazkamy = 0;   %pre ukladanie počtu kolízii pri trénovaní
min_pp = inf;

finalFit=zeros(1,lpop);
final_best_pozicia = zeros(lpop,2);
final_best_draha = zeros(lpop,riadok_cesta,stlpec_cesta);
finalPop = zeros(lpop,lstring);
X = 0;

kolizie_s_prekazkamy = 0;   %pre ukladanie počtu kolízii pri trénovaní

%% Skontrolovanie každého riešenia - každý jedinec z populácie
tic;
for gen = 1:numgen
    parfor i = 1:lpop
        [par_fit,par_best_pozicia,par_best_draha,par_Pop]=simulacia_jazdy(...
        Pop(i,:),prekazky_zapnute,riadok_cesta,stlpec_cesta,kroky,predchadzajuce_kroky,start,cesta,checkpoints,prekazky,min_pp,i);

        finalFit(i)= par_fit(end);
        finalPop(i,:) = par_Pop;
        final_best_pozicia(i,:) = par_best_pozicia;
        final_best_draha(i,:,:) = par_best_draha;
         
    end
    [evolution(gen),min_pos] = min(finalFit);
    %% GA pre optimalizáciu riešenia 
    Pop = geneticky_algoritmus(finalPop,finalFit,Space,Delta);
    gen
    toc
end

%% VYHODNOTENIE TRÉNOVANIA NS
%=========================================================================>
%                   ZOBRAZENIE VYSLEDKOV TRÉNOVANIA
%=========================================================================>
kolizie_s_prekazkamy
% Najlepsie riesenie - vykreslenie
figure(1)
plot(evolution) 

title('Evolúcia');
xlabel('Generácie');
ylabel('Fitnes');

[min_hodnota, pozicia_min_hodnoty] = min(finalFit);
figure
Vykreslovanie(riadok_cesta,stlpec_cesta,final_best_pozicia(pozicia_min_hodnoty,:),squeeze(final_best_draha(pozicia_min_hodnoty,:,:)),start,cesta,checkpoints)

figure
tiledlayout(5,5)
for graph=1:2:lpop
    nexttile
    Vykreslovanie(riadok_cesta,stlpec_cesta,final_best_pozicia(graph,:),squeeze(final_best_draha(graph,:,:)),start,cesta,checkpoints)
end
if prekazky_zapnute == 1
    Vykreslovanie(riadok_cesta,stlpec_cesta,best_pozicia,trasa_prekazky,start,cesta,checkpoints)
end

save('NS_premenne-vystup_Trenovania')
