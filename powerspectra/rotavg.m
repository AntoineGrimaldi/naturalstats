function f = rotavg(array)
% rotavg.m - function to compute rotational average of (square) array
% 
% function f = rotavg(array)
%
% array can be of dimensions N x N x M, in which case f is of 
% dimension NxM.  N should be even
%
%function available in Internet: http://www.rctn.org/bruno/npb261b/lab2/rotavg.m

[N N M]=size(array);

[X Y]=meshgrid(-N/2:N/2-1,-N/2:N/2-1);

[theta rho]=cart2pol(X,Y);

rho=round(rho);
i=cell(floor(N/2)+1,1);
for r=0:N/2
  i{r+1}=find(rho==r);
end

f=zeros(floor(N/2)+1,M);

for m=1:M

  a=array(:,:,m);
  for r=0:N/2
    f(r+1,m)=mean(a(i{r+1}));
  end
  
end