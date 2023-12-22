# ITALIANO
All'interno della cartella sono inseritti due progetti realizzati durante il corso di Statistica presso l'Università degli studi di Bergamo.
Entrambi i lavori sono stati svolti in collaborazione con altri tre colleghi.

Il primo progetto "S1Project" riguarda lo studio delle concentrazioni di PM10 presenti nell'aria in funzione delle variabili atmosferiche e delle concentrazini di Ozono. Le misurazoni a disposizione (dataset "G27") sono state rilevate nelle città di Bergamo e di Morbegno.
Per entrambe le stazioni si è cercato un modello statistcio che potesse prevedere in modo significativo le concentrazioni di PM10 in funzione delle altre covariate a disposizione; per farlo è stato utilizzato il comando "stepwiselm" e la funzione "fitlm" di Matlab e sono stati condotti dei ragionamnenti basati sulla significatività delle covariate con lo scopo di trovare per ciascuna stazione il modello migliore possibile.
E' stato sviluppato anche un confronto tra i due modelli sulla base di: 
➢ covariate;
➢ coefficiente di determinazione multipla;
➢ p-value del modello;
➢ valutazione dei residui;
➢ grafico delle interpolate.
Nella repository è stato inserito il documento "S1Report" contenente una spiegazione dettagliata dle progetto e dei risultati ottenuti.

Il secondo progetto "S2Project" riguarda lo studio di un dataset fornito durante il corso di Statistica 2 contenente dati metereologici raccolti da uan stazione meteo mobile INAIL.
L'obiettivo del progetto è stato quello di ceracre un modello statistico che potesse spiegare la temperatura del suolo (rilevata dal sensore INAIL) in funzione di uno o più regressori tra quelli a disposizione.
L’approccio iniziale è stato quello di osservare la matrice di correlazione per individuare quali fossero i parametrimaggiormente correlati alla  variabile di interesse. Successivamente è stato sviluppato un modello di regressione lineare.
Infine si è passati ad un'analisi più approfondita e precisa condotta con B-Spline.
Nella repository è stata insertita una cartella "S2Project" contenente l'intero codice Matlab sviluppato e i datasets di partenza.
Il file "S2Report" è invece una descrizione del lavoro svolto e mostra i risultati ottenuti dallo studio. 


# ENGLISH 
Within the folder there are two projects completed during the Statistics course at the University of Bergamo. Both projects were carried out in collaboration with three  colleagues of mine.

The first project, named "S1Project," focuses on studying PM10 concentrations in the air in relation to atmospheric variables and Ozone concentrations. 
Measurements from the "G27" dataset were taken in the cities of Bergamo and Morbegno. 
For both stations, a statistical model predicting PM10 concentrations was created. 
The "stepwiselm" command and the "fitlm" function of Matlab were used, and reasoning based on the significance of covariates was conducted to find the best model for each station. 
A comparison between the two models was also conducted based on:
➢ covariates;
➢ multiple determination coefficient;
➢ model p-value;
➢ residuals evaluation;
➢ interpolation graphs. 
The repository contains the "S1Report" document with a detailed explanation of the project and results obtained.

The second project, named "S2Project," involves the study of a dataset provided during the Statistics 2 course containing meteorological data collected by an INAIL mobile weather station. 
The goal was to create a statistical model explaining soil temperature (detected by the INAIL sensor) based on one or more available regressors. 
The initial approach involved observing the correlation matrix to identify parameters most correlated with the variable of interest. 
Subsequently, a linear regression model was developed, followed by a more in-depth and precise analysis conducted with B-Spline. 
The repository contains an "S2Project" folder with the entire Matlab code developed and the initial datasets. 
The "S2Report" file describes precisely the work done and presents the results obtained from the study.