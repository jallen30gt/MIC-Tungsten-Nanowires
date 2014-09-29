%% Load in the three images

lcldir = './assets/starterimages/';
files = dir( horzcat( lcldir, '*.jpg' ) );

for fileid = 1 : min(numel( files ),3)
    midid = size(A,1)./2;
    
    ax(fileid,1) = subplot( 2,3, fileid );
    A = double( imread( fullfile( lcldir, files(fileid).name ) ) );
    A(:) = A./255;
    A(midid-1,:) = 0;
    
    pcolor(A); shading flat
    
    ax(fileid,2) = subplot( 2,3, fileid + 3);
    plot( 1: size(A,2), A( midid, : ), '-k' );
    
    linkaxes( ax(fileid,:),'x' )
end

figure(gcf)

%% Testing the preprocessing of the Raw Images

for  filterstd = 2;
    % Loop over the standard deviation in the Gaussian Filter
    myfilter = fspecial('gaussian',[11 11], filterstd);
    
    for fileid = 1 : numel( files )
        midid = size(A,1)./2;
        
        ax(fileid,1) = subplot( 2,3, fileid );
        
        A = double( imread( fullfile( lcldir, files(fileid).name ) ) );
        A(:) = A./255;
        fA = imfilter( A, myfilter, 'replicate' );
        
        % Compute the derivatives in filtered image
        [Gx, Gxx] = derivative7( fA, 'x', 'xx');
        
        pcolor( fA ); shading flat
        %         A(midid-1,:) = 0;
        
        ax(fileid,2) = subplot( 2,3, fileid + 3);
        %         [ ax(fileid,2:3), h1] = plotyy( 1: size(A,2), fA( midid, : ), ... Filter Singled
        %                 1: size(A,2), [ Gx( midid, : ); ... First Derivative
        %                                Gxx( midid, : )] ... Second Derivative
        %                                );
        
        [ h1] = plot(ax(fileid,2), 1: size(A,2), [ mean(Gx( midid + [-1:1], : ),1); ... First Derivative
            mean(Gxx( midid + [-1:1], : ),1)] ... Second Derivative
            );
        
        linkaxes( ax(fileid,:),'x' )
    end
end
legend(h1,'First','Second')
linkaxes( ax(:,1), 'y')
linkaxes( ax(:,2), 'y')

%% Explore different filters on the raw images


for  filterstd = 2;
    % Loop over the standard deviation in the Gaussian Filter
    F = ones(5);
    filter = @(x)medfilt2(x,[5 5]-2)
    
    for fileid = 1 : min( numel( files ),3 )
        midid = size(A,1)./2;
        
        ax(fileid,1) = subplot( 2,3, fileid );
        
        A = double( imread( fullfile( lcldir, files(fileid).name ) ) );
        A(:) = A./255;
        fA = filter( A );
        
        pcolor( fA ); shading flat
        
        ax(fileid,2) = subplot( 2,3, fileid +3 );
        pcolor( A ); shading flat
        %         A(midid-1,:) = 0;
        
        linkaxes( ax(fileid,:) )
    end
end
%   legend(h1,'First','Second')
% linkaxes( ax(:,1), 'y')
% linkaxes( ax(:,2), 'y')

%% Testing the preprocessing of the Mediam Filter on the Raw Images

for  filtersz = 7;
    % Loop over the standard deviation in the Gaussian Filter
    filter = @(x)medfilt2( imadjust(x), [ filtersz filtersz] );
    
    for fileid = 1 : 2%numel( files )
        
        
        ax(fileid,1) = subplot( 2,3, fileid );
        
        A = double( imread( fullfile( lcldir, files(fileid).name ) ) );
        midid = size(A,1)./2;
        A(:) = A./255;
        fA = filter( A );
        
        % Compute the derivatives in filtered image
        [Gx, Gxx] = derivative5( fA, 'x', 'xx');
        
        % Peak Finding
        BatchAverage = imfilter( Gx, ones(1,3) );
        
        grad = BatchAverage( midid, : );
        
        dilateGAll = imdilate( BatchAverage, [ 1 1 1 1 0 1 1 1 1] );
        dilateG = dilateGAll(midid,:);
        [ida]= find( BatchAverage  > dilateGAll );
        [xid,yid]= find( BatchAverage  > dilateGAll );
        
        [id]= find( grad> dilateG);
        % END :: Peak Finding
        
        pcolor( fA ); shading flat
        hold on
        %         plot( yid, xid,'mo' );
        hold off
        title( numel(id))
        
        ax(fileid,2) = subplot( 2,3, fileid + 3);
        
        
        [ h1] = plot(ax(fileid,2), 1: size(A,2), grad,'k' );
        
        hold on;
        [ h2] = plot(ax(fileid,2), 1: size(A,2), dilateG,'r' );
        
        
        
        
        hold off;
        linkaxes( ax(fileid,:),'x' )
    end
