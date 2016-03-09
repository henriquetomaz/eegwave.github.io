                     

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
%                                                                                                                                   %
% O codigo fonte epoch_save (salva epocas) corresponde a um dos modulos pertencentes ao software "EEGWave" desenvolvido sobre a     %  
% plataforma MatLab para o processamento de registros de eletroencefalografia (EEG).                                                %    
% Este modulo eh responsavel pela primeira etapa da analise que consiste em utilizar uma tabela de tempo comportamental do animal   %  
% como inicio dos segmentos de EEGS relevantes para o usuario. O epoch_save eh capaz de processar 20 registros de EEGS para diversas%  
% epocas, ou seja, com um mesmo registro de EEG e possivel extrair quantas epocas forem necessarias.                                %    
%                                                                                                                                   %
% Entradas:                                                                                                                         %                                                                 
%                                                                                                                                   %    
% Frequencia de Amostragem: ????                                                                                                    %                                            
% Duracao da epoca: corresponde a duracao (em segundos) do comportamento que deseja ser analisado                                   %  
% Numero de Canais: quantidade de canais registrados no EEG                                                                         %                 
% Arquivos de registros de EEG: registro eletroencefalografico em arquivos de texto (.txt)                                          %  
% Tempos iniciais de cada epoca: Vetor com os diversos tempos inicais das epocas                                                    %    
%                                                                                                                                   %
% A saida deste modulo consiste em arquivos texto, no formato .txt salvos no diretorio corrente com as epocas solicitadas. Um mesmo %
% registro de EEG pode gerar diversa saidas, isso dependera do numero de epocas que se deseja analisar para o registro.             % 
%                                                                                                                                   %
% O epoch_save tambem apresenta uma ferramenta para corrigir o nome dos arquivos que apresentam numeracao apos um prefixo.Isto pode se  %  
% tornar interessante quando o usuario deseja visulizar os registros selecionados em ordem crescente.                               % 
%                                                                                                                                   %    
%###################################################################################################################################%

