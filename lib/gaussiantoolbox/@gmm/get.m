function [propValue,retFlag] = get(obj,Property)
%Type Independent GET   Access/query object property values. But 
%   the function can only return such properties, that are defined 
%   in the object member cell array OBJ.PROPS.
%   The function is "optimized" for single property access.
%
%   PROPVALUE = GET(OBJ,'Property')  returns the value of the 
%   specified property of object OBJ.
%   
%   PROPVALUE = GET(OBJ,{'Property1',...,'PropertyN')  returns the 
%   values of the specified properties of object OBJ in a cell array.
%   
%   STRUCT = GET(OBJ)  converts the  object OBJ into 
%   a structure STRUCT with the property names as field names and
%   the property values as field values.
%
%   Without left-hand argument,  GET(OBJ)  displays all properties 
%   of OBJ and their values.
%
%   Output argument RETFLAG is only used by the internal recursive
%   call of the GET function in context with derived class objects.
%
%   The method name is adopted from the access methods in Control TB,
%   but the function works very different to "control/@lti/pvpget".

%   T. Pawletta, March 1998
% -  Bug fixed for single property: pvpdisp() was called with the argument
% propValue which is not a cell if the object has only one property. Now we
% check it withan iscell( propValue ) and call pvpdisp() accordingly.
% Murat Uney, Sept 2008


   % Check input/output arguments

ni = nargin;
no = nargout;
error(nargchk(1,2,ni));
if ni == 0,
   error('Too few input arguments.');
elseif ni == 2 & ~ischar(Property) & ~iscellstr(Property),
   error('Input PROPERTY must be a string.');
end


   % All object properties are requested ?

if ni == 1,                         
   Property = pvpget(obj);        % Bottom up recursive PVPGET 
end


   % Bottom up recursive get values of requested properties 

Property  = cellstr(Property);        % single properties are of type char
n         = length(Property); 
Props     = obj.props;                % properties of this class
m         = length(Props);                   
propValue = {};

for i = 1:n,                          % for each requested property
   tmpValue = [];
   retFlag   = [];                       % for recursion control

   for j = 1:m,                          % for each property of this class 
      if strcmp(Property{i},Props{j}),
         tmpValue = eval(['obj.',Props{j}]);      % Get property value
         retFlag  = 1;                            % It's all O.K.
         break,
      end
   end % inner_for
                                         % Send get msg. to parent class obj.
   if isempty(retFlag) & ~isempty(obj.parClassName),
      p_obj = eval(['obj.',obj.parClassName]); % Get obj of parent class 
      [tmpValue,retFlag] = feval('get',p_obj,Property{i});  % Send get to parent
   end
                                         % Error check
   if isempty(retFlag),
      error(['Invalid object property "',Property{i},'".'])
   end
                                         % Collect all property values 
   if n == 1,                   
     propValue = tmpValue;                    % Single Property
   else 
     propValue = [propValue; {tmpValue}];         % List of Properties 
   end
end % outer_for


   % Only if all object properties are requested

if ni==1,
   if no,
     propValue = cell2struct(propValue,Property,1);
   else
       if ~iscell( propValue )
           pvpdisp(Property,{propValue},' = ');
           clear propValue
       else
           pvpdisp(Property,propValue,' = ');  
           clear propValue;
       end
   end
end


% end get.m 
