% Download and Image from the web and fit the phases
close all 
url = 'http://i.imgur.com/2SSTgSk.jpg';
A = imresize( imresize( ...
       mean(double( imread(url) ), 3), ...
      .5),2);
  
%A = double(imread(url));
%H = FSPECIAL('gaussian',[20,20],.9);
%A = imfilter(A,H, 'replicate');

id = find(normalize( A ) > 0);
out = segmentprob( A( 200:450, 400:700 ), ... A 2-D (could be 3-D) image, average the RGB channels
  150, ... Number of bins in the histogram
   5 ...  Number of peaks of phases to find
    );

A2 = zeros( size( A ) );
A2(id) = out.out.phase;
figure()
ax(1) = subplot(1,2,1);
pcolor(A);
shading flat
ax(2) = subplot(1,2,2);
pcolor( A2 );
shading flat



figure(1)


