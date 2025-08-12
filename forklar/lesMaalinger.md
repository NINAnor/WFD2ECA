# Forklaringer for funksjonen `lesMaalinger`

Funksjonen leser inn målinger og måleenheter fra vannmiljø-databasen.

_Innhold:_ [syntaks](#syntaks) – [argumenter](#argumenter) – [detaljer](#detaljer) – [funksjonsverdi](#funksjonsverdi) – [kode](#kode)


## Syntaks

```{r}
lesMaalinger(parameter, filsti = "../data", kolonnenavn = "navnVM.csv", medium = "VF")
```


## Argumenter

* `parameter` (**tekst-skalar**) angir [vannmiljø-forkortelsen på en vannforskrifts-parameter](https://vannmiljokoder.miljodirektoratet.no/parameter/bio).
* `filsti`  (**tekst-skalar**) angir filstien for filen som trengs (`kolonnenavn`).
* `kolonnenavn` (**tekst-skalar**) angir navnet på en fil med kolonnenavn. Fila må være en semikolondelt tabell ([se detaljer](hjelpfil.md#vannmiljø-data-navnvm.csv)). Standardinnstillinga er å lese inn fila "[navnVM.csv](../data/navnVM.csv)".
* `medium` (**tekst-skalar**) angir [vannmiljø-forkortelsen på prøvetagingsmediet](https://vannmiljokoder.miljodirektoratet.no/medium). Målinger som ble tatt i et annet medium, blir ekskludert. Standardinnstillinga er mediet "VF" (=&nbsp;ferskvann). For kystvannforekomster må mediet "VS" (=&nbsp;saltvann) oppgis.


## Detaljer

Funksjonen leser inn registreringer av den oppgitte vannforskrifts-parameteren fra vannmiljø-databasens [API](https://vannmiljowebapi.miljodirektoratet.no/swagger/ui/index#/).

I tillegg leser den inn en liste over vannmiljø-databasens måleenheter og lagrer denne som en egen variabel ved navn `Enheter`.


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
- `filt` (**tekst**), filtrert
- `operator` (**tekst**), operator (som oftest "=", men kan f.eks. være "<" eller ">")
- `verdi` (**numerisk**), måleverdi
- `enhet` (**tekst**), måleenhet-id (se [kodeliste](https://vannmiljokoder.miljodirektoratet.no/unit))
- `provnr` (**tekst**), prøvenummer
- `detgr` (**tekst**), deteksjonsgrense
- `kvantgr` (**tekst**), kvantifiseringsgrense
- `antverdi` (**tekst**), antall verdier


## Kode

Funksjonens [kode kan inspiseres her](../R/lesMaalinger.R).

