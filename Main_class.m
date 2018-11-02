function varargout = Plate_Number_Extraction(varargin)
% PLATE_NUMBER_EXTRACTION MATLAB code for Plate_Number_Extraction.fig
%      PLATE_NUMBER_EXTRS:\project\Minor Project(with template matching)S:\project\Minor Project(with template matching)S:\project\Minor Project(with template matching)S:\project\Minor Project(with template matching)S:\project\Minor Project(with template matching)S:\project\Minor Project(with template matching)ACTION, by itself, creates a new PLATE_NUMBER_EXTRACTION or raises the existing
%      singleton*.

% 	   created on okilkumarravi-pc
%
%      H = PLATE_NUMBER_EXTRACTION returns the handle to a new PLATE_NUMBER_EXTRACTION or the handle to
%      the existing singleton*.
%
%      PLATE_NUMBER_EXTRACTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLATE_NUMBER_EXTRACTION.M with the given input arguments.
%
%      PLATE_NUMBER_EXTRACTION('Property','Value',...) creates a new PLATE_NUMBER_EXTRACTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Plate_Number_Extraction_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Plate_Number_Extraction_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Plate_Number_Extraction

% Last Modified by GUIDE v2.5 27-Mar-2018 11:20:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Plate_Number_Extraction_OpeningFcn, ...
                   'gui_OutputFcn',  @Plate_Number_Extraction_OutputFcn, ...
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


% --- Executes just before Plate_Number_Extraction is made visible.
function Plate_Number_Extraction_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Plate_Number_Extraction (see VARARGIN)

% Choose default command line output for Plate_Number_Extraction
handles.output = hObject;
a=ones(256,256);
axes(handles.axes1);
imshow(a);

a=ones(200,300);
axes(handles.axes2);
imshow(a);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Plate_Number_Extraction wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Plate_Number_Extraction_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=uigetfile;
axes(handles.axes1);
imshow(a);
a=imread(a);
b=rgb2gray(a);
handles.a=b;
guidata(hObject, handles);

% --- Executes on button press in Segmentation.
function Segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to Segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

b=handles.a;
c=medfilt2(b);
[r m]=size(c);
%converting to binary
for i=1:r
    for j=1:m
        if(c(i,j)>140)
            bw(i,j)=1;
        else
            bw(i,j)=0;
        end
    end
end

e=bwfill(bw,'holes');
[L num]=bwlabel(e);
st=regionprops(L,'all');

MAXX1=0;
idx=0;
for i=1:num
   dd=st(i).Area;
   if(MAXX1<dd)
       MAXX1=dd;
       idx=i;
   end
end

st(idx).Area=0;
MAXX2=0;
for i=1:num
   dd=st(i).Area;
   if(MAXX2<dd)
       MAXX2=dd;
   end
end

st(idx).Area=MAXX1;

for i=1:num
dd=st(i).Area;
	if (dd~=MAXX1 && dd~=MAXX2)
          	L(L==i)=0;
            num=num-1;
    else
         %imshow(L==i);
		end
end

[L2 num2]=bwlabel(L);

st2=regionprops(L2,'All');
st3=regionprops(L2,'extent');
%ndims(st2)
if(num2==1)
  B=st2.BoundingBox;
  Xmin=B(2);
  Xmax=B(2)+B(4);

  Ymin=B(1);
  Ymax=B(1)+B(3);

else
  if(st3(1).Extent>st3(2).Extent)
      B=st2(1).BoundingBox;
      Xmin=B(2);
      Xmax=B(2)+B(4);
      Ymin=B(1);
      Ymax=B(1)+B(3);
  else
      B=st2(2).BoundingBox;
      Xmin=B(2);
      Xmax=B(2)+B(4);
      Ymin=B(1);
      Ymax=B(1)+B(3); 
  end
end


LP=[];

LP=b(Xmin+15:Xmax-10,Ymin+10:Ymax-10);
axes(handles.axes2);
imshow(LP);

handles.LP=LP;


% Update handles structure
guidata(hObject, handles);
% --- Executes on button press in vehicle_2.
function vehicle_2_Callback(hObject, eventdata, handles)
% hObject    handle to vehicle_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vehicle_2
if(get(hObject,'Value')==get(hObject,'Max'))
    handles.z='2-Wheeler'
end
guidata(hObject, handles);

% --- Executes on button press in vehicle_4.
function vehicle_4_Callback(hObject, eventdata, handles)
% hObject    handle to vehicle_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vehicle_4
if(get(hObject,'Value')==get(hObject,'Max'))
    handles.z='4-Wheeler'
end
guidata(hObject, handles);


% --- Executes on button press in Extract.
function Extract_Callback(hObject, eventdata, handles)
% hObject    handle to Extract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
flag=handles.z;
if(flag=='4-Wheeler')
imagen=handles.LP;
threshold = graythresh(imagen);
imagen =~im2bw(imagen,threshold);

%% Remove all object containing fewer than 30 pixels
imagen = bwareaopen(imagen,30);
pause(1)
%% Show image binary image
%figure
%imshow(imagen)

