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

Funksjonsverdien er en liste som i sine listeelementer tilsvarer utmatinga av funksjonen [`fraVFtilNI`](fraVFtilNI.md).


## Kode

Funksjonens [kode kan inspiseres her](../R/Funksjon.R).

