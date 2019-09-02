
function F=FeaturStatisticalStressModel(features)
%fs=[true false true false true];
X_test_w_best_feature = features;%(fs);
Model = loadCompactModel('StressRingSVM1.mat');
F=predict(Model,X_test_w_best_feature);

end


