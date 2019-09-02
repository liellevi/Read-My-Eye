clc;           
clear all;
close all;
syntheticDir   = fullfile(toolboxdir('vision'), 'visiondata','density');
trainingSet = imageDatastore(syntheticDir,   'IncludeSubfolders', true, 'LabelSource', 'foldernames');
numImages = numel(trainingSet.Files);


%di=dir('letters_numbers');
%st={di.name};
%nam=st(3:end);
DB=cell(2,numImages);
for i=1:numImages
   image1 = readimage(trainingSet, i);
   [img, Ftest1]=FeaturStatistical(image1);
   Ftest=imresize(img,[300 300]);

   DNST(1,i)={Ftest};
   DNST(2,i)={Ftest1(1)};
   DNST(3,i)={Ftest1(2)};
   DNST(4,i)={Ftest1(3)};
   DNST(5,i)={Ftest1(4)};

   DNST(6,i)=cellstr(trainingSet.Labels(i));
end
save('DNST.mat','DNST');
clear;

function [img, F]=FeaturStatistical(im)
im=rgb2gray(im);
im_bw=im2bw(im,0.3);
im_range=rangefilt(im);
im_edge=edge(im,'Canny', 0.05);
%F=im_edge;
stdbw=std(std(im_bw));
stdrange=std(std(double(im_range)));
%stdedge=std(std(im_edge));
meanbw=mean(mean(im_bw));
meanrange=mean(mean(double(im_range)));
%meanedge=mean(mean(im_edge));
F=[stdbw meanbw stdrange meanrange];
img=im_edge;
end