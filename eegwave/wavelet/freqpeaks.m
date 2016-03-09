% ##############################################################################################
function [powermax,newA]=freqpeaks(TFCELL,freqVec,Fs,n,ch,dir,out);
% function [powermax1,powermax2,newA,newB]=freqpeaks(TF1,TF2,freqVec,Fs,n,dir);
% ##############################################################################################

freqVecT=freqVec';
fo=freqVec(1);
ff=freqVec(end);
deltaF=freqVec(2)-freqVec(1);

%Declaracao de celulas
cumFreq = cell(ch:n);
DERIVCELL = cell(2,ch);
powermax = cell(ch,n);
%DER = cell(1:ch); 

for c=1:ch
    for i=1:n
        cumFreq{c,i}=sum(TFCELL{1,i}(:,:,c),2);
    end
end

%################################################################## 
% cumFreq= celula contendo a frequencia acumulada dos canais (cada canal esta em uma linha da celula) de cada arquivo analisado (n arquivos).

for c=1:ch 
    for i=1:n 
        [FITTEDMODEL,goodness]=fit(freqVecT,cumFreq{c,i},'smoothingspline');
        [DER1, DER2]=differentiate(FITTEDMODEL,freqVecT); 
        DERIVCELL{1,i}= DER1;
        DERIVCELL{2,i}= DER2;  

        k=0;
        mc=max(cumFreq{c,i});
        for j=2:length(freqVec)
            if (DERIVCELL{1,i}(j-1)>0 | DERIVCELL{1,i}(j-1)<0.005*mc)&(DERIVCELL{1,i}(j)<0 | DERIVCELL{1,i}(j)<(0.25*mc))
                if DERIVCELL{2,i}(j)<(0.005*min(DERIVCELL{2,i}))
                    k=k+1; 
                    ipeak=fo+((j-1)*deltaF);
                    powermax{c,i}(k,1)=ipeak; % cada linha da celula corresponde a um canal
                    powermax{c,i}(k,2)=cumFreq{c,i}(j);
                end 
            end
        end   
        
    end
end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[A,newA]=cleanfreqs_mod(n,dir,powermax,ch,out);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

