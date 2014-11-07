%% Opens directory with images and puts each image into a nested cell (cell
%% within a cell) *Note - directory must be changed to the location where
%% your images are stored

file = dir('2014 11 05 - smoothimages'); 
file = file(~[file.isdir]); 

%% Number of Files in directory; preallocated cells/arrays
NF = length(file); 
images = cell(NF,1);
lineplot = cell(NF,1);
firstsmooth = cell(NF-1,1);
firstsmooth2 = cell(NF-1,1);





   
%% Loop to modify each sub-cell; inverts the grey scale values and narrows
%% the range of information based on the user input for pixel starting and
%% ending rows.  A simple average is also taken down a column from row 
%% start to row end for later use in a lineplot.
for k = 1 : NF 
images{k} = imread(horzcat('./2014 11 05 - smoothimages/','img', num2str(k), '.jpeg' ));



imageslength = length(images{k});

end

lcldir = './2014 11 05 - smoothtimedev/';


   
        for k = 1:NF-1 
            firstsmooth{k} = (images{k+1} - images{k});
            %firstsmooth2{k} = mat2gray(imresize(imresize(firstsmooth{k},.5),2));
            imwrite( firstsmooth{k},fullfile( lcldir, horzcat( num2str(k), '.jpeg' ) ) );
        end
