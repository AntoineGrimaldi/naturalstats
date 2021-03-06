function [hist, a, b] = joint_histogram(x,y, fine, Cmax)
%This function computes the joint histogram for the vectors x and y. fine
%gives the number of bins and Cmax the maximum value to take into account.

    conx = reshape(x,size(x,1)*size(x,2),1);
    cony = reshape(y,size(y,1)*size(y,2),1);
    
    m = max([max(conx) max(cony)]);
    
    conx = conx/m;
    cony = cony/m;

[hist, a, b ] = histcounts2(conx,cony,[-Cmax:2*Cmax/fine:Cmax],[-Cmax:2*Cmax/fine:Cmax]);

end

