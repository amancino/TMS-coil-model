function varargout = ComparacionResultados(varargin)
% COMPARACIONRESULTADOS M-file for ComparacionResultados.fig
%      COMPARACIONRESULTADOS, by itself, creates a new COMPARACIONRESULTADOS or raises the existing
%      singleton*.
%
%      H = COMPARACIONRESULTADOS returns the handle to a new COMPARACIONRESULTADOS or the handle to
%      the existing singleton*.
%
%      COMPARACIONRESULTADOS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPARACIONRESULTADOS.M with the given input arguments.
%
%      COMPARACIONRESULTADOS('Property','Value',...) creates a new COMPARACIONRESULTADOS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ComparacionResultados_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ComparacionResultados_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ComparacionResultados

% Last Modified by GUIDE v2.5 02-Dec-2016 16:46:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ComparacionResultados_OpeningFcn, ...
                   'gui_OutputFcn',  @ComparacionResultados_OutputFcn, ...
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


% --- Executes just before ComparacionResultados is made visible.
function ComparacionResultados_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ComparacionResultados (see VARARGIN)

% Choose default command line output for ComparacionResultados
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(0,'userdata',[]);

% UIWAIT makes ComparacionResultados wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ComparacionResultados_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbCargarMed.
function pbCargarMed_Callback(hObject, eventdata, handles)
% hObject    handle to pbCargarMed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f = uigetfile('load');
load(f);
dat = get(0,'userdata');
if (exist('ud','var'))
    dat.medicion = ud;
    set(handles.editE1,'String',num2str(ud.e1));
    set(handles.editE2,'String',num2str(ud.e2));
    set(handles.editE3,'String',num2str(ud.e3));
elseif (exist('simulacion','var'))
    dat.medicion = simulacion;
end

% Correccion de mediciones
corr = [0.9963 1.0028 0.9985];
dat.medicion.Bx = dat.medicion.Bx * corr(1);
dat.medicion.By = dat.medicion.By * corr(2);
dat.medicion.Bz = dat.medicion.Bz * corr(3);

dat.medicion.BxOrig = dat.medicion.Bx;
dat.medicion.ByOrig = dat.medicion.By;
dat.medicion.BzOrig = dat.medicion.Bz;

dat.medicion.XxOrig = dat.medicion.Xx; dat.medicion.YxOrig = dat.medicion.Yx;
dat.medicion.XyOrig = dat.medicion.Xy; dat.medicion.YyOrig = dat.medicion.Yy;
dat.medicion.XzOrig = dat.medicion.Xz; dat.medicion.YzOrig = dat.medicion.Yz;

B = max(abs(dat.medicion.Bx(:)));
dat.medicion.B = B;

hold(handles.axes1,'on');xlim(handles.axes1,[-100 100]);ylim(handles.axes1,[-50 50]);
hold(handles.axes2,'on');xlim(handles.axes2,[-100 100]);ylim(handles.axes2,[-50 50]);
hold(handles.axes3,'on');xlim(handles.axes3,[-100 100]);ylim(handles.axes3,[-50 50]);
dat.medicion.hx = surf(handles.axes1,dat.medicion.Xx,dat.medicion.Yx,dat.medicion.Bx/B); 
dat.medicion.hy = surf(handles.axes2,dat.medicion.Xy,dat.medicion.Yy,dat.medicion.By/B);
dat.medicion.hz = surf(handles.axes3,dat.medicion.Xz,dat.medicion.Yz,dat.medicion.Bz/B);
xlabel(handles.axes1,'X');
ylabel(handles.axes1,'Y');
zlabel(handles.axes1,'Z');
title(handles.axes1,['Bx [z = ' num2str(-dat.medicion.dz) 'mm]']);
title(handles.axes2,['By [z = ' num2str(-dat.medicion.dz -1) 'mm]']);
title(handles.axes3,['Bz [z = ' num2str(-dat.medicion.dz +3.45) 'mm]']);
zlim(handles.axes1,[-1.3 1.3]);
zlim(handles.axes2,[-1.3 1.3]);
zlim(handles.axes3,[-1.3 1.3]);
set(0,'userdata',dat);
CalcularResta(handles);

% --- Executes on button press in pbCargarSim.
function pbCargarSim_Callback(hObject, eventdata, handles)
% hObject    handle to pbCargarSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f = uigetfile('load');
load(f);
dat = get(0,'userdata');
dat.simulacion = simulacion;
dat.simulacion.BxOrig = dat.simulacion.Bx;
dat.simulacion.ByOrig = dat.simulacion.By;
dat.simulacion.BzOrig = dat.simulacion.Bz;

