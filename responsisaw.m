function varargout = responsisaw(varargin)
% RESPONSISAW MATLAB code for responsisaw.fig
%      RESPONSISAW, by itself, creates a new RESPONSISAW or raises the existing
%      singleton*.
%
%      H = RESPONSISAW returns the handle to a new RESPONSISAW or the handle to
%      the existing singleton*.
%
%      RESPONSISAW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESPONSISAW.M with the given input arguments.
%
%      RESPONSISAW('Property','Value',...) creates a new RESPONSISAW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before responsisaw_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to responsisaw_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help responsisaw

% Last Modified by GUIDE v2.5 26-Jun-2021 12:39:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @responsisaw_OpeningFcn, ...
                   'gui_OutputFcn',  @responsisaw_OutputFcn, ...
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


% --- Executes just before responsisaw is made visible.
function responsisaw_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to responsisaw (see VARARGIN)

% Choose default command line output for responsisaw
handles.output = hObject;
%menampilkan data
opts = detectImportOptions('datarmh.xlsx');
opts.SelectedVariableNames = (1);
data1 = readmatrix('datarmh.xlsx',opts);

opts = detectImportOptions('datarmh.xlsx');
opts.SelectedVariableNames = (3:8);
data2 = readmatrix('datarmh.xlsx',opts);
%memasukkan data ke tabel 1
data = [data1 data2];
set(handles.datarumah,'data',data);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes responsisaw wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = responsisaw_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in proses.
function proses_Callback(hObject, eventdata, handles)
% hObject    handle to proses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
opts = detectImportOptions('datarmh.xlsx');
opts.SelectedVariableNames = (3:8);

x = readmatrix('datarmh.xlsx',opts);
w = [0.3,0.2,0.23,0.1,0.07,0.1]; %bobot kriteria
k = [0, 1, 1, 1, 1, 1]; %jenis kriteria, 1 = keuntungan, 0 = biaya

[m,n]=size (x); 
R=zeros (m,n);
for j=1:n
    if k(j)==1
        %normalisasi kriteria keuntungan
        R(:,j)=x(:,j)./max(x(:,j));
    else
        %normalisasi kriteria cost
        R(:,j)=min(x(:,j))./x(:,j);
    end
end
%perhitungan hasil perankingan
for i=1:m
 V(i)= sum(w.*R(i,:));
end
%menampilkan hasil perhitungan rumah
Vtranspose=V.'; 
Vtranspose=num2cell(Vtranspose);
opts = detectImportOptions('datarmh.xlsx');
opts.SelectedVariableNames = (2);
x2= readtable('datarmh.xlsx',opts);
x2 = table2cell(x2);
x2=[x2 Vtranspose];
x2=sortrows(x2,-2);
x2 = x2(:,1);
%memasukkan data hasil perhitungan ke tabel 2
set(handles.uitable2, 'data', x2);

B = sort(V, 'descend'); %sorting dari terbesar
