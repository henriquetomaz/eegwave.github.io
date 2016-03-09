
%###################################################################################################################################%
%                                               UNIVERSIDADE DE SAO PAULO                                                           %    
%                                                                                                                                   %
%                                    FACULDADE DE MEDICINA DE RIBEIRAO PRETO - USP-RP                                               %   
%                                                                                                                                   %
%                                    LABORATORIO DE INVESTIGAÇAO EM EPILEPSIA E SONO                                                %                                                
%                                   DR. JOAO PEREIRA LEITE / DR. RODRIGO ROMCY-PEREIRA                                              %          
%                                    Anexo A - Departamento de Neurologia (sala-12)                                                 % 
%                                                Contato: (16) 36024535                                                             %     
%                                                                                                                                   %
% © COPYRIGHT 05/2007 by                                                                                                            %                                                    
%     Henrique T. do Amaral Silva                                                                                                   %                                           
%     Dr. Rodrigo Romcy-Pereira                                                                                                     %                                             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = merge_oscill(varargin)
% merge_oscill M-file for merge_oscill.fig
%      merge_oscill, by itself, creates a new merge_oscill or raises the existing
%      singleton*.
%
%      H = merge_oscill returns the handle to a new merge_oscill or the handle to
%      the existing singleton*.
%
%      merge_oscill('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in merge_oscill.M with the given input arguments.
%
%      merge_oscill('Property','Value',...) creates a new merge_oscill or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before merge_oscill_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to merge_oscill_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help merge_oscill

% Last Modified by GUIDE v2.5 25-Apr-2008 18:28:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @merge_oscill_OpeningFcn, ...
                   'gui_OutputFcn',  @merge_oscill_OutputFcn, ...
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

% --- Executes just before merge_oscill is made visible.
function merge_oscill_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to merge_oscill (see VARARGIN)

global p

% Choose default command line output for merge_oscill
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes merge_oscill wait for user response (see UIRESUME)
% uiwait(handles.merge_oscill);

p=0; % contador de acionamento do uigetfiles (accountant of drive of uigetfiles)

% Choose default command line output for merge_oscill
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = merge_oscill_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function resol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function resol_Callback(hObject, eventdata, handles)

%==========================================================================
%================================

% --- Executes on button press in select.
function select_Callback(hObject, eventdata, handles)

global arq dir n p n2 morearq caixa_arq ht

set(ht,'Visible','off');
[arq,dir] = uigetfiles('Oscill.txt','Input Files');
arq = sort(arq); %sort for display
n = size(arq,2);

%Verifica se algum arquivo foi selecionado
t=isempty(arq);
if t==1
    return;
end

%Verificar se mais de 10 arquivos foram selecionados
if n> 10
    warndlg(sprintf('          Select only 10 files. \n Press OK to select the files again.'),...
        'Warning')
    uiwait(gcf); % aguardar o button Ok ser pressionado (wait Ok button to be pressured) 
    select_Callback;  % chama a funcao novamente para nova selecao dos arquivos  (it calls the function again for new election of the files) 
end

% Limpar as caixas caso o uigetfiles foi acionado mais de uma vez (Clean the boxes case uigetfiles was set more than once) 
if p>=1 % se o button Select foi acionado mais de uma vez (if Select button was set more than once)
    for i=1:n2
        set(caixa_arq{i},'Visible','off') % ocultar as caixas com os nomes do arquivos selecionados (hide the boxes with the names of the selected files) 
        set(morearq,'Visible','off')
    end % fim do if (end of if)
end % fim do for (end of for) 

n2= size(arq,2); % numero de arquivos de entradas a serem analisados na selecao anterior (number of files of inputs to be analyzed in the previous election) 
p=p+1; % contador de vezes de acionamento do uigetfiles (accountant of times of drive of uigetfiles) 

for i=1:n
    arq{1,i} = arq{1,i}(1:((length(arq{1,i})-11)));
    disp(['-File ' dir  arq{i}])         
    caixa_arq{i}   = uicontrol('Visible','on','BackgroundColor', [1.0 1.0 0.501],'Tag',['editarq',num2str(i)], 'Style', 'edit', 'String', arq{i},'Position', [20 215-19.5*(i-1) 230 20],'Enable','off');
end
   
%==========================================================================

% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)

global dir arq n k ht
resol = str2num(get(handles.resol,'String'));
read_SAIDA_sust(resol,dir,n,arq);

ht=uicontrol('ForegroundColor','r','FontSize',10,'Style', 'text', 'String', 'Done','Position', [4 4 100 20],'Visible','on');

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
clear all; %removes all variables, globals, functions and MEX links.
close;