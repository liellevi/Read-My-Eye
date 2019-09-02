%function [result] = multisvm(TrainingSet,GroupTrain,TestSet)
load Atara1.mat 

X = Atara1(100:end,1:4); % 1, 3, 5, 7 ? feature? ??? ??? feature? ??.

y = Atara1(100:end,5);

rand_num = randperm(size(X,1));
X_train = X(rand_num(1:round(0.8*length(rand_num))),:);
y_train = y(rand_num(1:round(0.8*length(rand_num))),:);

X_test = X(rand_num(round(0.8*length(rand_num))+1:end),:);
y_test = y(rand_num(round(0.8*length(rand_num))+1:end),:);

%X_train = X(rand_num(1:round(length(rand_num))),:);
%y_train = y(rand_num(1:round(length(rand_num))),:);



u=unique(y_train);
numClasses=length(u);
result = zeros(length(X_test(:,1)),1);
%build models
for k=1:numClasses
    %Vectorized statement that binarizes Group
    %where 1 is the current class and 0 is all other classes
    G1vAll=(y_train==u(k));
    
models{k} = fitcsvm(X_train,G1vAll,'Standardize',true,'KernelFunction','RBF',...
    'KernelScale','auto');
    %models{k} = svmtrain(X_test,G1vAll);
end

saveCompactModel(models{1}, 'AtaraLineSVM1');
saveCompactModel(models{2}, 'AtaraLineSVM2');
saveCompactModel(models{3}, 'AtaraLineSVM3');
