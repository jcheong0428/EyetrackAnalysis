function y = sem(x,dim)

if nargin==1, 
  % Determine which dimension SUM will use
  dim = find(size(x)~=1, 1 );
  if isempty(dim), dim = 1; end

y = std(x) ./ sqrt(size(x,dim));
else
    y = std(x,0,dim) ./ sqrt(size(x,dim));

end