B = max(abs(dat.simulacion.Bx(:)));
dat.simulacion.B = B;

hold(handles.axes1,'on');
hold(handles.axes2,'on');
hold(handles.axes3,'on');
dat.simulacion.hx = surf(handles.axes1,dat.simulacion.Xx,dat.simulacion.Yx,dat.simulacion.Bx/B); 
dat.simulacion.hy = surf(handles.axes2,dat.simulacion.Xy,dat.simulacion.Yy,dat.simulacion.By/B);
dat.simulacion.hz = surf(handles.axes3,dat.simulacion.Xz,dat.simulacion.Yz,dat.simulacion.Bz/B);



xlabel(handles.axes1,'X');
ylabel(handles.axes1,'Y');
zlabel(handles.axes1,'Z');
title(handles.axes1,['Bx [z = ' num2str(-dat.simulacion.dz*1000) 'mm]']);
title(handles.axes2,['By [z = ' num2str(-dat.simulacion.dz*1000 -1) 'mm]']);
title(handles.axes3,['Bz [z = ' num2str(-dat.simulacion.dz*1000 +3.45) 'mm]']);
zlim(handles.axes1,[-1.3 1.3]);
zlim(handles.axes2,[-1.3 1.3]);
zlim(handles.axes3,[-1.3 1.3]);
set(0,'userdata',dat);
CalcularResta(handles);

% --- Executes on button press in cbMed.
function cbMed_Callback(hObject, eventdata, handles)
% hObject    handle to cbMed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dat = get(0,'userdata');
if (get(handles.cbMed,'Value') == 1)
    set(dat.medicion.hx,'visible','on');
    set(dat.medicion.hy,'visible','on');
    set(dat.medicion.hz,'visible','on');
else
    set(dat.medicion.hx,'visible','off');
    set(dat.medicion.hy,'visible','off');
    set(dat.medicion.hz,'visible','off');
end


% --- Executes on button press in cbSim.
function cbSim_Callback(hObject, eventdata, handles)
% hObject    handle to cbSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dat = get(0,'userdata');
if (get(handles.cbSim,'Value') == 1)
    set(dat.simulacion.hx,'visible','on');
    set(dat.simulacion.hy,'visible','on');
    set(dat.simulacion.hz,'visible','on');
else
    set(dat.simulacion.hx,'visible','off');
    set(dat.simulacion.hy,'visible','off');
    set(dat.simulacion.hz,'visible','off');
end
set(dat.resta.hx,'visible','off');
set(dat.resta.hy,'visible','off');
set(dat.resta.hz,'visible','off');



% --- Executes when selected object is changed in panel.
function panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
dat = get(0,'userdata');
if (get(handles.rbMed,'Value') == 1)
    set(dat.simulacion.hx,'visible','off');
    set(dat.simulacion.hy,'visible','off');
    set(dat.simulacion.hz,'visible','off');
    set(dat.medicion.hx,'visible','on');
    set(dat.medicion.hy,'visible','on');
    set(dat.medicion.hz,'visible','on');
    set(dat.resta.hx,'visible','off');
    set(dat.resta.hy,'visible','off');
    set(dat.resta.hz,'visible','off');
    set(handles.cbSim,'Value',0);
    set(handles.cbMed,'Value',1);
elseif (get(handles.rbSim,'Value') == 1)
    set(dat.simulacion.hx,'visible','on');
    set(dat.simulacion.hy,'visible','on');
    set(dat.simulacion.hz,'visible','on');
    set(dat.medicion.hx,'visible','off');
    set(dat.medicion.hy,'visible','off');
    set(dat.medicion.hz,'visible','off');
    set(dat.resta.hx,'visible','off');
    set(dat.resta.hy,'visible','off');
    set(dat.resta.hz,'visible','off');
    set(handles.cbSim,'Value',1);
    set(handles.cbMed,'Value',0);
else
    set(dat.simulacion.hx,'visible','off');
    set(dat.simulacion.hy,'visible','off');
    set(dat.simulacion.hz,'visible','off');
    set(dat.medicion.hx,'visible','off');
    set(dat.medicion.hy,'visible','off');
    set(dat.medicion.hz,'visible','off');
    set(handles.cbSim,'Value',0);
    set(handles.cbMed,'Value',0);
    
    set(dat.resta.hx,'visible','on');
    set(dat.resta.hy,'visible','on');
    set(dat.resta.hz,'visible','on');
end

function [] = CalcularResta(handles)
dat = get(0,'userdata');

