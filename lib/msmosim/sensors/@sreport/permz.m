function varargout = permz( these , varargin )


fprintf('Permuting measurements \n');
for i=1:length(these)
    srep = these(i);
    
    Zs =  srep.Z;
    given_ = srep.given;
    
    pseq = randperm( length(given_ ) );
    
    Zs = Zs( pseq );
    given_ = given_( pseq );
    
    srep.Z = Zs;
    srep.given = given_;
    
    these(i) = srep;
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
