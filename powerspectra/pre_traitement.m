%_______________________________________________________%
% Cette fonction applique un fen�trage de hanning       %
% puis supprime la composante continue de l'image plac�e%
% en param�tre d'entr�e.                                %  
% N. Guyader, LIS                                       %
%_______________________________________________________%

function im=pre_traitement(image);

[im h]=fenetre_hanning(image);
%im=double(im)-mean(mean(im));
im = double(im)-sum(im(:))/sum(h(:));

