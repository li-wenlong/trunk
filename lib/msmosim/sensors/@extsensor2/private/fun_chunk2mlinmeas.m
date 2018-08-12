function [Z ] = fun_chunk2mlinmeas( chunk , varargin )

mx = [-90:180/( size(chunk,2)-2 ):90]*pi/180;
[Xb, Yb] = pol2cart( mx,  ones(1,length(mx))*8000 );
background = [Xb;Yb];


nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'inpstr1'}
                if argnum + 1 <= nvarargin
                    inpvar1 = varargin{argnum+1}(1);
                    argnum = argnum + 1;
                end
            case {''}
                
                
            otherwise
                error('Wrong input string');
        end
    elseif isa( varargin{argnum} , 'struct')
        if isfield( varargin{argnum}, 'background' )
            background = varargin{argnum}.background;
        end
        if isfield( varargin{argnum}, 'background' )
            
        end
        
    end
    argnum = argnum + 1;
end



sepdist = [ 0.5*pi/180, 50 ]'; % rad, mm.
cutoff = [ 100 ];


for i=1:size( chunk,1 )
    
    datapol = [mx; chunk(i,2:end)];
    % Convert to Euclidean 
    [X, Y] = pol2cart( datapol(1,:), datapol(2,:) );
    data_ = [X;Y];
    
    % Subtract background from data and update background
    [ data, background] = subback( data_, background );
    
    if isempty(data)
        continue;
    end
    
   
    
    % Cluster data
    if size(data, 2) == 1
        T = 1;
    else
        
        
