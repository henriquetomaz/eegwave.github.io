%###################################################################################################################################%%
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

function varargout = config(varargin)
% config M-file for config.fig
%      config, by itself, creates a new config or raises the existing
%      singleton*.
%
%      H = config returns the handle to a new config or the handle to
%      the existing singleton*.
%
%      config('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in config.M with the given input arguments.
%
%      config('Property','Value',...) creates a new config or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the G before config_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to config_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help config

% Last Modified by GUIDE v2.5 24-Nov-2014 17:10:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @config_OpeningFcn, ...
                   'gui_OutputFcn',  @config_OutputFcn, ...
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


% --- Executes just before config is made visible.
function config_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to config (see VARARGIN)

global cont % contador

% Choose default command line output for config
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes config wait for user response (see UIRESUME)
% uiwait(handles.config);

cont=0; % contador para eventuais alteracoes no numero de canais

% --- Outputs from this function are returned to the command line.
function varargout = config_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%###########################################################################

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Numero de Canais

% --- Executes during object creation, after setting all properties.
function numchannels_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
                   
function numchannels_Callback(hObject, eventdata, handles)

global ch 

ch = str2num(get(handles.numchannels,'String')); % recebe o numero de canais
%Verificar numero de canais ( Warning para numero de canais fora do limite)
if ch<=0 | ch>6
    warndlg(sprintf('Invalid number of channels. \n Min: 1 - Max: 6.','Warning')) % aviso (warning)
    uiwait(gcf); 
    return; % abortar a funcao e retornar (abort the function and returns)
end
create_editbox

function create_editbox 

global  ch ch2 cont caixa_static caixa_canal

%Veriicar o numero de entradas 
if cont>=1 % se selecionou o numero de canais mais de uma vez
    for i=1:ch2
        set(caixa_static{i},'Visible','off') % apagar static criado pela  selecao anterior
        set(caixa_canal{i},'Visible','off') % apagar edit box criado pela selecao anterior
    end
end

ch2=ch; % seleçao de canais anterior
cont=cont+1;

caixa_static=cell(1,ch); % celula para caixas de texto estaticas
caixa_canal=cell(1,ch); % celula para editbox

% Criar caixas 
for i=1:ch
    if i>=1 & i<=6
        caixa_static{i}  = uicontrol('Tag',['canal',num2str(i)], 'Style', 'text', 'String', ['Channel  ',num2str(i)], 'Position', [20 145-16*(i-1) 80 20],'Visible','on');
        caixa_canal{i}  = uicontrol('BackgroundColor', [1.0 1.0 1.0],'Tag',['canal',num2str(i)],'Style', 'edit', 'String', ['Channel',num2str(i)], 'Position', [100 145-16*(i-1) 120 20],...
            'Visible','on','Callback',@load_chan);
    end  
end


%#####################################################################


% --- Executes on button press in radio_comma.
function radio_comma_Callback(hObject, eventdata, handles)

global commab dotb

set(handles.radio_comma,'Value',1)
commab = 1;
dotb = 0;
off = [handles.radio_dot];
mutual_exclude(off)


% --- Executes on button press in radio_dot.
function radio_dot_Callback(hObject, eventdata, handles)

global dotb commab

set(handles.radio_dot,'Value',1)
dotb = 1;
commab = 0;
off = [handles.radio_comma];
mutual_exclude(off)

% --> Funcao responsavel por realizar exclusao mutua para o conjunto de Radio Button
% --> Responsible function for carrying through mutual exclusion for the set of Buttons Radio 
function mutual_exclude(off)

set(off,'Value',0) % nao permite que mais de um radio button seja selecionado (it doesnt allow that more than a button radio have been selected)



 %#################################################################################
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Numero de Ratos

% --- Executes during object creation, after setting all properties.
function numratos_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function numratos_Callback(hObject, eventdata, handles)

%#################################################################################

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sampling Frequency

% --- Executes during object creation, after setting all properties.
function sampl_freq_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function sampl_freq_Callback(hObject, eventdata, handles)

%##################################################################################

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Seleçao de arquivos (Files select)

% --- Executes on button press in Select.
function Select_Callback(hObject, eventdata, handles)

global arqcell dir n 

numratos = str2num(get(handles.numratos,'String')); % numero de ratos

if numratos < 1
    warndlg(sprintf('Invalid number of subjects. \n Select at least one subject','Warning')) % aviso (warning)
    uiwait(gcf);
    return; % abortar a funcao e retornar (abort the function and returns)
end

arqcell = cell(1,numratos); % celula com eegs de cada rato

for i=1:numratos % para o numero de ratos
    [arq, dir]=uigetfile('*.txt','Multiselect','on',['Select the EEGs / Epochs of subject ' num2str(i)]);
    n(1,i)=size(arq,2);     % n= numero de arquivos de entradas a serem analisados para cada rato
    for j=1:n(1,i) % de um ate o numero de arquivos selecionados para o i
        if (iscell(arq)==0)
            load(arq);
        else
            load(arq{j}); % load files / carrega dos arquivos
        end
    end % fim do segundo for
    arqcell{1,i} = arq; % celula com os EEGs/Epocas carregada
end % fim do primeiro for

set(handles.plot,'Enable','on');

%------------------------------------------------------------------------------------------------------------------------------------                    
% --- Executes on button press in load_chan.
function varargout = load_chan(hObject, eventdata, handles, varargin)

global  caixa_canal ch canalcell
                   
canalcell=cell(1,ch); % celula com os nomes dos canais
for i=1:ch                                 
    canalcell{1,i} = get(caixa_canal{i},'String'); % colocar os vetores de tempos na celula (puts the vectors of times in the cell)
end
%------------------------------------------------------------------------------------------------------------------------------------                    
% Chama a interface principal para plotar os dados de entrada
% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)

global Fs vert horiz ch arqcell canalcell commab dotb

load_chan; % chama funcao para carregar todos os arquivos

Fs = str2num(get(handles.sampl_freq,'String'));
vert = 1; % subject
horiz = 1; % epoch
close gcf;
eegwave_main('eegwave_main',Fs,vert, horiz, ch, arqcell, canalcell, commab, dotb);

%------------------------------------------------------------------------------------------------------------------------------------                    
% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)

clear all;
close;




