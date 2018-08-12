function [Xh, varargout] = mosest( this, varargin )
% MOSESTODC is the method for Multi-object state estimate based on observation driven clustering.


Xh = [];
Cs = {};

if ~isempty( this.post)
  for i=1:length( this.post )
      Xh(:,i) = this.post(i).m(:);
      Cs{i} = this.post(i).C;
   end
end

if nargout >= 2
    varargout{1} = Cs;
end


