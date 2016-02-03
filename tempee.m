clearvars -except data 
clc;tic;
classes = {'bedroom'};
j=0;
for class = classes
    j=j+1;
    load(class{1});
    obj = gmdistribution (nmu',nsigma,nweight);
    for class2 = classes
        
        d = data(class2{1});
        ret = zeros(1024,size(d,1));
        for i=1:200
            i
            X(:,:) = d(i,:,:);
            ret(:,i) = log(pdf(obj,X));
        end
        distribution(j).class2{1} = ret;
    end
%     d(j)=distribution;
end
toc;
% 
% % X=img;
% classes = {'bedroom','coast','highway','kitchen','livingroom','mountain','office','opencountry','tallbuilding'};
% for class = classes
%     load (class{1});
%     obj = gmdistribution (nmu',nsigma,nweight);
%     %1024*1
%     ret = log(pdf(obj,X));
%     dist.class{1} = ret;
% end