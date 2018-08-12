function [y, varargout] = evaluate( gmm, x )

if nargout==1
    y = zeros(1, size(x,2));
    for i=1:length(gmm.pdfs)
        y = y + gmm.w(i)*evaluate( gmm.pdfs(i), x );
    end
else
    y2 = zeros(length(gmm.pdfs) ,size(x,2));
    for i=1:length(gmm.pdfs)
        y2(i,:) = gmm.w(i)*evaluate( gmm.pdfs(i), x );
    end
    varargout{1} = y2;
    y = sum(y2,1);
end