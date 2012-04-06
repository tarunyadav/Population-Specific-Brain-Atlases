function varargout = complete_reg(varargin)
% COMPLETE_REG MATLAB code for complete_reg.fig
%      COMPLETE_REG, by itself, creates a new COMPLETE_REG or raises the existing
%      singleton*.
%
%      H = COMPLETE_REG returns the handle to a new COMPLETE_REG or the handle to
%      the existing singleton*.
%
%      COMPLETE_REG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPLETE_REG.M with the given input arguments.
%
%      COMPLETE_REG('Property','Value',...) creates a new COMPLETE_REG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before complete_reg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to complete_reg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help complete_reg

% Last Modified by GUIDE v2.5 05-Apr-2012 22:44:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @complete_reg_OpeningFcn, ...
                   'gui_OutputFcn',  @complete_reg_OutputFcn, ...
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


% --- Executes just before complete_reg is made visible.
function complete_reg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to complete_reg (see VARARGIN)

%------------------ADDED----------------------------

handles.src = '';
handles.dst = '';
handles.det_algo='Point Detection';
handles.map_algo='Point Mapping';
handles.avg_algo='One step averaging';
handles.templates(1)=struct('template',[]);
%handles.h = get(gcf,'Children');
handles.image='';
handles.dst_images='';


%-----------------FINISH-----------------------------

% Choose default command line output for complete_reg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes complete_reg wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = complete_reg_OutputFcn(hObject, eventdata, handles) 
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
handles.src=uigetfile({'*.dcm','All DICOM Image Files';...
          '*.*','All Files' },'Select a Source File',...
          'image.jpg');
% Save the handles structure.
guidata(hObject,handles)
set(handles.listbox1, 'String',[handles.src]);
subplot(handles.src_init); 
imshow(dicomread(sprintf('images/%s',handles.src)),[]);

% --- Executes on button press in choose_dst.
function choose_dst_Callback(hObject, eventdata, handles)
% hObject    handle to choose_dst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles.dst=uigetfile({'*.dcm','All DICOM Image Files';...
          '*.*','All Files' },'Select Destination Files',...
          'image.jpg','MultiSelect','on');
src=get(handles.listbox1,'String');
handles.dst=[src, cellstr(handles.dst)];
set(handles.listbox1, 'String',[handles.dst]);
set(handles.listbox2, 'String',[handles.dst]);
set(handles.listbox3, 'String',[handles.dst]);
handles.dst_images = handles.dst;
handles.src=handles.dst_images{1};
subplot(handles.src_init); 
imshow(dicomread(sprintf('images/%s',handles.src)),[]);
% Save the handles structure.
guidata(hObject,handles)

% --- Executes on button press in det_run. 
function det_run_Callback(hObject, eventdata, handles)
% hObject    handle to det_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 [a b]=size(handles.dst_images);
 
switch handles.det_algo;
     case 'Point Detection'
       % handles.dst_posinit = zeros(b);
        disp('Applying Point Detection for all given images...')
        for i = 1: b
                disp(handles.dst_images(i));
                handles.dst_posinit(i)=struct('points',affdemo2(handles.dst_images{i},25));
        end     
         subplot(handles.src_det);
         imshow(dicomread(sprintf('images/%s',handles.dst_images{1})),[]), hold on
         showellipticfeatures(handles.dst_posinit(1).points,[1 0 1]);        
         disp('Point Detection Over...')
     %case not used in GUI
    case 'Line Detection(Hough Transformation)'
        disp('Applying Line Detection for all given images...')
        
        for i = 1: b
            disp(handles.dst_images(i));
             [src_lines dst_lines src_points dst_points]= line_detection_hough(handles.dst_images{1},handles.dst_images{i});
             handles.src_lines(i)  = struct('lines',src_lines); 
             handles.dst_lines(i)=struct('lines',dst_lines);
             handles.src_points(i)=struct('points',src_points);
             handles.dst_points(i)=struct('points',dst_points);
        end
       
        subplot(handles.src_det);
        imshow(dicomread(sprintf('images/%s',handles.dst_images{2})),[]), hold on
        for k = 1:length(handles.dst_lines(1).lines)
             xy = [handles.dst_lines(1).lines(k,1:2); handles.dst_lines(1).lines(k,3:4,1)];
            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
            % Plot beginnings and ends of lines
            plot(xy(1,1),xy(1,2),'x','LineWidth',1,'Color','yellow');
            plot(xy(2,1),xy(2,2),'x','LineWidth',1,'Color','red');
        end
       disp('Lines Detection Over...')
    case 'Approx. Using Edges'
                disp('Applying Line Detection using Polygon approx. for all given images...')
                [src_lines src_points ]= line_detection_polygon(handles.dst_images{1},5);
                for i = 1: b
                    disp(handles.dst_images(i));
                     [dst_lines dst_points]=line_detection_polygon(handles.dst_images{i},5);
                     handles.src_lines(i)  = struct('lines',src_lines); 
                     handles.dst_lines(i)=struct('lines',dst_lines);
                     handles.src_points(i)=struct('points',src_points);
                     handles.dst_points(i)=struct('points',dst_points);
                end

                subplot(handles.src_det);
                imshow(dicomread(sprintf('images/%s',handles.dst_images{2})),[]), hold on
                for k = 1:length(handles.dst_lines(1).lines)
                     xy = [handles.dst_lines(1).lines(k,1:2); handles.dst_lines(1).lines(k,3:4,1)];
                    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
                    % Plot beginnings and ends of lines
                    plot(xy(1,1),xy(1,2),'x','LineWidth',1,'Color','yellow');
                    plot(xy(2,1),xy(2,2),'x','LineWidth',1,'Color','red');
                end
               disp('Lines Detection using Polygon approx.  Over...')
