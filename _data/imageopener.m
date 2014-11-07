%% Opens directory with images and puts each image into a nested cell (cell
%% within a cell) *Note - directory must be changed to the location where
%% your images are stored

file = dir('2013 08 01 - Samples from Maryana'); 
file = file(~[file.isdir]); 

%% Number of Files in directory; preallocated cells/arrays
NF = length(file); 
images = cell(NF,1);
lineplot = cell(NF,1);
firstdev = cell(NF,1);
secdev = cell(NF,1);


%% Allows user input to specify the pixel row starting point
pixelstart = input('Pixel to start  ', 's');
initial = str2double(pixelstart);

while initial < 1 || initial > 1024
   pixelstart = input('Pixel to start  ', 's');
   initial = str2double(pixelstart);
     
end
   
%% Allows user input to specify the pixel row end point
pixelend = input('Pixel to end  ', 's');
final = str2double(pixelend);

while final < initial+1 || final > 1024
   pixelend = input('Pixel to end  ', 's');
   final = str2double(pixelend);
     
end 
   
%% Loop to modify each sub-cell; inverts the grey scale values and narrows
%% the range of information based on the user input for pixel starting and
%% ending rows.  A simple average is also taken down a column from row 
%% start to row end for later use in a lineplot.
for k = 1 : NF 
images{k} = imread(fullfile('2013 08 01 - Samples from Maryana', file(k).name));

images{k} = 255 - images{k};

imageslength = length(images{k});

    for i = 1:imageslength 
        lineplot{k}(1,i) = mean(images{k}(initial:final, i));
    end
    
    %% This loop smooths out the function to help remove noise
    for l = 1:10;
         for j = 2:imageslength-1
             lineplot{k}(1,j) = (lineplot{k}(1,j+1)+lineplot{k}(1,j-1))/2; 
         end
    end

end

for k = 1 : NF 
   
     for r = 3 : 1022 
        %%firstdev{k}(1,r-1) = ((lineplot{k}(1,r+1)-lineplot{k}(1,r-1))/2);
        firstdev{k}(1,r-2) = (8*lineplot{k}(1,r+1)-8*lineplot{k}(1,r-1)-lineplot{k}(1,r+2)+lineplot{k}(1,r-2))/12;
    end

end

for k = 1 : NF 
   
     for r = 3 : 1022 
         %%secdev{k}(1,r-1) = (lineplot{k}(1,r+1)-2*lineplot{k}(1,r)+lineplot{k}(1,r-1))/2;
         secdev{k}(1,r-2) = (16*lineplot{k}(1,r+1)+16*lineplot{k}(1,r-1)-lineplot{k}(1,r+2)-lineplot{k}(1,r-2)-30*lineplot{k}(1,r))/12;
    end

end

%% Plots a line plot of the inverted grey scale intensities vs. the pixel
%% position along the row. Will work on this part.

imagestoplot = input('Number of Plots?  ', 's');
finalplots = str2double(imagestoplot);

for j = 1:finalplots
    
    whichimage = input('Which Images?  ', 's');
    imagepick = str2double(whichimage);
    
    plot(1:length(images{imagepick}), lineplot{imagepick});
    hold on;

end

hold off

devstoplot = input('Number of derivative Plots?  ', 's');
devplots = str2double(devstoplot);

for j = 1:devplots
    
    whichimage = input('Which Images?  ', 's');
    imagepick = str2double(whichimage);
    
    plot(3:length(images{imagepick})-2, firstdev{imagepick});
    hold on;

end

hold off

secdevstoplot = input('Number of second derivative Plots?  ', 's');
secdevplots = str2double(secdevstoplot);

for j = 1:devplots
    
    whichimage = input('Which Images?  ', 's');
    imagepick = str2double(whichimage);
    
    plot(3:length(images{imagepick})-2, secdev{imagepick});
    hold on;

end

hold off