figure
imshow(~imagen);
title('INPUT IMAGE WITHOUT NOISE')
%% Label connected components
[L Ne]=bwlabel(imagen);
%% Measure properties of image regions
propied=regionprops(L,'all');
hold on
%% Plot Bounding Box

for n=1:size(propied,1)
    rectangle('Position',propied(n).BoundingBox,'EdgeColor','r','LineWidth',2)
end
hold off
pause (1)
%% Objects extraction
Output=[]
for n=1:size(propied)
    i=propied(n).Area;
    Output=[Output i];
end

sorted=-sort(-Output);
if(Ne>15)
   sorted2=sorted(15);
elseif(Ne>12)
    sorted2=sorted(12);
else
    sorted2=sorted(10);
end

%sorted2

for i=1:Ne
    if(propied(i).Area<sorted2)
        L(L==i)=0;
        Ne=Ne-1;
    end
end

[L2 num2]=bwlabel(L);
st = regionprops(L2,'All');
stats1 = regionprops(L2, 'Image');
%disp('rifhi')
%disp(Ne)
%disp(num2)

%for i=1:num2
 %   B=st(i).BoundingBox
  %  st(i).Area
%end




%if(flag==2)
minn=100000;
for i=1:num2
    B=st(i).BoundingBox;
    sum=0;
    for j=1:num2
      C=st(j).BoundingBox;
      sum=sum+abs(B(2)-C(2));
    end
    if(minn>sum)
        minn=sum;
        idx=i;
    end
end



req=st(idx).BoundingBox;
disp(' okil')
req(2)

minn=100000;
%disp(num2)

for i=1:num2
    B=st(i).BoundingBox;
    sum=0;
    for j=1:num2
      C=st(j).BoundingBox;
      sum=sum+abs(B(3)-C(3));
    end
    if(minn>sum)
        minn=sum;
        idx=i;
    end
end

width=st(idx).BoundingBox;
disp(' okil')
width(3)

minn=100000;
for i=1:num2
    B=st(i).BoundingBox;
    sum=0;
    for j=1:num2
      C=st(j).BoundingBox;
      sum=sum+abs(B(4)-C(4));
    end
    if(minn>sum)
        minn=sum;
        idx=i;
    end
end

height=st(idx).BoundingBox;
disp('ravi')
height(4)

C=[];
j=1;
figure
for i=1:num2
    B=st(i).BoundingBox;
    if(((abs(width(3)-B(3))<15) ||  (abs(height(4)-B(4))<15)) && (abs(req(2)-B(2))<15))
       disp('result')
       B=st(i).BoundingBox;
       [r,c] = find(L2==i);
       n1=imagen(min(r):max(r),min(c):max(c));
       imshow(~n1);
       pause(1.5)
       
       c = stats1(i);
       C{j} = [c.Image];
       EE = imresize(C{j}, [45 24]);
       EE=imcomplement(EE);
       C{j}=EE;
       j=j+1;
       
       
    end
end

I=C;
result=character(I);

disp('NUMBER PLATE');
disp(result);
set(handles.edit1,'String',result);
handles.data=result;
guidata(hObject, handles);
else
    res=handles.LP;
    [r c]=size(res);
    LP1=res(1:r/2,1:c);
    LP2=res(r/2:r,1:c);

   figure
   imshow(LP1)
   figure
   imshow(LP2)
   
   imagen1=LP1;
   imagen2=LP2;
   
   threshold1 = graythresh(imagen1);
   imagen1 =~im2bw(imagen1,threshold1);
   %% Remove all object containing fewer than 30 pixels
   imagen1 = bwareaopen(imagen1,30);
   pause(1)
   %% Show image binary image
   figure(2)
   imshow(~imagen1);
   title('INPUT IMAGE WITHOUT NOISE')
   %% Label connected components
   [L1 Ne1]=bwlabel(imagen1);
%% Measure properties of image regions
   propied1=regionprops(L1,'all');
   hold on
%% Plot Bounding Box
   for n=1:size(propied1,1)
    rectangle('Position',propied1(n).BoundingBox,'EdgeColor','r','LineWidth',2)
   end
   hold off
   pause (1)
   
   threshold2 = graythresh(imagen2);
   imagen2 =~im2bw(imagen2,threshold2);
   %% Remove all object containing fewer than 30 pixels
   imagen2 = bwareaopen(imagen2,30);
   pause(1)
   %% Show image binary image
   figure(2)
   imshow(~imagen2);
   title('INPUT IMAGE WITHOUT NOISE')
   %% Label connected components
   [L2 Ne2]=bwlabel(imagen2);
%% Measure properties of image regions
   propied2=regionprops(L2,'all');
   hold on
%% Plot Bounding Box
   for n=1:size(propied2,1)
    rectangle('Position',propied2(n).BoundingBox,'EdgeColor','r','LineWidth',2)
   end
   hold off
   pause (1)
 
 
   Output1=[];
   Output2=[];
for n=1:size(propied1)
    i=propied1(n).Area;
    Output1=[Output1 i];
end
   
for n=1:size(propied2)
    i=propied2(n).Area;
    Output2=[Output2 i];
end   

