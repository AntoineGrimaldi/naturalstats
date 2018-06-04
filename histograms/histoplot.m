function [  ] = histoplot( loghisto , li , NMDR )

    couleurs = parula(size(loghisto,3)+2);
    leg = cell(size(loghisto,3),1);
    
    nbquantile = size(loghisto,3)-1;
    
    if nbquantile == 1
        drlim = max(cell2mat(NMDR(:,2)));
    else
        drlim = quantile(cell2mat(NMDR(:,2)),nbquantile);
    end
    
    
    figure;    
for i = 1:size(loghisto,3)

    a(i) = semilogy(li, loghisto(:,:,i), 'color',couleurs(i,:)); hold on; 
    
    leg{1} = strcat('DR<',num2str(round(drlim(1))));
    leg{end} = strcat(num2str(round(drlim(end))),'<DR');    
    if i>1 & i<size(loghisto,3)
         leg{i} = strcat(num2str(round(drlim(i-1))),'<DR<',num2str(round(drlim(i))));
    end
end
legend(a, char(leg{:}));



