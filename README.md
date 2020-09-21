# naturalstats (jeretest)

A code to compute statistics on natural images <br/><br/>

To use this code, open naturalstats.m, enter the name of the file where your     
images are stored, set up the different parameters for the statistical studies  
and run it.<br/><br/>

%____________________________________________________________________________ <br/> 
% This function computes various statistics on a dataset of images. The   <br/>
% four statistical moments are computed for each image along with the DR  <br/> 
% and other information about the images that will be used in the different <br/>
% analyses. Histograms are computed regarding the work from Huang &  <br/> 
% Mumford, 1999 as well as the wavelet coefficient joint histograms. The  <br/> 
% power spectra are a rotational average of the 2D Fourier transform of   <br/> 
% the images.                                                             <br/> 
% File with 1D luminance maps as an input.                                <br/> 
% All the results from the analyses are stored in the "Results" file.     <br/> 
%                                                                         <br/> 
% An example of the results of these analyses are presented in:           <br/> 
% Grimaldi, Kane, Bertalm??o, 2018 (unpublished)                          <br/> 
% -> http://ip4ec.upf.edu/system/files/publications/Statistics%20of%20natural%20images.pdf <br/> 
%                                                                         <br/> 
% Antoine Grimaldi, UPF, Barcelona                                        <br/> 
%____________________________________________________________________________ <br/> 
<br/><br/> 
