# Forklaringer for funksjonen `mEQR`

Funksjonen beregner modifiserte EQR-verdier.

_Innhold:_ [syntaks](#syntaks) – [argumenter](#argumenter) – [detaljer](#detaljer) – [funksjonsverdi](#funksjonsverdi) – [kode](#kode)


## Syntaks

```{r}
mEQR(x, klassegrenser)
```


## Argumenter

* `x` (**numerisk vektor**) er en verdi (eller en vektor eller matrise av verdier) av en vannforskriftsparameter oppgitt på parameterens opprinnelige måleskala.
* `klassegrenser` (**numerisk vektor**) er de klassegrensene for den aktuelle vannforskriftsparameteren, f.eks. slik de genereres av funksjonen [`hentKlassegrenser`](hentKlassegrenser.md). Vektoren må ha en lengde på 8 (minimumsverdien, seks klassegrenser og maksimumsverdien).


## Detaljer

Funksjonen transformerer måleverdier til mEQR-verdier.
I vannforskriften betegner **EQR**-verdier (_Ecological Quality Ratio_ eller "økologisk kvalitetskvotient") indeksverdier som er _trunkert_ og _skalert_ til en skala fra 0 (nedre grense for svært dårlig tilstand) til 1 (øvre grense for svært god tilstand), der
_trunkering_ betyr at "overskytende verdier kappes av" (måleverdier som er bedre enn referanseverdien, settes lik referanseverdien; og måleverdier som er dårligere enn "nullverdien", settes lik "nullverdien", dvs. dårligste tallverdi for svært dårlig tilstand), og 
_skalering_ betyr at at tallverdiene omregnes (lineært) til en skala der 0 tilsvarer "nullverdien" og 1 tilsvarer referanseverdien.
I et ytterligere trinn kan disse EQR-verdiene _transformeres_ til **nEQR**-verdier ("normaliserte økologiske kvalitetskvotienter"), der
_transformering_ betyr at tallverdiene "forskyves" (som regel ikke-lineært) slik at de samsvarer med de fem økologiske tilstandsklassene (0,0&ndash;0,2 for svært dårlig, 0,2&ndash;0,4 for dårlig, 0,4&ndash;0,6 for moderat, 0,6&ndash;0,8 for god, 0,8&ndash;1,0 for svært god). 
(Merk at [veileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), kap. 3.5, omtaler det siste trinnet som _normalisering_, ikke som _transformering_, som det matematisk sett er snakk om.
Matematisk betegner _normalisering_ det trinnet som her er omtalt som _skalering_.)

I naturindeksen er det imidlertid behov for ikke-trunkerte tilstandsverdier.
Sandvik ([2019](http://hdl.handle.net/11250/2631056), kap. 2.3) har derfor foreslått å endre på trinnenes rekkefølge: (1) skalering, (2) transformering, (3) trunkering
(for rekkefølgens betydning se [Fremstad mfl. 2023](https://hdl.handle.net/11250/3104185), kap. 3.6.).
Verdiene som er skalert og transformert, men ikke trunkert, kalles her **mEQR**-verdier ("m" for "modifisert" – eller som bokstaven før "n").
Utveksling av data mellom vannforskriften og naturindeksen skjer på dette stadiet, altså i form av mEQR-verdier.
Når disse til slutt trunkeres, får man igjen nEQR-verdier.
Fordelen er at de ikke-trunkerte verdiene først kan brukes i naturindeks-databasen til å estimere variasjonen i tilstandsverdiene.
En mer utførlig begrunnelse for og illustrasjon av den valgte beregningsmåten for mEQR er [gitt her](asympEQR.md).


## Funksjonsverdi

Funksjonsverdien er en **numerisk vektor** (eller skalar eller matrise) som er av samme dimensjon som `x` og inneholder mEQR-verdier.


## Kode

Funksjonens [kode kan inspiseres her](../R/mEQR.R).

