function [stupne] = orientacia_na_stupne(orientacia)

stupne = 0;

if orientacia >=3
    stupne = ((orientacia - 3) * 22.5);
elseif orientacia <3
    stupne = 292.5 + (orientacia * 22.5);
end

end

