%% Opens directory with images and puts each image into a nested cell (cell
%% within a cell) *Note - directory must be changed to the location where
%% your images are stored

file = dir('2014 11 05 - smoothimages'); 
file = file(~[file.isdir]); 

%% Number of Files in directory; preallocated cells/arrays
NF = length(file); 
images = cell(NF,1);
lineplot = cell(NF,1);
segments = cell(NF-1,1);
segment2 = cell(NF-1,1);
overlay = cell(NF-1,1);





   
%% Loop to modify each sub-cell; inverts the grey scale values and narrows
%% the range of information based on the user input for pixel starting and
%% ending rows.  A simple average is also taken down a column from row 
%% start to row end for later use in a lineplot.
for k = 1 : NF 
images{k} = imread(horzcat('./2014 11 05 - smoothimages/','img', num2str(k), '.jpeg' ));



imageslength = length(images{k});

end

lcldir = './2014 11 06 - segment/';


   
        for k = 1:NF 
            segments{k} = mat2gray(images{k}(200:500, 450:650));
            segments{k}(segments{k}<.1)=0;
            segments{k}(segments{k}>.1&segments{k}<.20)=0;
            segments{k}(segments{k}>.20&segments{k}<.5)=.4;
            segments{k}(segments{k}>.5&segments{k}<.75)=.6;
            segments{k}(segments{k}>.75&segments{k}<.9)=1;
            segments{k}(segments{k}>.9)=1;
            imwrite( segments{k},fullfile( lcldir, horzcat( num2str(k), '.jpeg' ) ) );
        end
        
        lcldir = './2014 11 07 - overlay/';
        
        for k = 1:NF 
            segment2{k} = mat2gray(images{k});
            
            segment2{k}(200:500, 450:650) = segments{k};
            imwrite( segment2{k},fullfile( lcldir, horzcat( num2str(k), '.jpeg' ) ) );
        end


