# Forklaringer for funksjonen `oppdaterNImedVF`

Funksjonen forbereder og tester de oppdaterte indikatorverdiene for skriving til naturindeks-databasen.

_Innhold:_ [syntaks](#syntaks) – [argumenter](#argumenter) – [detaljer](#detaljer) – [funksjonsverdi](#funksjonsverdi) – [kode](#kode)


## Syntaks

```{r}
oppdaterNImedVF(NIdata, nyeData, avrunding = 5, enhet = "kommune")
```


## Argumenter

* `NIdata` er det eksisterende datasettet i naturindeks-databasen. Dette må i forkant ha blitt lest inn ved hjelp av `NIcalc::getIndicatorValues`.
* `nyeData` er de nye indikatorverdiene som skal lastes opp til naturindeks-databasen. Dette vil vanligvis være utmatinga av funksjonen [`fraVFtilNI`](fraVFtilNI.md).
* `avrunding` (**numerisk skalar**) angir antall desimaler som de simulerte dataene skal avrundes til før de skrives til naturindeks-databasen.
* `enhet` (**tekst-skalar**) angir forvaltningsenheten som utgjør aggregeringsnivået som skal brukes i naturindeksen (f.eks. kommune eller fylke).


## Detaljer

Funksjonen tar utgangspunkt i de aktuelle indikatorverdiene fra naturindeks-databasen (som må ha blitt lest inn ved hjelp av `NIcalc::getIndicatorValues`) og oppdaterer disse med indikatorverdiene som ligger i `nyeData`.
Funksjonen gjennomfører også noen grunnleggende tester for kompatibilitet mellom datasettene.

Funksjonen forutsetter at man er logga på naturindeks-databasen ved hjelp av **R**-pakka [NIcalc](https://github.com/NINAnor/NIcalc). (Dette skjer med `NIcalc::getToken`.)


## Funksjonsverdi

Funksjonsverdien er en **tabell** som har samme format som funksjonsverdien til `NIcalc::getIndicatorValues`, men med oppdaterte indikatorverdier.


## Kode

Funksjonens [kode kan inspiseres her](../R/oppdaterNImedVF.R).

