function [new_pohybujuce_prekazky] = pohybujuce_prekazky (cesta,old_pohybujuce_prekazky,pozicia)
        new_pohybujuce_prekazky = old_pohybujuce_prekazky;
        for i = 1:2:length(old_pohybujuce_prekazky)
        pohyb_prekazky = randi(4); %smer
            switch pohyb_prekazky
                case 1 
                    new_pohybujuce_prekazky(i) = new_pohybujuce_prekazky(i)+1;%up
                case 2 
                    new_pohybujuce_prekazky(i) = new_pohybujuce_prekazky(i)-1;%down
                case 3 
                    new_pohybujuce_prekazky(i+1) = new_pohybujuce_prekazky(i+1)+1;%right
                case 4 
                    new_pohybujuce_prekazky(i+1) = new_pohybujuce_prekazky(i+1)-1;%left
            end
            
            % aby prekazka nesla mimo cesty alebo narazila do auta
            while (cesta(new_pohybujuce_prekazky(i),new_pohybujuce_prekazky(i+1)) == 1) || (new_pohybujuce_prekazky(i)==pozicia(1) && new_pohybujuce_prekazky(i+1)==pozicia(2))
                pohyb_prekazky = randi(4);
                new_pohybujuce_prekazky = old_pohybujuce_prekazky;
                switch pohyb_prekazky
                    case 1 
                        new_pohybujuce_prekazky(i) = new_pohybujuce_prekazky(i)+1;
                    case 2 
                        new_pohybujuce_prekazky(i) = new_pohybujuce_prekazky(i)-1;
                    case 3 
                        new_pohybujuce_prekazky(i+1) = new_pohybujuce_prekazky(i+1)+1;
                    case 4 
                        new_pohybujuce_prekazky(i+1) = new_pohybujuce_prekazky(i+1)-1;
                end
            end 
        end
end