# Modelltilpasning

Funksjonen [`fraVFtilNI`](fraVFtilNI.md) ekstrapolerer [mEQR-verdier](mEQR.md) til vannforekomster som det ikke foreligger målinger fra.
Denne [ekstrapoleringa](extrapol.md) er basert på en modell som blir tilpassa til de foreliggende målingene.
Modelltilpasninga gjøres slik:


## Modelltype

Modellen som tilpasses, er en lineær regresjon (***R***-funksjon `lm`).


## Avhengig variabel

Den avhengige variabelen, som er den valgte [vannforskriftsparameteren](param.md), transformeres før modelleringa.
Transformeringa består av to ulike trinn:

* Vannforskriftsparameteren gjøres om til [mEQR-verdier](mEQR.md). Det betyr at nullverdien (dårligste klassegrense for svært dårlig tilstand) tilsvarer 0, og at referanseverdien (beste klassegrense for svært god tilstand) tilsvarer 1, men uten at overskytende verdier blir trunkert. [Måten det gjøres på](asympEQR.md), styres av funksjonsargumentet `EQR`, men standardinnstillinga bør vanligvis ikke endres.
* For selve modelltilpasninga blir mEQR-verdiene i tillegg [logit-transformert](https://en.wikipedia.org/wiki/Logit). Siden mEQR-verdier kan bli mindre enn 0 og større enn 1, benyttes det en tilpassa logit-funksjon ([se funksjonene `skaler` og `reskaler`](../R/Funksjon.R)). Logit-transformeringa kan slås av ved å sette funksjonasrgumentet `logit = FALSE`, men standardinnstillinga bør vanligvis ikke endres. (Logit-transformeringa var ikke del av den [opprinnelige metodebeskrivelsen](http://hdl.handle.net/11250/2631056) og ble først implementert fra og med versjon 1.4. Ved å slå den av, kan man gjenskape utmatinga fra tidligere versjoner. Problemet med manglende logit-transformering er bl.a. at ekstrapolerte verdier kan bli vesentlig mye større enn 1 eller mindre enn 0.)


## Forklaringsvariabler


## Interaksjoner


## Vekting



## Modellseleksjon




