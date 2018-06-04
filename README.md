# naturalstats
A code to compute statistics on natural images
%________________________________________________________________________%
% This function computes various statistics on a dataset of images. The  %
% four statistical moments are computed for each image along with the DR %
% and other information about the images that will be used in the differ-%
% ent analyses. Histograms are computed regarding the work from Huang &  %
% Mumford, 1999 as well as the wavelet coefficient joint histograms. The %
% power spectra are a rotational average of the 2D Fourier transform of  %
% the images.                                                            %
% File with 1D luminance maps as an input.                               %
% All the results from the analyses are stored in the "Results" file.    %
%                                                                        %
% An example of the results of these analyses are presented in:          %
% Grimaldi, Kane, Bertalm??o, 2018 (unpublished)                         %
% -> http://ip4ec.upf.edu/system/files/publications/Statistics%20of%20natural%20images.pdf
%                                                                        %
% Antoine Grimaldi, UPF, Barcelona                                       %
%________________________________________________________________________%


To use this code, open naturalstats.m, enter the name of the file where your 
images are stored, set up the different parameters for the statistical studies
and run it. 
