# Forklaringer for funksjonen `lesInnsjodatabasen`

Funksjonen leser inn datasettet over innsjøer fra NVE.

_Innhold:_ [syntaks](#syntaks) – [argumenter](#argumenter) – [detaljer](#detaljer) – [funksjonsverdi](#funksjonsverdi) – [kode](#kode)


## Syntaks

```{r}
lesInnsjodatabasen(filnavn = "Innsjo_Innsjo.dbf", filsti = "../data", kolonnenavn = "navnNVEl.csv", CACHE = NULL)
```


## Argumenter

* `filnavn` (**tekst-skalar**) angir navnet på datasettet. Standardinnstillinga er å lese inn fila "Innsjo_Innsjo.dbf".
* `filsti` (**tekst-skalar**) angir filstien for filer som trengs (`filnavn` med resten av formfila samt `kolonnenavn`).
* `kolonnenavn` (**tekst-skalar**) angir navnet på en fil med kolonnenavn. Fila må være en semikolondelt tabell ([se detaljer](hjelpfil.md#innsjødatabasen-navnnvel.csv)). Standardinnstillinga er å lese inn fila "[navnNVEl.csv](../data/navnNVEl.csv)".
* `CACHE` (**tekst-skalar**) skal vanligvis være `NULL`. Om den angir navnet til en eventuell RData-fil, brukes denne istedenfor formfila "Innsjo_Innsjo.dbf".


## Detaljer

Funksjonen forutsetter at datasettet over innsjøer er lasta ned som en formfil fra [NVE](http://nedlasting.nve.no/gis/).
På nedlastingssida må man foreta følgende valg:

- datatype "Vektordata"
- utvide menyvalg "Innsjø"
- krysse av "Innsjø"
- klikke "Neste" 
- kartformat "ESRI shapefil (.shp)"
- koordinatsystem "Geografiske koordinater ETRS89"
- utvalgsmetode "Overlapper"
- dekningsområde "Landsdekkende"
- klikke "Neste"
- angi e-post
- godta vilkår
- klikke "Send"


## Funksjonsverdi

Funksjonsverdien er en **tabell** (_dataframe_) med informasjon om alle innsjøer. Tabellens kolonner er:

- `lnr` (**heltall**), innsjø-løpenummer
- `nam` (**tekst**), innsjøens navn
- `reg` (**sannhetsverdi**), regulert innsjø
- `mnr` (**heltall**), magasinnummer
- `hoh` (**heltall**), høyde over havet (i meter)
- `areal` (**numerisk**), totalt innsjøareal (i km<sup>2</sup>)
- `arealn` (**numerisk**), innsjøareal i Norge (i km<sup>2</sup>)
- `tilsig` (**numerisk**), tilsigsfeltets areal (i km<sup>2</sup>)
- `vassdrag` (**tekst**), vassdragsnummer
- `omrade` (**tekst**), vannområdenummer
- `lat` (**numerisk**), geografisk bredde (i &deg;N); denne og den følgende kolonnen blir foreløpig ikke fylt med data (ved innlesing inneholder de dermed kun `NA`)
- `lon` (**numerisk**), geografisk lengde (i &deg;Ø)


## Kode

Funksjonens [kode kan inspiseres her](../R/lesInnsjodatabasen.R).

