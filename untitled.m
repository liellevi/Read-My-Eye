 function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 29-Jul-2019 17:00:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
axes(handles.axes3);
handles.background=imread('background.jpg');
imagesc(handles.background);
axis off;
guidata(hObject, handles);
axes(handles.axes4);
handles.logo=imread('logo.PNG');
imagesc(handles.logo);
axis off;
guidata(hObject, handles);
axes(handles.axes5);
handles.diagnose=imread('diag.PNG');
imagesc(handles.diagnose);
axis off;
guidata(hObject, handles);
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
cla(handles.axes1, 'reset');
cla(handles.axes2, 'reset');
Y="Fasurot report";
set(handles.text9,'String',Y);
y="Density";
  set(handles.text3,'String',y);
  x="Color";
  set(handles.text2,'String',x);
  d="Central Hetrocromy";
 set(handles.text5,'String',d);
 c="Crown Line";
  set(handles.text4,'String',c);
 f="Stress Ring";
  set(handles.text10,'String',f);
f ="Evacuation Ring";
 set(handles.text8,'String',f);
 e="Cholesterol Ring";
 set(handles.text7,'String',e);

[file_name, path_name]=uigetfile('*');
handles.file_name=file_name;
handles.path_name=path_name;
full_path=[path_name '/' file_name];
handles.im_original=imread(full_path);

axes(handles.axes1);
imagesc(handles.im_original);
axis off;
guidata(hObject, handles);
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
handles.right=false;
handles.left=true;
axes(handles.axes1);
handles.im_crop=thresh(handles.im_original)
%handles.eye_left=eye_left_fuction(handles.im_crop);
image1=handles.im_crop;
map=imread('eye_left.jpg');
[x,y]=size(image1);
im1=imresize(map, [x,y/3]);
im2=im2bw(im1, 0.7);
im2=uint8(im2);
handles.F = image1 .* cat(3, im2, im2, im2);
imagesc(handles.F);
%imagesc(handles.eye_left);
axis off;
guidata(hObject, handles);
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
 [img, Ftest1]=FeaturStatisticaltexture(handles.im_crop);
%compare with database
load DNST.mat

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
 if max(x)>.3
 z=find(x==max(x));
 det_class2=str2num(cell2mat(DNST(6,z)));
 else
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
    tag=str2num(cell2mat(tag));
    det_class2=round((tag+out1+out2+out3)/4);
    if (tag+out1+out2+out3)/4<0.9
        det_class2=0;
    end
 end
   
if det_class2==0
    y="צפיפות סיבים- צפוף. ";
    y=y+"מעיד על עוצמה וחוזק גופני, הגוף עמיד יותר בפני גורמים פתוגניים כמו חיידקים וירוסים ועוד.";
    
else
    if det_class2==1
      y="צפיפות סיבים - בינוני. ";
      y=y+"מחסור ברכיבי תזונה ישפיע באופן ישיר על העמידות הגופנית בפני גורמים פתוגניים כמו חיידקים וירוסים ועוד.";
      
    else
        y="צפיפות סיבים - פרום. ";
        y=y+"מחסור ברכיבי תזונה כמו: אבץ, ברזל, סידן, מגנזיום";
       y=y+"גורמים פתוגניים (חיידקים ווירוסים) יחדרו יותר בקלות.";
       
    end
end
  set(handles.text3,'String',y);
guidata(hObject, handles); 







FColortest=FeaturStatisticalColor(handles.im_crop);
%compare with database
load Color.mat
FColortrain=Color(:,1:6);
CColortrain=Color(:,7);
for (i=1:size(FColortrain,1))
distColor(i,:)=sum(abs(FColortrain(i,:)-FColortest));
end
nColor=find(distColor==min(distColor),1);
det_class1=CColortrain(nColor);
globalColor=det_class1;
if det_class1==0
    x="צבע העין - כחול. ";
    x=x+"מערכת החיסון מגיבה בדרך כלל באופן חזק ולפעמים חזק מדי(מחלות אוטואימוניות, אלרגיות";
    x=x+"אברים הקשורים למערכת החיסון עלולים להיות חלשים כמו הטחול,השקדים, בלוטת התימוס,";
    x=x+"סביר להניח שתאים המפרישי ריר יעבדו יותר (נזלות, ליחות)";
    
