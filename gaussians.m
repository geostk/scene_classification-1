clc;
clearvars -except data;   
%load('data');
classes = keys(data);
i=0;
for class = classes
    i=i+1;
    scene = data(class{1});
    class
    for j = 1:120
        im(:,:) = scene(j,:,:);
        model(j) = emgm(im',128);
        j
    end
    save(class{1},'model');
    clear model;
end