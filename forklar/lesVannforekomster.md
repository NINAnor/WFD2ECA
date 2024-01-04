# Forklaringer for funksjonen `lesVannforekomster`

Funksjonen leser inn tabellen over vannforekomster fra vann-nett.


## Syntaks

```{r}
lesVannforekomster(vannkategori = c("L", "R", "C"), filsti = "data", kolonnenavn = "navnVN.csv")
```


## Argumenter

* `vannkategori` (**tekst-vektor**) må være én eller flere av bokstavene "L", "R" og/eller "C". Det angir vannkategorien som skal leses inn (innsjø, elv og/eller kyst).
* `filsti`  (**tekst-skalar**) angir filstien for filer som trengs (`kolonnenavn` samt V-L.csv, V-R.csv og V-C.csv).
* `kolonnenavn` (**tekst-skalar**) angir navnet på en fil med kolonnenavn. Fila må være en semikolondelt tabell. Standardinnstillinga er å lese inn fila "[navnVN.csv](../data/navnVN.csv)".


## Detaljer

Funksjonen forutsetter at filer over vannforekomster er lasta ned fra [vann-nett](https://vann-nett.no/portal/):

`https://vann-nett.no/portal/ > Rapporter > Vanntyper`

Filer for de ulike vannkategoriene må lastes ned hver for seg:

- Innsjøvannforekomster med vanntypeparametere, påvirkninger, tilstand, potensial og miljømål
- Elvevannforekomster   med vanntypeparametere, påvirkninger, tilstand, potensial og miljømål
- Kystvannforekomster   med vanntypeparametere, påvirkninger, tilstand, potensial og miljømål

For at filene kan leses inn, må de få følgende navn:

- "**V-L.csv**" for innsjøvannforekomstene
- "**V-R.csv**" for elvevannforekomstene
- "**V-C.csv**" for kystvannforekomstene

Man trenger ikke å laste ned alle tre. Det holder med den vannkategorien som er relevant for vannforskrift-parameteren eller -parameterne.
Dette må samsvare med funksjonsargumentet `vannkategori`.


## Funksjonsverdi

Funksjonsverdien er en **tabell** (_dataframe_) med informasjon om alle vannforekomster. Tabellens kolonner er:

- `id` (**tekst**), vannforekomst-id-en
- `nam` (**tekst**), vannforekomstens navn
- `typ` (**tekst**), vanntypekode
- `nas` (**tekst**), nasjonal vanntype
- `int` (**tekst**), interkalibreringstype
- `kat` (**tekst**), vannkategori ("C", "L", "R")
- `reg` (**tekst**), økoregion (se [klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), kap. 3.3, for denne og de følgende typologifaktorene)
- `son` (**tekst**), klimasone
- `stø` (**tekst**), størrelsesklasse
- `alk` (**tekst**), alkalitet
- `hum` (**tekst**), humøsitet
- `tur` (**tekst**), turbiditet
- `dyp` (**tekst**), dybde
- `kys` (**tekst**), kystvanntype (se [klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), kap. 3.4, for denne og de følgende typologifaktorene)
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
- `hoh` (**numerisk**), høyde over havet (i meter); denne og de følgende kolonnene kan foreløpig ikke fylles med data fra vann-nett (ved innlesing inneholder de dermed kun `NA`)
- `areal` (**numerisk**), innsjøareal (i km<sup>2<sup>)
- `dybde` (**numerisk**), dybde ( i meter)
- `tilsig` (**numerisk**), tilsigsfeltets areal (i km<sup>2<sup>)
- `utmx` (**numerisk**), _x_-koordinat UTM (i meter)
- `utmy` (**numerisk**), _y_-koordinat UTM (i meter)
- `lat` (**numerisk**), geografisk bredde (i &deg;N)
- `long` (**numerisk**), geografisk lengde (i &deg;Ø)


## Kode

Funksjonens [kode kan inspiseres her](../R/lesVannforekomster.R).

