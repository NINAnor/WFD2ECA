# Forklaringer for funksjonen `lesVannlokaliteter`

Funksjonen leser inn informasjon om vannlokaliteter fra vannmiljø-databasen.

_Innhold:_ [syntaks](#syntaks) – [argumenter](#argumenter) – [detaljer](#detaljer) – [funksjonsverdi](#funksjonsverdi) – [kode](#kode)


## Syntaks

```{r}
lesVannlokaliteter(vannkategori = c("L", "R", "C"), filsti = "../data", kolonnenavn = "navnVL.csv")
```


## Argumenter

* `vannkategori` (**tekst-vektor**) må være én eller flere av bokstavene "L", "R" og/eller "C". Det angir vannkategorien som skal leses inn (innsjø, elv og/eller kyst).
* `filsti`  (**tekst-skalar**) angir filstien for filer som trengs (`kolonnenavn`).
* `kolonnenavn` (**tekst-skalar**) angir navnet på en fil med kolonnenavn. Fila må være en semikolondelt tabell ([se detaljer](hjelpfil.md#vannlokaliteter-vl-.xlsx-navnvl.csv)). Standardinnstillinga er å lese inn fila "[navnVL.csv](../data/navnVL.csv)".


## Detaljer

Funksjonen leser inn den oppgitte informasjonen fra vannmiljø-databasens [API](https://vannmiljowebapi.miljodirektoratet.no/swagger/ui/index#/).


## Funksjonsverdi

Funksjonsverdien er en **tabell** (_dataframe_) med informasjon om alle vannlokaliteter. Tabellens kolonner er:

- `lokid` (**numerisk**), lokasjons-id
- `lokkod` (**tekst**), lokasjonskode
- `loknam` (**tekst**), vannlokalitetens navn
- `id` (**tekst**), vannforekomst-id-en
- `kat` (**tekst**), vannkategori ("C", "L", "R")
- `X` (**numerisk**), _x_-koordinat UTM (i meter)
- `Y` (**numerisk**), _y_-koordinat UTM (i meter)


## Kode

Funksjonens [kode kan inspiseres her](../R/lesVannlokaliteter.R).

