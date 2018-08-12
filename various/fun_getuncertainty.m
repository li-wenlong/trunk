function [emaxa, emina] = fun_getuncertainty( infos, varargin )

isdims = 0;
nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
     if isa( lower(varargin{argnum}), 'char')
         switch lower(varargin{argnum})
            
             case {'dims'}
                 if argnum + 1 <= nvarargin
                     isdims = 1;
                     dims = varargin{argnum+1};
                     argnum = argnum + 1;
                 end
            
             otherwise
                 error('Wrong input string');
         end
     end
     argnum = argnum + 1;
end


nume = length(infos);% length of info structure

emaxa = zeros(1, nume );
emina = zeros(1, nume );


for j=1:nume
    Cs = infos{j}.Cs;
    
    
    emax = 0;
    emin = 1.0e+50;
    
    if ~isempty(Cs )
        
        for i=1:length( Cs )
            
            if isdims
                evals = eig( Cs{i}(dims,dims) );
            else
                evals = eig( Cs{i} );
            end
            emax = max( emax, max(evals) );
            emin = min( emin, min(evals) );
        end
    else
        emin = 0;
    end
    
    emaxa(j) = emax;
    emina(j) = emin;
end