%         Y = pdist(data','euclid'); 
%         Zt = linkage(Y,'single'); 
%         T = cluster(Zt,'MaxClust',5:15);    
          T = seedngrowclustering( data );
    end
    
     
   % Fit ellipses to the clusters    
    ulabels = unique(T);
    numobs = 0;
    a = [];
    Pnts = {};
    Zs = mlinmeas;
    Zs([]);
    for j=1:length(ulabels)
        ind = find( T==ulabels(j) );
        if length(ind)>=4
            numobs = numobs + 1;
            obsins = mlinmeas( data( :, ind ) );
            Zs(numobs) = obsins;
        end
    end
%     
%     
% % % Comment out the lines below to visualise the chunks and the ellipses  
% %     if ~exist('fhandle')
% %         fhandle = figure;
% %     end
% %     cla;
% %     plotdatanback(data, background, gca, T);
% %     plotellipses(a, gca )
% %     disp(sprintf('chunk # %d',i ));
% %     pause(0.1);
%     
%   
%     % Find the center of gravities and initiate rbmeas objects
%     Zs = rbmeas;
%     Zs = Zs([]);
%     numobs = 0;
%     for j=1:size( a, 1 )
%        loc_ = a(j,:);
%                      
%        Cx = a(j,1);
%        Cy = a(j,2);
%        Rx = a(j,3); % Use Rx and Ry as measures of uncertainty
%        Ry = a(j,4);
%        alpha_ = a(j,5);
%        
%        mvec = mean( Pnts{j},2 );
%        Cmtrx = cov( Pnts{j}' );
%        
%        if norm( mvec-[Cx;Cy] )<= 750
%            R = [cos(alpha_), -sin(alpha_); sin(alpha_), cos(alpha_)];
%            CM = R*[ Rx^2 0;0 Ry^2]'; % Covariance Matrix
% 
%            bearing_ = atan2( Cy, Cx );
%            range_ = sqrt( Cx^2 + Cy^2 );
%        else
%            bearing_ = atan2( mvec(2), mvec(1) );
%            range_ = sqrt( mvec(1)^2 + mvec(2)^2 );
%        end
%        
%        
% %        rbmeasobj = rbmeas;
% %        rbmeasobj.bearing = bearing_;
% %        rbmeasobj.range = range_ ;
%        rbmeasobj = rbmeas( bearing_, range_ );
%        numobs = numobs + 1;
%        Zs(numobs) = rbmeasobj;
%     end
     Z{i} = Zs;
    
    
end % End the chunk


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [ pdata, background] = subback( data, background )

if isempty( background )
    background = data;
    pdata = data( [] ,:);
    return;
end

D = distance(data, background); % returns the distance matrix

[ ind ] = find( diag( D ) <= 200 );

bindata = data( :, ind ); % background in data

% update background
background(:, ind ) = ( background( :, ind ) + bindata )/2;
%cind = setdiff( [1:size(background,2)] , ind );
%background(:, cind ) = data( :, cind );

% prune data
cinddata = setdiff( [1:size(data,2)] , ind );
pdata = data( :, cinddata );

end % EO subback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotpulselocs( pulselocs, amp, axisHandle )

axis(axisHandle);
hold on;
for j=1:size(pulselocs,1)
    plot( [pulselocs(j,1), pulselocs(j,1) ], [0, amp], 'r' )
    plot( [pulselocs(j,2), pulselocs(j,2) ], [0, amp], 'r' )
    plot( [pulselocs(j,1), pulselocs(j,2) ], [amp, amp], 'r' )
end
Rx*cos(t)*cos(alpha_) - Ry*sin(t)*sin( alpha_ );
end % EO plotpulseloc

function plotdatanback( data, background, varargin )
if ~isempty(varargin)
    ahandle = varargin{1};
    axis( ahandle );
else
    figure
end
if nargin>=4
    labels = varargin{2};
end


hold on
axis equal
if ~exist('labels')
plot( data(1,:), data(2,:), '*b')
else
   ulabels = unique(labels);
   rgbobj = rgb;
   for j=1:length(ulabels)
       ind = find(labels==ulabels(j));
      plot( data(1,ind), data(2,ind), 'LineStyle','None','Marker','x','Color', rgbobj.getcol );       
   end
    
end
plot( background(1,:), background(2,:), 'LineStyle','None','Marker','*','Color', [0.3 0.3 0.3] );       
hold off
end

function plotellipses( a, varargin )
if ~isempty(varargin)
    ahandle = varargin{1};
    axis( ahandle );
else
    figure
end
hold on;
for j=1:size(a,1)
    alpha_ = a(j,5);
    Cx = a(j,1);
    Cy = a(j,2);
    Rx = a(j,3);
    Ry = a(j,4);
    
    % Find points in the circumphere 
    t = [0:1:359]*pi/180;
    xs = Cx + Rx*cos(t)*cos(alpha_) - Ry*sin(t)*sin( alpha_ );
    ys = Cy + Rx*cos(t)*sin(alpha_) + Ry*sin(t)*cos( alpha_ );
    
    plot( xs, ys );
    
end
hold off
end % EO plotellipses


function d = distance(a,b)
% DISTANCE - computes Euclidean distance matrix
%
% E = distance(A,B)
%
%    A - (DxM) matrix 
%    B - (DxN) matrix
%
% Returns:
%    E - (MxN) Euclidean distances between vectors in A and B
%
%
% Description : 
%    This fully vectorized (VERY FAST!) m-file computes the 
%    Euclidean distance between two vectors by:
%
%                 ||A-B|| = sqrt ( ||A||^2 + ||B||^2 - 2*A.B )
%
% Example : 
%    A = rand(400,100); B = rand(400,200);
%    d = distance(A,B);

% Author   : Roland Bunschoten
%            University of Amsterdam
%            Intelligent Autonomous Systems (IAS) group
%            Kruislaan 403  1098 SJ Amsterdam
%            tel.(+31)20-5257524
%            bunschot@wins.uva.nl
% Last Rev : Oct 29 16:35:48 MET DST 1999
% Tested   : PC Matlab v5.2 and Solaris Matlab v5.3
% Thanx    : Nikos Vlassis

% Copyright notice: You are free to modify, extend and distribute 
%    this code granted that the author of the original code is 
%    mentioned as the original author of the code.

if (nargin ~= 2)
   error('Not enough input arguments');
end

if (size(a,1) ~= size(b,1))
   error('A and B should be of same dimensionality');
end

aa=sum(a.*a,1); bb=sum(b.*b,1); ab=a'*b; 
d = sqrt(abs(repmat(aa',[1 size(bb,2)]) + repmat(bb,[size(aa,2) 1]) - 2*ab));
end
