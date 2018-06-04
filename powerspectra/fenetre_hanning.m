%_________________________________________________________%
% Cette fonction applique une fen�tre de Hanning          % 
%                                                         %
% param�tre d'entr�e: image originale                     %
% param�tre de sortie: image avec fen�trage de Hanning    %
%_________________________________________________________%

function [imfenetree h]=fenetre_hanning(image)

image=double(image);        

[lig,col]=size(image);
x=linspace(-col/2,col/2,col);
y=linspace(-lig/2,lig/2,lig);
[X Y]=meshgrid(x,y);

if lig<col
   r=lig;
else
   r=col;
end;

% �quation de la fen�tre de Hanning 
h=0.5+0.5*cos(2*pi*sqrt(X.^2+Y.^2)/r);

% �vite la "remont�e de la fen�tre au del� du cercle
% de rayon taille/2. Au dela du cercle on fixe la valeur
% des pixels a 0

for i=1:lig
   for j=1:col
      if sqrt(((lig+1)/2-i)^2+((col+1)/2-j)^2)>(r+1)/2
         h(i,j)=0;
      end;
   end;
end;

imfenetree=image.*h;


