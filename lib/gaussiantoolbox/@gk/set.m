function [Out, retFlag ] = set(obj,varargin)
%Type Independent SET  Set values of object properties.
%
%   SET(OBJ,'Property',VALUE)  sets the property of OBJ specified
%   by the string 'Property' to the value VALUE.
%
%   SET(OBJ,'Property1',Value1,'Property2',Value2,...)  sets multiple 
%   object property values with a single statement.
%
%   SET(OBJ,'Property')  displays possible value types for the 
%   specified property of OBJ.
%   ATTENTION: Necessary global method PMATCH is not full adopt!
%
%   SET(OBJ)  displays all properties of OBJ and their admissible 
%   value types.
%
%   The method name is adopted from the access methods in Control TB,
%   but the function works very different to "control/@lti/pvpget".

%   T. Pawletta, March 1998



   % Check input/output arguments

ni = nargin;
no = nargout;


   % ----- Call:  OUT=SET(OBJ) or SET(OBJ) ----- 
   % Return OBJ's Properties and set nothing 

if ni==1,                   
   % Get OBJ properties and admissible value types
   [Props,PValues] = pvpget(obj);
   if no,
     Out = cell2struct(PValues,Props,1);
   else
     pvpdisp(Props,PValues,':  ');
   end
   return


   % --- Call: OUT=SET(OBJ,'PROPERTY') or without OUT ---
   % Return value type of Property and set nothing 
   % ATTENTION: Necessary global method PMATCH is not full adopt!

elseif ni==2,               
   % Get OBJ properties and admissible value types
   [Props,PValues] = pvpget(obj);
   str = varargin{1};
   if ~isstr(str),
      error('Property names must be single-line strings'),
   end
   % Return admissible property value(s)
   [ind,stat] = pmatch(Props,str);
   error(stat);
   if no,
      Out = PValues{ind};
   else
      disp(PValues{ind});
   end
   return
end


   % --- Call: SET(OBJ,'PROPERTY',VALUE,'PROPERTY',VALUE,...) ---
   % We set(obj,P1,V1,...), i.e. each Property-Value pair in turn

Props = obj.props;                      % properties of this class
m     = length(Props);

for i = 1:2:ni-1,                       % for each requested property  
   Property = varargin{i};
   Value    = varargin{i+1};
   retFlag  = [];                         % for recursion control 

   for j = 1:m,                           % for each property of this class
      if strcmp(Property,Props{j}),  
         eval(['obj.',Props{j},'=Value;']);       % obj."property" = Value;
         retFlag = 1;                             % It's O.K.
         break,
      end 
   end % inner_for
                                           % Send set msg. to parent class obj.
   if isempty(retFlag) & ~isempty(obj.parClassName),
      p_obj   = eval(['obj.',obj.parClassName]);    % Get obj of parent class
      retFlag = feval('set',p_obj,Property,Value);  % Send set to parent
         % obj."obj.parClassName"=p_obj;
      eval(['obj.',obj.parClassName,'= p_obj;']);   % UPDATE PARENT PART OF OBJ
   end
                                           % Error check
   if isempty(retFlag),
      error(['Invalid object property "',Property,'".']),
   end
end % outer_for

if no,
    Out = obj;
else
    % --- Finally, assign obj in caller's workspace ---
  if ~isempty( inputname(1) )
    assignin('caller',inputname(1),obj);
  end
end



% end set.m
