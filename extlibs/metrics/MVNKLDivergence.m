function MVN_KLD = MVNKLDivergence(X, CvX, Y, CvY)

persistent t_CvX;
persistent t_iCvX;
persistent t_CvY;
persistent t_iCvY;

if isempty(t_CvX) || isempty(t_iCvX) || ~isequal(t_CvX, CvX)
    t_CvX = CvX;
    t_iCvX = inv(t_CvX);
end

if isempty(t_CvY) || isempty(t_iCvY) || ~isequal(t_CvY, CvY)
    t_CvY = CvY;
    t_iCvY = inv(t_CvY);
end


MVN_KLD = LocalKLD(X, Y, t_CvX, t_CvY, t_iCvX, t_iCvY) + ...
    LocalKLD(Y, X, t_CvY, t_CvX, t_iCvY, t_iCvX);


function KLD = LocalKLD(P, Q, CvP, CvQ, iCvP, iCvQ)

KLD = 0.5*(... 
    (P-Q)'*iCvQ*(P-Q) + ...
    log(det(CvQ)) - log(det(CvP)) + ...
    trace(CvP*iCvQ) + ...
    -size(iCvP, 1));

if isnan(KLD)
    KLD = inf;
end
