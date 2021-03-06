function sustentada(SCELL,resoltime,ch,n,dir,out);

% SCELL = contem as matrizes-saida do binariza_sust.m usadas para o calculo da duracao das oscilacoes; 
% n = input('Numero de arquivos a serem analisados:').
% dir = diretorio atual; 
% out = celula que contem os nomes dos arquivos de saida.

resoltime2 = resoltime/1000;
Z=0.23; % Z=limiar usado para considerar oscilacao positiva. Porcentagem de pontos binarizados e igual a 1 
        % dentro da caixa de freq x 200ms (100 ptos).

L=length(SCELL{1,1}(:,:,1)); % tamanho de uma matriz S (apenas um canal)


for c=1:ch   
    file_path = [dir out{1,c} '-Oscill.txt'];
    fid = fopen(file_path,'wt');
    fprintf(fid,'%s\t %s\t %s\t %s\t %s\t %s\t %s\n\n','Epoch','Frange','#','t-index','T-init(s)','T-final(s)','Dur-Oscill(s)');
    
    for k=1:n
        for p=1:7
            a=0; b=0; t_index=0;       
            for j=1:(L-4) 
                count=histc(SCELL{1,k}(p,j:j+4,c),[Z 1.1]);
                x=count(1,1);
                y=5-x;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
                if (x>=4) & (SCELL{1,k}(p,j,c)>=Z) & (a==0)
                    a=a+1;
                    t_index=j;
                elseif (x>=4) & (SCELL{1,k}(p,j,c)<Z) & (a==0)
                    a=a+1;
                    t_index=j+1;                         
                elseif (x>=4) & (j~=(L-4)) & (a~=0)
                    a=a+1;
                    t_index=t_index;
                elseif (x>=4) & (j==(L-4))& (a~=0)
                    a=a+1;  
                    if t_index==1
                        ti=resoltime2*(t_index-1);
                    else ti=resoltime2*(t_index);
                    end
                    tf=resoltime2*(j+4);
                    dur=tf-ti;
                    if dur <=0
                        a=0;t_index=0;
                    else    
                        fprintf(fid,'%1.0f\t %1.0f\t %1.0f\t %1.0f\t\t %3.1f\t\t %3.1f\t\t %3.1f\n',k,p,a,t_index,ti,tf,dur);
                        a=0;t_index=0; 
                    end
                end 
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
                if (x<4) & (a>0)
                    if t_index==1
                        ti=resoltime2*(t_index-1);
                    else ti=resoltime2*(t_index); 
                    end
                    if SCELL{1,k}(p,j+3,c)<Z
                        tf=resoltime2*(j+2);
                    elseif (SCELL{1,k}(p,j+3,c)>=Z) & (SCELL{1,k}(p,j+2,c)<Z)
                        if (j<(L-4)) & (SCELL{1,k}(p,j+5,c)<Z)
                            tf=resoltime2*(j+3);
                        elseif (j<(L-4)) & (SCELL{1,k}(p,j+5,c)>=Z)
                            if (j==(L-5)) tf=resoltime2*(j+5); elseif (j==(L-4)) tf=resoltime2*(j+4); else tf=resoltime2*(j+6); end
                        end                  
                    elseif (SCELL{1,k}(p,j+3,c)>=Z) & (SCELL{1,k}(p,j+1,c)<Z)
                        if (j<(L-4)) & (SCELL{1,k}(p,j+5,c)<Z)
                            tf=resoltime2*(j+3);
                        elseif (j<(L-4)) & (SCELL{1,k}(p,j+5,c)>=Z) 
                            if (j==(L-5)) tf=resoltime2*(j+5); elseif (j==(L-4)) tf=resoltime2*(j+4); else tf=resoltime2*(j+6); end
                        end
                    elseif (SCELL{1,k}(p,j+3,c)>=Z) & (SCELL{1,k}(p,j,c)<Z)
                        tf=resoltime2*(j+3);
                    end
                    dur=tf-ti;
                    if dur <=0
                        a=0;t_index=0;
                    else    
                        fprintf(fid,'%1.0f\t %1.0f\t %1.0f\t %1.0f\t\t %3.1f\t\t %3.1f\t\t %3.1f\n',k,p,a,t_index,ti,tf,dur);
                        a=0;t_index=0;
                    end                     
                elseif (x<4) & (a==0)
                    a=0; b=0; t_index=0;    
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
            end  
        end
        fprintf(fid,'\n');
        fprintf(fid,'\n');
    end      
    fclose(fid);
    
end

clear  t_index tf ti dur
