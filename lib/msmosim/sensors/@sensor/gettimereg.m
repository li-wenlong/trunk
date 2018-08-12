function [this, that, varargout] = gettimereg( this, that )


buff1 = this.srbuffer;
buff2 = that.srbuffer;
bufflen1 = length( buff1 );
bufflen2 = length( buff2 );
[minbufflen, minbind] = min( [bufflen1,bufflen2]  );

tarray1 = [];
for i=1:length(buff1)
    tarray1 = [tarray1; buff1(i).time ];
end

% check if the data is time sorted
if sum( abs ( tarray1 - sort( tarray1, 'ascend' ) ) ) ~= 0
    error('Sensor buffer of the first object is not in time increasing order!');
end


tarray2 = [];
for i=1:length(buff2)
    tarray2 = [tarray2; buff2(i).time ];
end

% check if the data is time sorted
if sum( abs ( tarray2 - sort( tarray2, 'ascend' ) ) ) ~= 0
    error('Sensor buffer of the second object is not in time increasing order!');
end
% find the distance matrix between tarray1 and tarray2
darray = zeros(bufflen1, bufflen2 );
for i=1:bufflen1
    darray(i,:) = abs( tarray2 - tarray1(i) );
end

[ind1, ind2]  = getassocs(darray );

% figure;plot(tarray1(ind1),zeros(size(tarray1(ind1))),'x')
% hold on
% plot(tarray2(ind2),zeros(size(tarray2(ind2))),'+r')


this.srbuffer = buff1( ind1 ); 
that.srbuffer = buff2( ind2 );

if nargout>= 3
    varargout{1} = ind1;
end
if nargout>=4
    varargout{2} = ind2;
end

end

function [ind1, ind2] = getassocs( darray )

ind1 = [];
ind2 = [];

[minvals, assoc1] = min( darray );
[minvals, assoc2] = min( darray' );

for i=1:size(darray,1)
        % i th element of the first array (row)
        % j the element of the second array (col)
        [ minval , jmin ] = min(darray(i,:)); % i<->jmin
        % Is i the best with jmin?
        [minval, imin ] = min(darray(:,jmin));
        if imin == i
           ind1 = [ind1;i];
           ind2 = [ind2;jmin];
        end
end

% 
% tarray = [1:tarraylen]; % target array in that assocs contains a mapping onto this one
% passoc = [];
% for i=1:tarraylen
%     passoc = [passoc, max( find(assocs==tarray(i) ) )];
% end
% passoc = passoc';

% preval = assocs(1);
% for k=2:length(assocs)
%     crrntval = assocs(k);
%     if crrntval == preval
%         if k < length(assocs)
%             continue;
%         end
%     end
%     passoc = [passoc, preval ];
%     preval = crrntval;
% end



end