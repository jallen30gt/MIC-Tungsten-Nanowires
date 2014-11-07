%% Opens directory with images and puts each image into a nested cell (cell
%% within a cell) *Note - directory must be changed to the location where
%% your images are stored

file = dir('2013 08 01 - Samples from Maryana'); 
file = file(~[file.isdir]); 

%% Number of Files in directory; preallocated cells/arrays
NF = length(file); 
images = cell(NF,1);
lineplot = cell(NF,1);
firstdev = cell(NF-1,1);
firstdev2 = cell(NF-1,1);




   
%% Loop to modify each sub-cell; inverts the grey scale values and narrows
%% the range of information based on the user input for pixel starting and
%% ending rows.  A simple average is also taken down a column from row 
%% start to row end for later use in a lineplot.
for k = 1 : NF 
images{k} = imread(fullfile('2013 08 01 - Samples from Maryana', file(k).name));



imageslength = length(images{k});

end


lcldir = './2014 11 06 - timedevsgray/';
   
        for k = 1:NF-1 
            %%firstdev{k}(1,r-1) = ((lineplot{k}(1,r+1)-lineplot{k}(1,r-1))/2);
            firstdev{k} = (images{k+1}-images{k});
         	firstdev2{k} = mat2gray(firstdev{k});
            imwrite( firstdev2{k},fullfile( lcldir, horzcat( num2str(k), '.jpeg' ) ) );
        end


