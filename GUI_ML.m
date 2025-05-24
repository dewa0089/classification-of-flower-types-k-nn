function varargout = GUI_ML(varargin)
% GUI_ML MATLAB code for GUI_ML.fig
%      GUI_ML, by itself, creates a new GUI_ML or raises the existing
%      singleton*.
%
%      H = GUI_ML returns the handle to a new GUI_ML or the handle to
%      the existing singleton*.
%
%      GUI_ML('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ML.M with the given input arguments.
%
%      GUI_ML('Property','Value',...) creates a new GUI_ML or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_ML_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_ML_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_ML

% Last Modified by GUIDE v2.5 17-Dec-2024 11:36:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_ML_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_ML_OutputFcn, ...
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


% --- Executes just before GUI_ML is made visible.
function GUI_ML_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_ML (see VARARGIN)

% Choose default command line output for GUI_ML
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_ML wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_ML_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% menampilkan menu open file
[nama_file, nama_path] = uigetfile('*.png');
 
% jika ada file yang dipilih maka akan mengeksekusi perintah di bawahnya
if ~isequal(nama_file,0)
% membaca file citra
Img = imread(fullfile(nama_path, nama_file));
% menampilkan citra pada axes 1
axes(handles.axes1)
imshow(Img)
title('Citra Asli')
% menampilkan nama file citra pada edit1
set(handles.edit1,'String',nama_file)
% menyimpan variabel Img pada lokasi handles
handles.Img = Img;
guidata(hObject, handles)
else
% jika tidak ada file yang dipilih maka akan kembali
return
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img = handles.Img;
% Mengkonversi Gambar RGB ke Gambar grayscale
Img_gray = rgb2gray(Img);
% Konversi Gambar grayscale image Ke binary
 thresh = graythresh(Img_gray);
 bw = im2bw(Img_gray, thresh);
% Operasi Morfologi Gradient
 se = strel('disk', 1); % Create a structuring element (disk of radius 1)
 dilated = imdilate(bw, se);
 eroded = imerode(bw, se);
 bw = dilated - eroded;
% Menampilkan citra biner hasil segmentasi pada axes2
axes(handles.axes2)
imshow(bw)
title('Citra biner')

 % Extract HSV color features
    HSV = rgb2hsv(Img);
    H = HSV(:,:,1);
    S = HSV(:,:,2);
    V = HSV(:,:,3);
    H(~Img_gray) = 0;
    S(~Img_gray) = 0;
    V(~Img_gray) = 0;
    HSV = cat(3,H,S,V);

axes(handles.axes3)
imshow(HSV)
title('Hasil Ekstraksi Warna HSV')

axes(handles.axes4)
imshow(Img_gray)
title('Hasil Ekstraksi Tekstur GLCM')

handles.bw = bw;
guidata(hObject, handles)


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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Memanggil variabel Img dan bw yang ada di lokasi handles
Img = handles.Img;
bw = handles.bw;

% konversi Gambar RGB ke Gambar grayscale
Img_gray = rgb2gray(Img);

HSV = rgb2hsv(Img);
H = HSV(:,:,1);
S = HSV(:,:,2);
V = HSV(:,:,3);
H(~Img_gray) = 0;
S(~Img_gray) = 0;
V(~Img_gray) = 0;
Hue = sum(sum(H))/sum(sum(Img_gray));
Saturation = sum(sum(S))/sum(sum(Img_gray));
Value = sum(sum(V))/sum(sum(Img_gray));


% Menghitung GLCM
glcm = graycomatrix(Img_gray, 'Offset', [0 1]); % You can adjust the offset
stats = graycoprops(glcm); % Extract GLCM features

Contrast = stats.Contrast
Correlation = stats.Correlation
Energy = stats.Energy
Homogeneity = stats.Homogeneity

% Mengisi hasil ekstraksi ciri pada variabel ciri_bunga
ciri_bunga = cell(7,2);
ciri_bunga{1,1} = 'Hue';
ciri_bunga{2,1} = 'Saturation';
ciri_bunga{3,1} = 'Value';
ciri_bunga{4,1} = 'Contrast';
ciri_bunga{5,1} = 'Correlation';
ciri_bunga{6,1} = 'Energy';
ciri_bunga{7,1} = 'Homogeneity';
ciri_bunga{1,2} = Hue;
ciri_bunga{2,2} = Saturation;
ciri_bunga{3,2} = Value;
ciri_bunga{4,2} = Contrast;
ciri_bunga{5,2} = Correlation;
ciri_bunga{6,2} = Energy;
ciri_bunga{7,2} = Homogeneity;

% menampilkan ciri_bunga pada tabel
set(handles.uitable1,'Data',ciri_bunga,'RowName',1:7)
ciri_uji = [%Red,Green,Blue,
    Hue,Saturation,Value,Contrast,Correlation,Energy,Homogeneity];
% menyimpan variabel ciri_uji pada lokasi handles
handles.ciri_uji = ciri_uji;
guidata(hObject, handles)

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ciri_uji = handles.ciri_uji;
% load hasil pelatihan knn
load ciri_database.mat
% standarisasi ciri uji
ciri_ujiZ = (ciri_uji - muZ)./sigmaZ;

% ekstrak PC1 & PC2
PC1 = ciri_ujiZ(:,1);
PC2 = ciri_ujiZ(:,2);

% Mengujikan Hasil Klasifikasi KNN
hasil_uji = predict(Mdl,[PC1,PC2]);

% Menampilkan hasil pengujian pada edit2
set(handles.edit2,'String',hasil_uji)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes2)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes3)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes4)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

set(handles.edit1,'String',[])
set(handles.edit2,'String',[])
set(handles.uitable1,'Data',[])
