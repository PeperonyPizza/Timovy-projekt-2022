clc
clear
addpath("genetic")
numgen = 50;  % pocet generacii
lpop = 25;	   % pocet chromozonov v populacii
lstring = 200; % pocet genov v chromozone (90+100+10)
M = 1;         % maximalny prehladavaci priestor


collum = [75 75 75 75 75 75 75 75];
start_line = [36:43; collum];
% start = [39 74];
checkpoints = cat(2,[collum; 29:36],[108:115; collum],[collum; 114:121]);
%x y, 36-43	75, 75	29-36, 109-116	75, 75	114-121
min_pp=inf;

kroky = 800;

trasa_num = 1;

[start,cesta] = vyber_trasy(trasa_num);

[riadok_cesta,stlpec_cesta] = size(cesta);

% Inicializacia populacie  
Space = [ones(1,lstring) * (-M); ones(1,lstring)]; % prehladavaci priestor
Delta = Space(2,:) / 50; % krok aditivnej mutacie

Pop = genrpop(lpop,Space);
min_kroky=kroky;
% Main cyklus
for gen = 1:numgen
    
    disp(gen);
    

    for i = 1:lpop
    %=====================================================================>
    %                      VYTVORENIE MATIC W1,W2,W3
    %=====================================================================>

    W1 = []; W2 = []; W3 = [];    
            % W1 => (10x9 = 90)
        for j = 9:9:90
            
            W1(end+1,:) = Pop(i,j-8:j);
          
        end
        
        % W2 => (10x10 = 100)
        for j = 91:10:190
            
            W2(end+1,:) = Pop(i,j-9:j);
                
        end
        
        % W3 => (1x10 = 10)
        for j = 191:10:200
            
            W3(end+1,:) = Pop(i,j-9:j);
                
        end

 %%       
        %=================================================================>
        %                         SPUSTENIE ROBOTA
        %=================================================================>
        
        % Nastavenie zakladnych parametrov
        draha = zeros(riadok_cesta,stlpec_cesta);
        pozicia = start;
        orientacia = 3;
        predosla_zmena = 0;
        pp = 0;
        
        
       for k = 1:kroky
            predosla_orientacia = orientacia;
            draha(pozicia(1,1),pozicia(1,2)) = draha(pozicia(1,1),pozicia(1,2)) + 1;
            
            snimace = kontrola_snimacov(pozicia,cesta,orientacia);
            snimace(end+1) = predosla_zmena;
            %                                                           uhol
            obraz_z_kameri = dash_cam(start,cesta,checkpoints, pozicia, pi);
            %%
            natocenie = neuronova_siet(W1,W2,W3,snimace);
          
           % orientacia = aktualizacia_orientacia(natocenie,orientacia);
            
            [pokuta,posledna_zmena] = kontrola_zmeny_orientaacie(predosla_orientacia,orientacia,predosla_zmena);
            
            [riadok_draha,stlpec_draha] = pohyb(orientacia,pozicia);
            
            pozicia = [riadok_draha,stlpec_draha];

            if cesta(pozicia(1,1),pozicia(1,2)) == 1
                pokuta_vybocenie = 100;
            else
                pokuta_vybocenie = -5;
            end
            
            %% prechod cez checkpoint
            for n=1:24
                if sum(checkpoints(1, n) == riadok_draha & checkpoints(2, n) == stlpec_draha) == 1 
                    bonus_checkpoint=-50;
                else
                    bonus_checkpoint = 0;
                end
            end

            aktualna_pozicia = cesta(pozicia(1,1),pozicia(1,2));

            pp = 1 + pp + pokuta + pokuta_vybocenie + 10*double(aktualna_pozicia) + 0.5 * sum(double(snimace(1:9))) + bonus_checkpoint ;
        
        end
 
 


        Fit(i) = pp;
        if min_pp>pp
            min_pp=pp;
            best_draha=draha;
            best_pozicia=pozicia;
%             best_W=[W1,W2,W3];
        end
        
    end
    
    evolution(gen) = min(Fit);
   
    Pop = geneticky_algoritmus(Pop,Fit,Space,Delta);
 
end

% Najlepsie riesenie
figure(1)
plot(evolution) 

title('Evolúcia');
xlabel('Generácie');
ylabel('Fitnes');

%%

Vykreslovanie(riadok_cesta,stlpec_cesta,best_pozicia,best_draha,start,cesta,checkpoints)
% 
