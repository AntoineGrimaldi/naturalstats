function [ DSP DSP_val DSP_val2 DR_coef DR_coef2 DELTA DELTA2 RMS RMS2] = STATS_powerspectra( file , NMDR , nbquantile , fmin , fmax , logspc , hanning , norm )
%This function uses a dataset of images within the folder 'file' and uses
%the name and DR of the images stored in NMDR with the fusction stats_moments 
%to compute the rotational averaged power spectra of the images. 
%   nbquantile: The dataset can be divided by DR categories with
%               nbquantile for the number-1 of category wanted. 
%   fmin: define the minimum frequency (cycles/image) to take into account
%   fmin: define the maximum frequency (cycles/image) to take into account
%   logspc: if = 1: the fit of the power spectrum is sampled with a log
%           space
%   hanning: if = 1: apply a hanning window
%   norm: Normalization of the images: 0 -> no normalization
%                                      1 -> divide by the maximum 
%                                      2 -> scale between 0 and 1 
%
%output: - DSP: store all the power spectra (line: frequency(c/image), column: image)
%        - DSP_val: values of the 1st order polyfit for each power spectra
%        - DSP_val2: values of the 2nd order polyfit for each power spectra
%        - DR_coef: leading term of the 1st order polyfit for each power spectra (slope)
%        - DR_coef2: leading term of the 2nd order polyfit for each power spectra (curvature)
%        - DELTA: delta value from polyfit function for the 1st order polyfit for each power spectra
%        - DELTA2: delta value from polyfit function for the 2nd order polyfit for each power spectra
%        - RMS: root mean square error for 1st order polyfit for each power spectra
%        - RMS2: root mean square error for 2nd order polyfit for each power spectra

DSP = [];
DSP_val = [];
DSP_val2 = [];
DR_coef = [];
DELTA = [];
DR_coef2 = [];
DELTA2 = [];

if nbquantile == 1
    drlim = median(cell2mat(NMDR(:,2)));
elseif nbquantile == 0
    drlim = max(cell2mat(NMDR(:,2)));
else
    drlim = quantile(cell2mat(NMDR(:,2)),nbquantile);
end

DSPq = cell(nbquantile+1,1);

for A = 1:size(NMDR,1)
    
    disp(strcat('ps_',num2str(A)));
    
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
    
    wl = 2*floor(min(size(LUM,1),size(LUM,2))/2);  
    LUM = LUM(1:wl,1:wl);   
    
    if fmax == 0
        fmax = size(LUM,1)/2;
        d = 1;
    elseif fmax > size(LUM,1)/2
        fmax = floor(size(LUM,1)/2);
    end 
    
    if norm == 1
        LUM = LUM./max(LUM(:));
    end
    
    if norm == 2
        LUM = (LUM-min(LUM(:)))./(max(LUM(:))-min(LUM(:)));
    end
    
    if hanning == 1
        LUM = pre_traitement(LUM);
    end
    
    dr = NMDR{A,2};
    q = 1;
    while dr>drlim(q) & q<nbquantile
        q = q+1;
    end
    if dr>drlim(q)
        q = q+1;
    end
    
    dsp = rotavg(abs(fftshift(fft2(LUM))));
    
    if logspc == 1
        index = logspace(log10(fmin), log10(fmax), 50);
        dsp = dsp(index);
    else
        dsp = dsp([fmin:fmax]);
    end
    
    %Fit by a first order polynomial
    [P,S] = polyfit(log([1:size(dsp)]'),log(dsp),1);
    [Y,delta] = polyval(P,log([1:size(dsp,1)]'),S);
    %Fit by a second order polynomial
    [P2,S2] = polyfit(log([1:size(dsp)]'),log(dsp),2);
    [Y2,delta2] = polyval(P2,log([1:size(dsp,1)]'),S2);    
    
    DR_coef = [DR_coef;abs(P(1))];
    DR_coef2 = [DR_coef2;P2(1)];
    DELTA = [DELTA; mean(delta)];
    DELTA2 = [DELTA2; mean(delta2)];
    
    if size(DSP,1)>size(dsp,1)
        DSP = DSP(1:size(dsp,1),:);
        DSP_val = DSP_val(1:size(Y,1),:);
        DSP_val2 = DSP_val2(1:size(Y2,1),:);
    end
    if size(DSP,1)==0
        DSP = [DSP dsp];
        DSP_val = [DSP_val Y];
        DSP_val2 = [DSP_val2 Y2];
    else
        DSP = [DSP dsp(1:size(DSP,1))];
        DSP_val = [DSP_val Y(1:size(DSP_val,1))];
        DSP_val2 = [DSP_val2 Y2(1:size(DSP_val2,1))];
    end
    if size(DSPq{q}, 1) > size(DSP(:,A), 1)
        DSPq{q} = DSPq{q}(1:size(DSP(:,A), 1),:);
        DSPq{q}= [DSPq{q} DSP(:,A)];
    else
        DSPq{q}= [DSPq{q} DSP(:,A)];
    end
end

replc = find(file=='/');
file(replc) = '-';

fmax = size(DSP,1)+fmin-1;
spectraplot( DSP , nbquantile , fmin , fmax , DELTA , DELTA2 , DR_coef2 , NMDR , DSPq);

if d == 1
    fmax = 0;
end

save(strcat('./Results/Spectra_',file,'_', num2str(norm),'_', num2str(fmin),'_', num2str(fmax), '_', num2str(logspc), '_', num2str(hanning)), 'DSP', 'DSP_val', 'DSP_val2', 'DR_coef', 'DR_coef2', 'DELTA', 'DELTA2', 'DSPq')

end