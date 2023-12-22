clear
clc

%% Caricamento dati
load('G27.mat')

%% Ispezione del dataset
summary(tG)
%dal summary si vede che la nostra stazione di riferimento è Morbegno (197 dati)

%% Statistiche descrittive per alcune variabili
%ricavo media, minimo,std, max di PM10 in Morbegno
grpstats(tG,'ARPA_AQ_nome_staz_tG1',{'mean','std','min','max'},'DataVars',{'PM10_tG1'})
%ricavo media, minimo,std, max di PM10 BERGAMO
grpstats(tG,'ARPA_AQ_nome_staz_BG',{'mean','std','min','max'},'DataVars',{'PM10_BG'})

%% Scatterplot MORBEGNO
%mettiamo in relazione PM10 e una variabile alla volta
%Temperatura
y1 = tG.PM10_tG1;
x1 = tG.Temperatura_tG1;
Grafico_SO_temp_PM10=scatter(x1,y1,'filled')
xlabel('Temperatura(°C)');
ylabel('Concentrazione PM10(microgrammo/m3)');
title('Temperatura e PM10 (SO)')
vTmin=tG.PM10_tG1==min(tG.PM10_tG1);
tG(vTmin,:)
vTmax=tG.PM10_tG1==max(tG.PM10_tG1);
tG(vTmax,:)
saveas(Grafico_SO_temp_PM10,'Temperatura(SO)')

%Pioggia
y2 = tG.PM10_tG1;
x2 = tG.Pioggia_cum_tG1;
Grafico_SO_pioggia_PM10=scatter(x2,y2,'filled')
xlabel('Pioggia cumulata(mm)');
ylabel('Concentrazione PM10(microgrammo/m3)');
title('Pioggia e PM10 (SO)')
vPmin=tG.PM10_tG1==min(tG.PM10_tG1);
tG(vPmin,:)
vPmax=tG.PM10_tG1==max(tG.PM10_tG1);
tG(vPmax,:)
saveas(Grafico_SO_pioggia_PM10,'Pioggia(SO)')

%Umidità
y3 = tG.PM10_tG1;
x3 = tG.Umidita_relativa_tG1;
Grafico_SO_umidita_PM10=scatter(x3,y3,'filled')
xlabel('Umidità relativa(%)');
ylabel('Concentrazione PM10(microgrammo/m3)');
title('Umidità e PM10 (SO)')
vUmin=tG.PM10_tG1==min(tG.PM10_tG1);
tG(vUmin,:)
vUmax=tG.PM10_tG1==max(tG.PM10_tG1);
tG(vPmax,:)
saveas(Grafico_SO_umidita_PM10,'Umidità(SO)')

%Ozono
y4 = tG.PM10_tG1;
x4 = tG.O3_tG1;
Grafico_SO_ozono_PM10=scatter(x4,y4,'filled')
xlabel('Ozono(microgrammo/m3)');
ylabel('Concentrazione PM10(microgrammo/m3)');
title('Ozono e PM10 (SO)')
vOminSO=tG.PM10_tG1==min(tG.PM10_tG1);
tG(vOminSO,:)
vOmaxSO=tG.PM10_tG1==max(tG.PM10_tG1);
tG(vOmaxSO,:)
saveas(Grafico_SO_ozono_PM10,'Ozono(SO)')

%% Scatterplot BERGAMO
%mettiamo in relazione PM10 e una variabile alla volta
%Temperatura
y1b = tG.PM10_BG ;
x1b = tG.Temperatura_BG;
Grafico_BG_temp_PM10=scatter(x1b,y1b,'filled')
xlabel('Temperatura(°C)');
ylabel('Concentrazione PM10(microgrammo/m3)');
title('Temperatura e PM10 (BG)')
vTminBG=tG.PM10_BG==min(tG.PM10_BG);
tG(vTminBG,:)
vTmaxBG=tG.PM10_BG==max(tG.PM10_BG);
tG(vTmaxBG,:)
saveas(Grafico_BG_temp_PM10,'Temperatura(BG)')