else
    if det_class1==1
      x="צבע העין- מעורב. ";
      x=x+" מעיד על חוסר באנזימי עיכול, קושי בעיכול, מיץ מרה לא איכותי.";
      x=x+" לבלב עובד קשה, וישנה נטיה להיפר והיפו גליקמיה. ";
      x=x+" כיוון לטיפול: תזונה במנות קטנות על מנת לא להעמיס על מערכת העיכול. ";
      
  else
     if det_class1==2
        x="צבע העין- חום. ";
        x=x+" נטייה להצטברות פסולת בדם: שומנים, סוכרים וכו'. קושי בתפקודי כבד, מעיים, לבלב וכיס מרה.";
        x=x+" נטייה לליקויים בתפקוד בלוטת התריס. לנשים- נטייה לאי סדירות וכאבים בוסת.";
        
       else
          x="צבע העין- מעורב. ";
        x=x+" מעיד על חוסר באנזימי עיכול, קושי בעיכול, מיץ מרה לא איכותי.";
        x=x+" לבלב עובד קשה, וישנה נטיה להיפר והיפו גליקמיה. ";
        x=x+" כיוון לטיפול: תזונה במנות קטנות על מנת לא להעמיס על מערכת העיכול. ";
     end
    end
end
 set(handles.text2,'String',x);
guidata(hObject, handles); 

Fataratest=FeaturStatisticalAtaraLine(handles.im_crop);
%compare with database
if Fataratest==0
    c="מיקום קו עטרה- רגיל. ";
    c=c+"מעיד על מערכת עיכול המתפקדת בצורה תקינה.";
elseif Fataratest==1
      c="מיקום קו עטרה- קרוב. ";
      c=c+"מעיד על הפרעות במעי, יכולה ספיגה לקויה של מינרלים שונים. ישנו קושי לספיגת מזון. בנוסף חוסר אנרגיה עייפות וחולשה.";
      
      
else
        c="מיקום קו עטרה-רחוק. ";
        c=c+"תנועת מעיים איטית, נטייה לעצירות, חולשה בספיגת רכיבי תזונה.";
        c=c+"נטייה לקנדידה ומחלות מעיים דלקתיות.";

     
end
 set(handles.text4,'String',c);
guidata(hObject, handles); 






FHTCRMtest=FeaturStatisticalHTCRM(handles.im_crop);
load HTCRM.mat
FHTCRMtrain=HTCRM(:,1:2:3:4:5:6:6:7:8:9);
CHTCRMtrain=HTCRM(:,10);
for (j=1:size(FHTCRMtrain,1))
    distHTCRM(j,:)=sum(abs(FHTCRMtrain(j,:)-FHTCRMtest));

   end
nHTCRM=find(distHTCRM==min(distHTCRM),1);
det_class4=CHTCRMtrain(nHTCRM);
if det_class4==1
    d="הטרוכרומיה מרכזית- אין.";
else
     d="הטרוכרומיה מרכזית -יש.";
     d=d+"היתכנות של חולשה בכליות";
  
     
end
 set(handles.text5,'String',d);
guidata(hObject, handles); 






Colesteroltest=findingColesterolRing(handles.im_crop, globalColor);
if Colesteroltest==false
    e="טבעת כולסטרול-נתרן: אין. ";
else
    e="טבעת כולסטרול-נתרן: יש. ";
     e=e+"טבעת כולסטרול נתרן מעידה על זרימה לקויה של דם וחמצן שיכולה להוביל לתופעות כמו שכחה והצטברות שומנים וכולסטרול.";
     
end
 set(handles.text7,'String',e);
guidata(hObject, handles); 




Pinuytest=FeaturStatisticalPinuyRing(handles.im_crop);
if Pinuytest==48
    f= "טבעת עור פינוי סילוק: אין.";
else
    f="טבעת עור פינוי סילוק: יש. ";
    f=f+"טבעת זו מעידה על עומס אפשרי באיברי הפינוי והניקוז של הגוף: שתן, עיכול, הפרשות עיניים, אף, גרון, זיעה מוגברת, כבד, ולנשים וסת.";
      
end
 set(handles.text8,'String',f);
 
 
 

StressRing=FeaturStatisticalStressRing(handles.im_crop);
if StressRing==0
    f= "טבעות מתח: אין. ";
