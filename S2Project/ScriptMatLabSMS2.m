clear
clc
%% Caricamento tabella
T1=readtable('Meteo2011.csv');

%% Estrazione dei dati (1 al giorno)
i = 15;
T = (T1(15,:));
while i<size(T1,1)
    i = i+1;
    if strcmp(T1.Ora(i),'14:00')
        vett = T1(i,:);
        T = [T;vett];
    end
end

%% Analisi preliminare
min_T=T.TSOIAs==min(T.TSOIAs);
T(min_T,:);
max_T=T.TSOIAs==max(T.TSOIAs);
T(max_T,:);

%% Normalità di y=TSOIAs
y=T.TSOIAs;
n=length(y);
JB_y=skewness(y').^2*n/6+(kurtosis(y')-3).^2*n/24;
%JB lontano da 0 e n piuttosto elevato

%% Modelli di regressione
%rimozione colonne data e ora
T(:,1:2)=[];
%matrice di correlazione
X=table2array(T);
correlazione=corrcoef(X);
corr = array2table(correlazione);
corr.Properties.VariableNames = {'VV02mAs', 'W02mAs', 'RADGLAs', 'PIOGG', 'T02mAv', 'UMRELAs', 'RADNTAs', 'TSOIAs', 'PRESSAs'};
corr.Properties.RowNames = {'VV02mAs', 'W02mAs', 'RADGLAs', 'PIOGG', 'T02mAv', 'UMRELAs', 'RADNTAs', 'TSOIAs', 'PRESSAs'};

%Modello con RAD
m_R=fitlm(T,'ResponseVar','TSOIAs','PredictorVars',{'RADNTAs'});
%Modello con UM+RAD
m_RU=fitlm(T,'ResponseVar','TSOIAs','PredictorVars',{'UMRELAs','RADNTAs'});
%stepwise
T3=T(:,{'RADNTAs','UMRELAs','PRESSAs'});
m_RP=stepwiselm(table2array(T3),y);
%per Occam scegliamo il modello m_R

%Grafico Tsuolo in funzione della radiazione
figure
Grafico_Tsuolo_Rad=plot(m_R);
title('Grafico modello m_R');


