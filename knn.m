clearvars -except train train_idx val val_idx
for i = 1:200
[~,idx] = pdist2(train',val','mahalanobis','smallest',i);
idx = train_idx(idx);
class = mode(idx);
correct = class == val_idx';
a(i)=sum(correct);
end
% for i = 1:200
% [~,idx] = pdist2(train',val','euclidean','smallest',i);
% idx = train_idx(idx);
% class = mode(idx);
% correct = class == val_idx';
% b(i)=sum(correct);
% end
% for i = 1:200
% [~,idx] = pdist2(train',val','cosine','smallest',i);
% idx = train_idx(idx);
% class = mode(idx);
% correct = class == val_idx';
% c(i)=sum(correct);
% end
% for i = 1:200
% [~,idx] = pdist2(train',val','correlation','smallest',i);
% idx = train_idx(idx);
% class = mode(idx);
% correct = class == val_idx';
% d(i)=sum(correct);
% end
% 
% for i = 1:200
% [~,idx] = pdist2(train',val','minkowski','smallest',i);
% idx = train_idx(idx);
% class = mode(idx);
% correct = class == val_idx';
% e(i)=sum(correct);
% end
% 
% for i = 1:200
% [~,idx] = pdist2(train',val','cityblock','smallest',i);
% idx = train_idx(idx);
% class = mode(idx);
% correct = class == val_idx';
% f(i)=sum(correct);
% end
% figure,plot(f/900),title('cityblock');
% figure,plot(e/900),title('minkowski');
figure,plot(a/900),title('mahalonobis');
% figure,plot(b/900),title('euclidean');
% figure,plot(c/900),title('cosine');
% figure,plot(d/900),title('correlation');