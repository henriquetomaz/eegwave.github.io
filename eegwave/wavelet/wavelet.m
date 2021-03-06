
%################################################################################################################################################################%
%                                               UNIVERSIDADE DE SAO PAULO                                                               
%                                                                                                                                   
%                                    FACULDADE DE MEDICINA DE RIBEIRAO PRETO - USP-RP                                                  
%                                                                                                                                   
%                                       LABORATORIO DE INVESTIGA�AO EM EPILEPSIA                                                                                                    
%                                   DR. JOAO PEREIRA LEITE / DR. RODRIGO ROMCY-PEREIRA                                                        
%                                    Anexo A - Departamento de Neurologia (sala-12)                                                  
%                                                Contato: (16) 36024535                                                                  
%                                                                                                                                   
% � COPYRIGHT 05/2007 by                                                                                                                                                                
%     Henrique T. do Amaral Silva                                                                                                                                              
%     Dr. Rodrigo Romcy-Pereira                                                                                                                                                  
%                                                                                                                                       
%                                                                                                                                                                                                                                                             
% The Wavelet module allows the calculation of Wavelet spectogramas and sustained oscillations of multiple animals through the       
% time-frequency analysis using Wavelet transformation. The time-frequency representation (TFR) of biological signals plays an            
% important role in the study the dynamic behaviour [Romcy-Pereira, R.N. et al. 2007].                                                  
% There are many types of wavelets, also known as basis. In this study, we used Morlet wavelet basis for calculating TFRs.  
% The  energy of a signal s(t), in a specific frequency band f0 can be obtined by the convolution. As a result, we obtain the 
% energy content of the signal (e.g., LFP epoch) at a specific time and frequency: an m (time) x n(frequency) matrix. The output 
% can be visualized as an image, where the pixel intensity represents energy and the x-y frame represents the time and frequency, 
% respectively.
% In this analysis is also calculated the Sustained Oscillations and the Frequency Peaks. Individual TFR images were initially 
% binarized to produce a black-and-white TFR image (bTFR) and then, subjected to a sliding-window algorithm that extracts sustained 
% oscillations. Binarization was accomplished by using Otsu's thresholding method implemented in a MatLab routine (imadjust) and 
% its reliability was checked through the compariosn of various TFRs and bTFRs. The sliding window algorithm was designed to sweep 
% bTFR images and extract oscillations lasting >= 600 ms, at seven preset frequency bands with a time resolution of 200ms. 
% In addition, the user can chooose to merge adjacent oscillations separated by a predefined time gap. Oscillatory events are 
% salved as a text file in a table-like format.The global power spectrum of each epoch is also calculated. All frequency
% peaks are selected and a output text file is generated.
%
%==================================================================================================================================
%Inputs
%
%Sampl. Freq.:  LFP Sampling Rate (Fs) 
%Init. Freq:.:  Initial frequency
%Res. Freq. : Resolution frequency
%Final Freq.: Final frequency
%Channels: Channels number of the epochs
%Frequency bands to be analysed:
%            - Lower Limit: Lower limit of the band
%            - Upper Limit: Upper limit of the band
%
%Number of Rats: number of rats of the analysis  (Each rat can has more than one epoch)
%Select Files: input epochs for analysis. For each rat more than one epoch can  be selected
%Prefix of the output files: first name of the output files provide for Wavelet analysis
%
%==================================================================================================================================
%Outputs:
%
%
%        - This module provides 4 Figures for analysis:
%	
%           Figure 1: plot the wavelet transform and its corresponding binarized side by side (per channel).
%           Figure 2: plot the epochs in each channel (per epoch)
%           Figure 3: plot the wavelet transform and peaks frequency (per epoch)
%           Figure 4: plot all the wavelets transforms per canals. Each figure will has the transfor of the channel X of all analyzed epochs.
%
%       - Text files 
%           Text File 1: Sustained Oscillations: This file has the oscillatory events found for each channel. This files have the sufix name '-Oscill.txt'
%           Text File 2: Merge Sutained Oscillations: This file merge the Sustained Oscillations according a resolution.  This files have the sufix name '-Merge-Oscill.txt'
%           Text File 3: Frequency Peaks: This file has all frequency peaks, listing: peak frequencies (HZ) and power at peak frequencies (((uV)^2)/Hz). This files have the sufix name '-Freq.txt'
%
%==================================================================================================================================
%
%################################################################################################################################################################################