%Pioggia
y2b = tG.PM10_BG;
x2b = tG.Pioggia_cum_BG;
Grafico_BG_pioggia_PM10=scatter(x2b,y2b,'filled')
xlabel('Pioggia cumulata(mm)');
ylabel('Concentrazione PM10(microgrammo/m3)');
title('Pioggia e PM10 (BG)')
vPminBG=tG.PM10_BG==min(tG.PM10_BG);
tG(vPminBG,:)
vPmaxBG=tG.PM10_BG==max(tG.PM10_BG);
tG(vPmaxBG,:)
saveas(Grafico_BG_pioggia_PM10,'Pioggia(BG)')

%Umidità
y3b = tG.PM10_BG;
x3b = tG.Umidita_relativa_BG;
Grafico_BG_umidita_PM10=scatter(x3b,y3b,'filled')
xlabel('Umidità realtiva(%)');
ylabel('Concentrazione PM10(microgrammo/m3)');
title('Umidità e PM10 (BG)')
vUminBG=tG.PM10_BG==min(tG.PM10_BG);
tG(vUminBG,:)
vUmaxBG=tG.PM10_BG==max(tG.PM10_BG);
tG(vPmaxBG,:)
saveas(Grafico_BG_umidita_PM10,'Umidità(BG)')

%Ozono
y4b = tG.PM10_BG;
x4b = tG.O3_BG;
Grafico_BG_ozono_PM10=scatter(x4b,y4b,'filled')
xlabel('Ozono(microgrammo/m3)');
ylabel('Concentrazione PM10(microgrammo/m3)');
title('Ozono e PM10 (BG)')
vOminBG=tG.PM10_BG==min(tG.PM10_BG);
tG(vOminBG,:)
vOmaxBG=tG.PM10_BG==max(tG.PM10_BG);
tG(vOmaxBG,:)
saveas(Grafico_BG_ozono_PM10,'Ozono(BG)')

%% Analisi modelli con Stepwise (Morbegno)
dataSO=tG(:,{'Temperatura_tG1','Pioggia_cum_tG1','Umidita_relativa_tG1','O3_tG1'});
dataSO1=table2array(dataSO);
mSO=stepwiselm(dataSO1,tG.PM10_tG1,'constant')

%% Regressione lineare multipla (Morbegno)
%Modello con Temperatura, Pioggia, Umidità, O3
m1SO=fitlm(tG,'ResponseVar','PM10_tG1','PredictorVars',{'Temperatura_tG1','Pioggia_cum_tG1','Umidita_relativa_tG1','O3_tG1'})
%Modello Pioggia e Umidità
m2SO=fitlm(tG,'ResponseVar','PM10_tG1','PredictorVars',{'Pioggia_cum_tG1','Umidita_relativa_tG1'})
%Modello Pioggia e Temperatura
m3SO=fitlm(tG,'ResponseVar','PM10_tG1','PredictorVars',{'Pioggia_cum_tG1','Temperatura_tG1'})
%Modello Ozono e Umidità
m4SO=fitlm(tG,'ResponseVar','PM10_tG1','PredictorVars',{'O3_tG1','Umidita_relativa_tG1'})
%Modello senza Umidità (migliore)
m5SO=fitlm(tG,'ResponseVar','PM10_tG1','PredictorVars',{'Temperatura_tG1','Pioggia_cum_tG1','O3_tG1'})

%% Residui (Morbegno)
%Modello con Temperatura, Pioggia, Umidità, O3
residuiSO1 = m1SO.Residuals.Raw;
Res_m1_SO=plot(residuiSO1)
yline(0,'r','LineWidth',3)%linea 0 in grassetto e rossa
yline(mean(residuiSO1),'b','LineWidth',2)
title('Residui m1(SO)')
%Modello Pioggia e Umidità
residuiSO2 = m2SO.Residuals.Raw;
Res_m2_SO=plot(residuiSO2)
yline(0,'r','LineWidth',3)%linea 0 in grassetto e rossa
yline(mean(residuiSO2),'b','LineWidth',2)
title('Residui m2(SO)')
%Modello Pioggia e Temperatura
residuiSO3 = m3SO.Residuals.Raw;
Res_m3_SO=plot(residuiSO3)
yline(0,'r','LineWidth',3)%linea 0 in grassetto e rossa
yline(mean(residuiSO3),'b','LineWidth',2)
title('Residui m3(SO)')
%Modello Ozono e Umidità
residuiSO4 = m4SO.Residuals.Raw;
Res_m4_SO=plot(residuiSO4)
yline(0,'r','LineWidth',3)%linea 0 in grassetto e rossa
yline(mean(residuiSO4),'b','LineWidth',2)
title('Residui m4(SO)')
%Modello senza Umidità (migliore)
residuiSO5 = m5SO.Residuals.Raw;
Res_m5_SO=plot(residuiSO5)
yline(0,'r','LineWidth',3)%linea 0 in grassetto e rossa
yline(mean(residuiSO5),'b','LineWidth',2)
title('Residui m5(SO)')

