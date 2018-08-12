function [p1,w1,c1] = par2pwc(this, varargin )

c1 = this.getlastlabel;
p1 = this.catstates;
w1 = this.catweights;

willresample = 0;
isGauss = 0;


for cnt=1:2:length(varargin)
    if ischar( varargin{cnt})&& cnt +1 <= length(varargin )
        if strcmp( lower( varargin{cnt} ), 'resample' )
            willresample = varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'gauss' )
            isGauss =  varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'options' )
            opts  = varargin{cnt+1};
        else
            warning(sprintf('Unidentified token: %s !', varargin{cnt}));
        end
    else
        error('Wrong input string');
    end
end


if willresample
    % Resample after estimating the distribution represented by the
    % particles
    clusternames = unique( c1,'legacy' );

    % Find the Gauss representations of the clusters based on the first two
    % moments and
    % Generate particles from these Gaussians
    for cind=1:length(clusternames)
        ind_ = find( c1 == clusternames( cind ) );
        
        if isGauss
            cluster_ = particle( 'state', p1(:, ind_ ) );
            cluster_ = cluster_.subweights( w1( ind_ ) );
            cluster_ = cluster_.sublabels( clusternames( cind )  );
            cgmm = cluster_.par2gmm;
            p1(:, ind_ ) = gensamples( cgmm, length( ind_ ) );
            
        else
            % The default repr. is KDE
            pc = p1(:,ind_);
            [d Nc] = size(pc);
            wc = reshape( w1(ind_), 1, Nc );
            % Find the whitening transform
            C_p = cov(pc');
            % Find the inverse covariance
            R = chol(C_p);
            Rinv = R^(-1); 
            Lambda_p = Rinv*Rinv';
            Wp = sqrtm(Lambda_p);% The whitening trasform
            % Construct the kde objects
            opt = kde( Wp*pc, 'rot', wc, 'g' ); % Weights are scaled at constructor
            pcres =  getPoints( resample( opt, Nc ) );
            p1(:,ind_) = sqrtm(C_p)*pcres;      
        end
        % These particles are equal weighted
        w1( ind_ ) = sum( w1(ind_) )/length( ind_ );
    end
end