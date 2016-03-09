function varargout = eegwave(varargin)
% EEGWAVE M-file for eegwave.fig
%      EEGWAVE, by itself, creates a new EEGWAVE or raises the existing
%      singleton*.
%
%      H = EEGWAVE returns the handle to a new EEGWAVE or the handle to
%      the existing singleton*.
%
%      EEGWAVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EEGWAVE.M with the given input arguments.
%
%      EEGWAVE('Property','Value',...) creates a new EEGWAVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eegwave_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eegwave_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eegwave

% Last Modified by GUIDE v2.5 10-May-2008 21:32:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eegwave_OpeningFcn, ...
                   'gui_OutputFcn',  @eegwave_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before eegwave is made visible.
function eegwave_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eegwave (see VARARGIN)

% Choose default command line output for eegwave
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes eegwave wait for user response (see UIRESUME)
% uiwait(handles.figure1);

dir_root = matlabroot;
dir = ['/Users/henriquetomaz/Desktop/BrainHack/eegwave/eegwave'];

set(hObject, 'Units', 'pixels');
handles.banner = imread([dir filesep 'logo-lab.jpg']); % Read the image file banner.jpg
info = imfinfo([dir filesep 'logo-lab.jpg']); % Determine the size of the image file
position = get(hObject, 'Position');
set(hObject, 'Position', [position(1:2) info.Width + 20 info.Height + 80]);
axes(handles.axes1);
image(handles.banner)
set(handles.axes1,'Visible', 'off','Units', 'pixels', 'Position', [10 60 info.Width info.Height]);

% --- Outputs from this function are returned to the command line.
function varargout = eegwave_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in cont.
function cont_Callback(hObject, eventdata, handles)
eegwave_main;
close(eegwave);

% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
close;
