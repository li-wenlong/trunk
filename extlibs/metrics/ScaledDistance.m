function [dist varargout]= ScaledDistance(X, CvX, Y, CvY, CutOff, Power, Epsilon)

%B. Vo.  26/08/2007
%Compute Schumacher distance between two finite sets X and Y
%Inputs: X,Y-   matrices of column vectors
%        c  -   cut-off parameter
%        p  -   p-parameter for the metric
%Output: scalar distance between X and Y
%Note: the Euclidean 2-norm is used as the "base" distance on the region
%
% Usage:
%   [n1, n2, n3]=new_dist(hat_X, X, 100, 1);
% 
%   TotalError - combined distance
%   LocalisationError - localisation
%   CardinalityError - cardinality
% 
%   with arguments:
%   hat_X - set of estimates
%   X - set of true positions
% 
%   100 - a 'cut off' to specify a maximum localisation error
%   1 =p - in L_p

if nargout ~=1 && nargout ~=3
  error('Incorrect number of outputs');
end

if isempty(X) && isempty(Y)
   dist = 0;

   if nargout == 3
       varargout(1)= {0};
       varargout(2)= {0};
   end

   return;
end

if isempty(X) || isempty(Y)
   dist = CutOff;

   if nargout == 3
       varargout(1)= {0};
       varargout(2)= {CutOff};
   end

   return;
end


%Calculate sizes of the input point patterns
NumX = size(X,2);
NumY = size(Y,2);

%Calculate cost/weight matrix for pairings - fast method with vectorization
% XX= repmat(X,[1 NumY]);
% YY= reshape(repmat(Y,[NumX 1]),[size(Y,1) NumX*NumY]);
% DistanceMatrix = reshape(sqrt(sum((XX-YY).^2)),[NumX NumY]);
% DistanceMatrix = min(CutOff, DistanceMatrix).^Power;
DistanceMatrix = ... 
    CalculateDistanceMatrix(X, CvX, Y, CvY, CutOff, Power, Epsilon);


% %Calculate cost/weight matrix for pairings - slow method with for loop
% D= zeros(NumX,m);
% for j=1:m
%     D(:,j)= sqrt(sum( ( repmat(Y(:,j),[1 NumX])- X ).^2 )');
% end
% D= min(c,D).^p;

%Compute optimal assignment and cost using the Hungarian algorithm
[~,cost]= Hungarian(DistanceMatrix);

%Calculate final distance
dist= ( 1/max(NumY,NumX)*( CutOff^Power*abs(NumY-NumX)+ cost ) ) ^(1/Power);

%Output components if called for in varargout
if nargout == 3
   varargout(1)= {(1/max(NumY,NumX)*cost)^(1/Power)};
   varargout(2)= {(1/max(NumY,NumX)*CutOff^Power*abs(NumY-NumX))^(1/Power)};
end
   

function DistanceMatrix = ... 
    CalculateDistanceMatrix(X, CvX, Y, CvY, CutOff, Power, Epsilon)

% E matrix
if isscalar(Epsilon)
    Epsilon = Epsilon*eye(size(X, 1));
end

%Calculate sizes of the input point patterns
NumX = size(X,2);
NumY = size(Y,2);

if isempty(CvX)
    CvX = zeros(size(X, 1));
end

if isempty(CvY)
    CvY = zeros(size(Y, 1));
end

if isequal(1, size(CvX, 3))
    CvX = repmat(CvX, [1, 1, NumX]);
end

if isequal(1, size(CvY, 3))
    CvX = repmat(CvX, [1, 1, NumY]);
end

%Calculate cost/weight matrix for pairings - fast method with vectorization
[XX, YY] = LocalGeneratePairs(X, Y, 2);
[CvXX, CvYY] = LocalGeneratePairs(CvX, CvY, 3);

CvInv = zeros(size(CvXX));
SumCv = CvXX + CvYY + repmat(2*Epsilon, [1, 1, NumX*NumY]);
ProdCv = multiprod(CvXX + repmat(Epsilon, [1 1 NumX*NumY]), ...
    CvYY + repmat(Epsilon, [1 1 NumX*NumY]), [1 2]);
DetRatio = zeros(1, 1, NumX*NumY);
for count = 1:NumX*NumY
    CvInv(:,:,count) = inv(SumCv(:,:,count));
    DetRatio(count) = ((det(ProdCv(:,:,count))^0.5)/ ... 
        (det(0.5*SumCv(:,:,count))))^0.5;
end

Difference = permute(XX - YY, [1 3 2]);
DistanceMatrix = 1 - DetRatio.*exp(-1/4*multiprod( ... 
    multiprod(multitransp(Difference, 1), CvInv, [1 2]), Difference, ... 
    [1, 2]));
DistanceMatrix = reshape(DistanceMatrix, NumY, NumX);

function [PairsList1, PairsList2] = ... 
    LocalGeneratePairs(List1, List2, NumDims)

if ~exist('NumDims', 'var') || isempty(NumDims)
    NumDims = max(ndims(List1), ndims(List2));
end

switch NumDims
    case 2
        [Dim1, List1Length] = size(List1);
        [Dim2, List2Length] = size(List2);
        
        % Repeat List1, List2Length number of times
        PairsList1 = reshape(repmat(List1, [List2Length, 1]), Dim1, ... 
            List2Length*List1Length);
        
        % Repeat List2, List1Length number of times
        PairsList2 = repmat(List2, [1, List1Length]);
        
        
    case 3
        [Dim1, ~, List1Length] = size(List1);
        [Dim2, ~, List2Length] = size(List2);
        
        if List1Length~=1
        % Repeat each in List1 List2Length number of times
        PairsList1 = cell2mat(reshape(repmat(mat2cell(List1, Dim1, Dim1, ... 
            ones(List1Length, 1)), [1, List2Length]), ... 
            [1, 1, List1Length*List2Length]));
        else
        PairsList1 = cell2mat(reshape(repmat(mat2cell(List1, Dim1, Dim1),...
            [1, List2Length]), ... 
            [1, 1, List1Length*List2Length]));
            
        end
        % Repeat all List2 List1Length number of times
        PairsList2 = repmat(List2, [1, 1, List1Length]);
        
end
