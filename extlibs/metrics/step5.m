


%**************************************************************************
% STEP 5: Construct a series of alternating primed and starred zeros as
%         follows.  Let Z0 represent the uncovered primed zero found in Step 4.
%         Let Z1 denote the starred zero in the column of Z0 (if any).
%         Let Z2 denote the primed zero in the row of Z1 (there will always
%         be one).  Continue until the series terminates at a primed zero
%         that has no starred zero in its column.  Unstar each starred
%         zero of the series, star each primed zero of the series, erase
%         all primes and uncover every line in the matrix.  Return to Step 3.
%**************************************************************************

function [M,r_cov,c_cov,stepnum] = step5(M,Z_r,Z_c,r_cov,c_cov)

 zflag = 1;
 ii = 1;
 while zflag
   % Find the index number of the starred zero in the column
   rindex = find(M(:,Z_c(ii))==1);
   if rindex > 0
     % Save the starred zero
     ii = ii+1;
     % Save the row of the starred zero
     Z_r(ii,1) = rindex;
     % The column of the starred zero is the same as the column of the
     % primed zero
     Z_c(ii,1) = Z_c(ii-1);
   else
     zflag = 0;
   end

   % Continue if there is a starred zero in the column of the primed zero
   if zflag == 1;
     % Find the column of the primed zero in the last starred zeros row
     cindex = find(M(Z_r(ii),:)==2);
     ii = ii+1;
     Z_r(ii,1) = Z_r(ii-1);
     Z_c(ii,1) = cindex;
   end
 end

 % UNSTAR all the starred zeros in the path and STAR all primed zeros
 for ii = 1:length(Z_r)
   if M(Z_r(ii),Z_c(ii)) == 1
     M(Z_r(ii),Z_c(ii)) = 0;
   else
     M(Z_r(ii),Z_c(ii)) = 1;
   end
 end

 % Clear the covers
 r_cov = r_cov.*0;
 c_cov = c_cov.*0;

 % Remove all the primes
 M(M==2) = 0;

stepnum = 3;

% *************************************************************************
% STEP 6: Add the minimum uncovered value to every element of each covered
%         row, and subtract it from every element of each uncovered column.
%         Return to Step 4 without altering any stars, primes, or covered lines.
%**************************************************************************

function [P_cond,stepnum] = step6(P_cond,r_cov,c_cov)
a = find(r_cov == 0);
b = find(c_cov == 0);
minval = min(min(P_cond(a,b)));

P_cond(find(r_cov == 1),:) = P_cond(find(r_cov == 1),:) + minval;
P_cond(:,find(c_cov == 0)) = P_cond(:,find(c_cov == 0)) - minval;

stepnum = 4;

function cnum = min_line_cover(Edge)

 % Step 2
   [r_cov,c_cov,M,stepnum] = step2(Edge);
 % Step 3
   [c_cov,stepnum] = step3(M,length(Edge));
 % Step 4
   [M,r_cov,c_cov,Z_r,Z_c,stepnum] = step4(Edge,r_cov,c_cov,M);
 % Calculate the deficiency
   cnum = length(Edge)-sum(r_cov)-sum(c_cov);
function [dist varargout]= new_dist(X,Y,c,p)

%B. Vo.  26/08/2007
%Compute Schumacher distance between two finite sets X and Y
%Inputs: X,Y-   matrices of column vectors
%        c  -   cut-off parameter
%        p  -   p-parameter for the metric
%Output: scalar distance between X and Y
%Note: the Euclidean 2-norm is used as the "base" distance on the region

if nargout ~=1 & nargout ~=3
  error('Incorrect number of outputs');
end

if isempty(X) & isempty(Y)
   dist = 0;

   if nargout == 3
       varargout(1)= {0};
       varargout(2)= {0};
   end

   return;
end

if isempty(X) | isempty(Y)
   dist = c;

   if nargout == 3
       varargout(1)= {0};
       varargout(2)= {c};
   end

   return;
end


%Calculate sizes of the input point patterns
n = size(X,2);
m = size(Y,2);

%Calculate cost/weight matrix for pairings - fast method with vectorization
XX= repmat(X,[1 m]);
YY= reshape(repmat(Y,[n 1]),[size(Y,1) n*m]);
D = reshape(sqrt(sum((XX-YY).^2)),[n m]);
D = min(c,D).^p;

% %Calculate cost/weight matrix for pairings - slow method with for loop
% D= zeros(n,m);
% for j=1:m
%     D(:,j)= sqrt(sum( ( repmat(Y(:,j),[1 n])- X ).^2 )');
% end
% D= min(c,D).^p;

%Compute optimal assignment and cost using the Hungarian algorithm
[assignment,cost]= Hungarian(D);

%Calculate final distance
dist= ( 1/max(m,n)*( c^p*abs(m-n)+ cost ) ) ^(1/p);

%Output components if called for in varargout
if nargout == 3
   varargout(1)= {(1/max(m,n)*cost)^(1/p)};
   varargout(2)= {(1/max(m,n)*c^p*abs(m-n))^(1/p)};
end
   