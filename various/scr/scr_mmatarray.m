

c = 17; % Number of matrices
a = 5; % num of rows
b = 3; % num of cols

d = 7; % num of cols of M

% Create an array of matrices
for i=1:c
    aa(:,:,i) = randn(a,b);
end

M = randn( b, d );

rm = rmmatarray( aa, M );

% Check the results
for j=1:c
    
    if sum( sum( ( rm(:,:,j) - aa(:,:,j)*M ).^2 )) > 1.0e-12
        error('Not working')
        
    end
end
disp('right matrix mult. rmmatarray is working fine!');

M2 = randn(d,a);
lm = lmmatarray( aa, M2 );
% Check the results
for j=1:c
    
    if sum( sum( ( lm(:,:,j) - M2*aa(:,:,j) ).^2 )) > 1.0e-12
        error('Not working')
        
    end
end
disp('left matrix mult. lmmatarray is working fine!');

