function L=multiObjLikelihood(info,z,x, r1s, r2s, alphas, ls, sigmas )
    

numobs = size( z, 2 );
lambda_ = numobs;

for j=1:size(x,2)
    
    L(j) = 0;
    
    % Centers
    cs = z - repmat( x([1,2],j),1, numobs );
    alpha_ = alphas(j);
    r1_ = r1s(j);
    r2_ = r2s(j);
    l_ = ls(j)/2;
    
    [th, r] = cart2pol( cs(1,:), cs(2,:) );
    
    % Point on the ellipse 
    
    % Polar parametric form of an ellipse:
    r_ep = r1_*r2_./sqrt( (r2_*cos(th)).^2 + (r1_*sin(th)).^2 );
    
    % Add the alpha_ angle
    [x_ep, y_ep] = pol2cart( th + alpha_, r_ep );
    
    
    [the, re] = cart2pol( x_ep, y_ep );
    
    ind1 = find( re - l_<= r );
    ind2 = find( r<= re + l_ );
    inds = intersect( ind1, ind2 );
    
    n_ = length(inds);
    L(j) = poisspdf(n_, lambda_ );
  
  
    
%      inds = [1:length(re)];
%      if ~isempty( inds )
%          % Points on the torus
%          sigma_ = sigmas(j)*10;
%          n_ = length(inds);
%          
%          g_zGx = (1/( sqrt(2*pi*sigma_^2) ))*exp( -0.5*( re(inds) - r(inds) ).^2/sigma_^2 );
%          
%          L(j) = prod( [1:length(g_zGx)].* g_zGx )*poisspdf(n_, lambda_ )
%      end
    % if exist('fighandle')
    % cla;
    % else
    % fighandle = figure;
    % end
    %plotset( cs, 'axis', gca )
    %plotset( [x_ep;y_ep],'options','''Marker'',''x'',''Color'',[1 0 0]', 'axis', gca )
end
