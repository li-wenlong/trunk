function varcoeff = fun_varcoeff( card )
% function varcoeff = fun_varcoeff( card )
% considers the computation of the variance measure of an iid cluster
% process and returns the variance coefficient c given the cardinality
% distribution in which case, the variance measure for any x is given by
% var(x) = D(x) + c*D(x)^2

if iscell( card )
    varcoeff = zeros(size(card));
    for i=1:length(card)
        varcoeff(i) = fun_varcoeff( card{i} );
    end
    return;
end
        
ns = [0:length(card)-1];
nsm1 =  ns - 1; nsm1(1) = 0;

mseq = ns(:).*card(:);

varcoeff = sum( mseq.*nsm1(:) )/ ( sum(mseq) )^2 -1;

