# Forklaringer for funksjonen `oppdaterNImedVF`

Funksjonen skriver de oppdaterte indikatorverdiene til naturindeks-databasen.

_Innhold:_ [syntaks](#syntaks) – [argumenter](#argumenter) – [detaljer](#detaljer) – [funksjonsverdi](#funksjonsverdi) – [kode](#kode)


## Syntaks

```{r}
oppdaterNImedVF(indikatorID, nyeData, avrunding = 6)
```


## Argumenter

* `indikatorID` (**numerisk skalar**) er indikatorens id i naturindeks-databasen (f.eks. slik den vises av funksjonen `NIcalc::getIndicators`).
* `nyeData` er de nye indikatorverdiene som skal lastes opp til naturindeks-databasen. Dette vil vanligvis være utmatinga av funksjonen [`fraVFtilNI`](fraVFtilNI.md).
* `avrunding` (**numerisk skalar**) angir antall desimaler som de simulerte dataene skal avrundes til før de skrives til naturindeks-databasen.


## Detaljer

Funksjonen leser inn de aktuelle indikatorverdiene fra naturindeks-databasen (ved hjelp av `NIcalc::getIndicatorValues`) og oppdaterer disse med indikatorverdiene som ligger i `nyeData`.
Om prosessen forløp uten feil, får man tilbud om å skrive de oppdaterte verdiene til naturindeks-databasen.

Funksjonen forutsetter at man er logga på naturindeks-databasen ved hjelp av **R**-pakka [NIcalc](https://github.com/NINAnor/NIcalc). (Dette skjer med `NIcalc::getToken`.)


## Funksjonsverdi

Funksjonsverdien er enten `NULL` (hvis det skjedde en feil eller skriving til databasen var vellykket) eller en **liste** som er klar til å lastes opp til naturindeks-databasen (hvis det ikke skjedde noen feil, men skriving til databasen ble utsatt).
I det siste tilfellet har funksjonsverdien altså samme format som funksjonsverdien til `NIcalc::getIndicatorValues`, men med oppdaterte indikatorverdier.


## Kode

Funksjonens [kode kan inspiseres her](../R/oppdaterNImedVF.R).

