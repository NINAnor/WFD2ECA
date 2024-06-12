# Forklaringer for funksjonen `lesVannforekomster`

Funksjonen leser inn tabellen over vannforekomster fra vann-nett.

_Innhold:_ [syntaks](#syntaks) – [argumenter](#argumenter) – [detaljer](#detaljer) – [funksjonsverdi](#funksjonsverdi) – [kode](#kode)


## Syntaks

```{r}
lesVannforekomster(vannkategori = c("L", "R", "C"), filsti = "data", kolonnenavn = "navnVN.csv", turbid = TRUE,
                   NVEnavn = c("SHAPE", "identifikasjon_lokalId", "arealKvadratkilometer", "lengdeKilometer"),
                   slingringsmonn = 0.02, CACHE = NULL)
```


## Argumenter

* `vannkategori` (**tekst-vektor**) må være én eller flere av bokstavene "L", "R" og/eller "C". Det angir vannkategorien(e) som skal leses inn (innsjø, elv og/eller kyst).
* `filsti`  (**tekst-skalar**) angir filstien for filer som trengs (`kolonnenavn` samt VF.gdb, V-L.csv, V-R.csv og V-C.csv).
* `kolonnenavn` (**tekst-skalar**) angir navnet på en fil med kolonnenavn. Fila må være en semikolondelt tabell ([se detaljer](hjelpfil.md#vannforekomster-v-.csv-navnvn.csv)). Standardinnstillinga er å lese inn fila "[navnVN.csv](../data/navnVN.csv)".
* `NVEnavn` (**tekst-vektor**) angir kolonnenavna i formfila. Standardinnstillinga er tilpassa det nåværende formatet på Miljødirektoratets karteksport.
* `turbid` (**sannhetsverdi-skalar**) angir om hva som skal skje med vannforekomster hvis humøsitet er "satt til turbid". Standardinnstillinga (`TRUE`) innebærer at humøsitet endres til "klar" for brepåvirka vannforekomster og til "humøs" for leirpåvirka vannforekomster. Ved `turbid = FALSE` beholdes humøsitet uendra, som vil si at vannforekomster som er satt til turbid, ikke inngår i de videre analysene.
* `slingringsmonn` (**numerisk skalar**) angir hvilket relativt avvik fra de reelle verdiene som godtas før opplysninger blir korrigert for en vannforekomst. Standardinnstillinga er 2&nbsp;%.
* `CACHE` (**tekst-skalar**) skal vanligvis være `NULL`. Om den angir navnet til en eventuell RData-fil, brukes denne istedenfor formfila "VF.gdb".


## Detaljer

Funksjonen forutsetter at filer over vannforekomstenes (1) beliggenhet og deres (2) typologi er tilgjengelig.

(1) Data over vannforekomstenes beliggenhet må være lasta ned som formfil (gdb) fra Miljødirektoratet (<https://karteksport.miljodirektoratet.no/>). I menyen må man foreta de følgende valg:

-   Produkt: “Vannforekomster”
-   Definer område: “nasjonalt”
-   Format: “ESRI Filgeodatabase (ESPG:4326)”

Datasettet man da får tilsendt per e-post, må dekomprimeres og døpes om
til “**VF.gdb**”.

(2) Filer over vannforekomstenes typologi må lastes ned som excel-filer (csv) fra [vann-nett](https://vann-nett.no/portal/):

`https://vann-nett.no/portal/ > Rapporter > Vanntyper`

Filer for de ulike vannkategoriene må lastes ned hver for seg:

- Innsjøvannforekomster med vanntypeparametere, påvirkninger, tilstand, potensial og miljømål
- Elvevannforekomster   med vanntypeparametere, påvirkninger, tilstand, potensial og miljømål
- Kystvannforekomster   med vanntypeparametere, påvirkninger, tilstand, potensial og miljømål

For at filene kan leses inn, må de få følgende navn:

- "**V-L.csv**" for innsjøvannforekomstene
- "**V-R.csv**" for elvevannforekomstene
- "**V-C.csv**" for kystvannforekomstene

Man trenger ikke å laste ned alle tre.
Det holder med den vannkategorien som er relevant for vannforskrift-parameteren eller -parameterne.
Dette må samsvare med funksjonsargumentet `vannkategori`.


## Funksjonsverdi

Funksjonsverdien er en **tabell** (_dataframe_) med informasjon om alle vannforekomster. Tabellens kolonner er:

- `id` (**tekst**), vannforekomst-id-en
- `nam` (**tekst**), vannforekomstens navn
- `typ` (**tekst**), vanntypekode
- `nas` (**tekst**), nasjonal vanntype
- `int` (**tekst**), interkalibreringstype
- `kat` (**tekst**), vannkategori ("C", "L", "R")
- `reg` (**tekst**), økoregion (se [klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), kap. 3.3, for denne og de følgende 6 typologifaktorene)
- `son` (**tekst**), klimasone
- `stø` (**tekst**), størrelsesklasse
- `alk` (**tekst**), alkalitet
- `hum` (**tekst**), humøsitet
- `tur` (**tekst**), turbiditet
- `dyp` (**tekst**), dybde
- `kys` (**tekst**), kystvanntype (se [klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), kap. 3.4, for denne og de følgende 6 typologifaktorene)
- `sal` (**tekst**), salinitet
- `tid` (**tekst**), tidevann
- `eks` (**tekst**), bølgeeksponering
- `mix` (**tekst**), miksing
- `opp` (**tekst**), oppholdstid
- `str` (**tekst**), strømhastighet
- `smvf` (**sannhetsverdi**), sterkt modifisert vannforekomst
- `øtil` (**tekst**), økologisk tilstandsklasse
- `øpot` (**tekst**), økologisk potensial
- `ktil` (**tekst**), kjemisk tilstand
- `ømål` (**tekst**), miljømål for økologisk tilstand
- `pmål` (**tekst**), miljømål for økologisk potensialmål
- `kmål` (**tekst**), kjemisk miljømål
- `vassdrag` (**tekst**), vassdragsområde
- `område` (**tekst**), vannområde
- `region` (**tekst**), vannregion
- `knr` (**tekst**), kommunenummer (ev. flere, adskilt ved komma)
- `kommune` (**tekst**), kommune(r)
- `fylke` (**tekst**), fylke(r)
- `hoh` (**numerisk**), høyde over havet (i meter); kun tilgjengelig for innsjøvannforekomster
- `areal` (**numerisk**), areal i Norge (i km<sup>2</sup>); kun tilgjengelig for innsjø- og kystvannforekomster
- `artot` (**numerisk**), totalt areal (i km<sup>2</sup>), inkludert utenlandske andeler (fra versjon 1.3); kun tilgjengelig for innsjø- og kystvannforekomster
- `lengd` (**numerisk**), lengde (i km; fra versjon 1.3); kun tilgjengelig for elvevannforekomster
- `dybde` (**numerisk**), dybde (i meter); foreløpig ikke implementert (inneholder kun `NA`)
- `tilsig` (**numerisk**), tilsigsfeltets areal (i km<sup>2</sup>); foreløpig ikke implementert (inneholder kun `NA`)
- `utmx` (**numerisk**), _x_-koordinat UTM (i meter); foreløpig ikke implementert (inneholder kun `NA`)
- `utmy` (**numerisk**), _y_-koordinat UTM (i meter); foreløpig ikke implementert (inneholder kun `NA`)
- `lat` (**numerisk**), geografisk bredde (i &deg;N)
- `long` (**numerisk**), geografisk lengde (i &deg;Ø)


## Kode

Funksjonens [kode kan inspiseres her](../R/lesVannforekomster.R).
