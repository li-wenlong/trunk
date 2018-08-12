 function varargout = subweights( inpars, weights )
 
 if ~isnumeric(weights)
     error('The weights should be a numeric array!');
 end
 
 for j=1:length(inpars)
     if ~isempty( inpars(j).weights )
         if length( weights ) ~= length( inpars(j).weights )
             error('The weight array should be either of length of the particle array or of 1!');
         else
             inpars(j).weights = weights(:)/sum(weights);
         end
     else
         if ~isempty( inpars(j).states )
             if size( inpars(j).states, 2 ) ~= 0 && length(weights) ~= 1 && length( weights )~= size( inpars(j).states, 2 )
                 
                 error('The lenght of the weight array and that of the state vectors are different!');
                 
             end 
             sum_ws = sum(weights);
             if sum_ws < eps
                 % handle all zero inputs
                 warning(sprintf('Effective sample size is %g, adding small increments to the weights', 0))
                 ws = 1/size( inpars(j).states , 2 );
             else
                 ws =  weights(:)/sum_ws;
                 N_eff = 1/sum(ws.^2);
                 if N_eff <  size( inpars(j).states , 1 )
                     warning(sprintf('Effective sample size is %g, adding small increments to the weights prop to distance matrix', N_eff))                              
                     ws = reweightdeff( ws, inpars(j).states );
                     N_eff = 1/sum(ws.^2);
                     disp(sprintf('New effective sample size is %g', N_eff ));
                 end
             end
             inpars(j).weights( 1: size( inpars(j).states , 2),1 ) = ws/sum(ws);
         else
             ws =  weights(:)/sum(weights);
             N_eff = 1/sum(ws.^2);
             if N_eff <  size( inpars.weights , 1 )
                 warning(sprintf('Effective sample size is %g, adding small increments to the weights (no states to find a distance matrix)', N_eff))
                 
                 
                 ws = ws + min( 0.001, 1/length(ws) );
             end
             inpars(j).weights = ws/sum(ws);
         end
     end
     
 end
 
 
if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),inpars);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = inpars;
end
