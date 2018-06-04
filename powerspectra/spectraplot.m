function [  ] = spectraplot( DSP , nbquantile , fmin , fmax , DELTA , DELTA2 , DR_coef2 , NMDR , DSPq)

couleurs = parula(size(DSPq,1)+2);
leg = cell(size(DSPq,1),1);

if nbquantile == 1
    drlim = max(cell2mat(NMDR(:,2)));
else
    drlim = quantile(cell2mat(NMDR(:,2)),nbquantile);
end


figure;

for i = 1:size(DSPq,1)
    
    a(i) = loglog([fmin:fmax], mean(DSPq{i},2),'.', 'color',couleurs(i,:)); hold on;    
    
    leg{1} = strcat(num2str(round(min([NMDR{:,2}]))),'<DR<',num2str(round(drlim(1))));
    leg{end} = strcat(num2str(round(drlim(end))),'<DR');
    if i>1 & i<nbquantile+1
        leg{i} = strcat(num2str(round(drlim(i-1))),'<DR<',num2str(round(drlim(i))));
    end    
end
legend(a, char(leg{:}));

xlabel('log(frequency) (cycles/image)', 'FontSize', 12)
ylabel('log(Power Scpectrum)', 'FontSize', 12)

figure;
semilogx([NMDR{:,2}],DELTA,'o'); hold on;
semilogx([NMDR{:,2}],DELTA2,'o'); hold on;
xlabel('DR', 'FontSize', 12)
ylabel('fit error', 'FontSize', 12)
legend('1st order', '2nd order', 'Location', 'NorthWest')

figure;
semilogx([NMDR{:,2}],DR_coef2,'o'); hold on;
xlabel('DR', 'FontSize', 12)
ylabel('a (leading term of the second order polynomial)', 'FontSize', 12)

end