if ((isfield(dat,'medicion'))&&(isfield(dat,'simulacion')))
    dat.resta.Bx = dat.simulacion.Bx/dat.simulacion.B - dat.medicion.Bx/dat.medicion.B;
    dat.resta.By = dat.simulacion.By/dat.simulacion.B - dat.medicion.By/dat.medicion.B;
    dat.resta.Bz = dat.simulacion.Bz/dat.simulacion.B - dat.medicion.Bz/dat.medicion.B;
    
    dat.resta.hx = surf(handles.axes1,dat.simulacion.Xx,dat.simulacion.Yx,dat.resta.Bx); 
    dat.resta.hy = surf(handles.axes2,dat.simulacion.Xy,dat.simulacion.Yy,dat.resta.By);
    dat.resta.hz = surf(handles.axes3,dat.simulacion.Xz,dat.simulacion.Yz,dat.resta.Bz);
    
    set(dat.resta.hx,'visible','off');
    set(dat.resta.hy,'visible','off');
    set(dat.resta.hz,'visible','off');
    
    sX = std2(dat.resta.Bx);
    sY = std2(dat.resta.By);
    sZ = std2(dat.resta.Bz);
    
    set(handles.textX,'String',[num2str(100-sX*100) '%']);
    set(handles.textY,'String',[num2str(100-sY*100) '%']);
    set(handles.textZ,'String',[num2str(100-sZ*100) '%']);
end
set(0,'userdata',dat);



function editE1_Callback(hObject, eventdata, handles)
% hObject    handle to editE1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function editE1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editE1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editE2_Callback(hObject, eventdata, handles)
% hObject    handle to editE2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function editE2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editE2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editE3_Callback(hObject, eventdata, handles)
% hObject    handle to editE3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function editE3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editE3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbDeformarSim.
function cbDeformarSim_Callback(hObject, eventdata, handles)
% hObject    handle to cbDeformarSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
e1 = str2double(get(handles.editE1,'String'));
e2 = str2double(get(handles.editE2,'String'));
e3 = str2double(get(handles.editE3,'String'));
e4 = str2double(get(handles.editE4,'String'));


dat = get(0,'userdata');
if (get(handles.cbDeformarSim,'Value') == 1)
    [bx,by,bz] = DeformarCampo(dat.simulacion.BxOrig,dat.simulacion.ByOrig,dat.simulacion.BzOrig,e1,e2,e3,e4);
    dat.simulacion.Bx = bx;
    dat.simulacion.By = by;
    dat.simulacion.Bz = bz;
else
    dat.simulacion.Bx = dat.simulacion.BxOrig;
    dat.simulacion.By = dat.simulacion.ByOrig;
    dat.simulacion.Bz = dat.simulacion.BzOrig;
end
set(0,'userdata',dat);
RecalcularCampos(handles,eventdata);


function RecalcularCampos(handles,eventdata)
    dat = get(0,'userdata');
    
    delete(dat.simulacion.hx);
    delete(dat.simulacion.hy);
    delete(dat.simulacion.hz);
    
    delete(dat.medicion.hx);
    delete(dat.medicion.hy);
    delete(dat.medicion.hz);
    
    delete(dat.resta.hx);
    delete(dat.resta.hy);
    delete(dat.resta.hz);
    
    dat.simulacion.hx = surf(handles.axes1,dat.simulacion.Xx,dat.simulacion.Yx,dat.simulacion.Bx/dat.simulacion.B); 
    dat.simulacion.hy = surf(handles.axes2,dat.simulacion.Xy,dat.simulacion.Yy,dat.simulacion.By/dat.simulacion.B);
    dat.simulacion.hz = surf(handles.axes3,dat.simulacion.Xz,dat.simulacion.Yz,dat.simulacion.Bz/dat.simulacion.B);

    dat.medicion.hx = surf(handles.axes1,dat.medicion.Xx,dat.medicion.Yx,dat.medicion.Bx/dat.medicion.B); 
    dat.medicion.hy = surf(handles.axes2,dat.medicion.Xy,dat.medicion.Yy,dat.medicion.By/dat.medicion.B);
    dat.medicion.hz = surf(handles.axes3,dat.medicion.Xz,dat.medicion.Yz,dat.medicion.Bz/dat.medicion.B);
    
    dat.resta.Bx = dat.simulacion.Bx/dat.simulacion.B - dat.medicion.Bx/dat.medicion.B;
    dat.resta.By = dat.simulacion.By/dat.simulacion.B - dat.medicion.By/dat.medicion.B;
    dat.resta.Bz = dat.simulacion.Bz/dat.simulacion.B - dat.medicion.Bz/dat.medicion.B;
    
    dat.resta.hx = surf(handles.axes1,dat.simulacion.Xx,dat.simulacion.Yx,dat.resta.Bx); 
    dat.resta.hy = surf(handles.axes2,dat.simulacion.Xy,dat.simulacion.Yy,dat.resta.By);
    dat.resta.hz = surf(handles.axes3,dat.simulacion.Xz,dat.simulacion.Yz,dat.resta.Bz);

    sX = std2(dat.resta.Bx);
    sY = std2(dat.resta.By);
    sZ = std2(dat.resta.Bz);
    
    set(handles.textX,'String',[num2str(100-sX*100) '%']);
    set(handles.textY,'String',[num2str(100-sY*100) '%']);
    set(handles.textZ,'String',[num2str(100-sZ*100) '%']);
    
    set(0,'userdata',dat);
    %panel_SelectionChangeFcn(handles.panel, eventdata, handles);
    cbSim_Callback(handles.cbSim, eventdata, handles);
    cbMed_Callback(handles.cbMed, eventdata, handles);
    
    

