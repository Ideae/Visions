alpha = 2;
beta = 3;
gamma = 5;
width = 10;
height = 50;
ground_truth = zeros(height,width);
for i = 1:height
   for j = 1:width
       ground_truth(i,j) = alpha*j + beta*i + gamma;
   end
end
noise_plane = ground_truth + randn(height,width);
A = ones(width*height, 3);
b = zeros(width*height,1);
for i = 1:height
   for j = 1:width
       index = width*(i-1) + j;
       A(index,1) = j;
       A(index,2) = i;
       b(index) = noise_plane(i,j);
   end
end

% x_estimate = inv(A'*A)*A'*b
x_estimate = A\b;
% ground_truth
% noise_plane
fprintf('Alpha abs error: %f\n', abs(alpha - x_estimate(1)));
fprintf('Beta abs error: %f\n', abs(beta - x_estimate(2)));
fprintf('Gamma abs error: %f\n', abs(gamma - x_estimate(3)));
