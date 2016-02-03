clear;
clc;
load('the_last');
t = train;
v = val;

d = size(t,1)*(size(t,2)-1) +1;        % because 8X8 + x0;
nH = 81;                                %m/10
c = 9;
n = 0.1;
iter = 1000;
thres = 10;

Wij = unifrnd(-1/sqrt(d),1/sqrt(d),d,nH);
Wjk = unifrnd(-1/sqrt(nH),1/sqrt(nH),nH,c);
netj = zeros(nH,1);
netk = zeros(c,1);
error = zeros(1,size(v,3));
e = zeros(1,size(v,3));

for j = 1:iter
    for i = 1:size(t,3)
        X = 1;
        X(2:d) = t(:,1:8,i);                % 1Xd
        netj = (X*Wij);                     % 1Xd.dXnH => 1XnH

        Y = (1+exp(-netj)).^(-1);               % 1XnH
        netk = (Y*Wjk);                     % 1XnH.nHXc => 1Xc

        Z = (1+exp(-netk)).^(-1);
        if t(1,end,i) == 1
            tc = [1,1];
        else
            tc = [0,0];
        end
        if  (norm(Z)> 0.6 & t(1,end,i) == 1) | (norm(Z)<= 0.4 & t(1,end,i) == 0)
            e(i) = 0;
        else
            e(i) = 1;
        end
        Dk = ((tc-Z).*(Z.*(1-Z)));
        Wjk = Wjk + n*Y'*Dk;            % momentum with alpha = 0
        Dj = ((Dk*Wjk').*(Y.*(1-Y)));
        Wij = Wij + n*X'*Dj;            % mometum with alpha = 0
    end
    if sum(e) < thres
        break;
    end
end

for i = 1:size(v,3)
    X = 1;
    X(2:d) = v(:,1:8,i);                % 1Xd
    netj = (X*Wij);                     % 1Xd.dXnH => 1XnH
    
    Y = (1+exp(-netj)).^(-1);               % 1XnH
    netk = (Y*Wjk);                     % 1XnH.nHXc => 1Xc
    
    Z = (1+exp(-netk)).^(-1);
    if  (norm(Z)> 0.5 & v(1,end,i) == 1) | (norm(Z)<= 0.5 & v(1,end,i) == 0)
        error(i) = 0;
    else
        error(i) = 1;
    end
end 
q = find(error == 1);
fprintf('Number of misclassified "7": %d\n',sum(v(1,end,q)));
fprintf('Total misclassified samples: %d\n',length(q));
fprintf('Hence the error percentage is: %d\n',length(q)/length(v)*100);

