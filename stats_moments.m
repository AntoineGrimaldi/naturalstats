function [ NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT ] = stats_moments( file, norm )
%This function needs a folder with .mat images to compute the statistics of
%these matrices and store them. A low pass filtering is applied before comp-
%uting the DR of the image.
%norm = 1 the values are divided by the maximum
%norm = 2 the values are scaled between 0 (min) and 1 (max)
%output -> table with the following information for each column:
%name; dynamic range; min; max; mean; median; variance; standard deviation; 
%skweness; kurtosis;    

namedatafile=dir(strcat('./',file,'/*.mat'));
namedatafile={namedatafile.name}';

NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT = cell([size(namedatafile,1),10]);

for A = 1:size(namedatafile,1)
    clear LUM
    disp(strcat('mom_',num2str(A)));
    nm = char(namedatafile(A));
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
    
    filter = zeros(size(LUM,1),size(LUM,2));
    filter(size(LUM,1)/2-2:size(LUM,1)/2+1,size(LUM,2)/2-2:size(LUM,2)/2+1) = 1/16;
    
    f_filter = fftshift(fft2(filter));
    
    f_Im = fftshift(fft2(LUM));
    
    f_filtered = f_Im.*f_filter;
    
    LUM_filtered = abs(ifftshift(ifft2(f_filtered)));
    
    dr = max(LUM_filtered(:))/min(LUM_filtered(:));
    
    if norm == 1
        LUM = LUM./max(LUM(:));
    end
    
    if norm == 2
        LUM = (LUM-min(LUM(:)))./(max(LUM(:))-min(LUM(:)));
    end
    
    NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT{A,1} = nm;
    NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT{A,2} = dr;
    NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT{A,3} = min(LUM(:));
    NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT{A,4} = max(LUM(:));
    NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT{A,5} = mean(LUM(:));
    NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT{A,6} = median(LUM(:));
    NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT{A,7} = var(LUM(:));
    NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT{A,8} = std(LUM(:));
    NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT{A,9} = skewness(LUM(:));
    NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT{A,10} = kurtosis(LUM(:));
end

replc = find(file=='/');
file(replc) = '-';
outputfile = 'Results';

if exist(outputfile)==7
    save(strcat(outputfile,'/Moments_',file, '_',num2str(norm)), 'NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT');
else
    mkdir(outputfile)
    save(strcat(outputfile,'/Moments_',file, '_',num2str(norm)), 'NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT');
end


%PLOT______________________________________________________________________

NMDR = NAMEDRMINMAXMEANMEDIANVARSDSKEWKURT;

figure(1)
loglog([NMDR{:,2}], [NMDR{:,5}], 'o'); hold on;
xlabel('DR', 'FontSize', 14)
ylabel('mean', 'FontSize', 14)

figure(2)
loglog([NMDR{:,2}], [NMDR{:,6}], 'o'); hold on;
xlabel('DR', 'FontSize', 14 )
ylabel('median', 'FontSize', 14)

figure(3)
loglog([NMDR{:,2}], [NMDR{:,8}], 'o'); hold on;
xlabel('DR', 'FontSize', 14)
ylabel('standard deviation', 'FontSize', 14)

figure(4)
loglog([NMDR{:,2}], abs([NMDR{:,9}]), 'o'); hold on;
loglog([NMDR{:,2}], -[NMDR{:,9}], 'k+'); hold on;
xlabel('DR', 'FontSize', 14)
ylabel('skewness', 'FontSize', 14)

figure(5)
loglog([NMDR{:,2}], [NMDR{:,10}], 'o'); hold on;
xlabel('DR', 'FontSize', 14)
ylabel('kurtosis', 'FontSize', 14)


end
    

