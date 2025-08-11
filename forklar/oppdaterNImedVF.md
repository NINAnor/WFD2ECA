# Forklaringer for funksjonen `oppdaterNImedVF`

Funksjonen forbereder og tester de oppdaterte indikatorverdiene for skriving til naturindeks-databasen.

_Innhold:_ [syntaks](#syntaks) – [argumenter](#argumenter) – [detaljer](#detaljer) – [funksjonsverdi](#funksjonsverdi) – [kode](#kode)


## Syntaks

```{r}
oppdaterNImedVF(NIdata, nyeData, avrunding = 5, enhet = "kommune", kvartiler = FALSE)
```


## Argumenter

* `NIdata` er det eksisterende datasettet i naturindeks-databasen. Dette må i forkant ha blitt lest inn ved hjelp av `NIcalc::getIndicatorValues`.
* `nyeData` er de nye indikatorverdiene som skal lastes opp til naturindeks-databasen. Dette vil vanligvis være utmatinga av funksjonen [`fraVFtilNI`](fraVFtilNI.md).
* `avrunding` (**numerisk skalar**) angir antall desimaler som de simulerte dataene skal avrundes til før de skrives til naturindeks-databasen.
* `enhet` (**tekst-skalar**) angir forvaltningsenheten som utgjør aggregeringsnivået som skal brukes i naturindeksen (f.eks. "kommune" eller "fylke").
* `kvartiler` (**sannhetsverdi-skalar**) angir om funksjonen `NIcalc::setIndicatorValues` skal få oppgitt indikatorverdienes sannsynlighetsfordeling via kvartiler. Alternativet (og standardinnstillinga) er å oppgi indikatorverdienes sannsynlighetsfordeling ved hjelp av `NIcalc::makeDistribution`, basert på alle simulerte data som inngår i `nyeData`.


## Detaljer

Funksjonen tar utgangspunkt i de aktuelle indikatorverdiene fra naturindeks-databasen (som må ha blitt lest inn ved hjelp av `NIcalc::getIndicatorValues`) og oppdaterer disse med indikatorverdiene som ligger i `nyeData`.
Funksjonen gjennomfører også noen grunnleggende tester for kompatibilitet mellom datasettene.

Funksjonen forutsetter at **R**-pakka [NIcalc](https://github.com/NINAnor/NIcalc) er installert og lasta inn.


## Funksjonsverdi

Funksjonsverdien er en **tabell** som har samme format som funksjonsverdien til `NIcalc::getIndicatorValues`, men med oppdaterte indikatorverdier.


## Kode

Funksjonens [kode kan inspiseres her](../R/fraVFtilNI.R).

