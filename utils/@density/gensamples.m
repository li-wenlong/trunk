function varargout = gensamples( these, varargin )

isGMM = 1;
isKDE = 0;
isnumsamples = 0;

for cnt=1:length(varargin)
    if ischar( varargin{cnt})
        if strcmp( lower( varargin{cnt} ), 'gmm' )
           isGMM = 1;
           isKDE = 0;
        elseif strcmp( lower( varargin{cnt} ), 'kde' )
            isKDE = 1;
            isGMM = 0;
        else
            warning(sprintf('Unidentified token: %s !', varargin{cnt}));
        end
    elseif isnumeric( varargin{cnt} )
        numSamplesIn = varargin{cnt}(1);
        isnumsamples = 1;
    else
        error('Wrong input string');
    end
end

for i=1:length(these)
    if isnumsamples
        numsamples = numSamplesIn;
    elseif ~isempty(these(i).particles)
        numsamples = length( these(i).particles );
    else
        numsamples = 1000;
    end
    if isGMM
        [p1, c1] = gensamples( these(i).gmm, numsamples );
    elseif isKDE
        c1 = gencompindx( these(i).gmm, numsamples );
        d = these(i).gmm.getdims;
        p1 = zeros( d, numsamples );
        
        clusternames = unique(c1,'legacy');
        for cind = 1:length(clusternames)
            ind_ = find( c1 == clusternames( cind ) );
            Nc = length(ind_);
            % Find the transform
            R = chol( these(i).gmm.pdfs(cind).C );
            w1 = getPoints( resample( kdes(cind), Nc ) );
            p1(:, ind_ ) = R*w1 + repmat( these(i).gmm.pdfs(cind).m,1,Nc );
        end
    end
    these(i).particles = particle( 'state', p1, 'label', c1 );
end

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),these);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = these;
end