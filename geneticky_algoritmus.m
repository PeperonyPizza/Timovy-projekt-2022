function [Pop] = geneticky_algoritmus(Pop,Fit,Space,Delta)
    Best = selbest(Pop,Fit,1);
    Old = selrand(Pop,Fit,6);
    Work1 = selsus(Pop,Fit,7);
    Work2 = seltourn(Pop,Fit,8);
    Work1 = crossov(Work1,1,0);
    Work2 = mutx(Work2,0.12,Space);
    Work1 = muta(Work1,0.15,Delta,Space);
    Work3 = genrpop(3,Space);

    Pop = [Best;Old;Work1;Work2;Work3];
    
end

