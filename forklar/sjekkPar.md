# Forklaringer for funksjonene `sjekkXXX`

Funksjonene sjekker om vannmiljø-målinger oppfyller parameterspesifikke krav.

_Innhold:_ [syntaks](#syntaks) – [argumenter](#argumenter) – [detaljer](#detaljer) – [funksjonsverdi](#funksjonsverdi) – [kode](#kode)


## Syntaks

```{r}
sjekkAIP(maaling, slingring, fraMaaned, tilMaaned)

sjekkANC(maaling)

sjekkASPT(maaling)

sjekkHBI2(maaling)

sjekkKLFA(maaling, slingring, fraMaaned, tilMaaned, antallSyd, antallNor)

sjekkLAL(maaling)

sjekkNTOT(maaling, slingring, fraMaaned, tilMaaned, antallSyd, antallNor)

sjekkPH(maaling)

sjekkPIT(maaling, slingring, fraMaaned, tilMaaned)

sjekkPPBIOMTOVO(maaling, slingring, fraMaaned, tilMaaned, antallSyd, antallNor)

sjekkPPTI(maaling, slingring, fraMaaned, tilMaaned, antallSyd, antallNor)

sjekkPTOT(maaling, slingring, fraMaaned, tilMaaned, antallSyd, antallNor)

sjekkRADDUM1(maaling)

sjekkTIANTL(maaling, slingring, fraMaaned, tilMaaned)
```


## Argumenter

* `maaling` (**tabell**) er et datasett med målinger.
* `slingring` (**numerisk skalar**) angir antall dager som godtas som avvik fra de spesifiserte månedene.
* `fraMaaned` (**numerisk skalar**) angir den første måneden i året (som et tall mellom 1 og 12) der målinger er gyldige. 
* `tilMaaned` (**numerisk skalar**) angir den siste måneden i året (som et tall mellom 1 og 12) der målinger er gyldige. 
* `antallSyd` (**numerisk skalar**) angir antall målinger som minst må foreligge i Norge sør for Saltfjellet. 
* `antallNor` (**numerisk skalar**) angir antall målinger som minst må foreligge i Norge nord for Saltfjellet. 


## Detaljer

Funksjonene kontrollerer visse parameterspesifikke krav, slik som antall målinger tatt i et år, måneden målingen er tatt i, vanntypen målingen er tatt i, og lignende.
Det fins separate funksjoner for ulike vannforskriftsparamtere.
Funksjonenes navn er "sjekk", etterfulgt av vannmiljø-databasens forkortelse av parameterne (der eventuelle bindestrek hlir utelatt).

Funksjonene brukes internt av funksjonene [`WFD2ECA`](WFD2ECA.md) og [`fraVFtilNI`](fraVFtilNI.md).
De er ikke tilrettelagt for annen bruk.
Funksjonenes parametere (unntatt `maaling`) kan angis som parametere for `WFD2ECA` og `fraVFtilNI`.
Disse kan brukes for å regulere "slingringsmonnet" rundt kravene.
Standardinnstillinga er å godta noen mindre avvik fra kravene, for ikke å redusere stikkprøvestørrelsen unødig.

For noen av vannforskriftsparameterne fins det krav som ikke kan kontrolleres basert på informasjon i vannmiljø-databasen.
I oversikten over [vannforskriftsparametere som er tilrettelagt for dataflyt](param.md#spesielle-krav-til-de-ulike-vannforskriftsparameterne), foreligger en mer detaljert forklaring av de parameterspesifikke kravene og hvilke av disse som kontrolleres av `sjekk`-funksjonene.


## Funksjonsverdi

Funksjonsverdien er en **numerisk vektor** som angir radene i `maaling` som _ikke_ oppfyller de parameterspesifikke kravene.

For noen av funksjonene (`sjekkASPT` og `sjekkRADDUM1`) har funksjonsverdien et attributt kalt `ikkeInkluder`, som har samme oppgave som det likelydende argumentet til funksjonene `WFD2ECA` og `fraVFtilNI`.


## Kode

Funksjonens [kode kan inspiseres her](../R/sjekkPar.R).