end
legend(h1,'First','Second')
linkaxes( ax(:,1), 'y')
linkaxes( ax(:,2), 'y')

%%

% pre-filter the x-peaks between ``xid`` 200 & 700
% Find max in the range that is a peak ``yid``
close all;
for jj = 1 : size( fA,1 )
    b = xid == jj ;
    b(:) = b & (yid > 350& yid < 600);
    xx = xid(b);
    yy = yid(b);
    ii = ida(b);           % indicies to peaks
    vv = BatchAverage(ii); % Filtered peak values
    [v,i] = max(vv);
    peak(jj) = yy(i);
    
end

pcolor(fA);
hold on
plot( peak, 1 : numel(peak),'mo')
hold off
figure(gcf)

%% Pre-processing proposal
%
% # Median Filter on Raw Image
% # First Derivative on Filtered Image
% # Smoothe nearest derivative rows
% # Find max peak in the middle

%% Batch the shit the out of shit

lcldir = './assets/starterimages/';
files = dir( horzcat( lcldir, '*.jpg' ) );
clear peak
for  filtersz = 7;
    % Loop over the standard deviation in the Gaussian Filter
    filter = @(x)medfilt2( imadjust(x), [ filtersz filtersz] );
    
    for fileid = 1 : numel( files )
        midid = size(fA,1)./2;
        
        A = double( imread( fullfile( lcldir, files(fileid).name ) ) );
        A(:) = A./255;
        fA = filter( A );
        
        % Compute the derivatives in filtered image
        [Gx] = derivative5( fA, 'x');
        
        % Peak Finding
        BatchAverage = imfilter( Gx, ones(1,3) );
        
        dilateGAll = imdilate( BatchAverage, [ 1 1 1 1 0 1 1 1 1] );
        
        [ida]= find( BatchAverage  > dilateGAll );
        [xid,yid]= find( BatchAverage  > dilateGAll );
        
        peak(fileid).name = files(fileid).name;
        tempstr = strtok(files(fileid).name,'.');
        peak(fileid).layer = str2num(tempstr(end-[3:-1:0]));
        
        disp( sprintf( 'Computing peaks for %s.\n',peak(fileid).name))
        for jj = 1 : size( fA,1 )
            b = xid == jj ;
            b(:) = b & (yid > 350& yid < 600);
            xx = xid(b);
            yy = yid(b);
            ii = ida(b);           % indicies to peaks
            vv = BatchAverage(ii); % Filtered peak values
            [v,i] = max(vv);
            peak(fileid).peaks(jj) = yy(i);
            
        end
        
    end
end

%%

%%

useida = find([peak(:).layer] > -Inf  & [peak(:).layer] < Inf);
% useid = useid(1:2:end)
for useid = useida

holded = false;

co = cbrewer( 'div', 'RdYlBu',numel(useid));

ct = 0;
str={}
h = []
r = [350,650]
B = double( imread( fullfile( lcldir, files(useid(end)).name ) ) )';
pcolor( 1 : size(B,2), r(1):r(2), B(r(1): r(2),: )); shading flat; colormap gray;
axis equal;
axis tight

if ~holded
        hold on;
        holded = true;
end

for pp = useid
    ct = ct + 1;
    h(ct) = plot(  1 : numel(peak(pp).peaks), peak(pp).peaks,'.','Color', co(ct,:), 'MarkerFaceColor', co(ct,:), 'Markersize',8 )
    str{ct} = num2str(peak(pp).layer);
    
end
hold off
xlim([0 1024])
figure(gcf)
grid on
legend( h, str);
saveas( gcf,fullfile( lcldir, horzcat( peak(useid).name, '.png' ) ) )
end