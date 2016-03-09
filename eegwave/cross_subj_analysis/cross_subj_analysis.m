
%############################################################################################################
%                                               UNIVERSIDADE DE SAO PAULO                                                               
%                                                                                                                                   
%                                    FACULDADE DE MEDICINA DE RIBEIRAO PRETO - USP-RP                                                  
%                                                                                                                                   
%                                       LABORATORIO DE INVESTIGAÇAO EM EPILEPSIA                                                                                                 
%                                   DR. JOAO PEREIRA LEITE / DR. RODRIGO ROMCY-PEREIRA                                                        
%                                    Anexo A - Departamento de Neurologia (sala-12)                                                  
%                                                Contato: (16) 36024535  
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% © COPYRIGHT 05/2007 by                                                                                                                                                                
%     Henrique T. do Amaral Silva                                                                                                                                              
%     Dr. Rodrigo Romcy-Pereira                                                                                                                                                  
%
% Once sustained oscillations have been identified for each subject, the "cross_subj_output_file" reads
% them and analyzes oscillatory events longer than a new user define duration. It produces an output
% file with descriptive statistics of the group that includes number of subjects analyzed, number of epochs
% analyzes per subject, number of oscillatory events detected per frequency band in each epoch, mean number
% of oscillatory events per frequency band of each subject, mean percentage (and standard deviation) of
% oscillatory events per frequency band across all animals. It allows the user to explore the large-scale
% tendency of the group at the same time it maintains individual epoch data of all subjects.
%
% Input Parameters: threshold for oscillation detection (thre), sustained oscillation text files (*_Oscill.txt) from all
% subjects.
%
% Output: text file in table-like format.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function varargout = cross_subj_analysis(varargin)
% cross_subj_output_file M-file for cross_subj_output_file.fig
%      cross_subj_output_file, by itself, creates a new cross_subj_output_file or raises the existing
%      singleton*.
%
%      H = cross_subj_output_file returns the handle to a new cross_subj_output_file or the handle to
%      the existing singleton*.
%
%      cross_subj_output_file('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in cross_subj_output_file.M with the given input arguments.
%
%      cross_subj_output_file('Property','Value',...) creates a new cross_subj_output_file or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cross_subj_output_file_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cross_subj_output_file_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cross_subj_output_file

% Last Modified by GUIDE v2.5 06-Jun-2008 16:06:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cross_subj_analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @cross_subj_analysis_OutputFcn, ...
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

% --- Executes just before cross_subj_output_file is made visible.
function cross_subj_analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cross_subj_output_file (see VARARGIN)

global pi

% Choose default command line output for cross_subj_output_file
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes cross_subj_output_file wait for user response (see UIRESUME)
% uiwait(handles.cross_subj_output_file);

pi=0; % contador de acionamento do uigetfiles (accountant of drive of uigetfiles)

% --- Outputs from this function are returned to the command line.
function varargout = cross_subj_analysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%------------------------------------------------------------------
% --- Executes on button press in select.
function select_Callback(hObject, eventdata, handles)

global dir arq n ntemp ind C OscEv Mepoches pi caixa_temp caixa_arq ht

set(ht,'Visible','off');
[arq,dir]=uigetfiles('*.txt','Input Files');
n=size(arq,2); % numero de arquivos selecionados

[arq,ind] = sort(arq); % ordenar arquivos e pegar indices (sort files and catch indices)

%Verifica se algum arquivo foi selecionado
t=isempty(arq);
if t==1
    return;
end

if n > 20 % se foram selecionados mais de 20 arquivos (capacidade maxima da interface) (if more than 20 files had been selected (maximum capacity of the interface)) 
    warndlg(sprintf('          Select only 20 files. \n Press OK to select the files again.'),...
        'Warning');
    uiwait(gcf); % aguardar o button Ok ser pressionado (wait Ok button to be pressured) 
    select_Callback;  % chama a funcao novamente para nova selecao dos arquivos  (it calls the function again for new election of the files) 
end

%Celulas
C=cell(1,n); %
OscEv=cell(1,n);

% Limpar as caixas caso o uigetfiles foi acionado mais de uma vez (Clean the boxes case uigetfiles was set more than once) 
if pi>=1 % se o button Select foi acionado mais de uma vez (if Select button was set more than once)
    
    for i=1:ntemp
        set(caixa_arq{i},'Visible','off'); % ocultar as caixas com os nomes do arquivos selecionados (hide the boxes with the names of the selected files) 
        set(caixa_temp{i},'Visible','off'); % ocultar as caixas com o tempos iniciais das epocas (hide the boxes with the initial times of the epoch)  
    end % fim do if (end of if)
end % fim do for (end of for) 

%  Criacao de celulas (Creation of cells)
caixa_arq=cell(1,n);  % celula que contem os uicontrols com os nomes dos arquivos selecionados (cell that contains uicontrols with the names of the selected files)
caixa_temp=cell(1,n); % celula que contem os uicontrols com os vetores de tempos inicias das epocas (cell that contains uicontrols with the vectors of initial times of the epochs) 

ntemp= size(arq,2); % numero de arquivos de entradas a serem analisados na selecao anterior (number of files of inputs to be analyzed in the previous election) 
pi=pi+1; % contador de vezes de acionamento do uigetfiles (accountant of times of drive of uigetfiles) 

for i = 1:n  % do arquivo 1 ate o arquivo n  (of file 1 until file n)
    disp(['-File ' dir arq{i}])           
    caixa_arq{i}   = uicontrol('Visible','on','BackgroundColor', [1.0 1.0 0.501],'Tag',['editarq',num2str(i)], 'Style', 'edit', 'String', arq{i},'Position', [15 450-19.5*(i-1) 165 20]);
    caixa_temp{i} = uicontrol('Visible','on','BackgroundColor', [1.0 1.0 0.501],'Tag',['edittemp',num2str(i)],'Style','edit','String',' ' ,'Position', [180 450-19.5*(i-1) 50 20],...
        'Callback',@user_input_Callback);
end

function varargout = user_input_Callback (varargin)

global  caixa_temp n Mepochs
Mepochs = cell(1,n);
 
for i=1:n                             
    Mepochs{1,i} = str2num(get(caixa_temp{1,i},'String')); %colocar os vetores de tempos na celula (puts the vectors of times in the cell)
end

%------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function group_name_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function group_name_Callback(hObject, eventdata, handles)
%------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function name_channel_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function name_channel_Callback(hObject, eventdata, handles)
%------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function threshold_edit_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function threshold_edit_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------


% --- Executes during object creation, after setting all properties.
function output_file_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function output_file_Callback(hObject, eventdata, handles)
%##########################################################################
%##########################################################################

% --- Executes on button press in ok.
function varargout = ok_Callback(hObject, eventdata, handles, thre, output)

global dir arq n C Mepochs OscEv ind ht

% Funçao que analisa a saida da funçao Binariza_sust.
% ind: vetor com os indices da celula de arquivo
% thre= limiar (duracao em segundos) para considerar oscilacao sustentada.
% output = p.ex.,'output.txt'. Nome do arquivo de saida.

%Parameters
%Input
thre = str2num(get(handles.threshold_edit,'String'));
%Output
output = get(handles.output_file,'String');
name_channel = get(handles.name_channel,'String');


for i=1:n % 
    disp(['-File: ' dir arq{ind(i)}])
    s=[dir arq{i}];
    data=importdata(s);
    m=size(data.data,1);
    p=size(data.data,2);
    k=0;
    for j=1:m
        if data.data(j,10) >= thre
            C{1,i}(1+k,1)=data.data(j,1);
            C{1,i}(1+k,2)=data.data(j,2);
            C{1,i}(1+k,3)=data.data(j,6);
            C{1,i}(1+k,4)=data.data(j,8);
            C{1,i}(1+k,5)=data.data(j,10);
            k=k+1;
        end
    end
    if isempty(C{1,i})
        C{1,i}(1,1)=0;
        C{1,i}(1,2)=0;
        C{1,i}(1,3)=0;
        C{1,i}(1,4)=0;
        C{1,i}(1,5)=0;
    else
        C{1,i}=sortrows(C{1,i},[2]);
    end
end

%#######################################################################
% Calcula o numero de oscilacoes nao redundantes por faixa de frequencia.

Ri=zeros(7,2);
Ri(1:7,1)=[1:1:7]';
for i=1:n
    a1=0;
    if size(C{1,i},1) > 1
        for j=1:size(C{1,i},1)-1
            if C{1,i}(j,1)==C{1,i}(j+1,1) & C{1,i}(j,2)==C{1,i}(j+1,2)
                irange=C{1,i}(j,2);
                Ri(irange,2)= a1+1;
                a1=a1+1;
            elseif C{1,i}(j,2)~=C{1,i}(j+1,2)
                a1=0;
            end
        end
    else Ri(:,2)=0; end
    n1=size(find(C{1,i}(:,2)==1),1)-Ri(1,2); % numero de oscilacoes na 1a faixa de frequenca com duracao > (thre). Sem redundancia por faixa.
    n2=size(find(C{1,i}(:,2)==2),1)-Ri(2,2); % numero de oscilacoes na 2a faixa de frequenca com duracao > (thre). "
    n3=size(find(C{1,i}(:,2)==3),1)-Ri(3,2); % numero de oscilacoes na 3a faixa de frequenca com duracao > (thre). "
    n4=size(find(C{1,i}(:,2)==4),1)-Ri(4,2); % numero de oscilacoes na 4a faixa de frequenca com duracao > (thre). "
    n5=size(find(C{1,i}(:,2)==5),1)-Ri(5,2); % numero de oscilacoes na 5a faixa de frequenca com duracao > (thre). "
    n6=size(find(C{1,i}(:,2)==6),1)-Ri(6,2); % numero de oscilacoes na 6a faixa de frequenca com duracao > (thre). "
    n7=size(find(C{1,i}(:,2)==7),1)-Ri(7,2); % numero de oscilacoes na 7a faixa de frequenca com duracao > (thre). "
    
    Ri_check=Ri;
    Ri(:,2)=0;
    A=[n1;n2;n3;n4;n5;n6;n7];
    
    % OscEv= Celula {1xn}(7x1) contendo n matrizes (n animais) com as % de eventos oscilatorios (duracao>thre) por faixa de freq.
    OscEv{1,i}=A/Mepochs{1,i}; 
    
end

% OscEv= Matriz(7x1) contendo (linhas: faixas de frequencia; colunas: n animais; valores: %oscilacoes c/ duracao>thre).
OscEv=cell2mat(OscEv);

[x,y]=find(OscEv==0);
ind=cat(2,x,y);
ind=sortrows(ind,[1,2]);
p=zeros(7,1);
q=zeros(7,1);
for i=1:7
    p(i,1)=size(find(ind(:,1)==i),1);
    q(i,1)=n-p(i,1);
end

Average=zeros(7,3); % Matriz Final (coluna 1= media da %de eventos oscilatorios; coluna 2= Desvio padrao; coluna 3= n animais)
Average(:,3)=q(:,1);

for i=1:7
    s1=0; s2=0;
    for j=1:n
        s1=s1+(OscEv(i,j)^2);
        s2=s2+OscEv(i,j);
    end
    if q(i,1)~=0
        Average(i,1)=100*(s2/q(i,1)); % media da % (de todos os animais; area X) de eventos oscilatorios por faixa de frequencia. 
        s=sqrt((s1-(s2^2/q(i,1)))/(q(i,1)-1)); % Desvio padrao de eventos oscilatorios por faixa de frequencia.
        Average(i,2)=100*s;
    else 
        Average(i,1)=0; 
        Average(i,2)=0;
    end
end

warning off
figure;
sem=Average(:,2)./sqrt(Average(:,3));
bar([1:1:7],Average(:,1),'k');
hold on;
errorbar([1:1:7],Average(:,1),sem,'k+');
ylabel('% of epochs analyzed');
xlabel('Frequency Band');
title ('Occurrence of Oscillatory Events - Ch X');

nome_fig = [dir output '-' name_channel '-oscill-events.tif'];
print(gcf,'-dtiff', nome_fig)
close;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove oscilacoes redundantes da matriz C, mantendo apenas aquelas de
% menor latencia. Importante para o calculo da latencia media baseado em
% uma oscilacao por epoca (i.e., oscilacao de menor latencia).

Ci=cell(1,n);
for i=1:n
    k=0;
    if size(C{1,i},1) > 1  
        for j=1:size(C{1,i},1)-1
            if C{1,i}(j,1)~=C{1,i}(j+1,1) & k==0
                Ci{1,i}(j,:)=C{1,i}(j,:);
                Ci{1,i}(j+1,:)=C{1,i}(j+1,:);
                k=0;
            elseif C{1,i}(j,1)~=C{1,i}(j+1,1) & k~=0
                Ci{1,i}(j+1,:)=C{1,i}(j+1,:); 
                k=0;
            elseif C{1,i}(j,1)==C{1,i}(j+1,1) & k==0
                if C{1,i}(j,2)==C{1,i}(j+1,2)
                    Ci{1,i}(j,:)=C{1,i}(j,:);
                    Ci{1,i}(j+1,:)=0;
                    k=k+1;
                else 
                    Ci{1,i}(j,:)=C{1,i}(j,:);
                    Ci{1,i}(j+1,:)=C{1,i}(j+1,:);
                    k=0;
                end 
            elseif C{1,i}(j,1)==C{1,i}(j+1,1) & k~=0
                if C{1,i}(j,2)==C{1,i}(j+1,2)
                    Ci{1,i}(j,:)=0;
                    Ci{1,i}(j+1,:)=0;
                    k=k+1;
                else
                    Ci{1,i}(j+1,:)=C{1,i}(j+1,:);
                    k=0;
                end
            end
        end
        Ci{1,i}=sortrows(Ci{1,i},[2]);
        [g,h]=find(Ci{1,i}(:,1)==0);
        if ~isempty(g)
            Ci{1,i}=Ci{1,i}(g(end)+1:end,:);
        end
    else Ci{1,i}=C{1,i}; 
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculo da latencia media das oscilacoes

Osclat=cell(1,n);
ilat=zeros(7,4);
ilat(1:7,1)=[1:1:7]';

for i=1:n
    for k=1:7
        [x,y]=find(Ci{1,i}(:,2)==k);
        if ~isempty(x)
            ave=mean((Ci{1,i}(x(1):x(end),3)));
            sd=std((Ci{1,i}(x(1):x(end),3)));
            ilat(k,2)=ave;
            ilat(k,3)=sd;
            ilat(k,4)=length(x);
        else
            ilat(k,2)=-1;
            ilat(k,3)=-1;
            ilat(k,4)=-1;
        end
    end
    Osclat{1,i}=ilat;
end

AllratsOsclat=zeros(7,n);
for i=1:7
    for j=1:n
        AllratsOsclat(:,j)=Osclat{j}(:,2);
    end
end
[x,y]=find(AllratsOsclat==-1);
ind=cat(2,x,y);
ind=sortrows(ind,[1,2]);
p=zeros(7,1);
q=zeros(7,1);
for i=1:7
    p(i,1)=size(find(ind(:,1)==i),1);
    q(i,1)=n-p(i,1);
end

% Matriz Final das latencias
% coluna 1= Media da latencia dos eventos oscilatorios;
% coluna 2= Desvio padrao;
% coluna 3= n Animais.

Averagelat=zeros(7,3);
Averagelat(:,3)=q(:,1);

for i=1:7
    s1=0; s2=0;
    for j=1:n
        if AllratsOsclat(i,j)~=-1
            s1=s1+(AllratsOsclat(i,j)^2);
            s2=s2+AllratsOsclat(i,j);
        end
    end
    if q(i,1)~=0
        Averagelat(i,1)=(s2/q(i,1)); % media da latencia (de todos os animais; area X) de eventos oscilatorios por faixa de frequencia. 
        s=sqrt((s1-(s2^2/q(i,1)))/(q(i,1)-1)); % Desvio padrao da latencia eventos oscilatorios por faixa de frequencia.
        Averagelat(i,2)=s;
    else 
        Averagelat(i,1)=-1; 
        Averagelat(i,2)=-1;
    end
end

figure;
sem=Averagelat(:,2)./sqrt(Averagelat(:,3));
bar([1:1:7],Averagelat(:,1),'k');
hold on;
errorbar([1:1:7],Averagelat(:,1),sem,'k+');
ylabel('Latency (s)');
xlabel('Frequency Band');
title ('Latency to Oscillation - Ch X');

nome_fig = [dir output '-' name_channel '-latency-oscill.tif'];
print(gcf,'-dtiff', nome_fig)
close;

%#####################################################################################################################
% GERAÇAO DO ARQUIVO TXT

output_file = [dir output '-' name_channel '-cross-subj-analysis.txt']; 
fid = fopen(output_file,'wt');

for i=1:n
    fprintf(fid,'%s %1.0f\t %s %1.0f\n','Subject: ',i,'Number of Epochs Analysis: ',Mepochs{1,i});
    fprintf(fid,'%s\t %s\t %s\t %s\t %s\n\n','Epoch','Freq Range','T-init(s)','T-final(s)','Dur-Oscill(s)');
    for j=1:size(C{1,i},1)   
        fprintf(fid,'%1.0f\t %1.0f\t\t %3.1f\t\t %3.1f\t\t %3.1f\n',C{1,i}(j,1),C{1,i}(j,2),C{1,i}(j,3),C{1,i}(j,4),C{1,i}(j,5));
    end
    fprintf(fid,'\n');
end
% an=1:1:size(OscEv,2);
fprintf(fid,'%s\n','Oscillatory Events Rate by Frequency Range'); 
% fprintf(fid,'%s\t\t %1.0f\t %1.0f\t %1.0f\n','Animais: ',an);
fprintf(fid,'\n');
fprintf(fid,'%s\t','Freq:');
fprintf(fid,'%1.0f %s\n',n,' Subjects');
for i=1:7
    for j=1:n
        fprintf(fid,'\t %1.0f %s %5.2f\t',i,' ',OscEv(i,j));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'\n');

