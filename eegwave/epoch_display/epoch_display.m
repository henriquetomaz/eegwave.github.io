function varargout = epoch_display(varargin)
% EPOCH_DISPLAY M-file for epoch_display.fig
%      EPOCH_DISPLAY, by itself, creates a new EPOCH_DISPLAY or raises the existing
%      singleton*.
%
%      H = EPOCH_DISPLAY returns the handle to a new EPOCH_DISPLAY or the handle to
%      the existing singleton*.
%
%      EPOCH_DISPLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EPOCH_DISPLAY.M with the given input arguments.
%
%      EPOCH_DISPLAY('Property','Value',...) creates a new EPOCH_DISPLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before epoch_display_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to epoch_display_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help epoch_display

% Last Modified by GUIDE v2.5 03-Aug-2008 14:44:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @epoch_display_OpeningFcn, ...
                   'gui_OutputFcn',  @epoch_display_OutputFcn, ...
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


% --- Executes just before epoch_display is made visible.
function epoch_display_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to epoch_display (see VARARGIN)

% Choose default command line output for epoch_display
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes epoch_display wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = epoch_display_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%---------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function numsub_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function numsub_Callback(hObject, eventdata, handles)

%---------------------------------------------------------------------

% --- Executes on button press in Select.
function Select_Callback(hObject, eventdata, handles)

global numsub dir_input arq_input n_input 

htemp = guihandles; %GUIHANDLES Return a structure of handles.
numsub = str2num(get(htemp.numsub,'String'));

arq_input = cell(1,numsub); % celula onde cada coluna contem as epocas do rato correspondente
dir_input = cell(1,numsub); % celula que contem o nome do diretorio das epocas de cada rato

if numsub < 0 
    warndlg(sprintf('Number of subjects must be a positive value.','Warning')) %warning
    uiwait(gcf); 
end
if isempty(numsub) == 1
        warndlg(sprintf('Enter with the number of subjects.','Warning')) %warning
        return;
    uiwait(gcf); 
end

for i=1:numsub
    [arq,dir] = uigetfile('*.txt','Multiselect','on',['Select the epochs of subject ' num2str(i)]);
    if isempty(arq) == 1
        warndlg(sprintf(['Select the epochs of subject ' num2str(i)],'Warning')) %warning
        uiwait(gcf);
        return;
    end    
    dir_input{1,i} = dir; % armazena na celula com os nomes dos diretorios
    n=size(arq,2);     % n= numero de arquivos de entradas a serem analisados
    %Verificar se mais de 30 arquivos foram selecionados
    if n > 30 % se foram selecionados mais de 30 arquivos (capacidade maxima da interface) (if more than 20 files had been selected (maximum capacity of the interface)) 
        warndlg(sprintf('          Select only 30 epochs. \n Press OK to select the epochs again.'),...
            'Warning');
        uiwait(gcf); % aguardar o button Ok ser pressionado (wait Ok button to be pressured) 
        return;
        %Select_Callback;  % chama a funcao novamente para nova selecao dos arquivos  (it calls the function again for new election of the files) 
    end
    
    n_input(1,i)=n; %number of epochs per subject
    for j=1:n
        disp(['-File ' dir arq{1,j}]);
        arq_input{1,i}(1,1,j) = arq(1,j); % armazena na celula de epocas
    end
end
%---------------------------------------------------------------------
% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)

global numsub dir_input arq_input n_input

% Cria uma celula de cores para cada canal
colorcell=cell(1,6); % celula com nome das cores
colorcell = {[0 0 1], [1 0 0], [0 0 0], [1.0000 0.5020 0], [0.5020 0.5020 0.5020],[0 0.5020 0]}; 
% [0 0 1] = blue
% [1 0 0] = red
% [0 0 0] = black
% [1.0000 0.5020 0] = orange
% [0.5020 0.5020 0.5020] = silver
% [0 0.5020 0] = green


close gcf; % close Epoch display

for j=1:numsub % number of subjects
    n = n_input(1,j); % numero de epocas de cada rato
    dir = dir_input{1,j}; % diretorio de onde estao as epocas do rato rat
    arq = arq_input{1,j}; % nome das epocas do rato rat
    figure; % one figure per subject
    for i = 1:n % number of epochs
        nome_arq=[dir arq{1,1,i}]; % armazena epoca temporariamente na vairavel
        name = arq{1,1,i};
        eeg = load(nome_arq); %load epoch
        timeVec=1:size(eeg,1);
        numch=size(eeg,2); %number of channels
        p = zeros(1,numch);
        title_name = [name(1:end-4)];
        subplot(6,5,i)
        hold on; %HOLD ON holds the current plot and all axis properties so that subsequent graphing commands add to the existing graph.
        for K = 1:numch
            p(K) = plot(timeVec, eeg(:,K),'Color', colorcell{1,K});
        end
        
        title(title_name)
        
        ymin = min(min(eeg));
        ymax = max(max(eeg));
             
        if ymin > 0 && ymax > 0
            axis([0 max(timeVec) (ymin*0.8) (ymax*1.2)])
        end
        if ymin == 0 && ymax > 0
            axis([0 max(timeVec) (ymax*(-0.1)) (ymax*1.2)])
        end
        if ymin == 0 && ymax == 0
            axis([0 max(timeVec) -1 1])
        end
        if ymin < 0 && ymax == 0
            axis([0 max(timeVec) (ymin*1.2) (ymin*(-0.1))])
        end    
        if ymin < 0 && ymax < 0
            axis([0 max(timeVec) (ymin*1.2) (ymax*0.8)])
        end
        if ymin < 0 && ymax > 0
            axis([0 max(timeVec) (ymin*1.2) (ymax*1.2)])
        end
        
        axis off
        xlabel('Time'),ylabel('Frequency')      
    end
    nome_fig = ['Subject' num2str(j) '-Epochs.tif'];
    print('-dtiff', nome_fig) 
end

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
close;
