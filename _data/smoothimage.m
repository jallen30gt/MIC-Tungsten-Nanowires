%% Opens directory with images and puts each image into a nested cell (cell
%% within a cell) *Note - directory must be changed to the location where
%% your images are stored

file = dir('2013 08 01 - Samples from Maryana'); 
file = file(~[file.isdir]); 

%% Number of Files in directory; preallocated cells/arrays
NF = length(file); 
images = cell(NF,1);
smooth = cell(NF-2,1);
smooth2 = cell(NF-2,1);





   
%% Loop to modify each sub-cell; inverts the grey scale values and narrows
%% the range of information based on the user input for pixel starting and
%% ending rows.  A simple average is also taken down a column from row 
%% start to row end for later use in a lineplot.
for k = 1 : NF 
images{k} = imread(fullfile('2013 08 01 - Samples from Maryana', file(k).name));



imageslength = length(images{k});

end

lcldir = './2014 11 06 - smoothimagesgray/';

   
        for k = 1:NF-2 
            %%firstdev{k}(1,r-1) = ((lineplot{k}(1,r+1)-lineplot{k}(1,r-1))/2);
            smooth{k} = (.5*images{k+2}+images{k+1}+.5*images{k})/2;
            %smooth2{k} = imresize(imresize(smooth{k},.5),2);
            smooth2{k} = mat2gray(imresize(imresize(smooth{k},.5),2));
            %smooth2{k} = imadjust(smooth2{k});
            imwrite( smooth2{k},fullfile( lcldir, horzcat( 'img', num2str(k), '.jpeg' ) ) );
        end
        
