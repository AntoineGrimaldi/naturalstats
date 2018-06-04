function [LUM] = haar(LUM, nb_subband)
%Haar wavelet decomposition on the input image LUM, NB_subband gives the
%number of levels to apply the decomposition

[s1 s2] = size(LUM);

LUM = LUM(1:end-mod(s1,2^nb_subband),1:end-mod(s2,2^nb_subband));

[s1 s2] = size(LUM);

fm = [.25 .25; .25 .25];
fv = [.25 .25; -.25 -.25];
fh = [.25 -.25; .25 -.25];
fd = [.25 -.25; -.25 .25];

k = 1;
while k <= nb_subband
    
    LLt = conv2(LUM(1:s1/(2^(k-1)), 1:s2/(2^(k-1))),fm, 'same');
    HLt = conv2(LUM(1:s1/(2^(k-1)), 1:s2/(2^(k-1))),fv, 'same');
    LHt = conv2(LUM(1:s1/(2^(k-1)), 1:s2/(2^(k-1))),fh, 'same');
    HHt = conv2(LUM(1:s1/(2^(k-1)), 1:s2/(2^(k-1))),fd, 'same');
    
    LL = LLt(1:2:end-1, 1:2:end-1); 
    LH = -LHt(1:2:end-1, 1:2:end-1); 
    HL = -HLt(1:2:end-1, 1:2:end-1); 
    HH = HHt(1:2:end-1, 1:2:end-1); 
    
    LUM(1:s1/(2^(k)), 1:s2/(2^(k))) = LL;
    LUM(1:s1/(2^(k)), s2/(2^(k))+1:s2/(2^(k-1))) = HL;
    LUM(s1/(2^(k))+1:s1/(2^(k-1)), 1:s2/(2^(k))) = LH;
    LUM(s1/(2^(k))+1:s1/(2^(k-1)), s2/(2^(k))+1:s2/(2^(k-1))) = HH;
    
 k = k+1;
end
