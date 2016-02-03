
k = {'bedroom','coast','highway','kitchen','livingroom','mountain','office','opencountry',   'tallbuilding'};
 image = zeros(9,9,1024,200);
for i=1:9
    for j = 1:9
        image(i,j,:,:) = des(i).(k{j})(:,1:200);
    end
end
image = permute(image,[1,3,4,2]);