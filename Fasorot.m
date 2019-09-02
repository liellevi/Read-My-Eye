%%
function [X]=Fasorot(im)

im3=imcomplement(handles.im_crop);
I = rgb2gray(im3);
bw = imbinarize(I);
bw = bwareafilt(bw,[36 500]);

%bw = bwareaopen(bw,30);

se = strel('disk',2);
bw = imclose(bw,se);


[B,L] = bwboundaries(bw,'noholes');


Fasurot=label2rgb(L,@jet,[.5 .5 .5]);
imagesc(label2rgb(L,@jet,[.5 .5 .5]));
hold on
MainColors=zeros(1,14);

stats = regionprops(L,'Area','Centroid');

threshold = 0.94;

% loop over the boundaries
for k = 1:length(B)

  % obtain (X,Y) boundary coordinates corresponding to label 'k'
  boundary = B{k};

  % compute a simple estimate of the object's perimeter
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  
  % obtain the area calculation corresponding to label 'k'
  area = stats(k).Area;
  
  % compute the roundness metric
  metric = 4*pi*area/perimeter^2;
if metric>0.45
     plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)

    A=imread('mapwithcolor.png');
    [rowsA colsA numberOfColorChannelsA] = size(A);
    [rowsB colsB numberOfColorChannelsB] = size(Fasurot);
    A = imresize(A, [rowsB colsB]);
    
    colors=zeros(1,14);
    for p=1:length( B{k, 1})
    thefirstpixel= B{k, 1}(p, 1);
    theseondpixel= B{k, 1}(p, 2);
    rgbColor = impixel(A, theseondpixel, thefirstpixel) ; 

    if rgbColor==[83,155,203]
        colors(1,1)=colors(1,1)+1;
    end   
    if rgbColor==[149,199,226]
        colors(1,2)=colors(1,2)+1;
    end
    if rgbColor==[210,92,150]
        colors(1,3)=colors(1,3)+1;
    end
    if rgbColor==[255,241,5]
        colors(1,4)=colors(1,4)+1;
    end
    if rgbColor==[132,28,51]
        colors(1,5)=colors(1,5)+1;
    end
    if rgbColor==[228,4,30]
        colors(1,6)=colors(1,6)+1;
    end
    if rgbColor==[128,44,113]
        colors(1,7)=colors(1,7)+1;
    end
    if rgbColor==[255,178,99]
        colors(1,8)=colors(1,8)+1;
    end
    if rgbColor== [82,163,94]
        colors(1,9)=colors(1,9)+1;
    end
    if rgbColor== [0,38,85]
        colors(1,10)=colors(1,10)+1;
    end
    if rgbColor== [255,249,147]
        colors(1,11)=colors(1,11)+1;
    end
    if rgbColor== [250,224,191]
        colors(1,12)=colors(1,12)+1;
    end
    if rgbColor== [241,140,0]
        colors(1,13)=colors(1,13)+1;
    end
    if rgbColor== [215,13,12]
        colors(1,14)=colors(1,14)+1;        
    end
             
    end
   [M,I] = find(colors == max(colors));
   MainColors(M,I)=MainColors(M,I)+1; 
    
   % figure,imagesc(boundary)
   
  % display the results
  metric_string = sprintf('%2.2f',metric);

  % mark objects above the threshold with a black circle
  if metric > threshold
    centroid = stats(k).Centroid;
    plot(centroid(1),centroid(2),'ko');
  end
  
  text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
       'FontSize',14,'FontWeight','bold')
end
end

colorsMinning=["פנים", "צוואר וכתפיים/סרעפת/רחם",...
    "ראות/צלעות/שקדים", "מעי דק/כבד/אשכים", "עצמות בריח/מערכת הקול",...
    "אנדרנלין", "מערכת העצבים/בלוטת התריס", "כליות/אגן/סמפונות","רגליים",...
    "לבלב", "מעי גס","עמוד שדרה" ,"שלפוחית השתן/בטן", "פי הטבעת"];
for J=1:14
    if MainColors(1,J)~=0
      if MainColors(1,J)==1
        X=["נמצאה רגישות ב",colorsMinning(1,J), " על ידי כתם אחד בקשתית העין."];
      else
        X=['נמצאה רגישות ב',colorsMinning(1,J), ' על ידי ', num2str(MainColors(1,J)),' כתמים שונים בקשתית העין.'];
      end
    end
end
