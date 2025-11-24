# Forklaringer for funksjonen `lesVannlokaliteter`

Funksjonen leser inn informasjon om vannlokaliteter fra vannmiljø-databasen.

_Innhold:_ [syntaks](#syntaks) – [argumenter](#argumenter) – [detaljer](#detaljer) – [funksjonsverdi](#funksjonsverdi) – [kode](#kode)


## Syntaks

```{r}
lesVannlokaliteter(vannkategori = c("L", "R"), filsti = "../data", kolonnenavn = "navnVL.csv", API = TRUE, ...)
```


## Argumenter

* `vannkategori` (**tekst-vektor**) må være én eller flere av bokstavene "L", "R" og/eller "C". Det angir vannkategorien som skal leses inn (innsjø, elv og/eller kyst). Standardinnstillinga er både "L" og "R", men ikke "C". (Frem til versjon 2.0 bestod standardinnstillinga av alle tre.)
* `filsti`  (**tekst-skalar**) angir filstien for filer som trengs (`kolonnenavn`).
* `kolonnenavn` (**tekst-skalar**) angir navnet på en fil med kolonnenavn. Fila må være en semikolondelt tabell ([se detaljer](hjelpfil.md#vannlokaliteter-vl-.xlsx-navnvl.csv)). Standardinnstillinga er å lese inn fila "[navnVL.csv](../data/navnVL.csv)".
* `API` (**sannhetsverdi-skalar**) angir om vannlokalitetene skal leses inn fra vannmiljøets API (hvis `TRUE`) eller fra en fil (hvis `FALSE`).
* `...` gir muligheten til å korrigere eller oppdatere informasjon om vannmiljøets API. Hvis dette er nødvendig, må det oppgis fire argumenter med navnene `baseURL` (API-ens basis-URL), `ENDpoint` (API-ens endelse for vannlokaliteter) og `APIkey` (nøkkelen til API-en).


## Detaljer

Ved `API = TRUE` leser funksjonen inn den oppgitte informasjonen fra vannmiljø-databasens [API](https://vannmiljoapi.miljodirektoratet.no/swagger/ui/index#/Public). 
Ved `API = FALSE` leses informasjonen inn fra én eller flere excel-regneark som må ha blitt lasta ned manuelt fra [vannmiljø-databasen](https://vannmiljo.miljodirektoratet.no/#/searchwaterlocations). 
Regnearkene må i så fall ha navnet/navnene "VL-&ast;.xlsx", der "&ast;" må byttes ut med "L" for innsjøvannlokaliteter, med "R" for elvevannlokaliteter og med "C" for kystvannlokaliteter.


## Funksjonsverdi

Funksjonsverdien er en **tabell** (_dataframe_) med informasjon om alle vannlokaliteter. Tabellens kolonner er:

- `lokid` (**numerisk**), lokasjons-id
- `lokkod` (**tekst**), lokasjonskode
- `loknam` (**tekst**), vannlokalitetens navn
- `sjonr` (**numerisk**), NVEs innsjønummer
- `id` (**tekst**), vannforekomst-id-en
- `kat` (**tekst**), vannkategori ("C", "L", "R")
- `X` (**numerisk**), _x_-koordinat UTM (i meter)
- `Y` (**numerisk**), _y_-koordinat UTM (i meter)


## Kode

Funksjonens [kode kan inspiseres her](../R/lesVannlokaliteter.R).

