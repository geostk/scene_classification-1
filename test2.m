tic;
g = zeros(12800,128);
for i = 1:1280
    for j = 1:128
        g(i,j)=1/sum(exp(h(i,:)-h(i,j)));
    end
end
toc;