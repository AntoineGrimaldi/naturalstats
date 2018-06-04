%________________________________________________________________________%
% This function computes various statistics on a dataset of images. The  %
% four statistical moments are computed for each image along with the DR %
% and other information about the images that will be used in the differ-%
% ent analyses. Histograms are computed regarding the work from Huang &  %
% Mumford, 1999 as well as the wavelet coefficient joint histograms. The %
% power spectra are a rotational average of the 2D Fourier transform of  %
% the images.                                                            %
% File with 1D luminance maps as an input.                               %
% All the results from the analyses are stored in the "Results" file.    %
%                                                                        %
% An example of the results of these analyses are presented in:          %
% Grimaldi, Kane, Bertalm??o, 2018 (unpublished)                         %
% -> http://ip4ec.upf.edu/system/files/publications/Statistics%20of%20natural%20images.pdf
%                                                                        %
% Antoine Grimaldi, UPF, Barcelona                                       %
%________________________________________________________________________%

clear all
close all

file = 'Fairchild_Y'

norm = 0; % Normalization of the images: 0 -> no normalization
          %                              1 -> divide by the maximum 
          %                              2 -> scale between 0 and 1 
%Choose which type of statistics to compute:
mom = 0;        %to compute the moments and DR of the images (compulsory for the other statistical analyses)
histo = 1;      %to compute the histograms
spctr = 1;      %to compute the power spectra
wave = 1;       %to compute the wavelets
onlyplot = 0;   %to plot the figures from the results already computed

nbquantile = 0; %   nbquantile: The dataset can be divided by DR categories with
%                               nbquantile for the number-1 of category wanted.

%Parameters for the histograms:
bins = 8;       %bins: define the number of bins of the histogram as 2^bins
Xlim = 10;      %Xlim: absolute extreme value for the histogram defined as e^Xlim
jointXlim = 4;  %jointXlim: idem for the derivative statistics (jointhisto)
avg = 1;        %avg: average type -> 0:mean 1:median

%Parameters for the power spectra:
fmin = 2;       %minimum frequency value (cycles/image)
fmax = 0;       %maximum frequency value (cycles/image) (If fmax=0 will take maximum frequency value)
logspc = 0;     %define a logspace for the polynomial fits
hanning = 0;    %apply a hanning window

%Parameters for the wavelets:
fine = 500;     %number of bins in the joint histograms
Cmax = 1;       %maximum value for the joint histograms
norm_wav = 0;   %normalization or not of the haar filtered image


if onlyplot == 1    
    if mom == 1
        load(strcat('./Results/Moments_',file,'_',num2str(norm),'.mat'));
        NMDR_h = NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT;
        figure
        loglog([NMDR_h{:,2}], [NMDR_h{:,5}], 'o'); hold on;
        xlabel('DR', 'FontSize', 14)
        ylabel('mean', 'FontSize', 14)
        
        figure
        loglog([NMDR_h{:,2}], [NMDR_h{:,6}], 'o'); hold on;
        xlabel('DR', 'FontSize', 14 )
        ylabel('median', 'FontSize', 14)
       
        figure
        loglog([NMDR_h{:,2}], [NMDR_h{:,8}], 'o'); hold on;
        xlabel('DR', 'FontSize', 14)
        ylabel('standard deviation', 'FontSize', 14)
        
        figure
        loglog([NMDR_h{:,2}], abs([NMDR_h{:,9}]), 'o'); hold on;
        loglog([NMDR_h{:,2}], -[NMDR_h{:,9}], 'k+'); hold on;
        xlabel('DR', 'FontSize', 14)
        ylabel('skewness', 'FontSize', 14)
        
        figure
        loglog([NMDR_h{:,2}], [NMDR_h{:,10}], 'o'); hold on;
        xlabel('DR', 'FontSize', 14)
        ylabel('kurtosis', 'FontSize', 14)
    end
    
    if histo == 1
        addpath('histograms')
        load(strcat('./Results/Histograms_',file,'_', num2str(norm), '_', num2str(avg), '_', num2str(bins),'.mat'));
        load(strcat('./Results/Moments_',file,'_',num2str(norm),'.mat'));
        NMDR = NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT;
        histoplot(histo, li , NMDR);
        %axis([-11 11 10^-8.1 0.1])
        axis([-Xlim Xlim 10^-8.1 0.1])
        xlabel('log(I(i, j)) - average(log(I))')
        ylabel('log(Histogram)')
        histoplot(histoH, li2 , NMDR );
        %axis([-5 5 10^-8.1 1])
        axis([-jointXlim jointXlim 10^-8.1 1])
        xlabel('log(I(i, j)) - log(I(i, j+1)))')
        ylabel('log(Histogram)')
    end
    
    if spctr == 1
        addpath('powerspectra')
        load(strcat('./Results/Spectra_', file, '_', num2str(norm), '_', num2str(fmin), '_', num2str(fmax), '_', num2str(logspc), '_', num2str(hanning),'.mat'));
        load(strcat('./Results/Moments_',file,'_',num2str(norm),'.mat'));
        NMDR = NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT;
        if fmax==0
            fmax = size(DSP,1)+fmin-1;
        end
        spectraplot( DSP , nbquantile , fmin , fmax , DELTA , DELTA2 , DR_coef2 , NMDR , DSPq);
    end
    
    if wave == 1
        addpath('wavelets')
        load(strcat('./Results/Moments_',file,'_',num2str(norm),'.mat'));
        load(strcat('./Results/Wavelets_',file,'_haar_',num2str(norm_wav),'_', num2str(fine),'_', num2str(Cmax),'.mat'));
        NMDR = NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT;
        n = 7; %coefficient to define the axes size of the plots of the joint histograms   
        q = 1; %takes the first DR category
        waveletplot(Cmax, fine, q, n, H_vh, H_hd, H_hupper, H_vleft, H_hleft, H_dupperleft, H_hprt, H_dprt);
        q = size(H_dprt,3); %takes the last DR category
        waveletplot(Cmax, fine, q, n, H_vh, H_hd, H_hupper, H_vleft, H_hleft, H_dupperleft, H_hprt, H_dprt);
    end
    
else
    
    if exist('Results')~=7
        mkdir('Results')
    end
    
    if mom == 1
        stats_moments(file, norm);
    end
    
    if histo == 1
        addpath('histograms')
        load(strcat('./Results/Moments_',file,'_',num2str(norm),'.mat'));
        NMDR = NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT; 
        [ histo li histoV histoH li2 ] = stats_histograms( file , NMDR , nbquantile , bins , Xlim , jointXlim , avg , norm);          
    end
    
    if spctr == 1
        addpath('powerspectra')
        load(strcat('./Results/Moments_',file,'_',num2str(norm),'.mat'));
        NMDR = NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT;        
        [DSP DSP_val DSP_val2 DR_coef DR_coef2 DELTA DELTA2] = stats_powerspectra( file , NMDR , nbquantile , fmin , fmax , logspc , hanning ,norm );        
    end
    
    if wave == 1
        addpath('wavelets')
        load(strcat('./Results/Moments_',file,'_',num2str(norm),'.mat'));
        NMDR = NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT;
        
        if exist(strcat(file, '_haar'))~=7
            Haarfiltering(file, 4);
        end
        
        [H_vh H_vd H_hd H_hupper H_vleft H_hleft H_dupperleft H_hprt H_dprt count] = stats_wavelet( strcat(file,'_haar') , NMDR , nbquantile , fine , Cmax, norm_wav );  
    end   
end

