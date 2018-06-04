%This function apply the haar wavelets nb_subband times on all the images from a given file
function [] = Haarfiltering(inputfile, nb_subband)

namedatafile=dir(strcat(inputfile,'/*.mat'));
namedatafile={namedatafile.name}';

disp('haar filtering..')

for F = 1:size(namedatafile,1)
    
    nm = char(namedatafile(F));
    
    load(strcat(inputfile,'/',nm));
    nm = nm(1:end-4);  
    
    if inputfile(end-2:end)=='_nk'
        LUM_haar = haar(LUM_nk, nb_subband);
    elseif inputfile(end-2:end)=='psf'
        LUM_haar = haar(LUM_psf, nb_subband);
    elseif inputfile(end-2:end)=='csf'
        LUM_haar = haar(LUM_csf, nb_subband);
    else
        LUM_haar = haar(LUM, nb_subband);
    end
    %Check if NaN values
    a = find(isnan(LUM_haar));    
    if isempty(a) == 0
        fprintf(strcat('Warning, existing Nan values! For', nm))
    end 
    
    outputfile = strcat(inputfile, '_haar');
    
    if exist(outputfile)==7
        save(strcat(outputfile,'/',nm,'.mat'),'LUM_haar')
    else
        mkdir(outputfile)
        save(strcat(outputfile,'/',nm,'.mat'),'LUM_haar')
    end
end
end

                
                
                
                