function varargout = wavelet(varargin)
% wavelet M-file for wavelet.fig
%      wavelet, by itself, creates a new wavelet or raises the existing
%      singleton*.
%
%      H = wavelet returns the handle to a new wavelet or the handle to
%      the existing singleton*.
%
%      wavelet('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in wavelet.M with the given input arguments.
%
%      wavelet('Property','Value',...) creates a new wavelet or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wavelet_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wavelet_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wavelet

% Last Modified by GUIDE v2.5 23-Nov-2014 19:04:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @wavelet_OpeningFcn, ...
    'gui_OutputFcn',  @wavelet_OutputFcn, ...
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
% --- Executes just before wavelet is made visible.
function wavelet_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wavelet (see VARARGIN)

global cont

% Choose default command line output for wavelet
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wavelet wait for user response (see UIRESUME)
% uiwait(handles.wavelet);

cont=0; % contador para eventuais alteracoes no numero de canais

% --- Outputs from this function are returned to the command line.
function varargout = wavelet_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%####################################################################################################################################
% Frequencia de Amostragem
% --- Executes during object creation, after setting all properties.
function Fs_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Fs_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------------------------------------------
% Frequencia Inicial
% --- Executes during object creation, after setting all properties.
function freqinic_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function freqinic_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------------------------------------------
% Resolucao da Frequencia
% --- Executes during object creation, after setting all properties.
function resfreq_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function resfreq_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------------------------------------------
% Frequencia Final
% --- Executes during object creation, after setting all properties.
function freqfim_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function freqfim_Callback(hObject, eventdata, handles)

%####################################################################################################################################
%  Faixas de Frequencia
% --- Executes during object creation, after setting all properties.
function ffi1_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ffi1_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function ffs1_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ffs1_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function ffi2_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ffi2_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function ffs2_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ffs2_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function ffi3_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ffi3_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function ffs3_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ffs3_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function ffi4_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ffi4_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function ffs4_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ffs4_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function ffi5_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ffi5_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function ffs5_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ffs5_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function ffi6_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ffi6_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function ffs6_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ffs6_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function ffi7_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ffi7_Callback(hObject, eventdata, handles)

%------------------------------------------------------------------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function ffs7_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ffs7_Callback(hObject, eventdata, handles)



%#######################################################################

% Decimal number with comma or dot


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
off = [handles.radio_comma];
mutual_exclude(off)
dotb = 1;
commab = 0;

%####################################################################################################################################

% --- Executes on button press in canal1.
% --> Chamada do Radio Button Canal1.
% --> Call of the Canal1 Radio Button.
function canal1_Callback(hObject, eventdata, handles)

global ch % numero de canais (number of channels)

set(handles.canal1,'Value',1) % seleciona o canal 1 (it selects channel 1)
ch=1;
% Chamar funcao responsavel por realizar exclusao mutua 
% Call function responsible for carrying through mutual exclusion  
off = [handles.canal2,handles.canal3,handles.canal4,handles.canal5,handles.canal6];
mutual_exclude(off)
create_editbox % criar edit box e static box proporcional ao numero de canais

% --- Executes on button press in canal2.
% --> Chamada do Radio Button Canal2.
% --> Call of the Canal2 Radio Button.
function canal2_Callback(hObject, eventdata, handles)

global ch

set(handles.canal2,'Value',1) % seleciona o canal 2 (it selects channel 2)
ch=2;
off = [handles.canal1,handles.canal3,handles.canal4,handles.canal5,handles.canal6];
mutual_exclude(off)
create_editbox 

% --- Executes on button press in canal3.
% --> Chamada do Radio Button Canal3.
% --> Call of the Canal3 Radio Button.
function canal3_Callback(hObject, eventdata, handles)

global ch

set(handles.canal3,'Value',1) % seleciona o canal 3 (it selects channel 3)
ch=3;
off = [handles.canal1,handles.canal2,handles.canal4,handles.canal5,handles.canal6];
mutual_exclude(off)
create_editbox

% --- Executes on button press in canal4.
% --> Chamada do Radio Button Canal4.
% --> Call of the Canal4 Radio Button.
function canal4_Callback(hObject, eventdata, handles)

global ch

set(handles.canal4,'Value',1) % seleciona o canal 4 (it selects channel 4)
ch=4;
off = [handles.canal1,handles.canal2,handles.canal3,handles.canal5,handles.canal6];
mutual_exclude(off)
create_editbox

% --- Executes on button press in canal5.
% --> Chamada do Radio Button Canal5.
% --> Call of the Canal5 Radio Button.
function canal5_Callback(hObject, eventdata, handles)

global ch

set(handles.canal5,'Value',1) % seleciona o canal 5 (it selects channel 5)
ch=5; 
off = [handles.canal1,handles.canal2,handles.canal3,handles.canal4,handles.canal6];
mutual_exclude(off)
create_editbox

% --- Executes on button press in canal6.
% --> Chamada do Radio Button Canal6.
% --> Call of the Canal6 Radio Button
function canal6_Callback(hObject, eventdata, handles)

global ch

set(handles.canal6,'Value',1)  % seleciona o canal 6 (it selects channel 6)
ch=6;
off = [handles.canal1,handles.canal2,handles.canal3,handles.canal4,handles.canal5];
mutual_exclude(off)
create_editbox
%------------------------------------------------------------------------------------------------------------------------------------

% --> Funcao responsavel por criar o numero de static e edit box correspondente ao numero de canais selecionados pelo usuario
function varargout = create_editbox (varargin)

global ch ch2 cont caixa_static caixa_canal

if cont>=1 % se selecionou o numero de canais mais de uma vez
    for i=1:ch2
        set(caixa_static{i},'Visible','off') % apagar static criado pela  selecao anterior
        set(caixa_canal{i},'Visible','off') % apagar edit box criado pela selecao anterior
    end
end

ch2=ch; % sele�ao de canais anterior
cont=cont+1;

caixa_static=cell(1,ch);
caixa_canal=cell(1,ch);

for i=1:ch
    caixa_static{i}  = uicontrol('Tag',['canal',num2str(i)], 'Style', 'text', 'String', ['Channel  ',num2str(i)], 'Position', [50 285-16*(i-1) 80 20],'Visible','on');
    caixa_canal{i}  = uicontrol('BackgroundColor', [1.0 1.0 1.0],'Tag',['canal',num2str(i)], 'Style', 'edit', 'String', ['Channel',num2str(i)], 'Position', [130 289-16*(i-1) 120 20],'Visible','on','Callback',@user_input_Callback);
end

% --> Funcao responsavel por realizar exclusao mutua para o conjunto de Radio Button
% --> Responsible function for carrying through mutual exclusion for the set of Buttons Radio 
function mutual_exclude(off)

set(off,'Value',0) % nao permite que mais de um radio button seja selecionado (it doesnt allow that more than a button radio have been selected)

%------------------------------------------------------------------------------------------------------------------------------------                   

% --> Funcao responsavel por armazenar em uma celula as strings com os nomes dos canais declarados pelo usuario                   
function varargout = user_input_Callback (varargin)

global  caixa_canal ch canalcell

canalcell=cell(1,ch); % celula com os nomes dos canais

for i=1:ch                             
    canalcell{1,i} = get(caixa_canal{i},'String'); % colocar os vetores de tempos na celula (puts the vectors of times in the cell)
end

%---------------------------------------------------------
% --- Executes on button press in load_chan.
function load_chan(hObject, eventdata, handles)

global  caixa_canal ch canalcell
                   
canalcell=cell(1,ch); % celula com os nomes dos canais
for i=1:ch                                 
    canalcell{1,i} = get(caixa_canal{i},'String'); % colocar os vetores de tempos na celula (puts the vectors of times in the cell)
end


%####################################################################################################################################

%Numero de ratos
% --- Executes during object creation, after setting all properties.
function ratos_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ratos_Callback(hObject, eventdata, handles)

%####################################################################################################################################

% Nome do arquivo de saida
% --- Executes during object creation, after setting all properties.
function outputfile_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function outputfile_Callback(hObject, eventdata, handles)

%####################################################################################################################################

% Sele�ao de arquivos
% --- Executes on button press in Select.
function Select_Callback(hObject, eventdata, handles)

global numratos dir_input arq_input n_input Fs vec resoltime q g

numratos = str2num(get(handles.ratos,'String')); % numero de ratos  
arq_input = cell(1,numratos); % celula onde cada coluna contem as epocas do rato correspondente
dir_input = cell(1,numratos); % celula que contem o nome do diretorio das epocas de cada rato

if numratos < 0 
    warndlg(sprintf('Number of subjects must be a positive value.','Warning')) %warning
    uiwait(gcf); 
end
if isempty(numratos) == 1
        warndlg(sprintf('Enter with the number of subjects.','Warning')) %warning
        return;
    uiwait(gcf); 
end

for i=1:numratos
    [arq,dir]=uigetfile('*.*','Multiselect','on',['Select the epochs of subject ' num2str(i)]); % '*.txt'
    if isempty(arq) == 1
        warndlg(sprintf(['Select the epochs of subject ' num2str(i) '.'],'Warning')) %warning
        uiwait(gcf);
        return;
    end
    if iscell(arq) == 0 %if just selected 1 eeg
        arq2 = arq;
        clear arq;
        arq=cell(1,1);
        arq{1,1} = arq2;
    end
    dir_input{1,i} = dir; % armazena na celula com os nomes dos diretorios
    n=size(arq,2);     % n= numero de arquivos de entradas a serem analisados
    n_input(1,i)=n;
    for j=1:n
        disp(['-File ' dir arq{1,j}]);
        arq_input{1,i}(1,1,j) = arq(1,j); % armazena na celula de epocas
    end
end

Fs = str2num(get(handles.Fs,'String')); % frequencia de amostragem

dirtemp = dir_input{1,1};
arqtemp = cell2mat(arq_input{1,1}(1,1,1));
s = [dirtemp arqtemp];
datatemp = load(s);
a = length(datatemp); % numero de pontos das epocas
i=0;
for q=10:a % q deve ser maior que 10
    g=a/q;
    if isposint(g) & g>=16 %limg (g deve ser positivo e maior que 16 pontos
        i=i+1;
        vec(i,1)=q; % numero de quadros
        vec(i,2)=g; % numero de pontos
        resol=(1000*g)/Fs; 
        vec(i,3)=resol; % resolucao
    end
end

set(handles.resolutionmenu,'Enable','on'); % habilitar o popupmenu
set(handles.resolutionmenu,'String',vec(:,3)); % listar as proposta no popupmenu

%Default (primeira opcao)
resoltime = vec(1,3);
q = vec(1,1);
g = vec(1,2);

clear dirtemp arqtemp s datatemp a  % deletar variaveis

%--------------------------------------------------------------------------
%Fun�ao que propoe valores de resoluc�oes de tempo baseado no tamanho da
%epoca (pontos) e na frequencia de amostragem.
% --- Executes during object creation, after setting all properties.
function resolutionmenu_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in resolutionmenu.
function resolutionmenu_Callback(hObject, eventdata, handles)

global vec q g resoltime 

resoltime_vec = str2num(get(handles.resolutionmenu,'String'));
resoltime_index = get(handles.resolutionmenu,'Value');
resoltime = resoltime_vec(resoltime_index);
q = vec(resoltime_index,1);
g = vec(resoltime_index,2);

%####################################################################################################################################

% Roda a rotina quando pressionado o button Ok.
% --- Executes on button press in pushbutton_Ok.
function [TF,timeVec,freqVec,n,dir] = pushbutton_Ok_Callback(hObject, eventdata, handles)

tic

global dir_input arq_input n_input numratos ch canalcell Fs resoltime q g commab dotb

if isempty(dotb) && isempty(commab); 
    dotb = 1; commab = 0; % default
end

load_chan; % carregar os nomes dos canais caso o usuario esquece de pressionar enter

% dir_input  : celula que contem o nome dos diretorios dos epocas selecionadas
% arq_input  : celula com as epocas selecionadas de todos os ratos
% n_input    : numero de epocas escolhidas para cada rato
% numratos   : numero de ratos
% ch         : numero de canais 
% canalcell  : celula com os nomes dos canais selecionados
% resoltime  : resolu�ao de tempo.
% q          : numero de caixas 
% g          : numero de pontos na caixa

%=========================================================================
colorcell=cell(1,6); % celula com nome das cores
colorcell = {[0 0 1], [1 0 0], [0 0 0], [1.0000 0.5020 0], [0.5020 0.5020 0.5020],[0 0.5020 0]}; 
% [0 0 1] = blue
% [1 0 0] = red
% [0 0 0] = black
% [1.0000 0.5020 0] = orange
% [0.5020 0.5020 0.5020] = silver
% [0 0.5020 0] = green

freqinic   = str2num(get(handles.freqinic,'String')); % frequencia inicial
resfreq    = str2num(get(handles.resfreq,'String')); % resolucao de frequencia
freqfim    = str2num(get(handles.freqfim,'String')); % frequencia final 
outputfile = get(handles.outputfile,'String'); % prefixo dos arquivos de saida


%Warnings
if Fs <= 0 || freqinic <= 0 || resfreq <= 0 || freqfim <= 0
    warndlg(sprintf('The input parameters must be greater than 0.','Warning')) % warning
    uiwait(gcf);
    return;
end

if freqinic >= freqfim
    warndlg(sprintf('Final Frequency must be greater than Initial Frequency','Warning')) % warning
    uiwait(gcf); 
    return;
end

if ch <=0
    warndlg(sprintf('Select the number of channels.','Warning')) % warning
    uiwait(gcf);
    return;
end   

% FreqVec
freqVec = freqinic:resfreq:freqfim; % vetor de frequencia

%=========================================================================
% Entrada dos limites das faixas de frequencia. (fo eh obtido do vetor freqVec)
ffi1 = str2num(get(handles.ffi1,'String')); % faixa de frequencia inferior 1
ffs1 = str2num(get(handles.ffs1,'String')); % faixa de frequencia superior 1
ffi2 = str2num(get(handles.ffi2,'String')); % faixa de frequencia inferior 2
ffs2 = str2num(get(handles.ffs2,'String')); % faixa de frequencia superior 2
ffi3 = str2num(get(handles.ffi3,'String')); % faixa de frequencia inferior 3
ffs3 = str2num(get(handles.ffs3,'String')); % faixa de frequencia superior 3
ffi4 = str2num(get(handles.ffi4,'String')); % faixa de frequencia inferior 4
ffs4 = str2num(get(handles.ffs4,'String')); % faixa de frequencia superior 4
ffi5 = str2num(get(handles.ffi5,'String')); % faixa de frequencia inferior 5
ffs5 = str2num(get(handles.ffs5,'String')); % faixa de frequencia superior 5
ffi6 = str2num(get(handles.ffi6,'String')); % faixa de frequencia inferior 6
ffs6 = str2num(get(handles.ffs6,'String')); % faixa de frequencia superior 6
ffi7 = str2num(get(handles.ffi7,'String')); % faixa de frequencia inferior 7
ffs7 = str2num(get(handles.ffs7,'String')); % faixa de frequencia superior 7
%Verificar se existe faixa de frequencia superior menor que faixa de frequencia inferior
ff = [ffi1 ffs1 ffi2 ffs2 ffi3 ffs3 ffi4 ffs4 ffi5 ffs5 ffi6 ffs6 ffi7 ffs7]; % vetor com todas faixas de frequencia

%Warnings (Frenquency bands to be analyzed)
for i=1:(length(ff)-1)
    if ff(i) > ff(i+1)
        warndlg(sprintf('Lower Limit must be less than Upper Limit.','Warning')) % warning
        uiwait(gcf); 
        return; % abortar a funcao e retornar (abort the function and returns)
    end % fim do if
end

%Warning (Output Parameters)
if isempty(outputfile) == 1
    warndlg(sprintf('Enter with the prefix of the outputfiles.','Warning')) % warning
    uiwait(gcf); 
    return; % abortar a funcao e retornar (abort the function and returns)
end % fim do if

   
%=========================================================================

% Estabelece celulas para os dados de entrada (as colunas da celula contem as matrizes dos 
% arquivos .txt de entrada), transformadas wavelets (as colunas da celula contem as matrizes das 
% TF dos arquivos .txt de entrada)e binarizacoes das transformadas (as colunas da celula contem 
% as matrizes das TF binarizadas dos arquivos .txt de entrada)

%Para cada rato
 h = waitbar(0,'Wavelet Transformation... Please Wait');
for rat=1:numratos   
    n = n_input(1,rat); % numero de epocas de cada rato
    dir = dir_input{1,rat}; % diretorio de onde estao as epocas do rato rat
    arq = arq_input{1,rat}; % nome das epocas do rato rat
    
    for j=1:ch % para cada canal
        namechannel =    canalcell{1,j};
        out{1,j} = [outputfile '-SUBJ' num2str(rat) '-' namechannel]; % usado para nomear aquivos de saida
    end % fim do for
    
    % Dados de Entrada
    dado=cell(1,n); 
    % Transformadas Wavelets
    TFCELL=cell(1,n); % celula com as transformada
    % Binarizacoes das Transformadas
    BWCELL=cell(1,n);  
    % Celula que contem as matrizes com a porcentagem de elementos com valor 1 das matrizes BW  dentro da caixa tempo x frequencia estabelecida. (P.ex., 200ms x 3Hz,se fo=1Hz e ff=4Hz)
    % Porcentagem BW
    SCELL=cell(1,n);
    % Celula que armazena os vetores de soma
    SH=cell(ch,n); 
    
    %=========================================================================
    % Carrega os arquivos de entrada como variaveis e calcula as transformadas Wavelets de cada sinal(Normaliza o sinal pelo valor medio do EEG)
    
    % Para cada cada epoca do rato 'rat': carregar as epocas
    
    for i=1:n % para cada epoca selecionada do rato na posicao r
        disp(['-File ' dir arq{1,1,i}]) % mostar a epoca
        s=[dir arq{1,1,i}]; % armazena epoca temporariamente na vairavel s
        if commab == 0 && dotb == 1
            data=load(s); % carregar epoca % data=load(s.acq.data); % carregar epoca
        else
            fileID = fopen(s);
            a = {'%s';'%s %s';'%s %s %s';'%s %s %s %s';'%s %s %s %s %s';'%s %s %s %s %s %s'};
            C = textscan(fileID, a{ch}); %k is number of channels
            fclose(fileID);
            for chind=1:ch
                C2(:,chind) = strrep(C{chind},',', '.');
            end
            data = zeros(length(C{1}),ch);
            for convarr=1:length(C{1})
                for convcol=1:ch
                    data(convarr,convcol)= str2double(C2{convarr,convcol});
                end
            end
            
        end 
        dado{i}=data.*3; % ALTERADO -> multiplica cada valor do sinal por 3 e coloca na celula
        clear fileID a C C2 data
        % Calcular as tranformadas
        % TFR - Energia do sinal Wavelet
        % timeVec - Vetor de Tempo
        % freqVec - Vetor de Frequencia
        
        for j=1:ch % para cada canal de cada epoca 
            waitbar((j*i*rat)/(ch*numratos*n))
            [TFR,timeVec,freqVec]=ondaletarod(dado{i}(:,j),freqVec,Fs,6); % para cada canal ( O que eh o 6????)
            y = length(timeVec);
            x = length(freqVec);   
            TFT(:,:,j) = TFR; 
        end % fim do segundo for
        dado{i}=dado{i}./3; 
        TFCELL{1,i} = TFT; % cada posicao na celula correponde as transformadas dos canais de uma epoca
    end % fim do primeiro for (end of for) 
    
    s=size(TFT);
    
    % Binariza cada imagem de transformada wavelet
    for i=1:n % para cada epoca selecionada
        for j=1:ch % para cada canal de cada epoca                
            H=TFCELL{1,i}(:,:,j); % para cada epoca (i), pegar o canal j
            H16 = uint16(H);
            H16 = imadjust(H16,stretchlim(H16),[0 1]);
            level = graythresh(H16);
            dadoBW = im2bw(H16,level);
            BW(:,:,j) = dadoBW; % colocar uma matriz atras da outra ( cada matriz corresponde a um canal da epoca ) 
            SH{j,i} = sum((TFCELL{1,i}(:,:,j)),2);
        end % fim do segundo for
        BWCELL{1,i}=  BW; % cada posicao na celula corresponde as binarizacoes dos canais de uma epoca.
    end % fim do primeiro for
    s=size(TFT); 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Estabelece as faixas de frequencia a serem utilizadas na analise de oscilacoes sustentadas
    
    fo=freqVec(1);
    ff=freqVec(length(freqVec));
    deltaF=freqVec(2)-freqVec(1);
    indiceFf=(ff-fo)/deltaF;   
    deltaT=timeVec(2)-timeVec(1);
    
    % Estabelece o numero de elementos (ptos) dentro de cada faixa de frequencia num intervalo de 200ms (100ptos quando Fs=500Hz)    
    p1=(1/deltaF)*(ffs1-ffi1)*g;  
    p2=(1/deltaF)*(ffs2-ffi2)*g;
    p3=(1/deltaF)*(ffs3-ffi3)*g;
    p4=(1/deltaF)*(ffs4-ffi4)*g;
    p5=(1/deltaF)*(ffs5-ffi5)*g;
    p6=(1/deltaF)*(ffs6-ffi6)*g;
    p7=(1/deltaF)*(ffs7-ffi6)*g;
    
    % Estabelece os limites no eixo da frequencia dentro da  matriz binarizada (#da linha; matriz BW que contem elementos com valor 0 
    % ou 1) onde serao contados aqueles com valor=1.
    
    k1=round((ffs1-fo)/deltaF)+1; %
    k2=round((ffs2-fo)/deltaF)+1;
    k3=round((ffs3-fo)/deltaF)+1;
    k4=round((ffs4-fo)/deltaF)+1;
    k5=round((ffs5-fo)/deltaF)+1;
    k6=round((ffs6-fo)/deltaF)+1;
    k7=round((ffs7-fo)/deltaF)+1;
    
    % Calcula as matrizes S a partir das matrizes BW.
    state = warning;
    warning off;
    
    ST = zeros(7,q,ch);
    for i=1:n  % para cada epoca
        for j=1:ch  % para cada canal de uma epoca
            for p=1:q
                r=(p-1)*g+1;
                s=p*g;
                
                a=sum(sum(BWCELL{1,i}(1:k1,r:s,j),2),1);
                S(1,p,j) = a/p1;
                b=sum(sum(BWCELL{1,i}(k1:k2,r:s,j),2),1);
                S(2,p,j) = b/p2;
                c=sum(sum(BWCELL{1,i}(k2:k3,r:s,j),2),1);
                S(3,p,j) = c/p3;
                d=sum(sum(BWCELL{1,i}(k3:k4,r:s,j),2),1);
                S(4,p,j) = d/p4;
                e=sum(sum(BWCELL{1,i}(k4:k5,r:s,j),2),1);
                S(5,p,j) = e/p5;
                f=sum(sum(BWCELL{1,i}(k5:k6,r:s,j),2),1);
                S(6,p,j) = f/p6;
                g2=sum(sum(BWCELL{1,i}(k6:k7,r:s,j),2),1); 
                S(7,p,j) = g2/p7;
            end 
        end 
        SCELL{1,i} = S; % uma celula com varias epocas
    end 
    
    L=length(SCELL{1,1}(:,:,1)); % tamanho de uma chapa da matriz S(:,:,1) (apenas um canal)
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Figuras %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
   
    % Customiza��o - EPOCA +
    % Wavelet##############################################################
   
    for i=1:n % para cada epoca
        figure; % criar uma figura
        for j=1:ch % para cada canal
            p=2*j-1;
            subplot(2*ch,1,p)
            plot (timeVec, dado{i}(:,j), 'Color', colorcell{1,j})
            colormap(hot);
            if (min(min(dado{i}))) > 0 && (max(max(dado{i}))) > 0
                axis([0 max(timeVec) min(min(dado{i})*0.8) max(max(dado{i})*1.2)])
            end
            if (min(min(dado{i}))) == 0 && (max(max(dado{i}))) > 0
                axis([0 max(timeVec) (max(max(dado{i}))*(-0.1)) max(max(dado{i})*1.2)])
            end
            if (min(min(dado{i}))) == 0 && (max(max(dado{i}))) == 0
                axis([0 max(timeVec) -1 1])
            end
            if (min(min(dado{i}))) < 0 && (max(max(dado{i}))) == 0
                axis([0 max(timeVec) min(min(dado{i})*1.2) min(min(dado{i})*(-0.1))])
            end
            if (min(min(dado{i}))) < 0 && (max(max(dado{i}))) < 0
                axis([0 max(timeVec) min(min(dado{i})*1.2) max(max(dado{i})*0.8)])
            end
            if (min(min(dado{i}))) < 0 && (max(max(dado{i}))) > 0
                axis([0 max(timeVec) min(min(dado{i})*1.2) max(max(dado{i})*1.2)])
            end
            box off;
            set(gca, 'xtick', []);
            title ([canalcell{1,j}],'Color',colorcell{1,j},'FontSize',6)
            ylabel('Amplitude(mV)','FontSize',6)
            subplot(2*ch,1,p+1)
            imagesc(timeVec, freqVec, TFCELL{1,i}(:,:,j));
            title([' Epoch - ' num2str(i)],'FontSize',5) % titulo do subplot (nome do canal)
            axis xy
        end
        nome_fig = [dir outputfile '-SUBJ' num2str(rat)  '-EPOCH-' num2str(i) '-WLT.tif'];
        print(gcf,'-dtiff', nome_fig)
        close;
    end
     %#####################################################################################################       
         
    
    % FIGURA 1: Plota os graficos das transformadas wavelet e suas binarizacoes correspondentes lado a lado (por canal).
    for j=1:ch % criar uma figura para cada canal 
        figure; % criar uma figura     
        for i=1:n % para cada epoca, criar um subplot
            %Plota TF
            p=2*i-1;
            subplot(n,2,p) % faz subplots em nx2
            imagesc(timeVec, freqVec, TFCELL{1,i}(:,:,j));
            title([' Epoch - ' num2str(i)],'FontSize',5) % titulo do subplot (nome do canal)
            axis xy       
            colormap(hot);
            %Plota BW
            subplot(n,2,p+1)
            imagesc(timeVec, freqVec, BWCELL{1,i}(:,:,j));
            title([' Epoch - ' num2str(i)],'FontSize',5) % titulo do subplot ( nome do canal)
            axis xy
        end  % fim do primeiro for
        nome_fig = [dir outputfile '-SUBJ' num2str(rat)  '-WLTBIN-' canalcell{1,j} '.tif'];
        print(gcf,'-dtiff', nome_fig) 
        close;
    end  %end % fim do segundo for

    %=================================================================================================   
    
    % FIGURA 2: Plota as epocas de cada area (por epoca)
    % Subplot dos sinais de cada canal
    pplot = zeros(1,ch);
    for i=1:n % para cada epoca plotar todos os seus canais
        figure;
        title (['EEG - File ' arq{i}(1:end-4) '  # ' num2str(i)],'FontSize',8)
        for j=1:ch % para cada canal
            % Plotar canais no mesmo subplot (sobrepostos)
            subplot(ch+1,1,1)
            hold on;
            pplot(j) = plot(timeVec, dado{i}(:,j),'Color', colorcell{1,j});            
            if (min(min(dado{i}))) > 0 && (max(max(dado{i}))) > 0
                axis([0 max(timeVec) min(min(dado{i})*0.8) max(max(dado{i})*1.2)])
            end
            if (min(min(dado{i}))) == 0 && (max(max(dado{i}))) > 0
                axis([0 max(timeVec) (max(max(dado{i}))*(-0.1)) max(max(dado{i})*1.2)])
            end
            if (min(min(dado{i}))) == 0 && (max(max(dado{i}))) == 0
                axis([0 max(timeVec) -1 1])
            end
            if (min(min(dado{i}))) < 0 && (max(max(dado{i}))) == 0
                axis([0 max(timeVec) min(min(dado{i})*1.2) min(min(dado{i})*(-0.1))])
            end    
            if (min(min(dado{i}))) < 0 && (max(max(dado{i}))) < 0
                axis([0 max(timeVec) min(min(dado{i})*1.2) max(max(dado{i})*0.8)])
            end
            if (min(min(dado{i}))) < 0 && (max(max(dado{i}))) > 0
                axis([0 max(timeVec) min(min(dado{i})*1.2) max(max(dado{i})*1.2)])
            end
            box off;
            set(gca, 'xtick', []);
            ylabel('Amplitude(mV)','FontSize',6)   
            
            %Plotar canais individualmente
            subplot(ch+1,1,j+1)
            plot (timeVec, dado{i}(:,j), 'Color', colorcell{1,j})             
            if (min(min(dado{i}))) > 0 && (max(max(dado{i}))) > 0
                axis([0 max(timeVec) min(min(dado{i})*0.8) max(max(dado{i})*1.2)])
            end
            if (min(min(dado{i}))) == 0 && (max(max(dado{i}))) > 0
                axis([0 max(timeVec) (max(max(dado{i}))*(-0.1)) max(max(dado{i})*1.2)])
            end
            if (min(min(dado{i}))) == 0 && (max(max(dado{i}))) == 0
                axis([0 max(timeVec) -1 1])
            end
            if (min(min(dado{i}))) < 0 && (max(max(dado{i}))) == 0
                axis([0 max(timeVec) min(min(dado{i})*1.2) min(min(dado{i})*(-0.1))])
            end    
            if (min(min(dado{i}))) < 0 && (max(max(dado{i}))) < 0
                axis([0 max(timeVec) min(min(dado{i})*1.2) max(max(dado{i})*0.8)])
            end
            if (min(min(dado{i}))) < 0 && (max(max(dado{i}))) > 0
                axis([0 max(timeVec) min(min(dado{i})*1.2) max(max(dado{i})*1.2)])
            end
            box off;
            set(gca, 'xtick', []);
            title ([canalcell{1,j}],'Color',colorcell{1,j},'FontSize',6) 
            ylabel('Amplitude(mV)','FontSize',6)

                                  
            if j==ch % se for a ultima figura, ativar eixo x
                set(gca, 'xtick', [0:1:max(timeVec)]);
                xlabel('Time (s)','FontSize',6)
            end    
        end 
        nome_fig = [dir outputfile '-SUBJ' num2str(rat) '-Channels-Epoch' num2str(i) '.tif'];
        print(gcf,'-dtiff', nome_fig)
        close;
    end

    
    %============================
    % FIGURA 3: Subplot das transformadas e picos de frequencia (por epoca)
    pplot2 = zeros(1,ch);
    for i=1:n % para cada epoca
        figure;
        for j=1:ch % subplot para cada canal
            subplot (2,4,j)
            imagesc (timeVec,freqVec, TFCELL{1,i}(:,:,j)) % Plota transformadas
            colormap(hot);
            colorbar;                    
            set(colorbar,'FontSize',5.5);
            
            axis xy; 
            xlabel('Time (s)','FontSize',8)
            title ([canalcell{1,j}],'Color',colorcell{1,j},'FontSize',8) 
            
            % Inserir label no eixo y
            if j==1 || j==5
                ylabel('Frequency (Hz)','FontSize',8)
            end
                        
            %Plota intensidade por frequencia     
            subplot (2,4,ch+2)
            hold on;
            pplot2(j) = plot(SH{j,i},freqVec,'Color', colorcell{1,j});
        end
        xlabel('Intensity (uV ^ 2 / Hz )','HorizontalAlignment','right','FontSize',8)%<---
        title (' Intensity  x  Frequency ','FontSize',8)    
        nome_fig = [dir outputfile '-SUBJ' num2str(rat) '-WLT-FreqPeak' 'Epoch' num2str(i) '.tif'];
        print(gcf,'-dtiff', nome_fig)
        close;
    end   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % FIGURA 4
    % Plota todas as wavelets calculadas por canal. Cada figura tera a transformada do canal X de todas as epocas analisadas. 
    for j=1:ch % para cada canal
        figure;
        for i=1:n % para cada epoca
            s=ceil(i/4); % arredondar "p/ cima"
            p=i+4*(s-1);
            sn=ceil(n/4);
            pn=n+4*(sn-1);
            m=ceil(pn/4);
            subplot(m,4,p)
            imagesc (timeVec,freqVec, TFCELL{1,i}(:,:,j)) %The imagesc function scales image data to the full range of the current colormap and displays the image.
            colormap(hot);
            axis xy
            xlabel('Time (s)','FontSize',7)
            if i==1
                canaltemp = canalcell{1,j}; 
                title ([canaltemp ' - ' arq{i}(1:end-4) '  #  ' num2str(i)],'FontSize',7)
                ylabel('Frequency (Hz)','FontSize',7)
            elseif i~=1 & rem(i,4)==1
                title ([arq{i}(1:end-4) '  # ' num2str(i)],'FontSize',7)
                ylabel('Frequency (Hz)','FontSize',7)
            else
                title ([arq{i}(1:end-4) '  # ' num2str(i)],'FontSize',7)
            end
        end
        nome_fig = [dir outputfile '-SUBJ' num2str(rat) '-WLT-' canalcell{1,j} '.tif'];
        print(gcf,'-dtiff', nome_fig)
        close;
    end 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Rotinas
    % sustentada : Calcula as oscilacoes sustentadas
    sustentada(SCELL,resoltime,ch,n,dir,out); 
    % read_SAIDA_sust: Le arquivos de saida da rotina sustentada.m e aglutina oscila�oes separadas por intervalos de tempo menores que <resol> i.e,
    read_SAIDA_sust(0.9,dir,ch,out);
    % freqpeaks: Calcula os picos de Frequencia acumulada e suas potencias em cada canal de EEG analisado
    [powermax,newA] = freqpeaks(TFCELL,freqVec,Fs,n,ch,dir,out);     
    %Limpar variaveis (clear variables)
    clear dado TFCELL BWCELL SCELL SH   
end 

close(gcf);

%####################################################################################################################################
% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
clear all;  %removes all variables, globals, functions and MEX links.
% fecha a janela wavelet
close;
%####################################################################################################################################



