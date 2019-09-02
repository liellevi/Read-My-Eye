clc;           
clear all;
close all;
syntheticDir   = fullfile(toolboxdir('vision'), 'visiondata','TestDNST');
trainingSet = imageDatastore(syntheticDir,   'IncludeSubfolders', true, 'LabelSource', 'foldernames');
numImages = numel(trainingSet.Files);
trainingFeatures=zeros(numImages);
   load('DNST.mat');

for i = 1:numImages
    image1 = readimage(trainingSet, i);
   [img, Ftest1]=FeaturStatistical(image1);
    Ftest=imresize(img,[300 300]);
    x=[ ];
    totalLetters=size(DNST,2);

    for k=1:totalLetters
    y=corr2(DNST{1,k},Ftest);
    x=[x y];
    end

    %figure, imagesc(image1), title(tag);

    %disp(num2str(tag)); 
%  t=[t max(x)];
 %if max(x)>.35
 z=find(x==max(x));
 x(z)=0;
 zz=find(x==max(x));
 x(zz)=0;
 zzz=find(x==max(x));

 out1=str2num(cell2mat(DNST(6,z)));
 out2=str2num(cell2mat(DNST(6,zz)));
 out3=str2num(cell2mat(DNST(6,zzz)));

 %disp(out);

 Ftrain=DNST(2:3:4:5, :);
Ctrain=DNST(6,:);
    for (j=1:size(Ftrain,2))
        DNSTtrain=[ cell2mat(Ftrain(1,j))  cell2mat(Ftrain(2,j))  cell2mat(Ftrain(3,j))  cell2mat(Ftrain(4,j))];
        dist(j,:)=sum(abs(DNSTtrain-Ftest1));
    end
    n=find(dist==min(dist), 1);
    det_class=Ctrain(n);
    tag=det_class;
    trainingFeatures(:, i) = str2num(cell2mat(tag));
    tag=str2num(cell2mat(tag));
    avg=round((tag+out1+out2+out3)/4);
    if (tag+out1+out2+out3)/4<0.9
        avg=0;
    end
    figure, imagesc(image1), title(num2str(avg));
end

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