end
 % Save the handles structure.
 guidata(hObject,handles)


% --- Executes on button press in map_run.
function map_run_Callback(hObject, eventdata, handles)
% hObject    handle to map_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[a b]=size(handles.dst_images);
switch handles.map_algo;
     
    case 'Point Mapping'
        disp('Applying Point Mapping for all given images...')
        %transformation(1,:)=[0,0,0,0,0];
        %transformation_config(1)=struct('config',[]);
        % initialization of Matrix contating all transformations
         transformations=[];
         max_x = 70;max_y=70;max_theta = 80;
         for i = -max_x:5:max_x
             for j = -max_y:5:max_y
                 for theta = -max_theta:5:max_theta
                   %for s = .8:.2:1.2  
                     d(1,1) = i;
                     d(1,2) = j;
                     d(1,3) = theta;
                     d(1,4) = 0;
                     d(1,5) = 0;
                     transformations = [transformations ; d];
                   %end
                 end
             end
         end
         for i = 1: b
            [transformation(i,:) config]= feature_mapping(transformations,transpose(handles.dst_posinit(1).points(:,1:2)),transpose(handles.dst_posinit(i).points(:,1:2)),5,5,5,handles.dst_images{i});
            transformation_config(i)=struct('config',config);
         end
         disp('Point Mapping is over...')
    case 'Line Mapping'
            disp('Applying Line Mapping for all given images...')
             % initialization of Matrix contating all transformations
             transformations=[];
             max_x = 70;max_y=70;max_theta = 80;
             for i = -max_x:5:max_x
                 for j = -max_y:5:max_y
                     for theta = -max_theta:5:max_theta
                       %for s = .8:.2:1.2  
                         d(1,1) = i;
                         d(1,2) = j;
                         d(1,3) = theta;
                         d(1,4) = 0;
                         d(1,5) = 0;
                         transformations = [transformations ; d];
                       %end
                     end
                 end
             end
            %transformation(1,:)=[0,0,0,0,0];
            %transformation_config(1)=struct('config',[]);
            for i = 1: b
                [transformation(i,:) config]=line_mapping(transformations,handles.src_lines(i).lines,handles.dst_lines(i).lines,transpose(handles.src_points(i).points),transpose(handles.dst_points(i).points),5,5,5,handles.dst_images{i});
                transformation_config(i)=struct('config',config);
            end
            disp('Line Mapping is over...')
end
trans_X =transformation(2,1);
trans_Y = transformation(2,2);
theta = -1*transformation(2,3);

%T = maketform('affine',[cos(pi*theta/180) -sin(pi*theta/180) 0; sin(pi*theta/180) cos(pi*theta/180) 0; 0 0 1]);
%tformfwd([trans_X trans_Y],T);
%REGISTERED= imtransform(dicomread(sprintf('images/%s',handles.dst_images{2})),T);
image=dicomread(sprintf('images/%s',handles.dst_images{1}));
REGISTERED=imrotate(image,theta,'bilinear','crop');
T = maketform('affine',[1 0 0; 0 1 0; trans_X trans_Y 1]);
REGISTERED= imtransform(REGISTERED,T,'XData',[1 size(REGISTERED,2)],'YData',[1 size(REGISTERED,1)]);
subplot(handles.dst_map);
imshow(REGISTERED,[]); 
set(handles.translation_x,'String',transformation(2,1));
set(handles.translation_y,'String',transformation(2,2));
set(handles.rotation,'String',transformation(2,3));
set(handles.votes,'String',transformation(2,5));
% Save the handles structure.
handles.transformation = transformation;
handles.transformation_config = transformation_config;
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


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=get(hObject, 'String');
image = get(hObject,'Value');
%handles.image2=str{image};
%disp(handles.image)
subplot(handles.src_init);
imshow(dicomread(sprintf('images/%s',str{image})),[]); hold on
% Save the handles structure.
 guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
% contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=get(hObject, 'String');
image = get(hObject,'Value');
%unit = get(hObject,'Units');
%handles.image=str{image};
switch handles.det_algo;
    case 'Point Detection'
        subplot(handles.src_det);
        dst_posinit=affdemo2(str{image}, 50);
        %disp(handles.src_posinit(image));
        imshow(dicomread(sprintf('images/%s',str{image})),[]), hold on
        %showellipticfeatures(handles.src_posinit(:,:,1),[1 0 1]);
          showellipticfeatures(dst_posinit,[1 0 1]);
           
    case 'Line Detection(Hough Transformation)'
        %Modify here for only one input for line detection
        [src_lines dst_lines src_points dst_points]=line_detection_hough(str{image},str{image});
        subplot(handles.src_det);
        
        imshow(dicomread(sprintf('images/%s',str{image})),[]), hold on
        for k = 1:length(dst_lines)
             xy = [dst_lines(k,1:2); dst_lines(k,3:4)];
            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
            % Plot beginnings and ends of lines
            plot(xy(1,1),xy(1,2),'x','LineWidth',1,'Color','yellow');
            plot(xy(2,1),xy(2,2),'x','LineWidth',1,'Color','red');
        end
              
    case 'Approx. Using Edges'
         [dst_lines dst_points]=line_detection_polygon(str{image},5);
        subplot(handles.src_det);
        imshow(dicomread(sprintf('images/%s',str{image})),[]), hold on
        for k = 1:length(dst_lines)
             xy = [dst_lines(k,1:2); dst_lines(k,3:4)];
            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
            % Plot beginnings and ends of lines
            plot(xy(1,1),xy(1,2),'x','LineWidth',1,'Color','yellow');
            plot(xy(2,1),xy(2,2),'x','LineWidth',1,'Color','red');
        end
end
 
% Save the handles structure.
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=get(hObject, 'String');
i = get(hObject,'Value');

trans_X = handles.transformation(i,1);
trans_Y = handles.transformation(i,2);
theta = -1*handles.transformation(i,3);
 image=dicomread(sprintf('images/%s',handles.dst_images{1}));
%T = maketform('affine',[cos(pi*theta/180) -sin(pi*theta/180) 0; sin(pi*theta/180) cos(pi*theta/180) 0; 0 0 1]);
%tformfwd([trans_X trans_Y],T);
%REGISTERED= imtransform(image,T,'XData',[1 size(image,2)],'YData',[1 size(image,1)]);
REGISTERED=imrotate(image,theta,'bilinear','crop');
T = maketform('affine',[1 0 0; 0 1 0; trans_X trans_Y 1]);
REGISTERED= imtransform(REGISTERED,T,'XData',[1 size(REGISTERED,2)],'YData',[1 size(REGISTERED,1)]);
subplot(handles.dst_map);
imshow(REGISTERED,[]); hold on
set(handles.translation_x,'String',handles.transformation(i,1));
set(handles.translation_y,'String',handles.transformation(i,2));
set(handles.rotation,'String',handles.transformation(i,3));
set(handles.votes,'String',handles.transformation(i,5));
 guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in select_avg.
