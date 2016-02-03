clc;
clearvars -except data;
%load('data');
street = data('street');
n = 128; %no. of gaussians
im(:,:) = street(1,:,:);
m = mean(im);
im = im - repmat(m,[1024,1]);
for i = 1:n
    mean_gsn(i,:) = rand(1,1); % initial random mean and var for the 128 gaussians
    var_gsn(:,:,i) = eye(36);
end
for i = 1:n
    for j = 1:1024
        a = (1/sqrt(2*pi*norm(var_gsn(:,:,i))));
        b = (im(j,:)-mean_gsn(i,:))*(inv(var_gsn(:,:,i)))*(im(j,:)-mean_gsn(i,:))';
        px_c(i,j) = a*exp((-1/2)*b);
    end
end

