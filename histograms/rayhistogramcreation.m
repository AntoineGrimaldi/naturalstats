function [histo1 index1] = rayhistogramcreation(LUM, avg, n, Nmax)
%Based on the way to compute histograms realized by Huang&Mumford (1999),
%this function gives histograms of log values centered by average (mean or median)
%for an input image. Parameters:
%
%avg: 0 for mean
%     1 for median
%n: choose how fine you want the histogram

li = [0:1/10^n:Nmax];
con = reshape(LUM(LUM>0),1,[]);

if avg==0
    con = con./mean(con);
elseif avg == 1
    con = con./median(con);
end

[histo1 index1] = histcounts(con, li);

end
