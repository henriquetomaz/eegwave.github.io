
%###################################################################################################################################%
%                                               UNIVERSIDADE DE SAO PAULO                                                           %    
%                                                                                                                                   %
%                                    FACULDADE DE MEDICINA DE RIBEIRAO PRETO - USP-RP                                               %   
%                                                                                                                                   %
%                                    LABORATORIO DE INVESTIGA�AO EM EPILEPSIA E SONO                                                %                                                
%                                   DR. JOAO PEREIRA LEITE / DR. RODRIGO ROMCY-PEREIRA                                              %          
%                                    Anexo A - Departamento de Neurologia (sala-12)                                                 % 
%                                                Contato: (16) 36024535                                                             %     
%                                                                                                                                   %
% � COPYRIGHT 05/2007 by                                                                                                            %                                                    
%     Henrique T. do Amaral Silva                                                                                                   %                                           
%     Dr. Rodrigo Romcy-Pereira                                                                                                     %                                             
%
% The eegwave_main is the Graphical User Interface  (GUI) responsible for viewing of the signals 
% (EEGs or Epochs) with the channels overlapping or individually. This GUI
% also allows the definition of the window time (resolution...)  
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = eegwave_main(varargin)

% eegwave_main M-file for eegwave_main.fig
%      eegwave_main, by itself, creates a new eegwave_main or raises the existing
%      singleton*.
%
%      H = eegwave_main returns the handle to a new eegwave_main or the handle to
%      the existing singleton*.
%
%      eegwave_main('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in eegwave_main.M with the given input arguments.
%
%      eegwave_main('Property','Value',...) creates a new eegwave_main or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eegwave_main_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eegwave_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eegwave_main

% Last Modified by GUIDE v2.5 23-Nov-2014 18:31:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @eegwave_main_OpeningFcn, ...
    'gui_OutputFcn',  @eegwave_main_OutputFcn, ...
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

% Esta funcao executa comandos antes que o usuario possa operar na no GUI
% --- Executes just before eegwave_main is made visible.
function eegwave_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eegwave_main (see VARARGIN)

% Choose default command line output for eegwave_main
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes eegwave_main wait for user response (see UIRESUME)
% uiwait(handles.eegwave_main);

global ch_select vert horiz ch arqcell dx canalcell py commab dotb

% % Se o numero de entradas da fun�ao for maior que 4 (ou seja, ha arquivos
% carregados
if nargin > 4

%Inicializa�ao de variaveis.
dx = 2; % janelamento de tempo
py = 0; % acionamento de zoom ou translacao

%Liberar funcionalidades da interfade principal
%Liberar canais
switch ch
    case 1
        set(handles.canal1,'Enable','on');
    case 2
        set(handles.canal1,'Enable','on');
        set(handles.canal2,'Enable','on');    
    case 3
        set(handles.canal1,'Enable','on');
        set(handles.canal2,'Enable','on');
        set(handles.canal3,'Enable','on');
    case 4
        set(handles.canal1,'Enable','on');
        set(handles.canal2,'Enable','on');
        set(handles.canal3,'Enable','on');
        set(handles.canal4,'Enable','on');
        
    case 5
        set(handles.canal1,'Enable','on');
        set(handles.canal2,'Enable','on');
        set(handles.canal3,'Enable','on');
        set(handles.canal4,'Enable','on');
        set(handles.canal5,'Enable','on');
        
    case 6
        set(handles.canal1,'Enable','on');
        set(handles.canal2,'Enable','on');
        set(handles.canal3,'Enable','on');
        set(handles.canal4,'Enable','on');
        set(handles.canal5,'Enable','on');
        set(handles.canal6,'Enable','on');
end

% Liberar GUIAS

if length(arqcell) == 1 && iscell(arqcell{1})==0 % just 1 eeg was select
    % not Enable the guides
elseif length(arqcell) == 1 && iscell(arqcell{1})==1 % just one rat
    set(handles.pushbutton_before1,'Enable','on');
    set(handles.pushbutton_after1,'Enable','on');
else    
    set(handles.pushbutton_before1,'Enable','on');
    set(handles.pushbutton_after1,'Enable','on');
    set(handles.pushbutton_before2,'Enable','on');
    set(handles.pushbutton_after2,'Enable','on');
end

%Liberar Translacao
set(handles.transmais,'Enable','on');
set(handles.transmenos,'Enable','on');
% set(handles.zoomin,'Enable','on');
% set(handles.zoomout,'Enable','on');

%Liberar op�oes de interface
set(handles.window_size,'Enable','on'); 
set(handles.wind_size,'Enable','on');
set(handles.potential_scale,'Enable','on'); 
set(handles.OK_pot_scale,'Enable','on');
set(handles.num_rat, 'string', horiz); % atualiza o numero do mostrador de ratos
set(handles.num_epoch, 'string', vert); % atualiza o numero do mostrador de epoch_save
if(iscell(arqcell{1})==0)
    set(handles.name_file, 'string', arqcell{horiz,vert});
else
    set(handles.name_file, 'string', arqcell{horiz}{vert}); % mostra o nome do arquivo que deve ser plotado
end

ch_select = [0, 0, 0, 0, 0, 0]; % vetor que indica se quais canais fora selecionado
end % fim do if


% --- Outputs from this function are returned to the command line.
function varargout = eegwave_main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%##########################################################################
%######################### File ###########################################
% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function file_open_Callback(hObject, eventdata, handles)
   
[arq,dir] = uigetfile('*','Multiselect','off','Select the file for visualization');
if isequal(dir,0) 
    return
end
file=[dir arq];
open(file);

% --------------------------------------------------------------------
function file_save_as_Callback(hObject, eventdata, handles)

[arq,dir] = uiputfile('*.fig','Output Files');

if isequal(dir,0) || isequal(dir,0)
    return
end
saveas(gca,fullfile(dir,arq));

% --------------------------------------------------------------------

function file_export_Callback(hObject, eventdata, handles)

global hscroll

[arq,dir] = uiputfile('*.jpg','Output Files');

if isequal(dir,0) 
    return   
else 
    
    set(handles.canal1,'Visible','off');
    set(handles.canal2,'Visible','off');
    set(handles.canal3,'Visible','off');
    set(handles.canal4,'Visible','off');
    set(handles.canal5,'Visible','off');
    set(handles.canal6,'Visible','off');
    set(handles.pushbutton_before1,'Visible','off');
    set(handles.pushbutton_after1,'Visible','off');
    set(handles.pushbutton_before2,'Visible','off');
    set(handles.pushbutton_after2,'Visible','off');
    set(handles.window_size,'Visible','off'); 
    set(handles.wind_size,'Visible','off');
    set(handles.potential_scale,'Visible','off'); 
    set(handles.OK_pot_scale,'Visible','off');
    set(handles.num_rat, 'Visible', 'off'); 
    set(handles.num_epoch, 'Visible','off'); 
    set(handles.name_file, 'Visible', 'off'); 
    set(handles.text_x, 'Visible', 'off');
    set(handles.text_y, 'Visible', 'off');
    set(handles.frame1, 'Visible', 'off');
    set(handles.plot_channels, 'Visible', 'off');
    set(handles.exit_Callback, 'Visible', 'off');
    set(handles.text_rat, 'Visible', 'off');
    set(handles.num_rat, 'Visible', 'off');
    set(handles.text_reg, 'Visible', 'off');
    set(handles.num_epoch, 'Visible', 'off');
    set(handles.text_dur, 'Visible', 'off');
    set(handles.tf_file, 'Visible', 'off');
    set(handles.text_dur_seg, 'Visible', 'off');
    set(handles.text_win_size_seg, 'Visible', 'off');
    set(handles.text_win_size, 'Visible', 'off');
    set(handles.text_chan, 'Visible', 'off');
    set(handles.color1,'Visible','off');
    set(handles.color2,'Visible','off');
    set(handles.color3,'Visible','off');
    set(handles.color4,'Visible','off');
    set(handles.color5,'Visible','off');
    set(handles.color6,'Visible','off');
    set(hscroll,'Visible','off'); 
    set(handles.transmais,'Visible','off');
    set(handles.transmenos,'Visible','off');
    set(handles.set_scale,'Visible','off');
    set(handles.uni_set_scale,'Visible','off');
    set(handles.OK_pot_scale,'Visible','off');
    
    saveas(handles.axes1,[dir arq '.jpg'])
        
    set(handles.canal1,'Visible','on');
    set(handles.canal2,'Visible','on');
    set(handles.canal3,'Visible','on');
    set(handles.canal4,'Visible','on');
    set(handles.canal5,'Visible','on');
    set(handles.canal6,'Visible','on');
    set(handles.pushbutton_before1,'Visible','on');
    set(handles.pushbutton_after1,'Visible','on');
    set(handles.pushbutton_before2,'Visible','on');
    set(handles.pushbutton_after2,'Visible','on');
    set(handles.window_size,'Visible','on'); 
    set(handles.wind_size,'Visible','on');
    set(handles.potential_scale,'Visible','on'); 
    set(handles.OK_pot_scale,'Visible','on');
    set(handles.num_rat, 'Visible', 'on'); 
    set(handles.num_epoch, 'Visible','on'); 
    set(handles.name_file, 'Visible', 'on'); 
    set(handles.text_x, 'Visible', 'on');
    set(handles.text_y, 'Visible', 'on');
    set(handles.frame1, 'Visible', 'on');
    set(handles.plot_channels, 'Visible', 'on');
    set(handles.exit_Callback, 'Visible', 'on');
    set(handles.text_rat, 'Visible', 'on');
    set(handles.num_rat, 'Visible', 'on');
    set(handles.text_reg, 'Visible', 'on');
    set(handles.num_epoch, 'Visible', 'on');
    set(handles.text_dur, 'Visible', 'on');
    set(handles.tf_file, 'Visible', 'on');
    set(handles.text_dur_seg, 'Visible', 'on');
    set(handles.text_win_size_seg, 'Visible', 'on');
    set(handles.text_win_size, 'Visible', 'on');
    set(handles.text_chan, 'Visible', 'on');
    set(handles.color1,'Visible','on');
    set(handles.color2,'Visible','on');
    set(handles.color3,'Visible','on');
    set(handles.color4,'Visible','on');
    set(handles.color5,'Visible','on');
    set(handles.color6,'Visible','on');
    set(hscroll,'Visible','on');
    set(handles.transmais,'Visible','on');
    set(handles.transmenos,'Visible','on');
    set(handles.set_scale,'Visible','on');
    set(handles.uni_set_scale,'Visible','on');
    set(handles.OK_pot_scale,'Visible','on');
end

% --------------------------------------------------------------------
% Chama a interface de selecao de arquivos
function file_load_Callback(hObject, eventdata, handles)

%clear all; %removes all variables, globals, functions and MEX links.
clear_eegmain(handles);
%Fun�ao que chama a interface de entrada de dados.
config; % call config interface 

%##########################################################################
%############## Current Directory #########################################
% --------------------------------------------------------------------
function current_directory_Callback(hObject, eventdata, handles)

dir = uigetdir;
%tdir =  isempty(dir); 
if dir == 0
    return;
end
cd (dir);

%##########################################################################
%######################### Analysis ########################################

% --------------------------------------------------------------------
function analysis_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function analysis_epoch_save_Callback(hObject, eventdata, handles)
epoch_save;

% --------------------------------------------------------------------
function analysis_epoch_display_Callback(hObject, eventdata, handles)
epoch_display;

% --------------------------------------------------------------------
function analysis_wavelet_Callback(hObject, eventdata, handles)
wavelet;
% --------------------------------------------------------------------
function analysis_merge_oscill_Callback(hObject, eventdata, handles)
merge_oscill;
% --------------------------------------------------------------------
function analysis_cross_subj_Callback(hObject, eventdata, handles)
cross_subj_analysis;
% --------------------------------------------------------------------
function analysis_coherence_Callback(hObject, eventdata, handles)
coherence;

%##########################################################################
%######################### Help ###########################################

% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function help_homepage_Callback(hObject, eventdata, handles)

web http://www.neuroimago.usp.br/BPT/EEGWave.php -browser;
% --------------------------------------------------------------------
function help_manual_Callback(hObject, eventdata, handles)
%winopen('C:\MATLAB6p5\toolbox\eegwave\ManualEEGWave.pdf');


%##########################################################################
%######################### Clear ###########################################

function clear_Callback(hObject, eventdata, handles)
clear_eegmain(handles);
% --------------------------------------------------------------------
function clear_eegmain(handles)

%Desabilitar canais
set(handles.canal1,'Enable','off','Value',0);
set(handles.canal2,'Enable','off','Value',0);
set(handles.canal3,'Enable','off','Value',0);
set(handles.canal4,'Enable','off','Value',0);
set(handles.canal5,'Enable','off','Value',0);
set(handles.canal6,'Enable','off','Value',0);
set(handles.color1,'Visible','off');
set(handles.color2,'Visible','off');
set(handles.color3,'Visible','off');
set(handles.color4,'Visible','off');
set(handles.color5,'Visible','off');
set(handles.color6,'Visible','off');
% Desabilitar GUIAS
set(handles.pushbutton_before1,'Enable','off');
set(handles.pushbutton_after1,'Enable','off');
set(handles.pushbutton_before2,'Enable','off');
set(handles.pushbutton_after2,'Enable','off');
set(handles.transmais,'Enable','off');
set(handles.transmenos,'Enable','off');
%Desabilitar op�oes de janela
set(handles.potential_scale,'Enable','off','String',[]); 
set(handles.OK_pot_scale,'Enable','off');
set(handles.window_size,'Enable','off','String',2); 
set(handles.wind_size,'Enable','off');
%Desabilitar plot channels
set(handles.plot_channels,'Enable','off')
%Inicializar contadores
set(handles.num_rat, 'string',''); 
set(handles.num_epoch, 'string', ''); 
set(handles.name_file, 'string', ''); 
set(handles.tf_file,'String','');
%Inicializar eixos
set(gca,'XTickMode','manual'); % auto
set(gca,'YTickMode','manual'); % auto
set(gca,'xtick',[]); % clear xtick
set(gca,'ytick',[]); % clear ytick

%Inicializacao da variavel
py = 0; % acionamento de zoom ou translacao
clear all; % clear all variables
cla; % clear the current axes
% --------------------------------------------------------------------
%############################# GUIAS ######################################
% --- Executes on button press in pushbutton_after1.
function pushbutton_after1_Callback(hObject, eventdata, handles)

global vert horiz n dir arqcell

vert = vert+1;
if vert > n(1,horiz) 
    vert = 1;
end
if vert <= 0
    vert = 1;
end
set(handles.num_rat, 'string', horiz) % atualiza o numero do mostrador de ratos
set(handles.num_epoch, 'string', vert) % atualiza o numero do mostrador de epoch_save
set(handles.name_file, 'string', arqcell{horiz}{vert}) % mostra o nome do arquivo plotado
plot_file(vert,horiz); % chama a funcao para plotar 
% --------------------------------------------------------------------
% --- Executes on button press in pushbutton_before1.
function pushbutton_before1_Callback(hObject, eventdata, handles)

global vert horiz n dir arqcell

vert = vert-1;
if vert <= 0 
    vert = n(1,horiz); 
end
if vert > n(1,horiz) 
    vert = 1;
end
set(handles.num_rat, 'string', horiz) % atualiza o numero do mostrador de ratos
set(handles.num_epoch, 'string', vert) % atualiza o numero do mostrador de epoch_save
set(handles.name_file, 'string', arqcell{horiz}{vert}) % mostra o nome do arquivo plotado
plot_file(vert,horiz);
% --------------------------------------------------------------------
% --- Executes on button press in pushbutton_after2.
function pushbutton_after2_Callback(hObject, eventdata, handles)

global vert horiz n dir arqcell

vert = 1; % volta para a primeira epoca do novo rato selecionado
if horiz <= 0 
    horiz = length(n); % numero de colunas da celula 
else if horiz >= length(n) 
        horiz = 1; % numero de colunas da celula 
    else if length(n) == 1  % se exitir epoch_save de apenas um rato
            horiz = 1;
        else
            horiz = horiz+1; % seleciona o proxima rato
        end
    end 
end
set(handles.num_rat, 'string', horiz) % atualiza o numero do mostrador de ratos
set(handles.num_epoch, 'string', vert) % atualiza o numero do mostrador de epoch_save
set(handles.name_file, 'string', arqcell{horiz}{vert}) % mostra o nome do arquivo plotado
plot_file(vert,horiz);
% --------------------------------------------------------------------
% --- Executes on button press in pushbutton_before2.
function pushbutton_before2_Callback(hObject, eventdata, handles)

global vert horiz n dir arqcell

vert = 1; % volta para a primeira epoca do novo rato selecionado
if horiz <= 1 
    horiz = length(n); % numero de colunas da celula 
else if horiz > length(n) 
        horiz = 1; % numero de colunas da celula 
    else if length(n) == 1 % se exitir epoch_save de apenas um rato
            horiz = 1;
        else
            horiz = horiz-1; % seleciona o rato anterior
        end
    end 
end
set(handles.num_rat, 'string', horiz) % atualiza o numero do mostrador de ratos
set(handles.num_epoch, 'string', vert) % atualiza o numero do mostrador de epoch_save
set(handles.name_file, 'string', arqcell{horiz}{vert}) % mostra o nome do arquivo plotado
plot_file(vert,horiz);
%---------------------------------------------------------------------------

%######################## Window Size #################################### 

% --- Executes during object creation, after setting all properties.
function window_size_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function window_size_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
%
% --- Executes during object creation, after setting all properties.
function potential_scale_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function potential_scale_Callback(hObject, eventdata, handles)

%--------------------------------------------------------------------------

function wind_size_Callback(hObject, eventdata, handles)
global vert horiz dx
% dx: is the resolution of the window time
dx = str2num(get(handles.window_size,'string'));
if dx <= 0 
    warndlg(sprintf(['The resolution must be a positive number and greater than 0' ],'Warning')); % warning
    uiwait(gcf);
    dx = 2; 
    set(handles.window_size,'String', 2);
end
plot_file(dx,vert,horiz); % calls the function for plot the sign (EEG/Epoch 1, Rat1)
%---------------------------------------------------------------------------

%######################## Channels ######################################## 
%RadioButtons

% --- Executes on button press in canal1.
function canal1_Callback(hObject, eventdata, handles)

global ch_select canalcell

if get(handles.canal1,'Value') == 1 % se o canal 1 foi selecionado
    set(handles.color1,'String',canalcell{1},'BackgroundColor','w','ForegroundColor',[0 0 1],'Visible','on')
    ch_select(1)=1; 
else 
    set(handles.color1,'Visible','off')
    ch_select(1)=0;
end
select_channels;
 
 % --- Executes on button press in canal2.
 function canal2_Callback(hObject, eventdata, handles)
 
 global ch_select canalcell
 
 if get(handles.canal2,'Value') == 1
     set(handles.color2,'String',canalcell{2},'BackgroundColor','w','ForegroundColor',[1 0 0],'Visible','on')
     ch_select(2)=2; 
 else 
     set(handles.color2,'Visible','off')
     ch_select(2)=0;
 end
 select_channels;
 
% --- Executes on button press in canal3.
function canal3_Callback(hObject, eventdata, handles)

global ch_select canalcell 

if get(handles.canal3,'Value') == 1
    set(handles.color3,'String',canalcell{3},'BackgroundColor','w','ForegroundColor',[0 0 0],'Visible','on')
    ch_select(3)=3;
else
    set(handles.color3,'Visible','off')
    ch_select(3)=0;
end
select_channels;

 % --- Executes on button press in canal4.
 function canal4_Callback(hObject, eventdata, handles)
 
 global ch_select canalcell
 
 if get(handles.canal4,'Value') == 1
     set(handles.color4,'String',canalcell{4},'BackgroundColor','w','ForegroundColor',[1.0000 0.5020 0],'Visible','on')
    ch_select(4)=4; 
else
    set(handles.color4,'Visible','off')
    ch_select(4)=0;
end
select_channels;

 % --- Executes on button press in canal5.
 function canal5_Callback(hObject, eventdata, handles)
 
 global ch_select canalcell
   
 if get(handles.canal5,'Value') == 1
     set(handles.color5,'String',canalcell{5},'BackgroundColor','w','ForegroundColor',[0.5020 0.5020 0.5020],'Visible','on')
    ch_select(5)=5; 
else
    set(handles.color5,'Visible','off')
    ch_select(5)=0;
end
select_channels;

 % --- Executes on button press in canal6.
 function canal6_Callback(hObject, eventdata, handles)
 
 global ch_select canalcell
 
 if get(handles.canal6,'Value') == 1
     set(handles.color6,'String',canalcell{6},'BackgroundColor','w','ForegroundColor',[0 0.5020 0],'Visible','on')
    ch_select(6)=6; 
else
    set(handles.color6,'Visible','off')
    ch_select(6)=0;
end
select_channels;
% --------------------------------------------------------------------
%Fun�ao que verifica quais canais devem ser plotados.
function select_channels (hObject, eventdata, handles)

global ch_select ch_plot horiz vert 
% ch_select: vetor de sele�ao dos canais
% ch_plot: vetor com o canais que devem ser plotados
% horiz e vert: guias
ch_plot = find(ch_select); % procura os indices dos valores diferentes de 0  
plot_file(ch_plot,vert,horiz);

%-----------------------------------------------------------    
%###################################Plotar#################################
% Plotar canais conjuntamente

function varargout = plot_file (hObject, eventdata, handles, varargin)

handles = guihandles(gcf); % recupera os handles da figura corrente

global Fs arqcell dir ch vert horiz a dx dado timeVectrans ch_plot numplots colorcell x y dxtemp hscroll miny maxy ymin ymax py  t1 t2 t3 commab dotb
 
% Fs : Sampling Frequency
% arqcell: celula que contem os EEGs/epoch_save
% dir : diretorio onde se encontram os EEGs/epoch_save
% ch : numero de canais
% vert: vai para a proximo/anterior EEG/Epoca de um rato
% horiz: vai para o proximo/anterior rato
% a: handles do axes1
% dx: tamanho da janela
% dado: EEGs/epoch_save carregada
% timeVecTrans: vetor de tempo
% ch_selec: vetor que contem os canais a ser plotados cnjuntamente
% dx is the width of the axis 'window_size'
% a  handles do axes1
%--------------------------------------------------------------------------

% Cria uma celula de cores para cada canal
colorcell=cell(1,6); % celula com nome das cores
colorcell = {[0 0 1], [1 0 0], [0 0 0], [1.0000 0.5020 0], [0.5020 0.5020 0.5020],[0 0.5020 0]}; 
% [0 0 1] = blue
% [1 0 0] = red
% [0 0 0] = black
% [1.0000 0.5020 0] = orange
% [0.5020 0.5020 0.5020] = silver
% [0 0.5020 0] = green
%--------------------------------------------------------------------------
% Carrega o EEG/Epoca


if isempty(dotb) && isempty(commab); 
    dotb = 1; commab = 0; % default
end

if iscell(arqcell{1})==0
    if commab == 0 && dotb == 1 % if dot
        dado = load(arqcell{horiz,vert}); % just 1 eeg
    else
        fileID = fopen([dir arqcell{horiz,vert}]);
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
        dado = data; % just 1 eeg
    end
else
    if commab == 0 && dotb == 1 % if dot
        dado = load(arqcell{horiz}{vert});
    else
        fileID = fopen([dir arqcell{horiz}{vert}]);
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
        dado = data; % just 1 eeg
    end
end
L=length(dado); % recebe o tamanho do EEG/Epoca
to=1/Fs; % tempo inicial
tf=L/Fs; % tempo final
deltat=1/Fs; % delta tempo
timeVec= [to:deltat:(L/Fs)]; % vetor de tempo
timeVectrans = timeVec'; % transposta do vetor de tempo
x = timeVectrans; % eixo x recebe o vetor de tempo
y = dado; % eixo y rede
%--------------------------------------------------------------------------
%View EEG / Epoch duration
set(handles.tf_file,'String',num2str(tf));
%--------------------------------------------------------------------------
%Verifica de existe ao menos um canal selecionado
%Update handles structure
t = isempty(ch_plot); % se vazio, t=1
if t == 0 %se a matriz nao estiver vazia
    %    Liberar Plot Channels
    set(handles.plot_channels,'Enable','on') 
else
    set(handles.plot_channels,'Enable','off')
end
%--------------------------------------------------------------------------
%Regula o comprimento da janela 
if dx > tf
    warndlg(sprintf('Select a value lower or equal to EEG/Epoch size','Warning')) %warning
    dx = dxtemp; %dx assume o valor anterior
    set(handles.window_size,'string',dx) 
    uiwait(gcf); 
    return; %abortar a funcao e retornar (abort the function and returns)
end
%--------------------------------------------------------------------------
dxtemp = dx;

% Plota os canais
%--------------------------------------------------------------------------
%Limpar axes antes de plotar
cla; %  CLA Clear current axis.
numplots = size(ch_plot,2);%Numero de canais selecionados para plotar
% Se nenhum canal foi selecionado
if numplots == 0
    cla; % clear
end

%--------------------------------------------------------------------------
%Plotar os canais sem slider se tamanho da janela igual ao tamanho do registro
if dx == tf & numplots ~= 0  % tamanho da janela eh igual ao tamanho do registro e  numplots diferente de 0    
    p = zeros(1,numplots);
    p(1) = plot(timeVectrans, dado(:,ch_plot(1)),'Color', colorcell{1,ch_plot(1)});
    hold on; %HOLD ON holds the current plot and all axis properties so that subsequent graphing commands add to the existing graph.
    for K = 2:numplots
        p(K) = plot(timeVectrans, dado(:,ch_plot(K)),'Color', colorcell{1,ch_plot(K)});
    end
    % Configura�ao dos eixos
    t1=1; t2=1; t3=1;
    if py == 0
        miny = min(y); % vetor com os valores minimos de cada coluna da matriz 
        maxy = max(y); % vetor com os valores maximo de cada coluna da matriz
        ymin = min(miny); % valor minimo do registro
        ymax = max(maxy); % valor maximo do registro
        t1=0.8;t2=1.2;t3=-0.1;
    end
    
    % Intervalo entre os valores maximo e minimo do sinal (Set appropriate axis limits and settings)
    set(gcf,'doublebuffer','on');
    % This avoids flickering when updating the axis
    set(gca,'xlim',[0 dx]); % limita o eixo x do axes1 a de 0 ao tamanho da janela (entrada do usuario)
    %set(gca,'ylim',[ymin*1.2 ymax*1.2]); % limita o eixo y do axes1 ao intervalo entre os valores maximo e minimo do sinal 
    
    if (ymin) > 0 && (ymax) > 0
        set(gca,'ylim',[ymin*t1 ymax*t2])
    end
    if (ymin) == 0 && (ymax) > 0
        set(gca,'ylim',[ymax*(t3) ymax*t2])
    end
    if (ymin) == 0 && (ymax) == 0
        set(gca,'ylim',[-1 1])
    end
    if (ymin) < 0 && (ymax) == 0
        set(gca,'ylim',[ymin*t2 ymin*(t3)])
    end    
    if (ymin) < 0 && (ymax) < 0
        set(gca,'ylim',[ymin*t2 ymax*t1])
    end
    if (ymin) < 0 && (ymax) > 0
        set(gca,'ylim',[ymin*t2 ymax*t2])
    end
end

 %--------------------------------------------------------------------------
%Plotar canais com slider
if dx < tf & numplots ~= 0 % tamanho da janela eh menor ao tamanho do registro e numplots diferente de 0    
    p = zeros(1,numplots);
    p(1) = plot(timeVectrans, dado(:,ch_plot(1)),'Color', colorcell{1,ch_plot(1)});
    hold on;
    for K = 2:numplots
        p(K) = plot(timeVectrans, dado(:,ch_plot(K)),'Color', colorcell{1,ch_plot(K)});
    end
    % Configura�ao dos eixos
    t1=1; t2=1; t3=1;
    if py == 0
        miny = min(y); % vetor com os valores minimos de cada coluna da matriz 
        maxy = max(y); % vetor com os valores maximo de cada coluna da matriz
        ymin = min(miny); % valor minimo do registro
        ymax = max(maxy); % valor maximo do registro
        t1=0.8;t2=1.2;t3=-0.1;
    end
       
    set(gca,'XTickMode','auto'); % auto
    set(gca,'YTickMode','auto'); % auto
    % Set appropriate axis limits and settings
    set(gcf,'doublebuffer','on');
    % This avoids flickering when updating the axis
    set(gca,'xlim',[0 dx]); % limita o eixo x do axes1 a de 0 ao tamanho da janela (entrada do usuario)
        
    if (ymin) > 0 && (ymax) > 0
        set(gca,'ylim',[ymin*t1 ymax*t2])
    end
    if (ymin) == 0 && (ymax) > 0
        set(gca,'ylim',[ymax*(t3) ymax*t2])
    end
    if (ymin) == 0 && (ymax) == 0
        set(gca,'ylim',[-1 1])
    end
    if (ymin) < 0 && (ymax) == 0
        set(gca,'ylim',[ymin*t2 ymin*(t3)])
    end    
    if (ymin) < 0 && (ymax) < 0
        set(gca,'ylim',[ymin*t2 ymax*t1])
    end
    if (ymin) < 0 && (ymax) > 0
        set(gca,'ylim',[ymin*t2 ymax*t2])
    end
    % Gera constantes para o uso na inicializa�ao do uicontrol (Generate constants for use in uicontrol initialization)
    pos=get(gca,'position'); % pos recebe posi�ao do axes1
    Newpos=[pos(1) pos(2)-0.1 pos(3) 0.03]; % Newpos recebe um novo vetor de posicao
    % Set appropriate axis limits and settings
    % Seta um limite apropriado para o axis
    set(gcf,'doublebuffer','on');
    %% This will create a slider which is just underneath the axis but still leaves room for the axis labels above the slider
    xmax=max(x);
    S=['set(gca,''xlim'',get(gcbo,''value'')+[0 ' num2str(dx) '])'];
    %% Setting up callback string to modify XLim of axis (gca) based on the position of the slider (gcbo)
    % Creating Uicontrol
    uicontrol('style','slider','units','normalized','position',Newpos,'callback',S,'min',0,'max',xmax-dx);   
end
vec_esc_in = [round(ymin) round(ymax)]; 
set(handles.potential_scale,'string', num2str(vec_esc_in));

%Configura�ao de variaveis
dxtemp = dx; % tamanho da janela do plot anterior
clear ch_plot % deleta a variavel ch_plot

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Individual Plot
% Plotar canais individualmente em um figure
% --- Executes during object creation, after setting all properties.
function plotchannels_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%-------------------------------------------------------------------
% --- Executes on button press in plot_channels.
% Plotar os canais individualmente
function plot_channels_Callback(hObject, eventdata, handles)

global ch ch_plot colorcell dado timeVectrans numplots canalcell x y dx miny maxy ymin ymax t1 t2 t3

figure; % create a figure
for i=1:numplots % number of channels
    subplot(numplots,1,i) % subplot all channels
    p(i) = plot(timeVectrans, dado(:,ch_plot(i)),'Color', colorcell{1,ch_plot(i)});
    hold on; %holds the current plot and all axis properties so that  subsequent graphing commands add to the existing graph.
    
    % This avoids flickering when updating the axis
    set(gca,'xlim',[0 dx]); % limita o eixo x do axes1 a de 0 ao tamanho da janela (entrada do usuario)
       
    if (ymin) > 0 && (ymax) > 0
        set(gca,'ylim',[ymin*t1 ymax*t2])
    end
    if (ymin) == 0 && (ymax) > 0
        set(gca,'ylim',[ymax*(t3) ymax*t2])
    end
    if (ymin) == 0 && (ymax) == 0
        set(gca,'ylim',[-1 1])
    end
    if (ymin) < 0 && (ymax) == 0
        set(gca,'ylim',[ymin*t2 ymin*(t3)])
    end    
    if (ymin) < 0 && (ymax) < 0
        set(gca,'ylim',[ymin*t2 ymax*t1])
    end
    if (ymin) < 0 && (ymax) > 0
        set(gca,'ylim',[ymin*t2 ymax*t2])
    end
    
    ylabel('Amplitude(mV)','FontSize',6); %axis y label
    set(gca,'FontSize',7); % axis x
    if i==numplots
        xlabel('Time (s)','FontSize',7); % axis x label
    end
end

% Generate constants for use in uicontrol initialization (Gera constantes para o uso na inicializa�ao do uicontrol)
pos=get(gca,'position'); % pos recebe posi�ao do axes1
Newpos=[pos(1) pos(2)-0.1 pos(3) 0.02]; % Newpos recebe um novo vetor de posicao
% Set appropriate axis limits and settings (Seta um limite apropriado para o axis)
set(gcf,'doublebuffer','on');
%% This will create a slider which is just underneath the axis but still leaves room for the axis labels above the slider
xmax=max(x);
S=['set(gca,''xlim'',get(gcbo,''value'')+[0 ' num2str(dx) '])'];  
%% Setting up callback string to modify XLim of axis (gca) based on the position of the slider (gcbo) - Creating Uicontrol
hscroll = uicontrol('style','slider','units','normalized','position',Newpos,'callback',S,'min',0,'max',xmax-dx);

%######################### Exit ###########################################
% --- Executes on button press in exit_Callback.
function exit_Callback_Callback(hObject, eventdata, handles)

clear all; %removes all variables, globals, functions and MEX links.
close; % close wavelet GUI
% --------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%$
% --- Executes on button press in OK_pot_scale.
function OK_pot_scale_Callback(hObject, eventdata, handles)

global py ymin ymax vec_esc_temp

vec_esc = str2num(get(handles.potential_scale,'string'));
ymin = vec_esc(1);
ymax = vec_esc(2);
if ymin > ymax || ymin == ymax
    warndlg(sprintf(['Y max must be greater than Y min' ],'Warning')); % warning
    set(handles.potential_scale,'string', num2str(vec_esc_temp));
    uiwait(gcf); 
    return;
end
set(gca,'ylim',[ymin ymax]);
vec_esc_temp = [ymin ymax];
py=1;

% --------------------------------------------------------------------
% --- Executes on button press in transmais.
function transmais_Callback(hObject, eventdata, handles)

global py miny maxy ymin ymax

if (py == 0) % se eh a primeira ver que eu dou zoom
ymin=min(miny);
ymax=max(maxy);
end
ymin=ymin+((ymax-ymin)*(1/10));
ymax=ymax+((ymax-ymin)*(1/10));
set(gca,'ylim',[ymin ymax]);
vec_esc_in=[round(ymin) round(ymax)];
set(handles.potential_scale,'string', num2str(vec_esc_in));
py=1;

% --- Executes on button press in transmenos.
function transmenos_Callback(hObject, eventdata, handles)

global py miny maxy ymin ymax

if (py == 0) % se eh a primeira ver que eu dou zoom
ymin=min(miny);
ymax=max(maxy);
end
ymin=ymin-((ymax-ymin)*(1/10));
ymax=ymax-((ymax-ymin)*(1/10));
set(gca,'ylim',[ymin ymax]);
vec_esc_in=[round(ymin) round(ymax)];
set(handles.potential_scale,'string', num2str(vec_esc_in));
py=1;






% --------------------------------------------------------------------
function configuration_menu_Callback(hObject, eventdata, handles)
% hObject    handle to configuration_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
