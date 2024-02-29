# Forklaringer for funksjonen `kombiner`

Funksjonen kombinerer to utmatinger for samme parameter til en felles resultatvariabel.


## Syntaks

```{r}
kombiner(ut1, ut2)
```


## Argumenter

* `ut1` (**liste**) er en utmating av [`fraVFtilNI`](fraVFtilNI.md).
* `ut2` (**liste**) er en annen utmating av [`fraVFtilNI`](fraVFtilNI.md).


## Detaljer

Funksjonen kombinerer to ulike utmatinger av [`fraVFtilNI`](fraVFtilNI.md).
Forutsetninga er at begge utmatingene gjelder _samme vannforskriftsparameter_, men _forskjellige vannkategorier_ (f.eks. "L" og "R"). 
Dermed utfører funksjonen [trinn 16 av dataflyten](dataflyt.md).
Dette trinnet er kun aktuell for få [parametere](param.md), f.eks. Raddum forsuringsindeks I.


## Funksjonsverdi

Funksjonsverdien er en **numerisk matrise** som inneholder klassegrenser.
Med klassegrense menes terskelverdiene mellom økologiske tilstandsklasser (svært dårlig, dårlig, moderat, god og svært god).
Matrisens kolonner og rader har de følgende navn:

- Kolonnenavnene er `c("min", "SD_nedre", "SD_D", "D_M", "M_G", "G_SG", "SG_øvre", "max")`, som identifiserer klassegrensene samt den dårligste og beste verdien som er teknisk mulig.
- Radnavnene er forkorta vanntyper ("LEL11011" osv.).


## Kode

Funksjonens [kode kan inspiseres her](../R/Funksjon.R).

