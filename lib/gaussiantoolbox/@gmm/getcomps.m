function [ms, Ps, ws ] = getcomps( this )

for i=1:length( this.pdfs )
    ms(:,i) = get( this.pdfs(i),'m');
    Ps(:,:,i) = get( this.pdfs(i),'C');
    ws(i) = this.w(i);
end
ws = ws(:);   