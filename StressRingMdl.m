%% preparing dataset

load StressRing.mat

X = StressRing(:,1:5); % 1, 3, 5, 7 ? feature? ??? ??? feature? ??.

y = StressRing(:,6);

rand_num = randperm(size(X));
%X_train = X(rand_num(1:round(0.8*length(rand_num))),:);
%y_train = y(rand_num(1:round(0.8*length(rand_num))),:);

%X_test = X(rand_num(round(0.8*length(rand_num))+1:end),:);
%y_test = y(rand_num(round(0.8*length(rand_num))+1:end),:);


X_train = X(rand_num(1:round(0.6*length(rand_num))),:);
y_train = y(rand_num(1:round(0.6*length(rand_num))),:);

X1 = StressRing(236:end,1:5); % 1, 3, 5, 7 ? feature? ??? ??? feature? ??.

y1 = StressRing(236:end,6);
X_train=[X_train; X1];
y_train=[y_train; y1];

%% CV partition

c = cvpartition(y_train,'k',5);
%% feature selection

opts = statset('display','iter');
classf = @(train_data, train_labels, test_data, test_labels)...
    sum(predict(fitcsvm(train_data, train_labels,'KernelFunction','rbf'), test_data) ~= test_labels);

[fs, history] = sequentialfs(classf, X_train, y_train, 'cv', c, 'options', opts,'nfeatures',5);
%% Best hyperparameter

X_train_w_best_feature = X_train(:,fs);
Md1 =  fitcsvm(...
    X_train_w_best_feature, ...
    y_train, ...
    'KernelFunction', 'linear', ...
    'PolynomialOrder', [], ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true, ...
    'ClassNames', [0; 1]);

%% Final test with test set
X_test_w_best_feature = X_test(:,fs);
test_accuracy_for_iter = sum((predict(Md1,X_test_w_best_feature) == y_test))/length(y_test)*100

 
sv = Md1.SupportVectors;
figure
gscatter(X(:,1),X(:,2),y)
hold on
legend('Exist','notExist')
hold off

saveCompactModel(Md1, 'StressRingSVM');
