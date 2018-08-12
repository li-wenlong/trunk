function [ pix] = findpixels ( this, bearings, ranges )
% This function finds the pixel numbers (row, col) cooresponding to the
% given points in the polar coordinate system

N = length( bearings );
pix = zeros(N,2);

% for i=1:N
%     bearing = bearings(i);
%     range = ranges(i);
%     [dummy, pix_col] = min( abs(this.colcentres - bearing) );
%     [dummy, pix_row] = min( abs(this.rowcentres - range) );
%     pix(i,:) = [pix_row, pix_col];
% end

bearings = bearings(:);
ranges = ranges(:);

colcentres = this.colcentres(:);
rowcentres = this.rowcentres(:);

blocksize = 50000;
elsleft = N;
pix = [];
while( elsleft ~= 0)
    numels = min( blocksize, elsleft );
    [dummy, pix_col] = min( abs( repmat( colcentres,[1,numels]) - repmat( bearings(end-elsleft+1:end-elsleft+numels)', [this.numcols,1]) ) );
    [dummy, pix_row] = min( abs( repmat( rowcentres,[1,numels]) - repmat( ranges(end-elsleft+1:end-elsleft+numels)', [this.numrows,1]) ) );
    pix = [ pix; [pix_row(:),pix_col(:)] ];
    elsleft = elsleft - numels;
end