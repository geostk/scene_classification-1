function [result, w, accuracy] = multisvm(TrainingSet, TestSet, GroupTrain, ValSet)

% Input Standards
% TrainingSet = [1 10;2 20;3 30;4 40;5 50;6 66;3 30;4.1 42];
% TestSet=[3 34; 1 14; 2.2 25; 6.2 63];
% GroupTrain=[1,1,2,2,3,3,2,2];
GroupTrain = GroupTrain';

%Models a given training set with a corresponding group vector and 
%classifies a given test set using an SVM classifier according to a 
%one vs. all relation. 

tic;
u=unique(GroupTrain);
numClasses=length(u);
result = zeros(length(TestSet(:,1)),1);

%build models
for k=1:numClasses
    %Vectorized statement that binarizes Group
    %where 1 is the current class and 0 is all other classes
    G1vAll=(GroupTrain==u(k));
    models(k) = svmtrain(double(TrainingSet),double(G1vAll),'kernel_function','rbf');
end

% Don't know why this is required..?
TestSet = TestSet';
%classify test cases
for j=1:size(TestSet,1)
    for k=1:numClasses
        if(svmclassify(models(k),TestSet(j,:))) 
            break;
        end
    end
    result(j) = k;
end
accuracy = length(find(result ~= ValSet))/9;
w = toc;
