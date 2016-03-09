
%#################################################################################################################%
%                                               UNIVERSIDADE DE SAO PAULO                                                             
%                                                                                                                                   
%                                    FACULDADE DE MEDICINA DE RIBEIRAO PRETO - USP-RP                                                  
%                                                                                                                                   
%                                        LABORATORIO DE INVESTIGAÇAO EM EPILEPSIA                                                                                                 
%                                   DR. JOAO PEREIRA LEITE / DR. RODRIGO ROMCY-PEREIRA                                                        
%                                    Anexo A - Departamento de Neurologia (sala-12)                                                  
%                                                Contato: (16) 36024535                                                                  
%                                                                                                                                   
% © COPYRIGHT 05/2007 by                                                                                                                                                                
%     Henrique T. do Amaral Silva                                                                                                                                              
%     Dr. Rodrigo Romcy-Pereira                                                                                                                                                  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The coherence function measures the linear correlation between two signals in the frequency domain [1].
% It can be defined as the cross-spectrum modulus normalized by the auto-spectra product of two signals.
% It can be used to estimate the degree of synchronization between two signals and its values are normalized 
% to fit in the [0,1] interval. Zero coherence means that the two signals are completely desynchronized,
% while unit coherence means the two signals are in perect synchrony. Here, we incorporated a freely available
% code for the calculation of coherence and confidence intervals using a bootstrap technique [9,15]. Bootstrap
% creates a set of surrogate data that mimics the original data but that is completely uncoupled to them.
% It is accomplished by randomly permuting, in temporal order, samples from one o the signals and calculating
% coherence functions for each pair of surrogate and non-permuted data. In this way, the temporal structure
% of one data set is destroyed, while the other data set remains unchanged. The surrogate data keeps the same
% mean variance and histogram as the original signal. After repeating this process hundreds of time,
% significance levels are generated at each frequency f, from the distribution of coherence estimates.
% In summary, it sets  a threshold that defines whether the coherence between two signals is significant 
% or not, at each specific frequency analyzed [6].
%
% Input Parameters: dataset name, epoch files ( 1 to 6 channels epochs - multiple epochs input through
% popup window), number of bootstrap iterations (boot; default: 200), LFP sampling rate (Fs), confidence
% interval for coherence calculation (ci; default: 0,95).
%
% Output: Coherence and phase delay graphs saved as two MatLab figures and two tiff images.
%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = coherence(varargin)
% coherence M-file for coherence.fig
%      coherence, by itself, creates a new coherence or raises the existing
%      singleton*.
%
%      H = coherence returns the handle to a new coherence or the handle to
%      the existing singleton*.
%
%      coherence('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in coherence.M with the given input arguments.
%
%      coherence('Property','Value',...) creates a new coherence or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before coherence_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to coherence_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help coherence

% Last Modified by GUIDE v2.5 25-Apr-2008 18:30:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @coherence_OpeningFcn, ...
    'gui_OutputFcn',  @coherence_OutputFcn, ...
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


% --- Executes just before coherence is made visible.
function coherence_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to coherence (see VARARGIN)

% Choose default command line output for coherence
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes coherence wait for user response (see UIRESUME)
% uiwait(handles.coherence);

set(handles.edit_channels,'BackgroundColor',[0.75,0.75,0.75]) % setar a cor da caixa para cinza ao iniciar o modulo

% --- Outputs from this function are returned to the command line.
function varargout = coherence_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function edit_NFFT_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_NFFT_Callback(hObject, eventdata, handles)

%--------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function edit_FS_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_FS_Callback(hObject, eventdata, handles)

%--------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function edit_bootnum_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_bootnum_Callback(hObject, eventdata, handles)

%--------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function edit_sig_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_sig_Callback(hObject, eventdata, handles)


%--------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edit_f0_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_f0_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function edit_f1_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_f1_Callback(hObject, eventdata, handles)

%--------------------------------------------------------------------------
% --- Executes on button press in pushbutton_select.
function pushbutton_select_Callback(hObject, eventdata, handles)

global Coh CohSl vSigCoh mSl csd_coh Corr n dir arq numch ch numparestot dadotemp

%numch: vetor com o numero de canais de cada epoca ( epocas tem o mesmo numero de canais
%ch: numero de canais possiveis 
%numparestot: numero de pares possiveis

% Inicializacao das variaveis (limpa os vetores se select foi acionado mais
% de uma vez
arq = []; % limpa vetor arq
dir = []; % limp vetor dir
numch = []; % limpa vetor com numero de canais

% Abre janela para seleçao dos arquivos
[arq,dir]=uigetfiles('*.txt','Input Files');
n=size(arq,2);     % n= numero de arquivos de entradas a serem analisados

%Verificar se existe epocas selecionadas 
if  dir == 0 % se dir estiver vazio, emitir mensagem de aviso
    warndlg(sprintf('No epochs was selected. \n Select at least one epoch.','Warning')) % aviso (warning)
    uiwait(gcf);  
    return; % abortar a funcao e retornar (abort the function and returns)
end

if dir ~= 0 % se dir nao estiver vazio
    
    % Ativa os toggles box
    set(handles.radiobutton_select_ch,'Enable','on') % desativar ediçao de texto para entrada dos canais
    set(handles.radiobutton_allch,'Enable','on') % desativar ediçao de texto para entrada dos canais
    
    % Declaraçao de celulas
    dadotemp=cell(1,n);  % carrega os arquivos selecionados para uma celula
    
    % Carrega os arquivos
    for i=1:n % para cada arquivo
        disp(['-File ' dir arq{i}]) % mostrar o nome do arquivo
        s=[dir arq{i}]; % recebe o arquivo
        data=load(s); % carrega o arquivo
        dadotemp{i}=data; % celula que ira receber os arquivos
        [nl,nc] = size(dadotemp{i}); % retona o tamanho de cada arquivo (num de linha e num de coluna
        numch(1,i) = nc; % vetor com o numero de canais de cada arquivo
    end
    
    ch = numch(1,1); % numero de canais recebe o primeiro valor da matriz com numero dos canais
    numparestot = (ch * (ch-1))/2; % numero de combinaçoes possiveis
    
    % Verifica se existe apenas 1 canal
    for i=1:n
        if(numch(1,i) == 1)
            dir = []; % limpa o vetor dir
            arq = []; % limpa o vetor arq
            warndlg(sprintf('There is a epoch with only 1 channel. \n Select epochs with number of channels more than 2.','Warning')) % aviso (warning)
            uiwait(gcf); ; % cancela a operaçao 
        end % fim do for
    end % fim do if
    
    % Verifica se todas as epocas possuem o mesmo numero de canais.    
    for i=1:(n-1) % para cada posiçao do vetor de numero de canais
        if(numch(1,i) ~= numch(1,(i+1))) % se numero de canais do arquivo i for diferente do numero de canais do arquivo i+1
            dir = []; % limpa o vetor dir
            arq = []; % limpa o vetor arq
            warndlg(sprintf('Epochs with different number of channels. \n Select epochs with the same number of channels.','Warning')) % aviso (warning)
            uiwait(gcf); ; % cancela a operaçao 
        end % fim do if
    end % fim do for 
end

%--------------------------------------------------------------------------

% --- Executes on button press in radiobutton_allch.
function radiobutton_allch_Callback(hObject, eventdata, handles)


global ch numparestot ch_cohere numpares

set(handles.radiobutton_select_ch,'Value',0) % desativar o toggle Select Channels
set(handles.radiobutton_allch,'Value',1) % ativar o toggle All Channels 

if (get(handles.radiobutton_allch,'Value') == 1) % se selecionado
    set(handles.radiobutton_select_ch,'Value',0); 
    set(handles.edit_channels,'Enable','inactive'); % desativar a caixa de texto para entrada dos canais
    set(handles.edit_channels,'BackgroundColor',[0.75,0.75,0.75]); % mudar cor de fundo
    set(handles.ok_selchan,'Enable','off'); % desativar o button OK 
    set(handles.edit_channels,'String',''); % deletar valores 
    
    c1=1; % inicializa posiçao da linha no vetor
    for i=1:(ch-1)
        for j=(i+1):ch
            ch_cohere(c1,1) = ch - (ch-i);  % matriz com os pares de canais
            ch_cohere(c1,2) = ch - (ch-j);
            c1 = c1 + 1; % incremanta posiçao da linha
        end 
    end
    
    numpares = numparestot; %numero de pares 
else if (get(handles.radiobutton_allch,'Value') == 0) % se nao selecionado
        set(handles.radiobutton_select_ch,'Value',1) 
        set(handles.edit_channels,'Enable','on') % ativar ediçao de texto para entrada dos canais
        set(handles.edit_channels,'BackgroundColor','w') % mudar cor de fundo
        set(handles.ok_selchan,'Enable','off') % desativar o button OK 
    end
end

if (get(handles.radiobutton_select_ch,'Value'))==1
    clear ch_cohere numpares
end

%--------------------------------------------------------------------------

% --- Executes on button press in radiobutton_select_ch.
function radiobutton_select_ch_Callback(hObject, eventdata, handles)

set(handles.radiobutton_allch,'Value',0)
set(handles.radiobutton_select_ch,'Value',1)

if (get(handles.radiobutton_select_ch,'Value') == 1) % se selecionado
    set(handles.radiobutton_allch,'Value', 0)
    set(handles.edit_channels,'Enable','on') % editar a caixa de texto para entrada dos canais
    set(handles.edit_channels,'BackgroundColor','w') % ativar ediçao de texto para entrada dos canais
    set(handles.ok_selchan,'Enable','on') % ativar o button OK 
else if (get(handles.radiobutton_select_ch,'Value') == 0) % se nao selecionado
        set(handles.radiobutton_allch,'Value', 1)
        set(handles.edit_channels,'Enable','inactive') % desativar ediçao de texto para entrada dos canais
        set(handles.edit_channels,'BackgroundColor',[0.75,0.75,0.75]) % mudar a cor do Background
        set(handle.edit_channels,'String','') % deletar valores 
        set(handles.ok_selchan,'Enable','off') % desativar o button OK 
    end
end

% --- Executes on button press in ok_selchan.
function ok_selchan_Callback(hObject, eventdata, handles)

global ch numparestot ch_cohere numpares
ch_cohere = [];
vcohere = str2num(get(handles.edit_channels,'String'));

% Warnings

if isempty(vcohere)==1 % se nao existir elemento no vetor
    warndlg(sprintf('No number was typed','Warning')); % aviso (warning)
    uiwait(gcf); % cancela a operaçao 
end
if rem(length(vcohere),2)==1 % o numero de elementos eh impar
    warndlg(sprintf('The channels are not grouped in pairs.','Warning')); % aviso (warning)
    uiwait(gcf);  % cancela a operaçao 
end
if length(vcohere) > (2*numparestot)
    warndlg(sprintf('Number of pairs surplus.','Warning')); % aviso (warning)
    uiwait(gcf);  % cancela a operaçao 
end
if max(vcohere) > ch
    warndlg(sprintf(['The channel ' num2str(max(vcohere)) ' does not exist'],'Warning')); % aviso (warning)
    uiwait(gcf);  % cancela a operaçao 
end

c2=1; % inicializa posiçao da linha no vetor
j=0; % auxiliar para o contador i
for i=1:(length(vcohere))/2
    ch_cohere(c2,1) = vcohere(i+j);  % matriz com os pares de canais
    ch_cohere(c2,2) = vcohere(i+j+1);
    c2 = c2 + 1; % incremanta posiçao da linha
    j = j+1;
end

numpares = size(ch_cohere,1); % nomero de pares selecionados
if (get(handles.radiobutton_allch,'Value'))==1
    clear ch_cohere numpares
end

%--------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edit_channels_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_channels_Callback(hObject, eventdata, handles)

%--------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function edit_name_files_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_name_files_Callback(hObject, eventdata, handles)

%##########################################################################


% --- Executes on button press in pushbutton_ok.
function pushbutton_ok_Callback(hObject, eventdata, handles)

global n dir arq numpares ch_cohere dadotemp

% dado : contem arquivo
% Coh :
% CohSL:
% vSigCoh:
% mSl:
% csd_coh:
% Corr:
% n:
% dir / arq:
% ch_cohere: vetor com os pares de canais 
% numpares : numero de pares de canais

% Declaraçao das celulas
Coh=cell(numpares,n); % cell with coherence values for each epoch anlyzed.
CohSl=cell(numpares,n); % cell with P% confidence intervals for coherences in Coh (for each epoch anlyzed).
vSigCoh=cell(numpares,n); % cell containing the Frequencies, the Coherence values higher than the coherence confidence interval
% for each epoch anlyzed and the phase angles (-180..+180).
mSl=zeros(numpares,n); % cell containing significance level means (for all freqs) for each epoch analyzed.
csd_coh=cell(numpares,n);
phase=cell(numpares,n); % fase
Corr=cell(numpares,n); % correlacao
v=cell(numpares,n);

% Input Parameters
NFFT = str2num(get(handles.edit_NFFT,'String')); 
Fs =   str2num(get(handles.edit_FS,'String'));          % Frequencia de Amostragem
nboot = str2num(get(handles.edit_bootnum,'String'));    % Numero de bootstrap
siglev = str2num(get(handles.edit_sig,'String'));       % Nivel de significancia
f0 = str2num(get(handles.edit_f0,'String'));            % Frequencia inicial
f1 = str2num(get(handles.edit_f1,'String'));            % Frequencia final

% Output Parameters
name_files = get(handles.edit_name_files,'String'); % prefixo de saida dos arquivos gerados

% Diretorio corrente
R=pwd; % recebe o diretorio corrente

%##########################################################################
% Processamento


 hw = waitbar(0,'Coherence Processing... Please Wait');
for i=1:n % para cada arquivo
    % Calculate the coherence btwn the two channels and the bootstrap significance level (confidence interval)
    % for each epoch coherences
    for p=1:numpares % numero de pares / l: contador para o numero de pares
        waitbar((i*p)/(n*numpares))
        [sl,slf,df,F,CC,D] = cohere_bootstrap_signif_level(dadotemp{i}(:,ch_cohere(p,1)),dadotemp{i}(:,ch_cohere(p,2)),siglev,nboot,NFFT,Fs,'mean');
        slf=slf'; % slf (in each freq) significance level matrix.       ---> vetor 
        mSl(p,i)=sl; % sl significance level mean for all freqs.        ---> matrix
        Coh{p,i}=D; % coherence cell.                                   ---> cell
        CohSl{p,i}=slf; % significance level cell.                      ---> cell
        
        %[I,J] = FIND(X) returns the row and column indices of
        %the nonzero entries in the matrix X.  This is often used
        %with sparse matrices.
        [j,k]=find(D>slf); %index from D of coherences greater than slf.
        v{p,i}=zeros(length(j),3); % v eh uma matriz de zeros.
        v{p,i}(:,1)=F(j,1); % recebe F
        v{p,i}(:,2)=D(j,1); % recebe D
        [h,bin]=hist(v{p,i}(:,1),100); % histograma
        
        [Pxy,freq] = csd( dadotemp{i}(:,ch_cohere(p,1)),dadotemp{i}(:,ch_cohere(p,2)), NFFT, Fs,'mean');
        Kxy  = real( Pxy );
        Qxy  = imag( Pxy );
        phase{p,i}  = atan2( Qxy, Kxy );
        phase{p,i} = rad2deg(phase{p,i});
        v{p,i}(:,3)=phase{p,i}(j,1);
        vSigCoh{p,i}=v{p,i}; % freq vector (column 1); and the coherences greater than slf (column 2); phases (deg; column 3) .
    end
end
close(hw);

%##########################################################################
%##########################################################################

% Calculo da Fase

P=cell2mat(phase);
Phrad=deg2rad(P);
sumcosP=sum(cos(Phrad),2);
sumsinP=sum(sin(Phrad),2);
acosP=(sumcosP)./(n);
asinP=(sumsinP)./(n);
meanPhase=zeros(length(acosP),1);
t=zeros(length(acosP),1);
r=sqrt((asinP.^2)+(acosP.^2));
t=t + rad2deg(atan(asinP./acosP));


for i=1:length(meanPhase)
    if asinP(i) >= 0 & acosP(i) >= 0
        meanPhase(i)=meanPhase(i) + t(i);
    elseif asinP(i) >= 0 & acosP(i) <= 0
        meanPhase(i)=180 + meanPhase(i) + t(i);
    elseif asinP(i) <=0 & acosP(i) >= 0
        meanPhase(i)=t(i);
    elseif asinP(i) <=0 & acosP(i) <= 0
        meanPhase(i)= -180 + meanPhase(i) + t(i);
    end
end

% Calculates Phase difference average and variance   
varPhase=2.*(1-r).*((180/pi).^2); % Angular variance (J.Zar, 1999, p.604)
stdPhase=sqrt(varPhase);
Plimminus=meanPhase-stdPhase;
Plimplus=meanPhase+stdPhase;


%##########################################################################
%##########################################################################

% Figura 1

%Figure('Phase Variance per Frequency across all Epochs');

for i=1:n % para cada epoca
    fig = 1; % numero da figura
    for p=1:numpares    
        if p==1 || p==6 || p==11
            figure; % cria uma figura
            k=1; % inicializa o primeiro subplot da figura
        end
        subplot(5,1,k) % fazer subplot k
        area(F,Coh{p,i},mSl(p,i));
        axis([f0 f1 mSl(p,i) 1]);
        set(gca,'Box','off','Color',[0.8 0.8 0.8],'XTickLabel',[],'FontSize',5);
        title(['Coherence: ' num2str(ch_cohere(p,1)) '-vs-' num2str(ch_cohere(p,2))]);
        ylabel('Coher','FontSize',7)
        if p==5 || p==10 || p==15 || p==numpares
            axis on;
            %axis([f0 f1 mSl(p,i) 1]);
            set(gca,'Box','off','Color',[0.8 0.8 0.8],'XLim',[f0 f1],'XTickLabelMode','auto','FontSize',5.5);
            xlabel('Frequency (Hz)','FontSize',5);
            % Salvar as figuras
            cd (dir);
            nome_fig = [name_files 'Fig' num2str(fig)  '-Cohere-ep' num2str(i) '.tif' ];
            print('-dtiff', nome_fig)
            cd (R);
            fig = fig + 1;
            close; %fechar figuras
        end
        k=k+1; % incrementa o valor do subplot
    end
end
clear i p k fig namefig % limpar algumas variaveis

%##########################################################################
%##########################################################################

% Figura 2

% Figure composition (Significant Coherence, Confidence Interval and Phase angles)

for i=1:n % para cada epoca
    fig = 1; % numero da figura
    for p=1:numpares    
        if p==1 || p==6 || p==11
            figure; % cria uma figura
            k=1; % inicializa o primeiro subplot da figura
        end
        subplot(5,1,k) % fazer um subplot
        axis off;
        area(F,Coh{p,i},mSl(p,i));
        axis([f0 f1 mSl(p,i) 1]);
        ax1 = gca;
        h0=ylabel('Coherence');
        set(h0,'string','Coher','FontSize',5.5);
        hl1 = line(F,Coh{p,i},'Color','b');
        set(ax1,'Box','off','XLim',[f0 f1],'XColor','k','YColor','k','Color',[1 1 1],'XTickLabel',[],'FontSize',5.5); 
        ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XLim',[f0 f1],'YLim',[-180 180],'Color','none','XColor','k','YColor','r','FontSize',5.5);     
        ax2=gca;
        hl3 = line(F,phase{p,i},'Color',[0.4 0.4 0.4],'Parent',ax2); 
        h14 = line(F,0,'Color',[0.7 0.7 0.7]);
        h15 = ylabel('Phase','rotation',270);
        set(h15,'Units','normalized','Position',[1.09 0.5 0]);
        set(gca, 'XTickLabel',[]);% omitir valores do eixo x
        title(['Coherence and Phase Angles: ' num2str(ch_cohere(p,1)) '-vs-' num2str(ch_cohere(p,2))]); 
        if p==5 || p==10 || p==15 || p==numpares
            axis on
            %axis([f0 f1 mSl(p,i) 1]);        
            set(gca, 'YTickLabel',[],'YTick',[]);
            ax2 = axes('Position',get(ax1,'Position'),'XLim',[f0 f1],'YAxisLocation','right','YLim',[-180 180],'Color','none','YColor','r','FontSize',5.5);     
            xlabel('Frequency (Hz)','FontSize',5.5);           
            % Salvar as figuras
            cd (dir);
            nome_fig = [name_files 'Fig' num2str(fig)  '-Cohere-Phase-ep' num2str(i) '.tif' ];
            print('-dtiff', nome_fig)
            cd (R);
            fig = fig + 1;
            close; %fechar figuras
        end % fim do if
        k=k+1; % incrementa o valor do subplot
    end % fim do for
end % fim do for

%##########################################################################
%##########################################################################

% Figura 3

%Figure ('Phase variance per frequency')
figure;
subplot(3,1,1)

%------------------------------------------------------------------------------    

%Subplot 1 - Phase Variance per Frequency across all Epochs
plot(1:1:f1,0,'k-',1:1:f1,meanPhase(1:f1),'k',1:1:f1,Plimminus(1:f1),'r',1:1:f1,Plimplus(1:f1),'r');
set(gca,'FontSize',8);
if min(Plimminus) < -180 | max(Plimplus) > 180
    axis([f0 f1 1.1*min(Plimminus) 1.1*max(Plimplus)]);
else
    axis([f0 f1 -180 180]);
end
title('Phase Variance per Frequency across all Epochs');
h00=ylabel('Phase (deg)');
set(h00,'FontSize',8);
%------------------------------------------------------------------------------  

%Subplot 2
subplot(3,1,2)
area(1:1:f1,varPhase(1:f1),0); 
axis([f0 f1 0 max(varPhase)*1.3]);
ax0=gca;
set(ax0,'FontSize',8);
h1=ylabel('Variance (deg^2)');
set(h1,'Units','normalized','FontSize',8,'Position',[-0.08 0.5 0]);
%------------------------------------------------------------------------------

% Subplot 3
subplot(3,1,3)
ax1 = gca;
h3=ylabel(' ');
set(h3,'string','Phase (deg)','FontSize',8);
hl1 = line(1:1:f1,meanPhase(1:f1),'Color','k');
set(ax1,'Box','off','XLim',[f0 f1],'YLim',[-180 180],'XColor','k','YColor','k','Color',[1 1 1],'FontSize',8); % 'Color',[0.9 0.95 0.1],
h12 = line(1:1:f1,0,'Color',[0.2 0.2 0.2]);
ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XLim',[f0 f1],'YLim',[0 max(varPhase)*1.3],'Color','none','XColor','k','YColor','r','FontSize',8);     
ax2=gca;
hl3 = line(1:1:f1,varPhase(1:f1),'Color','r','Parent',ax2);
h14 = ylabel('Variance (deg^2)','rotation',270);
set(h14,'Units','normalized','Position',[1.09 0.5 0]);

%---------------------------------------------------------------------- 
cd (dir);
nome_fig = [name_files '-PhaseVar.tif'];
print('-dtiff', nome_fig)
cd (R);     
close; % fechar figura

%######################################################################

% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
clear all;  %removes all variables, globals, functions and MEX links.
close;


