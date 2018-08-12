function varargout = resample( these, varargin )

isGMM = 1;
isKDE = 0;

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
    else
        error('Wrong input string');
    end
end
         

for i=1:length(these)
    % For each density instance
    [p1,w1,c1] = these(i).particles.par2pwc;
    clusternames = unique( c1,'legacy' );
    
    for cind = 1:length(clusternames)
        ind_ = find( c1 == clusternames( cind ) );
        [d Nc] = size( p1(:, ind_) );
        % For each cluster
        if isGMM   
            p1(:, ind_ ) = gensamples( these(i).gmm.pdfs(cind), Nc );
        elseif isKDE 
            % Find the transform
            R = chol( these(i).gmm.pdfs(cind).C );
            w1 = getPoints( resample( these(i).kdes(cind), Nc ) );
            p1(:, ind_ ) = R'*w1 + repmat( these(i).gmm.pdfs(cind).m,1,Nc );
        end
    end
    these(i).particles = these(i).particles.substates( p1 );
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