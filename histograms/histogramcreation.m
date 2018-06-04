function [histo1 histoV1 histoH1 index1 index2] = histogramcreation(LUM, avg, lo, pow, Nmax, Nmaxdev)
%Based on the way to compute histograms realized by Huang&Mumford (1999),
%this function gives histograms of log values centered by average (mean or median)
%for an input image. Parameters:
%
%avg: 0 for mean
%     1 for median
%lo: 0 for log10
%    1 for log (neperien)
%pow: choose how fine you want the histogram
%Nmax & Nmaxdev: maximun values for the histogram x axis

index = logspace(-Nmax, Nmax, 2^pow+1 );
index2 = logspace(-Nmaxdev, Nmaxdev, 2^pow+1 );

if lo == 0
    li=log10(index);
    li2=log10(index2);
elseif lo == 1
    li=log(index);
    li2=log(index2);
end


if lo == 0
    con = log10(reshape(LUM(LUM>0),1,[]));
    vercor = log10(LUM(1:end-1,:)./LUM(2:end,:));
    ver = reshape(vercor(abs(vercor)~=inf),1,[]);
    horcor = log10(LUM(:,1:end-1)./LUM(:,2:end));
    hor = reshape(horcor(abs(horcor)~=inf),1,[]);
    
    if avg==0
        con = con-mean(con);
    elseif avg == 1
        con = con-median(con);
    end
    
    [histo1 index1] = histcounts(con, li);
    [histoV1 index2] = histcounts(ver, li2);
    [histoH1 index2] = histcounts(hor, li2);
    
elseif lo == 1
    con = log(reshape(LUM(LUM>0),1,[]));
    vercor = log(LUM(1:end-1,:)./LUM(2:end,:));
    ver = reshape(vercor(abs(vercor)~=inf),1,[]);
    horcor = log(LUM(:,1:end-1)./LUM(:,2:end));
    hor = reshape(horcor(abs(horcor)~=inf),1,[]);
    
    if avg==0
        con = con-mean(con);
    elseif avg == 1
        con = con-median(con);
    end
    
    [histo1 index1] = histcounts(con, li);
    [histoV1 index2] = histcounts(ver, li2);
    [histoH1 index2] = histcounts(hor, li2);
    
end

end
