# Forklaringer for funksjonen `lesInnsjodatabasen`

Funksjonen leser inn datasettet over innsjøer fra NVE.


## Syntaks

```{r}
lesInnsjodatabasen(filnavn = "Innsjo_Innsjo.dbf", filsti = "data", kolonnenavn = "navnNVEl.csv")
```


## Argumenter

* `filnavn` (**tekst-skalar**) angir navnet på datasettet. Standardinnstillinga er å lese inn fila "Innsjo_Innsjo.dbf".
* `filsti` (**tekst-skalar**) angir filstien for filer som trengs (`filnavn` med resten av formfila samt `kolonnenavn`).
* `kolonnenavn` (**tekst-skalar**) angir navnet på en fil med kolonnenavn. Fila må være en semikolondelt tabell. Standardinnstillinga er å lese inn fila "[navnNVEl.csv](../data/navnNVEl.csv)".


## Detaljer

Funksjonen forutsetter at datasettet over innsjøer er lasta ned som en formfil fra [NVE](http://nedlasting.nve.no/gis/):

`http://nedlasting.nve.no/gis/ > Innsjø > Innsjø`

I menyen må man foreta følgende valg:

- kartformat "ESRI shapefil (.shp)"
- koordinatsystem "Geografiske koordinater ETRS89"
- utvalgsmetode "Overlapper"
- dekningsområde "Landsdekkende"


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
- `område` (**tekst**), vannområdenummer
- `lat` (**numerisk**), geografisk bredde (i &deg;N); denne og den følgende kolonnen blir foreløpig ikke fylt med data (ved innlesing inneholder de dermed kun `NA`)
- `lon` (**numerisk**), geografisk lengde (i &deg;Ø)


## Kode

Funksjonens [kode kan inspiseres her](../R/lesInnsjodatabasen.R).