%% Grafico y interpolata e dati(PM10) (MORBEGNO)
%m5
Y_interpolato=tG.PM10_tG1-residuiSO5;
X=tG.PM10_tG1;
Grafico_m5_SO=scatter(X,Y_interpolato)
xlabel('Valori PM10 (reali)')
ylabel('Valori PM10 (stimati)')
title('Grafico m5(SO)')
hold on
Y=X;
plot(X,Y)
saveas(Grafico_m5_SO,'Grafico m5(SO)')
hold off
%m (stepwise)
residui=mSO.Residuals.Raw;
Y_interpolato=tG.PM10_tG1-residui;
X=tG.PM10_tG1;
Grafico_m_SO=scatter(X,Y_interpolato)
xlabel('Valori PM10 (reali)')
ylabel('Valori PM10 (stimati)')
title('Grafico stepwise(SO)')
hold on
Y=X;
plot(X,Y)
saveas(Grafico_m_SO,'Grafico modello ideale(SO)')
hold off

%% Analisi modelli con Stepwise (Bergamo)
dataBG=tG(:,{'Temperatura_BG','Pioggia_cum_BG','Umidita_relativa_BG','O3_BG'});
dataBG1=table2array(dataBG);
mBG=stepwiselm(dataBG1,tG.PM10_BG,'constant')

%% Regressione lineare multipla (Bergamo)
%Modello con Temperatura, Pioggia, Umidità, O3
m1BG=fitlm(tG,'ResponseVar','PM10_BG','PredictorVars',{'Temperatura_BG','Pioggia_cum_BG','Umidita_relativa_BG','O3_BG'})
%Modello Pioggia e Umidità
m2BG=fitlm(tG,'ResponseVar','PM10_BG','PredictorVars',{'Pioggia_cum_BG','Umidita_relativa_BG'})
%Modello Pioggia e Temperatura
m3BG=fitlm(tG,'ResponseVar','PM10_BG','PredictorVars',{'Temperatura_BG','Pioggia_cum_BG'})
%Modello Ozono e Umidità
m4BG=fitlm(tG,'ResponseVar','PM10_BG','PredictorVars',{'Umidita_relativa_BG','O3_BG'})
%Modello senza Umidità 
m5BG=fitlm(tG,'ResponseVar','PM10_BG','PredictorVars',{'Temperatura_BG','Pioggia_cum_BG','O3_BG'})
%Modello Ozono e Pioggia (per il principio del rasoio di Ockman si sceglie
%questo modello poichè con R2 molto simili ha meno variabili e p-value minore)
m6BG=fitlm(tG,'ResponseVar','PM10_BG','PredictorVars',{'Pioggia_cum_BG','O3_BG'})

%% Residui (Bergamo)
%Modello con Temperatura, Pioggia, Umidità, O3
residuiBG1 = m1BG.Residuals.Raw; 
Res_m1_BG=plot(residuiBG1)
yline(0,'r','LineWidth',3)%linea 0 in grassetto e rossa
yline(mean(residuiBG1),'b','LineWidth',2)
title('Residui m1(BG)')
%Modello Pioggia e Umidità
residuiBG2 = m2BG.Residuals.Raw;
Res_m2_BG=plot(residuiBG2)
yline(0,'r','LineWidth',3)%linea 0 in grassetto e rossa
yline(mean(residuiBG2),'b','LineWidth',2)
title('Residui m2(BG)')
%Modello Pioggia e Temperatura
residuiBG3 = m3BG.Residuals.Raw;
Res_m3_BG=plot(residuiBG3)
yline(0,'r','LineWidth',3)%linea 0 in grassetto e rossa
yline(mean(residuiBG3),'b','LineWidth',2)
title('Residui m3(BG)')
%Modello Ozono e Umidità
residuiBG4 = m4BG.Residuals.Raw;
Res_m4_BG=plot(residuiBG4)
yline(0,'r','LineWidth',3)%linea 0 in grassetto e rossa
yline(mean(residuiBG4),'b','LineWidth',2)
title('Residui m4(BG)')
%Modello senza Umidità 
residuiBG5 = m5BG.Residuals.Raw;
Res_m5_BG=plot(residuiBG5)
yline(0,'r','LineWidth',3)%linea 0 in grassetto e rossa
yline(mean(residuiBG5),'b','LineWidth',2)
title('Residui m5(BG)')
%Modello Pioggia e Ozono (migliore)
residuiBG6 = m6BG.Residuals.Raw;
Res_m6_BG=plot(residuiBG6)
yline(0,'r','LineWidth',3)%linea 0 in grassetto e rossa
yline(mean(residuiBG6),'b','LineWidth',2)
title('Residui m6(BG)')

