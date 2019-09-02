function F=FeaturStatisticalAtaraModel(features)

load('Atara1.mat');

X = Atara1(100:end,1:4); % 1, 3, 5, 7 ? feature? ??? ??? feature? ??.

y = Atara1(100:end,5);

%rand_num = randperm(size(X,1));
%X_train = X(rand_num(1:round(length(rand_num))),:);
%y_train = y(rand_num(1:round(length(rand_num))),:);


SVMModels = cell(3,1);
classes = unique(y);
rng(1); % For reproducibility

for j = 1:numel(classes)
    indx = strcmp(num2cell(y),classes(j)); % Create binary classes for each classifier
  SVMModels{j} = fitcsvm(X,indx,'Standardize',true,'KernelFunction','RBF',...
    'KernelScale','auto');

end

for j = 1:numel(classes)
    [~,score] = predict(SVMModels{j},features);
    Scores(:,j) = score; % Second column contains positive-class scores
end
[~,maxScore] = max(Scores,[],2);
F=maxScore-1;
end