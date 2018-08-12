function ss = sseq( stimes, t1, t2 )
% 

stimes = stimes(:);
t1 = t1(1);
t2 = t2(1);

swtable = [];
for i=1:length( stimes )-1
    swtable = [swtable; stimes(i), stimes(i+1)];
end
swtable = [ swtable; stimes(end),inf];

i1 = findind( swtable, t1 );
i2 = findind( swtable, t2 );

ss = [];
for j=1:i2-i1
    ss = [ ss, swtable(i1+j-1,2) ];
end
ss = [ss, t2];

function i = findind( S, t)

i = [];
for j=1:size(S,1)
    if S(j,1)<=t && t<S(j,2)
        i = j;
    end
end





        

