function is = randint( w, varargin )

numsamples = 1;
if nargin>=2
    numsamples = varargin{1}(1);
end
w = w/sum(w);
cpmf = 0;

for i=1:length(w)
    cpmf(end+1) = sum(w(1:i));
end

indset = [1:length(w)];

rs = rand(numsamples,1);
is = ones(size(rs));
for i=1:length(w)
    ind = find( cpmf(i)<= rs & rs < cpmf(i+1)  );
    is(ind) = i;
end