sorted=-sort(-Output1);
if(Ne1>8)
   sorted2=sorted(8);
elseif(Ne1>6)
    sorted2=sorted(6);
else
    sorted2=sorted(4);
end

for i=1:Ne1
    if(propied1(i).Area<sorted2)
        L1(L1==i)=0;
        Ne1=Ne1-1;
    end
end

[L3 num2]=bwlabel(L1);
st1 = regionprops(L3,'All');
stats1 = regionprops(L3, 'Image');


minn=100000;
for i=1:num2
    B=st1(i).BoundingBox;
    sum=0;
    for j=1:num2
      C=st1(j).BoundingBox;
      sum=sum+abs(B(2)-C(2));
    end
    if(minn>sum)
        minn=sum;
        idx=i;
    end
end



req=st1(idx).BoundingBox;
disp('okil')
req(2)

minn=100000;
%disp(num2)

for i=1:num2
    B=st1(i).BoundingBox;
    sum=0;
    for j=1:num2
      C=st1(j).BoundingBox;
      sum=sum+abs(B(3)-C(3));
    end
    if(minn>sum)
        minn=sum;
        idx=i;
    end
end

width=st1(idx).BoundingBox;
disp(' okil')
width(3)

minn=100000;
for i=1:num2
    B=st1(i).BoundingBox;
    sum=0;
    for j=1:num2
      C=st1(j).BoundingBox;
      sum=sum+abs(B(4)-C(4));
    end
    if(minn>sum)
        minn=sum;
        idx=i;
    end
end

height=st1(idx).BoundingBox;
disp(' ravi')
height(4)

C = [];
j=1;
figure
for i=1:num2
    B=st1(i).BoundingBox;
    if(((abs(width(3)-B(3))<15) ||  (abs(height(4)-B(4))<15)) && (abs(req(2)-B(2))<15))
       disp('result')
       B=st1(i).BoundingBox
      [r,c] = find(L3==i);
      n1=imagen1(min(r):max(r),min(c):max(c));
      imshow(~n1);
      pause(1.5)
      
      c = stats1(i);
      C{j} = [c.Image];
      EE = imresize(C{j}, [45 24]);
      EE=imcomplement(EE);
      C{j}=EE;
      j=j+1;
      
      
    end
end

I=C;
result1=character(I);

%disp('NUMBER PLATE');
%disp(result);


disp('dvjhjd')

sorted=-sort(-Output2);
if(Ne2>8)
   sorted2=sorted(8);
elseif(Ne2>=7)
    sorted2=sorted(7);
else
    sorted2=sorted(6);
end

for i=1:Ne2
    if(propied2(i).Area<sorted2)
        L2(L2==i)=0;
        Ne2=Ne2-1;
    end
end

[L4 num2]=bwlabel(L2);
st2 = regionprops(L4,'All');
stats1 = regionprops(L4,'Image');
disp('vvv')
disp(num2)
disp(Ne2)

%for i=1:num2
 %   B=st2(i).BoundingBox
 %   %st2(i).Area
%end


minn=100000;
for i=1:num2
    B=st2(i).BoundingBox;
    sum=0;
    for j=1:num2
      C=st2(j).BoundingBox;
      sum=sum+abs(B(2)-C(2));
    end
    if(minn>sum)
        minn=sum;
        idx=i;
    end
end



req=st2(idx).BoundingBox;
disp(' okil')
req(2)

minn=100000;
%disp(num2)

for i=1:num2
    B=st2(i).BoundingBox;
    sum=0;
    for j=1:num2
      C=st2(j).BoundingBox;
      sum=sum+abs(B(3)-C(3));
    end
    if(minn>sum)
        minn=sum;
        idx=i;
    end
end

width=st2(idx).BoundingBox;
disp(' okil')
width(3)

minn=100000;
for i=1:num2
    B=st2(i).BoundingBox;
    sum=0;
    for j=1:num2
      C=st2(j).BoundingBox;
      sum=sum+abs(B(4)-C(4));
    end
    if(minn>sum)
        minn=sum;
        idx=i;
    end
end

height=st2(idx).BoundingBox;
disp(' ravi')
height(4)

C = [];
j=1;
figure
for i=1:num2
    B=st2(i).BoundingBox;
    if(((abs(width(3)-B(3))<15) ||  (abs(height(4)-B(4))<15)) && (abs(req(2)-B(2))<15))
       disp('result')
       B=st2(i).BoundingBox
      [r,c] = find(L4==i);
      n1=imagen2(min(r):max(r),min(c):max(c));
      imshow(~n1);
      pause(1.5)
      
      c = stats1(i);
      C{j} = [c.Image];
      EE = imresize(C{j}, [45 24]);
      EE=imcomplement(EE);
      C{j}=EE;
      j=j+1;
      
      
    end
end

I=C;
result2=character(I);

disp('NUMBER PLATE');
final_result=strcat(result1,result2);
disp(final_result);
set(handles.edit1,'String',final_result);
handles.data=final_result;

end
guidata(hObject, handles);

% --- Executes on button press in database.
function database_Callback(hObject, eventdata, handles)
% hObject    handle to database (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
add=handles.data;
addDatabase(add);


