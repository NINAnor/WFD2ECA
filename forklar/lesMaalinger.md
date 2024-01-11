# Forklaringer for funksjonen `lesMaalinger`

Funksjonen leser inn tabellen over målinger fra vannmiljø-databasen.

_Innhold:_ [syntaks](#syntaks) – [argumenter](#argumenter) – [detaljer](#detaljer) – [funksjonsverdi](#funksjonsverdi) – [kode](#kode)


## Syntaks

```{r}
lesMaalinger(filnavn, filsti = "data", kolonnenavn = "navnVM.csv")
```


## Argumenter

* `filnavn` (**tekst-skalar**) angir navnet på en fil med målinger. Fila må være et excel-regneark.
* `filsti`  (**tekst-skalar**) angir filstien for filer som trengs (`filnavn` og `kolonnenavn`).
* `kolonnenavn` (**tekst-skalar**) angir navnet på en fil med kolonnenavn. Fila må være en semikolondelt tabell. Standardinnstillinga er å lese inn fila "[navnVM.csv](../data/navnVM.csv)".


## Detaljer

Funksjonen forutsetter at et regneark med målinger er lasta fra [vannmiljø](https://vannmiljo.miljodirektoratet.no/)-databasen:

`https://vannmiljo.miljodirektoratet.no/ > Jeg vil > Søke > Søk i vannregistreringer og miljøgifter`

I fanen "Søk i registreringer" må man

- velge riktig "Parameter",
- eventuelt avgrense med andre kriterier (f.eks. "Prøvedato")
- trykke "Søk",
- trykke "Eksport",
- velge eksporttype "Redigeringsformat",
- trykke "Eksporter til epost".


## Funksjonsverdi

Funksjonsverdien er en **tabell** (_dataframe_) med informasjon om alle målinger. Tabellens kolonner er:

- `lokid` (**tekst**), vannlokalitetskode
- `aktid` (**tekst**), overvåkingsaktivitet (se [kodeliste](https://vannmiljokoder.miljodirektoratet.no/activity))
- `oppdrg` (**tekst**), oppdragsgiver
- `oppdrt` (**tekst**), oppdragstager
- `parid` (**tekst**), parameter-id (se [kodeliste](https://vannmiljokoder.miljodirektoratet.no/parameter/bio))
- `medium` (**tekst**), medium-id (se [kodeliste](https://vannmiljokoder.miljodirektoratet.no/medium))
- `navnid` (**tekst**), artsnavn-id (se [kodeliste](https://vannmiljokoder.miljodirektoratet.no/species))
- `vitnavn` (**tekst**), vitenskapelig artsnavn
- `provmet` (**tekst**), prøvetagingsmetode-id (se [kodeliste](https://vannmiljokoder.miljodirektoratet.no/samplingMethod))
- `analmet` (**tekst**), analysemetode-id (se [kodeliste](https://vannmiljokoder.miljodirektoratet.no/analysisMethod))
- `tidpkt` (**tekst**), prøvetagingstidspunkt (formatert som "YYYY-MM-DD hh:mm:ss")
- `odyp` (**tekst**), øvre dyp
- `ndyp` (**tekst**), nedre dyp
- `dypenh` (**tekst**), dybdeenhet
- `filt` (**tekst**), filtrert
- `unntas` (**tekst**), unntas klassifisering
- `operator` (**tekst**), operator
- `verdi` (**numerisk**), måleverdi
- `enhet` (**tekst**), måleenhet-id (se [kodeliste](https://vannmiljokoder.miljodirektoratet.no/unit))
- `provnr` (**tekst**), prøvenummer
- `detgr` (**tekst**), deteksjonsgrense
- `kvantgr` (**tekst**), kvantifiseringsgrense
- `antverdi` (**tekst**), antall verdier


## Kode

Funksjonens [kode kan inspiseres her](../R/lesMaalinger.R).

