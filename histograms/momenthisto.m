function [R] = momenthisto(hist, li)
%this function computes the statistical moments of the histogram in input

R = [];

for q = 1:size(hist,3)
    m = 0;
    sd = 0;
    s = 0;
    k = 0;
    k2 = 0;
    h = 0;
    
    
    %CALCUL MEAN
    for i = 1:size(hist,2)
        m = m + hist(:,i,q)*li(i);
    end
    
    %CALCUL VARIANCE
    for i = 1:size(hist,2)
        sd = sd + hist(:,i,q)*(li(i)-m)^2;
    end
    sd = sqrt(sd);
    
    %CALCUL SKEWNESS    
    for i = 1:size(hist,2)
        s = s + hist(:,i,q)*(li(i)-m)^3;
    end
    s = s/sd^3;
    
    %CALCUL KURTOSIS
    for i = 1:size(hist,2)
        k = k + hist(:,i,q)*(li(i)-m)^4;
    end
    k = k/sd^4;
    
    %CALCUL KURTOSIS
    for i = 1:size(hist,2)
        if abs(li(i))<14*sd 
            k2 = k2 + hist(:,i,q)*(li(i)-m)^4;
        end
    end
    k2 = k2/sd^4;
    
    for i = 1:size(hist,2)
        h = h + hist(:,i,q)*log10(hist(:,i,q)+1);
    end
    
    r = [m sd s k k2 h];
    R = [R;r];
end
