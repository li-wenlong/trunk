function [props,values] = pvpget(obj)
%Type Independent PVPGET   returns the list of properties of object OBJ 
%   and their admissible value types.
%
%   PROPS = PVPGET(OBJ)  returns the properties of object OBJ.
%
%   [PROPS,VALUES] = PVPGET(OBJ)  returns the properties of object OBJ
%   and the appropriate type values.
%
%   The method name is adopted from the access methods in Control TB,
%   but the function works very different to "control/@lti/pvpget".

%   T. Pawletta, Feb. 1998


   % Get public properties of this class and  
   % if needed their property value types

props = obj.props;
if nargout > 1,
  values = obj.values;
else
  values = {};
end


   % ONLY FOR DERIVED CLASS_OBJs: 
   % ----------------------------
   % Get public properties defined in parent classes
   % and if needed their property value types 

if ~isempty(obj.parClassName),
   if nargout > 1,
      [Pprops,Pvalues] = eval( ['pvpget(obj.',obj.parClassName,')'] );
   else
      Pvalues = {};
      Pprops = eval( ['pvpget(obj.',obj.parClassName,')'] );
   end   
   props = [props; Pprops]; 
   values = [values; Pvalues];
end


% end pvpget.m