else
    f="טבעות מתח: יש. ";
    f=f+"טבעות מתח מעידות על זרימת דם לקויה לפריפריה (איברי קצוות הגוף), כאבי ראש, מגרנות, וכאבי בטן. ";
    f=f+"המערכת הסימפטטית- מערכת הפועלת לתגובות מיידיות באדם במצבי לחץ, חירום ומתח, ומכינה את הגוף למאבק או נסיגה בהתאם לתגובת הילחם או ברח, עובדת שעות נוספות."; 
end
 set(handles.text10,'String',f);
guidata(hObject, handles);
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
axes(handles.axes2);
%%
im3=imcomplement(handles.im_crop);
I = rgb2gray(im3);
bw = imbinarize(I);
bw = bwareafilt(bw,[36 500]);
%bw = bwareaopen(bw,30);

se = strel('disk',2);
bw = imclose(bw,se);
  Y=" ";

[B,L] = bwboundaries(bw,'noholes');


Fasurot=label2rgb(L,@jet,[.5 .5 .5]);
 imshow(label2rgb(L,@jet,[.5 .5 .5]));
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
    
     if handles.right==true
         A=imread('rightmapwithcolor.png');
     else
         A=imread('leftmapwithcolor.png');
     end
    [rowsA colsA numberOfColorChannelsA] = size(A);
    [rowsB colsB numberOfColorChannelsB] = size(Fasurot);
    A = imresize(A, [rowsB colsB]);
    
    colors=zeros(1,15);
    for p=1:length( B{k, 1})
    thefirstpixel= B{k, 1}(p, 1);
    theseondpixel= B{k, 1}(p, 2);
    rgbColor = impixel(A, theseondpixel, thefirstpixel) ; 

    if rgbColor==[83,155,203]
        colors(1,1)=colors(1,1)+1;   
    elseif rgbColor==[149,199,226]
        colors(1,2)=colors(1,2)+1;
    elseif rgbColor==[210,92,150]
        colors(1,3)=colors(1,3)+1;
    elseif rgbColor==[255,241,5]
        colors(1,4)=colors(1,4)+1;
    elseif rgbColor==[132,28,51]
        colors(1,5)=colors(1,5)+1;
    elseif rgbColor==[228,4,30]
        colors(1,6)=colors(1,6)+1;
    elseif rgbColor==[128,44,113]
        colors(1,7)=colors(1,7)+1;
    elseif rgbColor==[255,178,99]
        colors(1,8)=colors(1,8)+1;
    elseif rgbColor== [82,163,94]
        colors(1,9)=colors(1,9)+1;
    elseif rgbColor== [0,38,85]
        colors(1,10)=colors(1,10)+1;
    elseif rgbColor== [255,249,147]
        colors(1,11)=colors(1,11)+1;
    elseif rgbColor== [250,224,191]
        colors(1,12)=colors(1,12)+1;
    elseif rgbColor== [241,140,0]
        colors(1,13)=colors(1,13)+1;
    elseif rgbColor== [215,13,12]
        colors(1,14)=colors(1,14)+1; 
    else
        colors(1,15)=1;

    end
             
    end
  
   realColors=colors(1, 1:14);     
  if (colors(1,15)~=1 || sum(realColors(1, :))~=0)
        [M,I] = find(colors == max(colors));
        MainColors(M,I)=MainColors(M,I)+1; 
  end
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
        X="נמצאה רגישות ב";
      if MainColors(1,J)==1
          X=X+colorsMinning(1,J);
          X=X+" על ידי כתם אחד בקשתית העין.";
        
      else
          X=X+colorsMinning(1,J);
          X=X+' על ידי ';
          X=X+num2str(MainColors(1,J));
          X=X+' כתמים שונים בקשתית העין.';
      end
      Y=Y+X;
      Y=Y+'       ';

    end
     
end
if sum(MainColors(1, :))==0
         Y=Y+"לא נמצאו פסורות.";
         
 
     end


       set(handles.text9,'String',Y);
       clearvars handles.im_original handle

%%
%handles.im_fasurot=findingFasurot(handles.im_crop);
%imagesc(handles.im_fasurot);

axis off;
guidata(hObject, handles);
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
handles.right=true;
handles.left=false;

axes(handles.axes1);
handles.im_crop=thresh(handles.im_original);
image1=handles.im_crop;
map=imread('eye_right.jpg');
[x,y]=size(image1);
im1=imresize(map, [x,y/3]);
im2=im2bw(im1, 0.7);
im2=uint8(im2);
handles.F = image1 .* cat(3, im2, im2, im2);
imagesc(handles.F);
axis off;
guidata(hObject, handles);
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
