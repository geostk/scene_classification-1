final = zeros(9,1800);
label = zeros(1800,1);
for i = 1:9
    for j = 1:200
        temp(:,:) = images(:,:,j,i);
        temp(:,:) = sign(sign(bsxfun(@minus,temp,max(temp)*0.85))+1);
        final(:,j+200*(i-1))=sum(temp,2);
    end
    label((i-1)*200+1:i*200) = i;
end
final = bsxfun(@times,final,1./sum(final,1));
        