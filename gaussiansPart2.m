clc;
clearvars -except data bedroom
format LONGG;
load('./../smai_data/normalise');
% classes = data.keys;
class = './../smai_data/street';

% for a = classes
%     class = a{1};
load(class);

% All Variables Initilization
omu = zeros(36,12800);
osigma = zeros(36,36,12800);
oweight = zeros(12800,1);
odiag = zeros (36, 12800);
nweight = ones(128,1)/128;
nsigma = zeros(36,36,128);
for i=1:128
    nsigma(:,:,i) = eye(36);
end

idx = randi(12800,[128,1]);
maxiter = 20;
converged = false;
t=1;
h = zeros([12800,128]);
g = zeros([12800,128]);

for i = 1:100
    omu(:,(i-1)*128+1:i*128) = model(i).mu;
    osigma(:,:,(i-1)*128+1:i*128) = model(i).Sigma;
    oweight((i-1)*128+1:i*128) = model(i).weight/100; % because there are 100*128 gaussians
end
omu = bsxfun(@minus,omu,m);
omu = bsxfun(@times,omu,1./v');
for i=1:12800
    odiag(:,i) = diag(osigma(:,:,i));
end

nmu = omu(:,idx);
%     nmu = rand(36,128);
tic;

fprintf ('started the expectation step at t = %d\n',t);
fprintf ('Computing g matrix\n');

for j = 1:128
    gaussian = loggausspdf2(omu, nmu(:,j), nsigma(:,:,j));
    gaussian = gaussian + (-1/2)*sum(repmat(diag(inv(nsigma(:,:,j))), [1,12800]) .* odiag);
    wgt = floor((oweight*102400)');
    gaussian = (gaussian .* wgt) + log(nweight(j));
    h(:,j) = gaussian';
end
llh(t) = sum(logsumexp(h,2));
for j=1:128
    g(:,j) = 1./sum(exp(bsxfun(@minus,h,h(:,j))),2);
end
fprintf ('Computation of g matrix complete\n');

while ~converged && t < maxiter
    
    %         [~,I] = pdist2(omu', nmu', 'euclidean', 'smallest',1);
    %         gg = zeros([1,128]);
    %         for j = 1:128
    %             gg(j) = loggausspdf2(nmu(:,j), omu(:,I(j)), osigma(:,:,I(j)));
    %             gg(j) = gg(j) - (1/2)*(trace(osigma(:,:,I(j))\nsigma(:,:,j))) + oweight(I(j));
    %             gg(j) = gg(j)*nweight(j);
    %         end
    %         llh(t) = sum(gg);
    fprintf ('started maximisation step...\n');
    
    nweight = sum(g,1)/12800;
    
    tempw = bsxfun(@times,g,oweight);
    tempww = sum(tempw,1);
    tempidx=find(tempww == 0);
    tempww(tempidx)=1;
    tempw = bsxfun(@rdivide,tempw,tempww);
    
    % Variables for checking the previous data if the code crashes due to
    % NaN error in the g, or due to nsigma not being positive semi-definite
    % matrix.
    backup_nweight  = nweight;
    backup_nmu      = nmu;
    backup_nsigma   = nsigma;
    
    % Converting omu to 3-D matrix for manipulation using bsxfun
    tempmu(1,:,:)   = omu;
    for j = 1:128
        tempw2 = permute(repmat(tempw(:,j)',[36,1,36]),[1,3,2]);
        mu = nmu(:,j);
        tempmu2 = bsxfun(@minus,tempmu(1,:,:),nmu(:,j)');
        tempmu3 = bsxfun(@times,tempmu2(1,:,:),permute(tempmu2,[2,1,3]));
        tempmu3 = tempmu3 + osigma;
        tempmu3 = tempmu3.*tempw2;
        nsigma(:,:,j) = sum(tempmu3,3);
    end
    nmu = omu*tempw;
    fprintf ('finished maximisation step...\n');
    t = t+1;
    
    fprintf ('started the expectation step at t = %d\n',t);
    odiag = zeros (36, 12800);
    
    fprintf ('Computing g matrix\n');
    for i=1:12800
        odiag(:,i) = diag(osigma(:,:,i));
    end
    for j = 1:128
        gaussian = loggausspdf2(omu, nmu(:,j), nsigma(:,:,j));
        gaussian = gaussian + (-1/2)*sum(repmat(diag(inv(nsigma(:,:,j))), [1,12800]) .* odiag);
        wgt = floor((oweight*102400)');
        gaussian = (gaussian .* wgt) + log(nweight(j));
        h(:,j) = gaussian';
    end
    llh(t) = sum(logsumexp(h,2));
    if llh(t)-llh(t-1)<1e-4*abs(llh(t))
        converged = true;
    end
    for j=1:128
        g(:,j) = 1./sum(exp(bsxfun(@minus,h,h(:,j))),2);
    end
    
    fprintf ('Computation of g matrix complete\n');
    %
end
% end
toc;