%% Residui OLS
%Proprietà dei residui
mean(m_R.Residuals.Raw); %circa 0
%incorrelazione con i regressori
sum(m_R.Residuals.Raw'*T.RADNTAs); %circa 0->incorrelazione

%Normalità residui
figure
GraficoResidui=histfit(m_R.Residuals.Raw);
title('Grafico Residui m_R');

JB_residui=jbtest(m_R.Residuals.Raw);
skewness(m_R.Residuals.Raw);
kurtosis(m_R.Residuals.Raw);
%i residui sono normali dunque posso fare inferenza statistica

%% Inferenza statistica
m_R.Coefficients.pValue(2);%basso quindi significativo
EQM_2011 = mean(m_R.Residuals.Raw.^2); %(dati di trainig)

%% stima WLS (se non si elminassero i 999)
T2=readtable('Meteo - Completo.csv');
i = 15;
T_WLS = (T2(15,:));
while i<size(T2,1)
    i = i+1;
    if strcmp(T2.Ora(i),'14:00')
        vett = T2(i,:);
        T_WLS = [T_WLS;vett];
    end
end

x2=T_WLS.RADNTAs;
y2=T_WLS.TSOIAs;
n2=length(x2);
X2=[ones(length(x2),1) x2];
D=ones(1,n2);
last_beta=[0 0]';
exit=0;
iteration_count=1;
while exit==0
    DD(iteration_count,:)=D;
    D = diag(D);
    beta = inv(X2'*inv(D)*X2)*X2'*inv(D)*y2;
    res = y2 - (beta(1)+beta(2)*x2);
    D = abs(res)'+0.001;
    delta=norm(last_beta-beta);
    if delta<0.0001 
        exit=1;
    end
    iteration_count=iteration_count+1;
    last_beta=beta;
end
OLS_WLS_mat=[m_R.Coefficients.Estimate, last_beta];
tab_OLS_WLS=array2table(OLS_WLS_mat);
tab_OLS_WLS.Properties.VariableNames={'stima OLS', 'stima WLS'};
tab_OLS_WLS.Properties.RowNames={'Intercetta', 'Coeff regressore'};

%% Cross validazione OLS
y = T.TSOIAs;
X = [ones(length(y),1) T.RADNTAs];

rng('default') 
cvMSE = crossval('mse',X,y,'Predfun',@regf);

rng('default') 
cvdist = zeros(5,1);
for k = 1:10
    fun = @(Xtrain,Xtest)clustf(Xtrain,Xtest,k);
    distances = crossval(fun,T.RADNTAs);
    cvdist(k) = sum(distances);
end


%% B-Spline 
T3=readtable('Meteo2011 - Ordinato.csv');
minRad=min(T3.RADNTAs);
maxRad=max(T3.RADNTAs);
yobs=T3.TSOIAs;
tobs=T3.RADNTAs;
nobs=length(tobs);
norder=4;

%ciclo per trovare il numero perfetto di nodi
GCV_precedente=inf;%massimo numero esistente
divisore_scelto=0;
for j=2:(abs(minRad)+maxRad)
    divisore=(abs(minRad)+maxRad)/j;
    knots=minRad:divisore:maxRad;
    nknots=length(knots);
    interior_knots=nknots-2;
    nbasis=norder+interior_knots;
    rangeval = [min(tobs), max(tobs)];
    basis = create_bspline_basis(rangeval, nbasis, norder, knots);
    basismat=eval_basis(tobs,basis);
    c_hat=(basismat'*basismat)\(basismat'*yobs);
    valori_stimati=basismat*c_hat;
    c_map=(basismat'*basismat)\(basismat');
    Smat=basismat*c_map; % matrice di smoothing 
    GCV=1/nobs*sum(((yobs-valori_stimati)/(1-trace(Smat)/nobs)).^2);
    if(GCV<=GCV_precedente)
       GCV_precedente=GCV;
       divisore_scelto=divisore;
    else
       break
    end
end
knots=minRad:divisore_scelto:maxRad;
nknots=length(knots);
interior_knots=nknots-2;
nbasis=norder+interior_knots;
rangeval = [min(tobs), max(tobs)];
basis = create_bspline_basis(rangeval, nbasis, norder, knots);
basismat=eval_basis(tobs,basis);
c_hat=(basismat'*basismat)\(basismat'*yobs);
valori_stimati=basismat*c_hat;

basismat=eval_basis(tobs,basis);

c_hat=(basismat'*basismat)\(basismat'*yobs);
valori_stimati=basismat*c_hat;


%Varianza con Bspline
residui = yobs - valori_stimati;
RSS = residui'*residui;
c_map=(basismat'*basismat)\(basismat');
Smat=basismat*c_map;    %matrice di smoothing 
df = trace(Smat);   %numero di gradi di libertà=numero funzioni basi
sigma_square_hat = RSS / (length(T3.RADNTAs) - df);
sigma_hat = sqrt(sigma_square_hat); 
JB_spline=jbtest(residui);  %=0 i resdidui sono normali->posso fare inferenza statistica
EQM_spline_training=mean(residui.^2);

%Stima della varianza dei valori stimati e intervallo di confidenza
var_cov_yhat = sigma_square_hat*(Smat'*Smat);   
varYhat = diag(var_cov_yhat);

%calcolo IC dei valori stimati (Puntiforme)
alpha = .05;
z_alpha = norminv(1 - (alpha)/2);
Lower = valori_stimati - z_alpha*sqrt(varYhat);
Upper = valori_stimati + z_alpha*sqrt(varYhat);
figure
scatter(tobs, yobs, 5,"black", "filled");
hold on
plot(tobs, valori_stimati)
hold on
plot(tobs, Lower, '--b', 'LineWidth', 1)
hold on
plot(tobs, Upper, '--b', 'LineWidth', 1)
legend('dati misurati', 'funzione stimata', 'IC')
hold off
title('Grafico modello Spline');

%% Conclusioni
EQM_mat=[EQM_2011 EQM_spline_training; cvMSE GCV_precedente];
tab_conclusiva=array2table(EQM_mat);
tab_conclusiva.Properties.VariableNames={'Regressione lineare', 'B-spline'};
tab_conclusiva.Properties.RowNames={'EQM training', 'EQM test'};

%% comandi disp
clc
fprintf('\n')
cprintf('blue' ,'Risultato test Jarque-Bera per normalità di Tsuolo: \n')
disp(JB_y)
cprintf('blue' ,'Matrice di correlazione: \n')
fprintf('\n')
disp(corr)
fprintf('\n')
cprintf('blue' ,'Modello di regressione lineare con solo radianza: \n')
disp(m_R)
fprintf('\n')
cprintf('blue' ,'Modello di regressione lineare con radianza e pressione: \n')
disp(m_RP)
fprintf('\n')
cprintf('blue' ,'Media residui modello di regressione lineare: \n')
fprintf('%d \n', mean(m_R.Residuals.Raw))
fprintf('\n')
cprintf('blue' ,'Incorrelazione tra residui e regressori nel modello di regressione lineare: \n')
fprintf('%d \n', sum(m_R.Residuals.Raw'*T.RADNTAs))
fprintf('\n')
cprintf('blue' ,'Risultato test Jarque-Bera per normalità residui del modello di regressione lineare: \n')
fprintf('%d \n', JB_residui)
fprintf('\n')
cprintf('blue' , 'Confronto soluzione OLS e WLS (da usare se si considera il dataset completo): \n')
disp(tab_OLS_WLS)
fprintf('\n')
cprintf('blue' , 'Caratteristiche spline scelto: \n')
basis
fprintf('\n')
cprintf('blue' , 'Risultato test Jarque-Bera per normalità residui del modello spline: \n')
fprintf('%d \n', JB_spline)
fprintf('\n')
cprintf('blue' , 'Confronto coefficienti del modello di regressione lineare e spline: \n')
disp(tab_conclusiva)