% --- Executes on button press in cbCompensarMed.
function cbCompensarMed_Callback(hObject, eventdata, handles)
% hObject    handle to cbCompensarMed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
e1 = str2double(get(handles.editE1,'String'));
e2 = str2double(get(handles.editE2,'String'));
e3 = str2double(get(handles.editE3,'String'));
e4 = str2double(get(handles.editE4,'String'));

dat = get(0,'userdata');
if (get(handles.cbCompensarMed,'Value') == 1)
    [bx,by,bz] = CompensarCampo(dat.medicion.BxOrig,dat.medicion.ByOrig,dat.medicion.BzOrig,e1,e2,e3,e4);
    dat.medicion.Bx = bx;
    dat.medicion.By = by;
    dat.medicion.Bz = bz;
else
    dat.medicion.Bx = dat.medicion.BxOrig;
    dat.medicion.By = dat.medicion.ByOrig;
    dat.medicion.Bz = dat.medicion.BzOrig;
end
set(0,'userdata',dat);
RecalcularCampos(handles,eventdata);



function editOffsetX_Callback(hObject, eventdata, handles)
% hObject    handle to editOffsetX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ud = get(0,'userdata');
offsetX = str2double(get(handles.editOffsetX,'String'));
ud.medicion.Xx = ud.medicion.XxOrig + offsetX; 
ud.medicion.Xy = ud.medicion.XyOrig + offsetX;
ud.medicion.Xz = ud.medicion.XzOrig + offsetX;
set(0,'userdata',ud);
RecalcularCampos(handles,eventdata);

% --- Executes during object creation, after setting all properties.
function editOffsetX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOffsetX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editOffsetY_Callback(hObject, eventdata, handles)
% hObject    handle to editOffsetY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ud = get(0,'userdata');
offsetY = str2double(get(handles.editOffsetY,'String'));
ud.medicion.Yx = ud.medicion.YxOrig + offsetY;
ud.medicion.Yy = ud.medicion.YyOrig + offsetY;
ud.medicion.Yz = ud.medicion.YzOrig + offsetY;
set(0,'userdata',ud);
RecalcularCampos(handles,eventdata);

% --- Executes during object creation, after setting all properties.
function editOffsetY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOffsetY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editE4_Callback(hObject, eventdata, handles)
% hObject    handle to editE4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editE4 as text
%        str2double(get(hObject,'String')) returns contents of editE4 as a double


% --- Executes during object creation, after setting all properties.
function editE4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editE4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbAbs.
function cbAbs_Callback(hObject, eventdata, handles)
% hObject    handle to cbAbs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dat = get(0,'userdata');
if (get(handles.cbAbs,'Value') == 1)
    dat.medicion.Bx = abs(dat.medicion.Bx);
    dat.medicion.By = abs(dat.medicion.By);
    dat.medicion.Bz = abs(dat.medicion.Bz);
    
    dat.simulacion.Bx = abs(dat.simulacion.Bx);
    dat.simulacion.By = abs(dat.simulacion.By);
    dat.simulacion.Bz = abs(dat.simulacion.Bz);
else
    dat.medicion.Bx = dat.medicion.BxOrig;
    dat.medicion.By = dat.medicion.ByOrig;
    dat.medicion.Bz = dat.medicion.BzOrig;
    
    dat.simulacion.Bx = dat.simulacion.BxOrig;
    dat.simulacion.By = dat.simulacion.ByOrig;
    dat.simulacion.Bz = dat.simulacion.BzOrig;
end
set(0,'userdata',dat);
RecalcularCampos(handles,eventdata);