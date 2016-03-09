function read_SAIDA_sust(resol,dir,ch,out);

% Le arquivos de saida da rotina binariza_sust.m (contido na celula out) e aglutina oscilaçoes
% separadas por intervalos de tempo menores que <resol> i.e,
% read_SAIDA(0.9,'input1.txt','input2.txt');
% out eh celula que contem os nome dos arquivos de entrada

%Declaracao das celulas
inputdata = cell(1:ch); % celula de vetores contendo o diretorio o nome do arquivo.
Ch = cell(1:ch); % celula com que carrega os arquivos de saida
header = cell(1:ch); % contem dados de texto dos arquivos de saida
dataCh = cell(1:ch); % contem dados numericos dos arquivos de saida

for c=1:ch
    name_file = [out{1,c} '-Oscill.txt'];
    inputdata{1,c} = [dir name_file];
    Ch{1,c} = importdata(inputdata{1,c});
    if ~isfield(Ch{1,c},'data')
        header{1,c} = ['No oscillations detected'];
        dataCh{1,c} = []; % empty because there are no oscillations detected.
        lines_Ch(c) = 1; % one line.
    else    
        header{1,c} = (Ch{1,c}.textdata); % dados de texto
        dataCh{1,c} = (Ch{1,c}.data); % dados numericos
        lines_Ch(c) = size(dataCh{1,c},1);
    end
end

j=0;

for c=1:ch
    for i=1:(lines_Ch(c)-1) % numero de linhas do canal
        if dataCh{1,c}(i,2)==dataCh{1,c}(i+1,2)
            if abs(dataCh{1,c}(i+1,6)-dataCh{1,c}(i,8)) <= resol
                dataCh{1,c}(i-j,8)=dataCh{1,c}(i+1,8);
                dataCh{1,c}(i-j,10)=dataCh{1,c}(i-j,8)-dataCh{1,c}(i-j,6);          
                dataCh{1,c}(i+1,6)=0;
                dataCh{1,c}(i+1,10)=0;
                j=j+1;
            else 
                j=0;
            end         
        else
            j=0;
        end
    end
    if  ~isempty(dataCh{1,c})
        [dataCh{1,c}] = sortrows(dataCh{1,c},[1,6]);
    end    
    j=0;%<----- zerar quando mudar de canal
end

% CREATE TEXT FILE
for c=1:ch
    file_path=[dir out{1,c} '-Merge-Oscill-' num2str(resol) 'sec.txt'];
    fid = fopen(file_path,'wt');
    fprintf(fid,'%s\t %s\t %s\t %s\t %s\t %s\t %s\n\n','File','Frange','#','t-index','T-init(s)','T-final(s)','Dur-Oscil(s)'); %<mudar o nome
    for i=1:lines_Ch(c)
        if ~isempty(dataCh{1,c})
          if dataCh{1,c}(i,10)~=0
            fprintf(fid,'%1.0f\t %1.0f\t %1.0f\t %1.0f\t\t %3.1f\t\t %3.1f\t\t %3.1f\n',dataCh{1,c}(i,1),dataCh{1,c}(i,2),dataCh{1,c}(i,3),dataCh{1,c}(i,4),dataCh{1,c}(i,6),dataCh{1,c}(i,8),dataCh{1,c}(i,10)); 
          end
        end
    end
    fclose(fid);
end