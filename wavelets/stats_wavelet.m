function [H_vh H_vd H_hd H_hupper H_vleft H_hleft H_dupperleft H_hprt H_dprt] = stats_wavelet( file , NMDR , nbquantile , fine, Cmax, norm )
%This function uses a dataset of images within the folder 'file' and uses
%the name and DR of the images stored in NMDR with the function stats_moments 
%to compute the joint histogram of th wavelet coefficients of the images. 
%   nbquantile: The dataset can be divided by DR categories with
%               nbquantile for the number-1 of category wanted. 
%   fine: define the number of bins to use
%   Cmax: define the extreme value to take into account in the joint
%   histogram
%   norm: Normalization of the images: 0 -> no normalization
%                                      1 -> divide by the maximum 
%                                      2 -> scale between 0 and 1 
%
%output: all the joint histograms found in Huang&Mumford, 1999 study: 
%        - H_vh for the vertical and horizontal coefficients
%        - H_vd for the vertical and diagonal coefficients
%        - H_hd for the horizontal and diagonal coefficients
%        - H_hupper for the horizontal coef and its upper brother
%        - H_vleft for the vertical coef and its left brother
%        - H_hleft for the horizontal coef and its left brother
%        - H_dupperleft for the diagonal coef and its upper left brother
%        - H_hprt for the horizontal coef and its parent 
%        - H_dprt for the diagonal coef and its parent 


long = fine;

H_vh = zeros(long,long,nbquantile+1);
H_vd = zeros(long,long,nbquantile+1);
H_hd = zeros(long,long,nbquantile+1);
H_hupper = zeros(long,long,nbquantile+1);
H_vleft = zeros(long,long,nbquantile+1);
H_hleft = zeros(long,long,nbquantile+1);
H_dupperleft = zeros(long,long,nbquantile+1);
H_hprt = zeros(long,long,nbquantile+1);
H_dprt = zeros(long,long,nbquantile+1);

for A = 1:size(NMDR,1)
    
    disp(strcat('wave_',num2str(A)));
    nm = NMDR{A,1};
    load(strcat('./',file,'/',nm(1:end-4),'.mat'));
    if nbquantile == 1
        drlim = median(cell2mat(NMDR(:,2)));
    elseif nbquantile == 0
        drlim = max(cell2mat(NMDR(:,2)));
    else
        drlim = quantile(cell2mat(NMDR(:,2)),nbquantile);
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
        LUM_haar = LUM_haar./max(LUM_haar(:));
    end
    
    if norm == 2
        LUM_haar = (LUM_haar-min(LUM_haar(:)))./(max(LUM_haar(:))-min(LUM_haar(:)));
    end
    
%     vert = LUM_haar(513:1024,1:512);
%     horz = LUM_haar(1:512,513:1024);
%     diag = LUM_haar(513:1024,513:1024);
%     horz_prt = zeros(512,512);
%     horz_prt(1:2:512,1:2:512) = LUM_haar(1:256,257:512);
%     horz_prt(1:2:512,2:2:512) = LUM_haar(1:256,257:512);
%     horz_prt(2:2:512,1:2:512) = LUM_haar(1:256,257:512);
%     horz_prt(2:2:512,2:2:512) = LUM_haar(1:256,257:512);
%     diag_prt = zeros(512,512);
%     diag_prt(1:2:512,1:2:512) = LUM_haar(257:512,257:512);
%     diag_prt(1:2:512,2:2:512) = LUM_haar(257:512,257:512);
%     diag_prt(2:2:512,1:2:512) = LUM_haar(257:512,257:512);
%     diag_prt(2:2:512,2:2:512) = LUM_haar(257:512,257:512);  
%     

    sub1 = floor(log2(size(LUM_haar,1)));
    sub2 = floor(log2(size(LUM_haar,2)));
    vert = LUM_haar(2^(sub1-1)+1:2^sub1,1:2^(sub2-1));
    horz = LUM_haar(1:2^(sub1-1),2^(sub2-1)+1:2^sub2);
    diag = LUM_haar(2^(sub1-1)+1:2^sub1,2^(sub2-1)+1:2^sub2);
    horz_prt = zeros(2^(sub1-1),2^(sub2-1));
    horz_prt(1:2:2^(sub1-1),1:2:2^(sub2-1)) = LUM_haar(1:2^(sub1-2),2^(sub2-2)+1:2^(sub2-1));
    horz_prt(1:2:2^(sub1-1),2:2:2^(sub2-1)) = LUM_haar(1:2^(sub1-2),2^(sub2-2)+1:2^(sub2-1));
    horz_prt(2:2:2^(sub1-1),1:2:2^(sub2-1)) = LUM_haar(1:2^(sub1-2),2^(sub2-2)+1:2^(sub2-1));
    horz_prt(2:2:2^(sub1-1),2:2:2^(sub2-1)) = LUM_haar(1:2^(sub1-2),2^(sub2-2)+1:2^(sub2-1));
    diag_prt = zeros(2^(sub1-1),2^(sub2-1));
    diag_prt(1:2:2^(sub1-1),1:2:2^(sub2-1)) = LUM_haar(2^(sub1-2)+1:2^(sub1-1),2^(sub2-2)+1:2^(sub2-1));
    diag_prt(1:2:2^(sub1-1),2:2:2^(sub2-1)) = LUM_haar(2^(sub1-2)+1:2^(sub1-1),2^(sub2-2)+1:2^(sub2-1));
    diag_prt(2:2:2^(sub1-1),1:2:2^(sub2-1)) = LUM_haar(2^(sub1-2)+1:2^(sub1-1),2^(sub2-2)+1:2^(sub2-1));
    diag_prt(2:2:2^(sub1-1),2:2:2^(sub2-1)) = LUM_haar(2^(sub1-2)+1:2^(sub1-1),2^(sub2-2)+1:2^(sub2-1));  
    
    
    hist_vh = joint_histogram(vert,horz, fine, Cmax);
    hist_vd = joint_histogram(vert,diag, fine, Cmax);
    hist_hd = joint_histogram(horz,diag, fine, Cmax);
    hist_hupper = joint_histogram(horz(2:end,:),horz(1:end-1,:), fine, Cmax);
    hist_vleft = joint_histogram(vert(:,2:end),vert(:,1:end-1), fine, Cmax);
    hist_hleft = joint_histogram(horz(:,2:end),horz(:,1:end-1), fine, Cmax);
    hist_dupperleft = joint_histogram(diag(2:end,2:end),horz(1:end-1,1:end-1), fine, Cmax);
    hist_hprt = joint_histogram(horz,horz_prt, fine, Cmax);
    hist_dprt = joint_histogram(diag,diag_prt, fine, Cmax);
    
    H_vh(:,:,q) = H_vh(:,:,q) + hist_vh;
    H_vd(:,:,q) = H_vd(:,:,q) + hist_vd;
    H_hd(:,:,q) = H_hd(:,:,q) + hist_hd;
    H_hupper(:,:,q) = H_hupper(:,:,q) + hist_hupper;
    H_vleft(:,:,q) = H_vleft(:,:,q) + hist_vleft;
    H_hleft(:,:,q) = H_hleft(:,:,q) + hist_hleft;
    H_dupperleft(:,:,q) = H_dupperleft(:,:,q) + hist_dupperleft;
    H_hprt(:,:,q) = H_hprt(:,:,q) + hist_hprt;
    H_dprt(:,:,q) = H_dprt(:,:,q) + hist_dprt; 
    
