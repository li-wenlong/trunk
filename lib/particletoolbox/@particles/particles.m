classdef particles
    properties
        states
        weights
        blabels % Birth labels
        blmap   % Birth label map of states
        labels  % Cluster label field which is regardless of the blabels
        ispersistent
        histlen
        bws
        C % covariance matrices
        S % inverse covariance matrices
    end
    methods 
        % constructor
        function p = particles(varargin)
            areweightsin = 0;
            arestatesin = 0;
            arelabelsin = 0;
            arebwsin = 0;
            labels_ = 0;
            for cnt=1:2:length(varargin)
                if ischar( varargin{cnt})&& cnt +1 <= length(varargin )
                    if strcmp( lower( varargin{cnt} ), 'states' )
                        p = p.substates( varargin{cnt + 1} );
                        arestatesin = 1;

                    elseif strcmp( lower( varargin{cnt} ), 'weights' )
                        p.subweights( varargin{cnt + 1} );
                        areweightsin = 1;
                        
                    elseif strcmp( lower( varargin{cnt} ), 'labels' )
                        labels_ = varargin{cnt + 1};
                        arelabelsin = 1;
                     elseif strcmp( lower( varargin{cnt} ), 'bw' )
                        p.subbw( varargin{cnt + 1} );
                        arebwsin = 1;
                        % Need to add similar for C and S and modify them
                        % in accordance with the bws
                    else
                        warning(sprintf('Unidentified token: %s !', varargin{cnt}));
                    end
                else
                     if isempty( varargin{cnt} )
                        p = particles;
                        p = p([]);
                        return;
                     else
                    error('Wrong input string');
                    end
                end
            end
            if arestatesin == 1 && areweightsin == 0
                ws = ones(1, size( p.states ,2) )/size( p.states ,2);
                p.weights = ws(:);
            elseif arestatesin == 0 && areweightsin == 0
                p = p.substates( 0 );
                p = p.subweights(1);
            end
            p.sublabels( labels_ );
            p = p.allnb;
            p = p.inithist;
        end
        % eo particles()
        %%%%%%%%%%%%%%%%%%%
        % inithist()
        function particles = inithist(particles)
            for j=1:length( particles )
                particles(j).histlen = zeros( size(particles(j).states, 2), 1);
            end
            
            if nargout == 0
                if ~isempty( inputname(1) )
                    assignin('caller',inputname(1), particles);
                else
                    error('Could not overwrite the instance; make sure that the argument is not in an array!');
                end
            else
                varargout{1} = particles;
            end
        end
        % eo inithist
        %%%%%%%%%%%%%%%%%%%
              
        function ls = gethistlen(particles)
            ls = particles.histlen;
        end
        
        function bw = getbw(particles)
            bw = particles.bws;
        end
       
        function cs = getcovmat(particles)
            cs = particles.c;
        end
        
        function Ss = getinvcovmat(particles)
            Ss = particles.S;
        end
        %%%%%%%%%%%%%%%%%%%%%%%
        % addlabels
        function inpars = addlabels( inpars, labels )
            if length(labels)~=1 ||  length(labels)~=length( inpars.labels )
                error('Number of labels not 1 or less than the number of states!');
            end
   
            inpars.labels(1:end) = labels(:);
            inpars.histlen = inpars.histlen + 1;
            
            if nargout == 0
                if ~isempty( inputname(1) )
                    assignin('caller',inputname(1), inpars );
                else
                    error('Could not overwrite the instance; make sure that the argument is not in an array!');
                end
            else
                varargout{1} = inpars;
            end
        end
        % eo addlabels
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function c = mtimes(a,b)    
            if isa(a, 'particles') && isnumeric(b)
                if length(b)~=1
                   error('Vector multiplication is not defined. Try .* instead?'); 
                end
                c = a;
                for i=1:length(a)
                    c(i).weights = c(i).weights*b(:);
                end
                
            elseif isa(a, 'particles') && isa(b, 'particles')
               error('Not meaningful');
               
            elseif isa(b, 'particles') && isnumeric(a)
                c = b*a;
                return;
            end
        end % 
        function c = times(a, b)
            
            if abs( sum( size(a)-size(b)))~= 0
                error('In an expression a.*b, a and b should be of the same size.');
            end
            if isa( a, 'particles' )
                c = a;
            elseif isa( b, 'particles')
                c = b;
            end
            
            for i=1:length(a(:))
                c(i) = a(i)*b(i);
            end
        end % function c = times(a, b)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % replabel()
        function varargout = replabel( these, oldlabel, newlabel )
                   
           for i=1:length(these)
              indx = find( these( i ).labels == oldlabel );
              if ~isempty( indx )
                  these( i ).labels(indx) = newlabel;               
              end
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
        end % eo replabel( these, oldlabel, newlabel )
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
        
    end % MEthods
end
