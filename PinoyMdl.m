%0- Not Exist, 1- Exist
load Pinuy.mat

X=Pinuy(:,1:5);
y=Pinuy(:,6);

rand_num = randperm(size(X,1));
X_train = X(rand_num(1:round(0.8*length(rand_num))),:);
y_train = y(rand_num(1:round(0.8*length(rand_num))),:);

X_test = X(rand_num(round(0.8*length(rand_num))+1:end),:);
y_test = y(rand_num(round(0.8*length(rand_num))+1:end),:);


%X_train = X(rand_num(1:round(length(rand_num))),:);
%y_train = y(rand_num(1:round(length(rand_num))),:);



%% CV partition

c = cvpartition(y_train,'k',5);
%% feature selection

opts = statset('display','iter');
classf = @(train_data, train_labels, test_data, test_labels)...
    sum(predict(fitcsvm(train_data, train_labels,'KernelFunction','rbf'), test_data) ~= test_labels);

[fs, history] = sequentialfs(classf, X_train, y_train, 'cv', c, 'options', opts,'nfeatures',5);
%% Best hyperparameter

X_train_w_best_feature = X_train(:,fs);

%%

Md1 = fitcsvm(X_train_w_best_feature,y_train,'KernelFunction','rbf','OptimizeHyperparameters','auto',...
      'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
      'expected-improvement-plus','ShowPlots',true)); % Bayes' Optimization ??.

%% Final test with test set

X_test_w_best_feature = X_test(:,fs);
test_accuracy_for_iter = sum((predict(Md1,X_test_w_best_feature) == y_test))/length(y_test)*100

 
sv = Md1.SupportVectors;
figure
gscatter(X_train_w_best_feature(:,1),X_train_w_best_feature(:,2),y)
hold on
legend('notExist','Exist')
hold off

saveCompactModel(Md1, 'PinoySVM');
