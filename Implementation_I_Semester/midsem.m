function varargout = midsem(varargin)
% MIDSEM MATLAB code for midsem.fig
%      MIDSEM, by itself, creates a new MIDSEM or raises the existing
%      singleton*.
%
%      H = MIDSEM returns the handle to a new MIDSEM or the handle to
%      the existing singleton*.
%
%      MIDSEM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MIDSEM.M with the given input arguments.
%
%      MIDSEM('Property','Value',...) creates a new MIDSEM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before midsem_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to midsem_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help midsem

% Last Modified by GUIDE v2.5 04-Mar-2012 22:18:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @midsem_OpeningFcn, ...
                   'gui_OutputFcn',  @midsem_OutputFcn, ...
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


% --- Executes just before midsem is made visible.
function midsem_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to midsem (see VARARGIN)

%------------------ADDED----------------------------

handles.src = 'car2.png';
handles.dst = 'car4.png';
handles.det_algo='Point Detection';
handles.map_algo='Point Mapping';
handles.h = get(gcf,'Children');
%-----------------FINISH-----------------------------

% Choose default command line output for midsem
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes midsem wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = midsem_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in choose_src.
function choose_src_Callback(hObject, eventdata, handles)
% hObject    handle to choose_src (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.src=uigetfile({'*.jpg;*.tif;*.png;*.gif;*.dicom','All Image Files';...
          '*.*','All Files' },'Select a Source File',...
          'image.jpg');
% Save the handles structure.
guidata(hObject,handles)

subplot(handles.h(9)); 
imshow(dicomread(sprintf('images/%s',handles.src)),[]);

% --- Executes on button press in choose_dst.
function choose_dst_Callback(hObject, eventdata, handles)
% hObject    handle to choose_dst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles.dst=uigetfile({'*.jpg;*.tif;*.png;*.gif;*.dicom','All Image Files';...
          '*.*','All Files' },'Select a Destination File',...
          'image.jpg');
% Save the handles structure.
guidata(hObject,handles)

subplot(handles.h(8));
imshow(dicomread(sprintf('images/%s',handles.dst)),[]);

% --- Executes on button press in det_run. 
function det_run_Callback(hObject, eventdata, handles)
% hObject    handle to det_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch handles.det_algo;
    case 'Point Detection'
        subplot(handles.h(6));
        handles.src_posinit=affdemo2(handles.src);
        imshow(dicomread(sprintf('images/%s',handles.src)),[]), hold on
        showellipticfeatures(handles.src_posinit,[1 0 1]);
        
        subplot(handles.h(5));
        handles.dst_posinit=affdemo2(handles.dst);
        imshow(dicomread(sprintf('images/%s',handles.dst)),[]), hold on
        showellipticfeatures(handles.dst_posinit,[1 0 1]);
           
    case 'Line Detection(Hough Transformation)'
        [handles.src_lines handles.dst_lines handles.src_points handles.dst_points]=line_detection_hough(handles.src,handles.dst);
        subplot(handles.h(6));
        
        imshow(dicomread(sprintf('images/%s',handles.src)),[]), hold on
        for k = 1:length(handles.src_lines)
            
            xy = [handles.src_lines(k,1:2); handles.src_lines(k,3:4)];
            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
            % Plot beginnings and ends of lines
            plot(xy(1,1),xy(1,2),'x','LineWidth',1,'Color','yellow');
            plot(xy(2,1),xy(2,2),'x','LineWidth',1,'Color','red');
        end
        
        subplot(handles.h(5));
        imshow(dicomread(sprintf('images/%s',handles.dst)),[]), hold on
        for k = 1:length(handles.dst_lines)
            xy = [handles.dst_lines(k,1:2); handles.dst_lines(k,3:4)];
            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
            % Plot beginnings and ends of lines
            plot(xy(1,1),xy(1,2),'x','LineWidth',1,'Color','yellow');
            plot(xy(2,1),xy(2,2),'x','LineWidth',1,'Color','red');
        end
        
    case 'Approx. Using Edges'
        
end
 % Save the handles structure.
 guidata(hObject,handles)
        
% --- Executes on button press in map_run.
function map_run_Callback(hObject, eventdata, handles)
% hObject    handle to map_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch handles.map_algo;
    case 'Point Mapping'
            transformation= feature_mapping(transpose(handles.src_posinit(:,1:2)),transpose(handles.dst_posinit(:,1:2)),20,20,30);
    case 'Line Mapping'
             transformation =line_mapping(handles.src_lines,handles.dst_lines,transpose(handles.src_points),transpose(handles.dst_points),20,20,5);
end
trans_X = transformation(1,1);
trans_Y = transformation(1,2);
theta = -1*transformation(1,3);
T = maketform('affine',[cos(pi*theta/180) -sin(pi*theta/180) 0; sin(pi*theta/180) cos(pi*theta/180) 0; 0 0 1]);
tformfwd([trans_X trans_Y],T);
REGISTERED= imtransform(dicomread(sprintf('images/%s',handles.src)),T);
subplot(handles.h(4));
imshow(REGISTERED,[]); 
set(handles.translation_x,'String',transformation(1));
set(handles.translation_y,'String',transformation(2));
set(handles.rotation,'String',transformation(3));
set(handles.votes,'String',transformation(5));
% Save the handles structure.
handles.transformation = transformation;
 guidata(hObject,handles)


% --- Executes on selection change in select_det_algo.
function select_det_algo_Callback(hObject, eventdata, handles)
% hObject    handle to select_det_algo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns select_det_algo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_det_algo
% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');
handles.det_algo= str{val};
% Save the handles structure.
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function select_det_algo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_det_algo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in select_map_algo.
function select_map_algo_Callback(hObject, eventdata, handles)
% hObject    handle to select_map_algo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns select_map_algo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_map_algo
% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');
handles.map_algo= str{val};
% Save the handles structure.
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function select_map_algo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_map_algo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function src_init_CreateFcn(hObject, eventdata, handles)
% hObject    handle to src_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate src_init


% --- Executes during object creation, after setting all properties.
function dst_init_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dst_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate dst_init


% --- Executes during object deletion, before destroying properties.
function src_init_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to src_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function src_init_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to src_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
