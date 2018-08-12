function pvpdisp(Props,Values,sep)
%PVPDISP Displays properties PROPS and their values VALUES 
%        in an HG-like format.

%       Author(s): A. Potvin, 3-29-95, P. Gahinet, 7-9-96
%       Copyright (c) 1986-96 by The MathWorks, Inc.
%       $Revision: 1.4 $  $Date: 1996/09/18 20:25:04 $

%       Copied from CONTROL TB by T. Pawletta, Feb. 1998


pad = blanks(8);
too_big_constant = 30+30*strcmp(sep(1),':');

for i=1:size(Props,1),
   val = Values{i};

   % Only display row vectors (string or double) or 1x1 cell thereof
   cellflag = 0;
   if isa(val,'cell') & isequal(size(val),[1 1]),
      val1 = val{1};
      if (isstr(val1) | isa(val1,'double')) & ndims(val1)==2 & size(val1,1)<=1,
         val = val1;
         cellflag = 1;
      end
   end

   if isstr(val) & ndims(val)==2 & size(val,1)<=1 & size(val,2)<too_big_constant,
      if strcmp(sep(1),':'),
         % SET display
         val_str = val;
      else
         % GET display
         val_str = ['''' val ''''];
      end
   elseif isa(val,'double') & ndims(val)==2 & ...
          (isempty(val) | (size(val,1)<=1 & size(val,2)<too_big_constant)),
      if isempty(val) & ~isequal(size(val),[0 0]),
         val_str = sprintf('[%dx%d double]',size(val,1),size(val,2));
      else
         val_str = mat2str(val,3);
      end
   elseif isa(val,'cell') & isempty(val),
      if isequal(size(val),[0 0]),
         val_str = '{}';
      else
         val_str = sprintf('{%dx%d cell}',size(val,1),size(val,2));
      end
   else
      % Too big to be displayed
      val_str = mat2str(size(val));
      val_str = [strrep(val_str(2:end-1),' ','x') ' ' class(val)];
      if isa(val,'cell'),
         val_str = ['{' val_str '}'];
      else
         val_str = ['[' val_str ']'];
      end
   end

   if cellflag,  val_str = ['{' val_str '}'];  end
   disp([pad , Props{i} , sep , val_str]);
end
disp(' ')

% end pvpdisp.m
