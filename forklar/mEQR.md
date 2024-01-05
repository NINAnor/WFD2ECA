# Forklaringer for funksjonen `mEQR`

Funksjonen beregner modifiserte EQR-verdier.

_Innhold:_ [syntaks](#syntaks) – [argumenter](#argumenter) – [detaljer](#detaljer) – [funksjonsverdi](#funksjonsverdi) – [kode](#kode)


## Syntaks

```{r}
mEQR(x, klassegrenser)
```


## Argumenter

* `x` (**numerisk vektor**) er en verdi (eller en vektor av verdier) av en vannforskriftsparameter oppgitt på parameterens opprinnelige måleskala.
* `klassegrenser` (**numerisk vektor**) er klassegrensene for den aktuelle vannforskriftsparameteren, f.eks. slik de genereres av funksjonen [`hentKlassegrenser`](hentKlassegrenser.md).


## Detaljer

Funksjonen transformerer måleverdier til mEQR-verdier.
I vannforskriften betenger **EQR**-verdier (_Ecological Quality Ratio_ eller "økologisk kvalitetskvotient") indeksverdier som er _skalert_ og _trunkert_ til en skala fra 0 (nedre grense for svært dårlig tilstand) til 1 (øvre grense for svært god tilstand).
I et ytterligere trinn kan disse EQR-verdiene _transformeres_ til **nEQR**-verdier ("normaliserte økologiske kvalitetskvotienter";
merk at dette trinnet ikke omtales som _transformering_, men som _normalisering_ i [klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), kap. 3.5).
I naturindeksen er det imidlertid behov for ikke-trunkerte tilstandsverdier.
Sandvik ([2019](http://hdl.handle.net/11250/2631056), kap. 2.3) har derfor foreslått å endre på trinnenes rekkefølge: (1) skalering, (2) transformering, (3) trunkering
(for en detaljert redegjørelse se [Fremstad mfl. 2023](https://hdl.handle.net/11250/3104185), kap. 3.6.).
Verdiene som er skalert og transformert, men ikke trunkert, kalles her **mEQR**-verdier ("m" for "modifisert" – eller som bokstaven før "n").
Utveksling av data mellom vannforskriften og naturindeks skjer på dette stadiet, altså i form av mEQR-verdier.
Når disse til slutt trunkeres, får man igjen nEQR-verdier.
Fordelen er at de ikke-trunkerte verdiene først kan brukes i naturindeks-databasen til å estimere variasjonen i tilstandsverdiene.


## Funksjonsverdi

Funksjonsverdien er en **numerisk vektor** som er av samme dimensjon som `x` og inneholder mEQR-verdier.


## Kode

Funksjonens [kode kan inspiseres her](../R/mEQR.R).