end

    H_vh = log(H_vh+1);
    H_vd = log(H_vd+1);
    H_hd = log(H_hd+1);
    H_hupper = log(H_hupper+1);
    H_vleft = log(H_vleft+1);
    H_hleft = log(H_hleft+1);
    H_dupperleft = log(H_dupperleft+1);
    H_hprt = log(H_hprt+1);
    H_dprt = log(H_dprt+1);

    SOMhist = sum(H_vh,2);
    SOMhist = sum(SOMhist,1);
    for Q = 1:size(SOMhist,3)
        H_vh(:,:,Q) = H_vh(:,:,Q)./SOMhist(:,:,Q);
    end
    
    SOMhist = sum(H_vd,2);
    SOMhist = sum(SOMhist,1);
    for Q = 1:size(SOMhist,3)
        H_vd(:,:,Q) = H_vd(:,:,Q)./SOMhist(:,:,Q);
    end
    
    SOMhist = sum(H_hd,2);
    SOMhist = sum(SOMhist,1);
    for Q = 1:size(SOMhist,3)
        H_hd(:,:,Q) = H_hd(:,:,Q)./SOMhist(:,:,Q);
    end
    
    SOMhist = sum(H_hupper,2);
    SOMhist = sum(SOMhist,1);
    for Q = 1:size(SOMhist,3)
        H_hupper(:,:,Q) = H_hupper(:,:,Q)./SOMhist(:,:,Q);
    end
    
    SOMhist = sum(H_vleft,2);
    SOMhist = sum(SOMhist,1);
    for Q = 1:size(SOMhist,3)
        H_vleft(:,:,Q) = H_vleft(:,:,Q)./SOMhist(:,:,Q);
    end
    
    SOMhist = sum(H_hleft,2);
    SOMhist = sum(SOMhist,1);
    for Q = 1:size(SOMhist,3)
        H_hleft(:,:,Q) = H_hleft(:,:,Q)./SOMhist(:,:,Q);
    end
    
    SOMhist = sum(H_dupperleft,2);
    SOMhist = sum(SOMhist,1);
    for Q = 1:size(SOMhist,3)
        H_dupperleft(:,:,Q) = H_dupperleft(:,:,Q)./SOMhist(:,:,Q);
    end
    
    SOMhist = sum(H_hprt,2);
    SOMhist = sum(SOMhist,1);
    for Q = 1:size(SOMhist,3)
        H_hprt(:,:,Q) = H_hprt(:,:,Q)./SOMhist(:,:,Q);
    end
    
    SOMhist = sum(H_dprt,2);
    SOMhist = sum(SOMhist,1);
    for Q = 1:size(SOMhist,3)
        H_dprt(:,:,Q) = H_dprt(:,:,Q)./SOMhist(:,:,Q);
    end
    
    save(strcat('./Results/Wavelets_', file, '_',num2str(norm), '_', num2str(fine), '_', num2str(Cmax),'.mat'), 'H_vh', 'H_vd', 'H_hd', 'H_hupper', 'H_vleft', 'H_hleft', 'H_dupperleft', 'H_hprt', 'H_dprt')  

n = 7;    
q = 1;
waveletplot(Cmax, fine, q, n, H_vh, H_hd, H_hupper, H_vleft, H_hleft, H_dupperleft, H_hprt, H_dprt);

if nbquantile>1
    q = size(H_dprt,3);
    waveletplot(Cmax, fine, q, n, H_vh, H_hd, H_hupper, H_vleft, H_hleft, H_dupperleft, H_hprt, H_dprt);
end

end

