function [ histo li histoV histoH li2 ] = STATS_histograms( file , NMDR , nbquantile , n , Xlim , avg , norm)
%This function uses a dataset of images within the folder 'file' and uses
%the name and DR of the images stored in NMDR with STATS_moments to compute
%histograms of the images. 
%   nbquantile: The dataset can be divided by DR categories with
%       nbquantile for the number-1 of category wanted. 
%   bins: define the number of bins of the histogram as 2^bins
%   Xlim: absolute extreme value for the histogram defined as 10^Xlim
%   jointXlim: idem for the derivative statistics (jointhisto)
%   avg: average type -> 0:mean 1:median

lo = 1;
drlim = quantile(cell2mat(NMDR(:,2)),nbquantile);

    histo = zeros(1, 10^n*Xlim, nbquantile+1);
    PDF = zeros(1, 10^n*Xlim, nbquantile+1);

for A = 1:size(NMDR,1)
    
    disp(strcat('hist_',num2str(A)));
    clear LUM
    nm = NMDR{A,1};
    load(strcat('./',file,'/',nm));
    
    if exist('LUM') == 0
        if exist('LUM_psf') == 1
            LUM = LUM_psf;
        end
        if exist('LUM_nk') == 1
            LUM = LUM_nk;
        end
        if exist('LUM_csf') == 1
            LUM = LUM_csf;
        end
    end
    
    dr = NMDR{A,2};
    q = 1;
        while dr>drlim(q) & q<nbquantile
            q = q+1;
        end
        if dr>drlim(q)
            q = q+1;
        end
        
    if norm == 1
        LUM = LUM./max(LUM(:));
    end
    
    if norm == 2
        LUM = (LUM-min(LUM(:)))./(max(LUM(:))-min(LUM(:)));
    end    
    
    [logh li] = rayhistogramcreation(LUM, avg, n, Xlim);
    
    histo(:,:,q) = histo(:,:,q)+logh;
    
end

SOMhist = sum(histo,2);
for Q = 1:size(SOMhist,3)
    histo(:,:,Q) = histo(:,:,Q)./SOMhist(:,:,Q);
end

SOMhist = sum(PDF,2);
for Q = 1:size(SOMhist,3)
    PDF(:,:,Q) = PDF(:,:,Q)./SOMhist(:,:,Q);
end

lit = li;
clear li

for i = 1:size(lit,2)-1
    li(i) = (lit(i)+lit(i+1))/2;
end
    
momhisto = momenthisto(histo, li);

replc = find(file=='/');
file(replc) = '-';

save(strcat('./Results/Histograms_rayleigh_',file,'_', num2str(norm),'_', num2str(Xlim), '_', num2str(n)), 'histo', 'li', 'momhisto')  

histoplot(histo, li , NMDR);

end
