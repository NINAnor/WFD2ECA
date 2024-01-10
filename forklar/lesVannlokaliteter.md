# Forklaringer for funksjonen `lesVannlokaliteter`

Funksjonen leser inn tabellen over vannlokaliteter fra vannmiljø-databasen.

_Innhold:_ [syntaks](#syntaks) – [argumenter](#argumenter) – [detaljer](#detaljer) – [funksjonsverdi](#funksjonsverdi) – [kode](#kode)


## Syntaks

```{r}
lesVannlokaliteter(vannkategori = c("L", "R", "C"), filsti = "data", kolonnenavn = "navnVL.csv")
```


## Argumenter

* `vannkategori` (**tekst-vektor**) må være én eller flere av bokstavene "L", "R" og/eller "C". Det angir vannkategorien som skal leses inn (innsjø, elv og/eller kyst).
* `filsti`  (**tekst-skalar**) angir filstien for filer som trengs (`kolonnenavn` samt VL-L.xlsx, VL-R.xlsx og VL-C.xlsx).
* `kolonnenavn` (**tekst-skalar**) angir navnet på en fil med kolonnenavn. Fila må være en semikolondelt tabell. Standardinnstillinga er å lese inn fila "[navnVL.csv](../data/navnVL.csv)".


## Detaljer

Funksjonen forutsetter at filer over vannlokaliteter er lasta fra [vannmiljø](https://vannmiljo.miljodirektoratet.no/)-databasen:

`https://vannmiljo.miljodirektoratet.no/ > Jeg vil > Søke > Søk i vannlokaliteter`

I fanen "Søk i vannlokaliteter" må man

- velge riktig "Vannkategori",
- trykke "Søk",
- trykke "Eksporter",
- velge eksporttype "Excel",
- trykke "Eksporter til epost".

Filer for de like vannkategoriene må lastes ned hver for seg. 
For at filene kan leses inn, må de få følgende navn:

- "**VL-L.xlsx**" for innsjøvannlokaliteter
- "**VL-R.xlsx**" for elvevannlokaliteter
- "**VL-C.xlsx**" for kystvannlokaliteter

Man trenger ikke å laste ned alle tre. Det holder med den vannkategorien som er relevant for vannforskrift-parameteren eller -parameterne.
Dette må samsvare med funksjonsargumentet `vannkategori`.


## Funksjonsverdi

Funksjonsverdien er en **tabell** (_dataframe_) med informasjon om alle vannlokaliteter. Tabellens kolonner er:

- `lokid` (**numerisk**), lokasjons-id
- `lokkod` (**tekst**), lokasjonskode
- `loknam` (**tekst**), vannlokalitetens navn
- `sjønr` (**numerisk**), innsjønummer
- `id` (**tekst**), vannforekomst-id-en
- `kat` (**tekst**), vannkategori ("C", "L", "R")
- `X` (**numerisk**), _x_-koordinat UTM (i meter)
- `Y` (**numerisk**), _y_-koordinat UTM (i meter)


## Kode

Funksjonens [kode kan inspiseres her](../R/lesVannlokaliteter.R).

