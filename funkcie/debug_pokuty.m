
addpath("C:\Users\Exavyy\Documents\GitHub\Timovy-projekt-2022\genetic")
addpath("C:\Users\Exavyy\Documents\GitHub\Timovy-projekt-2022")
i=1;
kroky=1000;
[Fit,best_pozicia,best_draha,Pop,sumpp,sumpokuta,sumpokuta_vybocenie,sumpokuta_cyklus,sumpokuta_vzdialenost_od_cp,summensia_vzdialenost,sumprejdenie_cp,sumpokuta_obraz]=simulacia_jazdy_pokuty(...
        Pop(i,:),prekazky_zapnute,riadok_cesta,stlpec_cesta,kroky,predchadzajuce_kroky,start,cesta,checkpoints,prekazky,min_pp,i);
    
figure('Name',['pokuty samostatne jedinec c.' num2str(i)], 'NumberTitle','off')
title(['jedninec císlo ' num2str(i)]);
tiledlayout(2,4)
nexttile
plot(sumpp);
title('sumpp');

nexttile
plot(sumpokuta);
title('sumpokuta');

nexttile
plot(sumpokuta_vybocenie);
title('sumpokuta vybocenie');

nexttile
plot(sumpokuta_cyklus);
title('sumpokuta cyklus');

nexttile
plot(sumpokuta_vzdialenost_od_cp);
title('sumpokuta vzdialenost od cp');

nexttile
plot(summensia_vzdialenost);
title('summensia vzdialenost');

nexttile
plot(sumprejdenie_cp);
title('sumprejdenie cp');

nexttile
plot(sumpokuta_obraz);
title('sumpokuta obraz');

figure('Name',['Pokuty v jednom grafe jedinec c.' num2str(i)], 'NumberTitle','off')
tiledlayout(2,2)
nexttile
Vykreslovanie(riadok_cesta,stlpec_cesta,best_pozicia,best_draha,start,cesta,checkpoints)
title('Jedinec c.'+string(i))

nexttile;
plot(sumpp);
legend('sumpp');
title('Suma pokut v case')
nexttile;
plot(evolution) 

title('Evolúcia');
xlabel('Generácie');
ylabel('Fitnes');


nexttile;
plot(sumpokuta);
hold on;
title('Priebeh jednotlivych pokut')

plot(sumpokuta_vybocenie);

plot(sumpokuta_cyklus);

plot(sumpokuta_vzdialenost_od_cp);

plot(summensia_vzdialenost);

plot(sumprejdenie_cp);

plot(sumpokuta_obraz);
legend('sumpokuta','sumpokuta vybocenie','sumpokuta cyklus','sumpokuta vzdialenost od cp','summensia vzdialenost','sumprejdenie cp','sumpokuta_obraz')
hold off