function select_avg_Callback(hObject, eventdata, handles)
% hObject    handle to select_avg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns select_avg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_avg
str = get(hObject, 'String');
val = get(hObject,'Value');
handles.avg_algo= str{val};
% Save the handles structure.
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function select_avg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_avg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in avg_run.
function avg_run_Callback(hObject, eventdata, handles)
% hObject    handle to avg_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    switch handles.avg_algo;
        case 'One step averaging'
               %template=zeros(256,256); % hardcoded
               L=length(handles.dst_images);
               for i =  1:L
                    trans_X = -1*handles.transformation(i,1);
                    trans_Y = -1*handles.transformation(i,2);
                     theta = handles.transformation(i,3);
                    image=dicomread(sprintf('images/%s',handles.dst_images{i}));
                    REGISTERED=imrotate(image,theta,'bilinear','crop');
                    T = maketform('affine',[1 0 0; 0 1 0; trans_X trans_Y 1]);
                    REGISTERED= imtransform(REGISTERED,T,'XData',[1 size(REGISTERED,2)],'YData',[1 size(REGISTERED,1)]);
                    if(i==1)
                        template=REGISTERED;
                    else
                        template = template + REGISTERED;
                    end
               end
               K = round(template/L);
               handles.templates(1)= struct('template',K);
        case 'Pair matching(similar)'
                 reg_images=[];
                for i =  1:length(handles.dst_images)
                        trans_X = -1*handles.transformation(i,1);
                        trans_Y = -1*handles.transformation(i,2);
                        theta = handles.transformation(i,3);
                        image=dicomread(sprintf('images/%s',handles.dst_images{i}));
                       REGISTERED=imrotate(image,theta,'bilinear','crop');
                        T = maketform('affine',[1 0 0; 0 1 0; trans_X trans_Y 1]);
                        REGISTERED= imtransform(REGISTERED,T,'XData',[1 size(REGISTERED,2)],'YData',[1 size(REGISTERED,1)]);
                         reg_images= [reg_images; REGISTERED];
                end
                handles.reg_images=reg_images;
                K=template_average(handles.transformation,handles.reg_images,0);
                handles.templates(2)= struct('template',K);
         case 'Pair matching(dissimilar)'   
                reg_images=[];
                for i =  1:length(handles.dst_images)
                        trans_X = -1*handles.transformation(i,1);
                        trans_Y = -1*handles.transformation(i,2);
                        theta = handles.transformation(i,3);
                        image=dicomread(sprintf('images/%s',handles.dst_images{i}));
                        %T = maketform('affine',[cos(pi*theta/180) -sin(pi*theta/180) 0; sin(pi*theta/180) cos(pi*theta/180) 0; 0 0 1]);
                        %REGISTERED= imtransform(image,T,'XData',[1 size(image,2)],'YData',[1 size(image,1)]);
                        REGISTERED=imrotate(image,theta,'bilinear','crop');
                        T = maketform('affine',[1 0 0; 0 1 0; trans_X trans_Y 1]);
                        REGISTERED= imtransform(REGISTERED,T,'XData',[1 size(REGISTERED,2)],'YData',[1 size(REGISTERED,1)]);
                         
                        reg_images= [reg_images; REGISTERED];
                end
                handles.reg_images=reg_images;
                K=template_average(handles.transformation,handles.reg_images,1);
                handles.templates(3)= struct('template',K);
        case 'Median Approach'
                 reg_images=[];
                for i =  1:length(handles.dst_images)
                        trans_X = -1*handles.transformation(i,1);
                        trans_Y = -1*handles.transformation(i,2);
                        theta = handles.transformation(i,3);
                        image=dicomread(sprintf('images/%s',handles.dst_images{i}));
                        %T = maketform('affine',[cos(pi*theta/180) -sin(pi*theta/180) 0; sin(pi*theta/180) cos(pi*theta/180) 0; 0 0 1]);
                        %REGISTERED= imtransform(image,T,'XData',[1 size(image,2)],'YData',[1 size(image,1)]);
                        REGISTERED=imrotate(image,theta,'bilinear','crop');
                        T = maketform('affine',[1 0 0; 0 1 0; trans_X trans_Y 1]);
                        REGISTERED= imtransform(REGISTERED,T,'XData',[1 size(REGISTERED,2)],'YData',[1 size(REGISTERED,1)]);
                        reg_images= [reg_images; REGISTERED];
                end
                handles.reg_images=reg_images;
                [row column] = size(handles.reg_images);
                
                row = row/256;
                no_of_images = row;
               
                K =image;
                for i  = 1:256
                    for j = 1:256
                         i1 = i;   
                         temp=[];
                        for k = 1:no_of_images
                            value = handles.reg_images(i1,j);
                            i1 = i1+256;
                            %disp(i1);
                            temp = [temp value];
                        end
                        temp = sort(temp);
                        if mod(no_of_images,2) == 0
                            final_value = temp(no_of_images/2)+temp((no_of_images/2) + 1);
                            final_value = round(final_value/2);
                            K(i,j) = final_value;
                            
                        else
                            final_value = temp((no_of_images+1)/2);
                            K(i,j) = final_value;
                        end
                    end
                end
                handles.templates(4)= struct('template',K);
    end
    
  subplot(handles.template);
  imshow(K,[])
% Save the handles structure.
guidata(hObject,handles)

% --- Executes on button press in analysis.
function analysis_Callback(hObject, eventdata, handles)
% hObject    handle to analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

analysis(handles.transformation_config,handles.templates)
h=openfig('analysis','reuse');
handles1=guihandles(h);
set(handles1.listbox1, 'String',[handles.dst_images]);
subplot(handles1.graph);
y=handles.transformation_config(2).config(:,5);
x=1:1:size(handles.transformation_config(2).config,1);
disp(size(handles.transformation_config(2).config,1));
plot(x,y)
%disp(handles.templates(2).template(1,1)-handles.templates(1).template(1,1));
image = handles.templates(2).template-handles.templates(1).template;
subplot(handles1.template_diff);
imshow(abs(image),[]);
sum = 0;
 for i = 1:256
     for j = 1:256
         sum = sum + (image(i,j)*image(i,j));
     end
 end
set(handles1.sum_diff,'String',sum);
%subplot(handles1.template_diff);
%imshow(handles.templates(1).template,[]);