% --> Funcao de inicializacao da interface epoch_save
% --> Function of inicialization of interface epoch_save 
function varargout = epoch_save(varargin)
% epoch_save M-file for epoch_save.fig
%      epoch_save, by itself, creates a new epoch_save or raises the existing
%      singleton*.
%
%      H = epoch_save %returns the handle to a new epoch_save or the handle to
%      the existing singleton*.
%
%      epoch_save('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in epoch_save.M with the given input arguments.
%
%      epoch_save('Property','Value',...) creates a new epoch_save or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before epoch_save_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to epoch_save_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help epoch_save

% Last Modified by GUIDE v2.5 23-Nov-2014 22:32:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @epoch_save_OpeningFcn, ...
                   'gui_OutputFcn',  @epoch_save_OutputFcn, ...
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes just before epoch_save is made visible.
% --> Inicializao de variaveis
% --> Inicialization of variables 
function epoch_save_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to epoch_save (see VARARGIN)

global p

% Choose default command line output for epoch_save
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes epoch_save wait for user response (see UIRESUME)
% uiwait(handles.epoch_save);

p=0; % contador de acionamento do uigetfile (accountant of drive of uigetfile)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Outputs from this function are returned to the command line.
% --> Funcao de saida
% --> Function of output
function varargout = epoch_save_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
% --> Criacao do Edit Text - Duracao
% --> Creation of the Edit Text - Duration 
function edit_duracao_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Callback of Edit Text Duracao
% --> Chamada do Edit Text Duracao
function edit_duracao_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
% --> Criacao do Edit Text Freq. Amost 
% --> Creation of the Edit Text Freq. Amost 
function edit_frequencia_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Callback of Edit Text Freq. Amost.
% --> Chamada do Edit Text Freq. Amost 
function edit_frequencia_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in canal1.
% --> Chamada do Radio Button Canal1.
% --> Call of the Canal1 Radio Button.
function canal1_Callback(hObject, eventdata, handles)

global k % numero de canais (number of channels)

set(handles.canal1,'Value',1) % seleciona o canal 1 (it selects channel 1)
k=1; 
% Chamar funcao responsavel por realizar exclusao mutua 
% Call function responsible for carrying through mutual exclusion  
off = [handles.canal2,handles.canal3,handles.canal4,handles.canal5,handles.canal6];
mutual_exclude(off)

% --- Executes on button press in canal2.
% --> Chamada do Radio Button Canal2.
% --> Call of the Canal2 Radio Button.
function canal2_Callback(hObject, eventdata, handles)

global k

set(handles.canal2,'Value',1) % seleciona o canal 2 (it selects channel 2)
k=2; 
off = [handles.canal1,handles.canal3,handles.canal4,handles.canal5,handles.canal6];
mutual_exclude(off)

% --- Executes on button press in canal3.
% --> Chamada do Radio Button Canal3.
% --> Call of the Canal3 Radio Button.
function canal3_Callback(hObject, eventdata, handles)

global k

set(handles.canal3,'Value',1) % seleciona o canal 3 (it selects channel 3)
k=3; 
off = [handles.canal1,handles.canal2,handles.canal4,handles.canal5,handles.canal6];
mutual_exclude(off)


% --- Executes on button press in canal4.
% --> Chamada do Radio Button Canal4.
% --> Call of the Canal4 Radio Button.
function canal4_Callback(hObject, eventdata, handles)

global k

set(handles.canal4,'Value',1) % seleciona o canal 4 (it selects channel 4)
k=4; 
off = [handles.canal1,handles.canal2,handles.canal3,handles.canal5,handles.canal6];
mutual_exclude(off)

% --- Executes on button press in canal5.
% --> Chamada do Radio Button Canal5.
% --> Call of the Canal5 Radio Button.
function canal5_Callback(hObject, eventdata, handles)

global k

set(handles.canal5,'Value',1) % seleciona o canal 5 (it selects channel 5)
k=5; 
off = [handles.canal1,handles.canal2,handles.canal3,handles.canal4,handles.canal6];
mutual_exclude(off)

% --- Executes on button press in canal6.
% --> Chamada do Radio Button Canal6.
% --> Call of the Canal6 Radio Button
function canal6_Callback(hObject, eventdata, handles)

global k

set(handles.canal6,'Value',1)  % seleciona o canal 6 (it selects channel 6)
k=6; 
off = [handles.canal1,handles.canal2,handles.canal3,handles.canal4,handles.canal5];
mutual_exclude(off)

% --> Funcao responsavel por realizar exclusao mutua para o conjunto de Radio Button
% --> Responsible function for carrying through mutual exclusion for the set of Buttons Radio 
function mutual_exclude(off)
set(off,'Value',0) % nao permite que mais de um radio button seja selecionado (it doesnt allow that more than a button radio have 
                   %been selected)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in checkbox3.
% --> Chamada para a funcao que realiza a correcao dos nomes dos arquivos de EEGS 
% --> Call for the function that carries through the correction of the names of the EEGS files
function varargout = checkbox3_Callback(hObject, eventdata, handles, varargin)

global click_val_cb3

click_val_cb3 = (get(hObject,'Value'));

    if (get(hObject,'Value') == get(hObject,'Max')) % se o Check Box esta acionado (if the Check Box is set)
        % Checkbox is checked-take approriate action
        q = get(hObject,'Value');
        % Mostrar o Edit Text para a entrada do numero de letras no prefixo do nome do arquivo (Show the Edit Text for the input
        %of the number of letters in the prefix of the name of the file)      
        set(handles.edit_pref,'Visible','on') 
        set(handles.text_pref,'Visible','on')
     else
        % Checkbox is not checked-take approriate action
        q = get(hObject,'Value');
        % Ocultar o Edit Text (Hide the Edit Text)
        set(handles.edit_pref,'Visible','off')
        set(handles.text_pref,'Visible','off')      
     end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
% --> Criaçao do Edit Test - Nro de letras no prefixo 
% --> Creation of the Edit Test - Number of letters in the prefix
function edit_pref_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --> Chamada do Edit Test - Nro de letras no prefixo 
% --> Call of the Edit Test - Number of letters in the prefix 
function edit_pref_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --> Funcao executada quando pressionado o button 'Select' 
% --> Function executed when pressured the 'Select' button 
function varargout = Select_Callback(hObject, eventdata, handles, varargin)

global dir arq ind n n2 caixa_arq caixa_temp click_val_cb3 p

[arq,dir] = uigetfile('*.*','Multiselect','on','Input Files');
if iscell(arq) == 0
    n = 1;
    arq2 = arq; clear arq;
    arq=cell(1,1); arq{1,1}=arq2;
else
    n = size(arq,2);
end

% Limpar as caixas caso o uigetfile foi acionado mais de uma vez (Clean the boxes case uigetfile was set more than once) 
if p>=1 % se o button Select foi acionado mais de uma vez (if Select button was set more than once)
  for i=1:n2
      set(caixa_arq{i},'Visible','off') % ocultar as caixas com os nomes do arquivos selecionados (hide the boxes with the names of the selected files) 
      set(caixa_temp{i},'Visible','off') % ocultar as caixas com o tempos iniciais das epocas (hide the boxes with the initial times of the epoch)  
  end % fim do if (end of if)
end % fim do for (end of for) 

%  Criacao de celulas (Creation of cells)
caixa_arq=cell(1,n);  % celula que contem os uicontrols com os nomes dos arquivos selecionados (cell that contains uicontrols with the names of the selected files)
caixa_temp=cell(1,n); % celula que contem os uicontrols com os vetores de tempos inicias das epocas (cell that contains uicontrols with the vectors of initial times of the epochs) 
novo_arq = cell(1,n); % celula auxiliar que recebe os nomes corrigidos dos arquivos (auxiliary cell that receives the names corrected from the files) 

n2= size(arq,2); % numero de arquivos de entradas a serem analisados na selecao anterior (number of files of inputs to be analyzed in the previous election) 
p=p+1; % contador de vezes de acionamento do uigetfile (accountant of times of drive of uigetfile) 

if n > 20 % se foram selecionados mais de 20 arquivos (capacidade maxima da interface) (if more than 20 files had been selected (maximum capacity of the interface)) 
    warndlg(sprintf('          Select only 20 files. \n Press OK to select the files again.'),...
        'Warning')
    uiwait(gcf); % aguardar o button Ok ser pressionado (wait Ok button to be pressured) 
    Select_Callback;  % chama a funcao novamente para nova selecao dos arquivos  (it calls the function again for new election of the files) 
end

% Correcao para o nome dos arquivos (Correction for the name of the files)
if click_val_cb3 == 1 % se a correcao para os nomes dos arquivos foi acionada (if the correction for the names of the files was set)
    Npref = str2num(get(handles.edit_pref,'String')); % pegar o numero de digitos no prefixo da numeracao do arquivo (catch the number of digits in the prefix of the numeration of the file) 
    j = (Npref+2+4)-1; % auxiliar para encontrar arquivos com diferentes numeros de digitos numericos apos o prefixo (auxiliary variable to find files with different numbers of numeric digits after the prefix
    for i=1:n 
        if length(arq{i}) == j % se o nome ter apenas um digito numerico (if the name have only one numeric digit) 
           novo_arq{i}=[arq{i}(1:Npref) '0' arq{i}(Npref+1:end)]; % colocar 0 na frente do unico numero do nome do arquivo e armazena em uma celula auxiliar (puts 0 in the front of the only number of the name of the file and store in a auxiliary cell) 
         else % se o nome do arquivo ter mais de um digito numerico apos o prefixo (if the name of the file has more than one numeric digit after the prefix)
            novo_arq{i}=arq{i}; % armazenar na celula auxiliar (store in the auxiliary cell)  
         end  
    end 
    
    [novo_arq,ind] = sort(novo_arq); % ordenar arquivos e pegar indices (sort files and catch indices)
    
else
   [arq,ind] = sort(arq); % ordenar arquivos e pegar indices (sort files and catch indices)
end

if click_val_cb3 == 1 % se correcao para nome de arquivos foi ativada (if correction for name of files was activated) 
    for i = 1:n  % do arquivo 1 ate o arquivo n  (of file 1 until file n)          
        disp(['-File ' dir novo_arq{i}])
        caixa_arq{i}   = uicontrol('Visible','on','BackgroundColor', [1.0 1.0 1.0],'Tag',['editarq',num2str(i)], 'Style', 'edit', 'String', novo_arq{i},'Position', [30 415-19.5*(i-1) 270 20]);
        caixa_temp{i} = uicontrol('Visible','on','BackgroundColor', [1.0 1.0 1.0],'Tag',['edittemp',num2str(i)],'Style','edit','String',' ' ,'Position', [315 415-19.5*(i-1) 160 20],...
            'Callback',@user_input_Callback);
    end    
else
    for i = 1:n  % do arquivo 1 ate o arquivo n  (of file 1 until file n) 
        if n == 1
            disp(['-File ' dir arq{i}]) % if just 1 eeg
        else        
            disp(['-File ' dir arq{i}])
        end
        caixa_arq{i}   = uicontrol('Visible','on','BackgroundColor', [1.0 1.0 1.0],'Tag',['editarq',num2str(i)], 'Style', 'edit', 'String', arq{i},'Position', [30 415-19.5*(i-1) 270 20]);
        caixa_temp{i} = uicontrol('Visible','on','BackgroundColor', [1.0 1.0 1.0],'Tag',['edittemp',num2str(i)],'Style','edit','String',' ' ,'Position', [315 415-19.5*(i-1) 160 20],...
            'Callback',@user_input_Callback);
    end
end

% Funcao responsavel por atualizar e armazenar os valores dos vetores de tempos declarados pelo usuario
% Function responsible for update and store the values of the vectors of times declared by the user 
function varargout = user_input_Callback (varargin)
   
global caixa_temp n caixa_temp tempcell

tempcell=cell(1,n);

for i=1:n    
    tempcell{1,i} = str2num(get(caixa_temp{i},'String')); % colocar os vetores de tempos na celula (puts the vectors of times in the cell)
    for j=1:length(tempcell{1,i})
        if tempcell{1,i}(1,j) <= 0
            warndlg(sprintf(['The initial time must be a positive number and greater than 0.'],'Warning')); % warning
            uiwait(gcf);
        end
    end
end
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --> Funcao responsavel por executar a rotina SALVA EPOCA quando pressionado o button Ok 
% --> Function responsible for execute the routine SALVA EPOCA when pressured the Ok button 
function varargout =  pushbutton_OK_Callback(hObject, eventdata, handles, varargin)

global dir arq duration Fs ind n tempcell caixa_arq k  dotb commab  

if isempty(dotb) && isempty(commab);  % comma or dot
    dotb = 1; commab = 0; % default
end
%if just 1 eeg was selected, so put it into a cell
if n == 1
    arq2 = arq;
    clear arq;
    arq=cell(1,1);
    arq{1,1} = arq2;
end


%celula com os arquivos carregados
eeg = cell(1,n);

% Pegar entradas do usuario dos edits boxes (catch inputs of the user of edits boxes) 
duration = str2num(get(handles.edit_duracao,'String')); % pegar a duracao (catch the duration)
Fs       = str2num(get(handles.edit_frequencia,'String')); % pegar a frequencia de amostragem (catch the sampling frequency) 
np = duration*Fs; % calcular numero de pontos (calculate number of points)

h = waitbar(0,'Load Files...');
for i=1:n
    %load files
    waitbar(i/n)
    if n == 1 
        s = [dir arq{1}];
    else
        s = [dir arq{ind(i)}];
    end % pegar o arquivo do diretorio (catch the file of the directory)
    
    if commab == 0 && dotb == 1 % if dot
        eeg{1,i}=load(s); % carregar epoca % data=load(s.acq.data); % carregar epoca
    else % if comma
        fileID = fopen(s);
        a = {'%s';'%s %s';'%s %s %s';'%s %s %s %s';'%s %s %s %s %s';'%s %s %s %s %s %s'};
        C = textscan(fileID, a{k}); %k is number of channels
        fclose(fileID);        
        for chind=1:k
            C2(:,chind) = strrep(C{chind},',', '.');
        end
        data = zeros(length(C{1}),k);
        for convarr=1:length(C{1})
            for convcol=1:k
                data(convarr,convcol)= str2double(C2{convarr,convcol});
            end
        end
        eeg{1,i}=data;
        clear fileID a C C2 data
    end
    %eeg{1,i} = load(s); % carregar o arquivo (load the file)
    disp(['-File ' s]) % mostrar o arquivo carregado (show the loaded file )
    
    if isempty (tempcell{1,i}) == 1 % se alguma posicao da celula de tempo estiver vazia (if some position of the time cell will be empty)
        warndlg(sprintf('            EEG without reference to initial times. \n Complete correctly the field Times with the initial times of epochs.'),...
            'Warning') % aviso (warning)
        uiwait(gcf);
        return; % abortar a funcao e retornar (abort the function and returns)
    end
    tempmax = max(tempcell{1,i});
    lengtheeg = length(eeg{1,i})/Fs;
    if (tempmax+duration) > (lengtheeg)
        warndlg(sprintf(['For a ' num2str(duration) ' seconds epoch, time max is ' num2str(lengtheeg-duration) ' seconds. \n            EEG ' num2str(i) ' has ' num2str(lengtheeg) ' seconds.'],'Warning')) %warning
        clear eeg;
        uiwait(gcf);
        return; %abortar a funcao e retornar (abort the function and returns)
    end
end
close(h) 
  
h = waitbar(0,'Saving Epochs... Please Wait');
for u = 1:n  % percorrer cada posicao da celula para pegar o vetor de tempo para cada arquivo (cover each position of the cell to catch the vector of time for each file)
   
    for v = 1:length(tempcell{u})  % percorrer o vetor de tempo (cover the time vector)  
         waitbar((u*v)/(n*length(tempcell{u})))
        % Se houver uma entrada de tempo com valor 0, o programa atribuira o valor 1 a variavel correspondente
        % If it will have an input of time with value 0, the program will attribute the value 1 to corresponding variable
        if  tempcell{u}(v) == 0 
            tempcell{u}(v) = 1/Fs;
        end
        nome_arq = arq{ind(u)};
        output_file = [dir nome_arq(1:end-4),'-ep1-', num2str(v) ,'.txt'];   % nome do arquivo de saida (name of the exit file)  
        time = tempcell{u}(v) * Fs; % calcular o tempo (calculate the time)   
        fid = fopen(output_file,'w'); % abrir o arquivo de saida para escrever (open the exit file to write) 
        disp(['-File ' output_file]) % mostrar o nome do arquivo de saida (show the name of the exit file) 
        
        switch k % canais (channels)
            case 1                         
                for j=0:(np-1), % gravar arquivo com o segmento de EEG escolhido (record file with the chosen segment of EEG) 
                    fprintf(fid,'%12.8f\n' ,eeg{1,u}(time+j,1)); 
                end % fim do for (end of for)       
                fclose(fid);
            case 2                         
                for j=0:(np-1),  
                    fprintf(fid,'%12.8f  %12.8f\n',eeg{1,u}(time+j,1),eeg{1,u}(time+j,2)); 
                end % fim do for (end of for)      
                fclose(fid);
            case 3                         
                for j=0:(np-1),  
                    fprintf(fid,'%12.8f %12.8f %12.8f\n',eeg{1,u}(time+j,1), eeg{1,u}(time+j,2), eeg{1,u}(time+j,3)); 
                end % fim do for (end of for)         
                fclose(fid);
            case 4                         
                for j=0:(np-1),  
                    fprintf(fid,'%12.8f %12.8f %12.8f %12.8f\n',eeg{1,u}(time+j,1),eeg{1,u}(time+j,2),eeg{1,u}(time+j,3),eeg{1,u}(time+j,4)); 
                end % fim do for (end of for)        
                fclose(fid);
            case 5                         
                for j=0:(np-1),  
                    fprintf(fid,'%12.8f %12.8f %12.8f %12.8f %12.8f\n',eeg{1,u}(time+j,1),eeg{1,u}(time+j,2),eeg{1,u}(time+j,3),eeg{1,u}(time+j,4),eeg{1,u}(time+j,5)); 
                end % fim do for (end of for)         
                fclose(fid);  
            case 6                         
                for j=0:(np-1),
                    fprintf(fid,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n',eeg{1,u}(time+j,1),eeg{1,u}(time+j,2),eeg{1,u}(time+j,3),eeg{1,u}(time+j,4),eeg{1,u}(time+j,5),eeg{1,u}(time+j,6)); 
                end % fim do for (end of for)         
                fclose(fid);                            
        end % fim do switch  (end of switch)                      
    end % fim do segundo for (end of second for)
end % fim do primeiro for (end of first for)
close(h) 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --> Funcao responsavel por cancelar a interface epoch_save quando pressionado o button 'Cancel' 
% --> Function responsible for cancelling interface epoch_save when pressured the 'Cancel' button  
function pushbutton_Cancel_Callback(hObject, eventdata, handles)

clear all;  %removes all variables, globals, functions and MEX links.
close; % fecha a janela epoch_save (it closes window epoch_save)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
