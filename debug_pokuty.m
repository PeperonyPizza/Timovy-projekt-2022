i=1;
[sumpp,sumpokuta,sumpokuta_vybocenie,sumpokuta_cyklus,sumpokuta_vzdialenost_od_cp,summensia_vzdialenost,sumprejdenie_cp]=simulacia_jazdy_pokuty(...
        Pop(i,:),prekazky_zapnute,riadok_cesta,stlpec_cesta,kroky,predchadzajuce_kroky,start,cesta,checkpoints,prekazky,min_pp,i);
    
figure
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