fprintf(fid,'%s\n','Percent Medium (of all subjects) of Oscillatory Events by Frequency Range');
fprintf(fid,'%s\t %s\t %s\t %s\n','Freq','Average (%)','Standard Deviation (%)','n (# Subjects)');
for i=1:7    
    fprintf(fid,'%1.0f\t %6.2f\t\t\t %6.2f\t\t\t %1.0f\n',i,Average(i,1),Average(i,2),Average(i,3));
end
fprintf(fid,'\n');
fprintf(fid,'%s\n','Oscillatory Events Latency by Frequency Range (per subject)');
fprintf(fid,'\t\t %s\t %s\t %s\t %s\n','Freq','Average Latency (s)','Standard Deviation (s)','n (# Epochs)');
for i=1:n
    fprintf(fid,'%s %1.0f\n','Subject: ',i);
    for j=1:7
        fprintf(fid,'\t\t %1.0f\t\t %6.2f\t\t %6.2f\t\t\t %1.0f\n',j,Osclat{i}(j,2),Osclat{i}(j,3),Osclat{i}(j,4));
    end
    fprintf(fid,'\n');
end

fprintf(fid,'%s\n','Oscillatory Events Average Latency (of all subjects) by Frequency Range');
fprintf(fid,'%s\t %s\t %s\t %s\n','Freq','Average Latency  (s)','Standard Deviation (s)','n (# subjects)');
for i=1:7    
    fprintf(fid,'%1.0f\t %6.2f\t\t\t %6.2f\t\t\t %1.0f\n',i,Averagelat(i,1),Averagelat(i,2),Averagelat(i,3));
end    
fclose(fid);

ht=uicontrol('ForegroundColor','r','FontSize',10,'Style', 'text', 'String', 'Done','Position', [2 3 100 20],'Visible','on');



%--------------------------------------------------------------------------
% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
clear all;
close;

