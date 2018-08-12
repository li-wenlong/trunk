function [ kdes, varargout] = par2kdes(these, varargin )

kernelType = 'Gauss';
bwselection = 'rot';

for cnt=1:2:length(varargin)
    if ischar( varargin{cnt})&& cnt +1 <= length(varargin )
        if strcmp( lower( varargin{cnt} ), 'kerneltype' )
            kernelType = varargin{cnt+1};  
        elseif strcmp( lower( varargin{cnt} ), 'bwselection' )
            bwselection =  varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'gmm' )
            g_ =  varargin{cnt+1};
        else
            warning(sprintf('Unidentified token: %s !', varargin{cnt}));
        end
    else
        error('Wrong input string');
    end
end


c1 = these.getlastlabel;
p1 = these.catstates;
w1 = these.catweights;
if ~exist('g_')
g_ = these.par2gmm;
end

complabels = unique(c1,'legacy');
numcomps = length( complabels );

for i = 1:numcomps
    ind_ = find( c1 == complabels( i ) );
    
    pc = p1(:,ind_);
    [d Nc] = size(pc);
    wc = reshape( w1(ind_), 1, Nc );
    
    % Get the covariance matrix
    C_p = g_.pdfs(i).C;
    % Get the mean
    m_ = g_.pdfs(i).m;
    % Find the inverse covariance
    R = chol(C_p);
    Rinv = R^(-1);
    Lambda_p = Rinv*Rinv';
    Wp = sqrtm(Lambda_p);% The whitening trasform
    % Construct the kde objects
   % kdes(i) = kde( Wp*(pc - repmat(m_ ,1, Nc ) ), bwselection, wc,kernelType  ); % Weights are scaled at constructor
     kdes(i) = kde( Wp*(pc ), bwselection, wc,kernelType  ); % Weights are scaled at constructor
end

if nargout >= 2
    varargout{1} = g_;
end