%% Grafico y interpolata e dati(PM10) (BERGAMO)
%m5
Y_interpolato=tG.PM10_BG-residuiBG5;
X=tG.PM10_BG;
Grafico_m5_BG=scatter(X,Y_interpolato)
xlabel('Valori PM10 (reali)')
ylabel('Valori PM10 (stimati)')
title('Grafico m5(BG)')
hold on
Y=X;
plot(X,Y)
saveas(Grafico_m5_BG,'Grafico m5(BG)')
hold off
%m (stepwise)
residui=mBG.Residuals.Raw;
Y_interpolato=tG.PM10_BG-residui;
X=tG.PM10_BG;
Grafico_m_BG=scatter(X,Y_interpolato)
xlabel('Valori PM10 (reali)')
ylabel('Valori PM10 (stimati)')
title('Grafico stepwise(BG)')
hold on
Y=X;
plot(X,Y)
saveas(Grafico_m_BG,'Grafico modello ideale(BG)')
hold off
%m6 (migliore)
Y_interpolato=tG.PM10_BG-residuiBG6;
X=tG.PM10_BG;
Grafico_m6_BG=scatter(X,Y_interpolato)
xlabel('Valori PM10 (reali)')
ylabel('Valori PM10 (stimati)')
title('Grafico m6(BG)')
hold on
Y=X;
plot(X,Y)
saveas(Grafico_m6_BG,'Grafico m6(BG)')
hold off

%% Confronto Morbegno-Bergamo
%2)Coefficienti 
coef_SO=m5SO.Coefficients.Estimate
coef_BG=m6BG.Coefficients.Estimate

%3)Statisticamente significativi?
%p_value
pvalue_SO=m5SO.Coefficients.pValue
pvalue_BG=m6BG.Coefficients.pValue

%4)Confronto R2
R2_SO=m5SO.Rsquared.Ordinary
R2_BG=m6BG.Rsquared.Ordinary
%R2_SO=0.500    R2_BG=0.533

%5) p_value modello (totale)
M1=anova(m5SO,'summary');
p_valueSO=M1(2,5)
M2=anova(m6BG,'summary');
p_valueBG=M2(2,5)
%i due p_value sono comunque bassissimi

%6) grafico residui
%MORBEGNO
%m5
plotResiduals(m5SO,'fitted')
title('Residui m5(SO)')
%m stepwise
plotResiduals(mSO,'fitted')
title('Residui Stepwise(SO)')
%BERGAMO
%m5
plotResiduals(m5BG,'fitted')
title('Residui m5(BG)')
%m6
plotResiduals(m6BG,'fitted')
title('Residui m6(BG)')
%stepwise
plotResiduals(mBG,'fitted')
title('Residui Stepwise(BG)')
%6b)somma residui
%MORBEGNO 
somma_m5S0=sum(residuiSO5) %molto piccola, quasi 0->risultato ottimo
residuiSO=mSO.Residuals.Raw;
somma_stepSO=sum(residuiSO)
%BERGAMO
somma_m6BG=sum(residuiBG6) %molto piccola, quasi 0->risultato ottimo
residuiBG=mBG.Residuals.Raw;
somma_stepBG=sum(residuiBG)

%7) grafico modelli (con interpolato)
%Morbegno
open('Grafico m5(SO).fig')
%Bergamo
open('Grafico m6(BG).fig')












