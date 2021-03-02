function dx = derivative(x,N,dim) 
% DERIVATIVE also available as stand-alone function. 
% Visit my author page: 
% http://www.mathworks.com/matlabcentral/fileexchange/authors/110216

%set DIM
if nargin<3  
   if size(x,1)==1 %if row vector        
       dim = 2;
   else
       dim = 1; %default to computing along the columns, unless input is a row vector
   end
else           
    if ~isscalar(dim) || ~ismember(dim,[1 2])    
        error('dim must be 1 or 2!')
    end
end

%set N
if nargin<2 || isempty(N) %allows for letting N = [] as placeholder
    N = 1; %default to first derivative    
else        
    if ~isscalar(N) || N~=round(N)
        error('N must be a scalar integer!')
    end
end

if size(x,dim)<=1 && N
    error('X cannot be singleton along dimension DIM')
elseif N>=size(x,dim)
    warning('Computing derivative of order longer than or equal to size(x,dim). Results may not be valid...')
end

dx = x; %'Zeroth' derivative
for n = 1:N % Apply iteratively

    dif = diff(dx,1,dim);

    if dim==1
        first = [dif(1,:) ; dif];
        last = [dif; dif(end,:)];
    elseif dim==2;
        first = [dif(:,1) dif];
        last = [dif dif(:,end)];
    end
    
    dx = (first+last)/2;
end