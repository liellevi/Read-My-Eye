
function F=FeaturStatisticalPinoyModel(features)
PinoySVM = loadCompactModel('PinoySVM.mat');
F=predict(PinoySVM,features);

end

