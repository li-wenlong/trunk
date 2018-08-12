function varargout = prune(these )
outindx = [];
if ~isempty(these)
    
    c1 = these.getlastlabel;
    p1 = these.catstates;
    w1 = these.catweights;
    
    clusternames = unique( c1,'legacy' );
    
    for cind=1:length(clusternames)
        if  clusternames( cind ) == 0
            % Discard if the clustername is 0
            continue;
        end
        
        ind_ = find( c1 == clusternames( cind ) );
        pc = p1(:,ind_);
        [d Nc] = size(pc);
        wc = reshape( w1(ind_), 1, Nc );
        
        C_p = wcov( pc, wc );
        
        %C_p = cov(pc');
        if rank( C_p ) < d
            % If the cluster weight is not small, regularise
            if sum(wc)/sum(w1) > 0.5/length(clusternames)
                these(ind_) = these(ind_).regularise;
                warning(sprintf('Regularising deprived cluster!!!'));      
            else
                 % Discard if the cluster is degenerate
                 continue;
            end
        end
        outindx = [ outindx; ind_ ];
    end
end




if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1), these(outindx) );
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = these(outindx);
end
