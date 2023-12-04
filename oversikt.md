# Oversikt over funksjoner

### Hjelpefunksjoner

Diverse hjelpefunksjoner er definert i fila "[Funksjon.R](Funksjon.R)".
Disse er ikke nærmere forklart her.


### `lesVannforekomster` 

Funksjonen [`lesVannforekomster`](Vannfork.R) leser inn tabellen over vannforekomster fra vann-nett.
Funksjonen har to argumenter:

* `vannkategori` (**tekst-vektor**) må være én eller flere av bokstavene "L", "R" og/eller "C". Det angir vannkategorien som skal leses inn (innsjø, elv og/eller kyst).
* `kolonnenavn` (**tekst-skalar**) angir navnet på en fil med kolonnenavn. Fila må være en semikolondelt tabell. Standardinnstillinga er å lese inn fila "[navnVN.csv](navnVN.csv)".

Funksjonsverdien er en **tabell** (_dataframe_) med informasjon om alle vannforekomster.

Funksjonen forutsetter dessuten at filer over vannforekomster er lasta ned fra [vann-nett](https://vann-nett.no/portal/):

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



### `lesVannlokaliteter`

Funksjonen [`lesVannlokaliteter`](Vannfork.R) leser inn tabellen over vannlokaliteter fra vannmiljø.
Funksjonen har to argumenter:

* `vannkategori` (**tekst-vektor**) må være én eller flere av bokstavene "L", "R" og/eller "C". Det angir vannkategorien som skal leses inn (innsjø, elv og/eller kyst).
* `kolonnenavn` (**tekst-skalar**) angir navnet på en fil med kolonnenavn. Fila må være en semikolondelt tabell. Standardinnstillinga er å lese inn fila "[navnVL.csv](navnVL.csv)".

Funksjonsverdien er en **tabell** (_dataframe_) med informasjon om alle vannlokaliteter.

Funksjonen forutsetter dessuten at filer over vannlokaliteter er lasta fra [vannmiljø](https://vannmiljo.miljodirektoratet.no/)-databasen:

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



### `lesInnsjodatabasen` 

Funksjonen [`lesInnsjodatabasen`](Vannfork.R) leser inn datasettet over innsjøer fra NVE.
Funksjonen har to argumenter:

* `filnavn` (**tekst-skalar**) angir navnet på datasettet. Standardinnstillinga er å lese inn fila "Innsjo_Innsjo.dbf".
* `kolonnenavn` (**tekst-skalar**) angir navnet på en fil med kolonnenavn. Fila må være en semikolondelt tabell. Standardinnstillinga er å lese inn fila "[navnNVEl.csv](navnNVEl.csv)".

Funksjonsverdien er en **tabell** (_dataframe_) med informasjon om alle innsjøer.

Funksjonen forutsetter at datasettet over innsjøer er lasta ned som en formfil fra [NVE](http://nedlasting.nve.no/gis/):

`http://nedlasting.nve.no/gis/ > Innsjø > Innsjø`

I menyen må man foreta følgende valg:

- kartformat "ESRI shapefil (.shp)"
- koordinatsystem "Geografiske koordinater ETRS89"
- utvalgsmetode "Overlapper"
- dekningsområde "Landsdekkende"



### `oppdaterVannforekomster`

Funksjonen [`oppdaterVannforekomster`](Vannfork.R) kobler informasjonen om innsjøvannforekomster (fra vann-nett) med informasjon fra innsjødatabasen (fra NVE). Funksjonen trengs bare om de(n) aktuelle vannforskrift-parameteren (-parameterne) er relevant for innsjøer. Funksjonen har tre argumenter:

* `V` er **R**-tabellen for vannforekomster (som må ha blitt lest inn ved hjelp av `lesVannforekomster`).
* `nve` er **R**-tabellen for innsjødatabasen (som må ha blitt lest inn ved hjelp av `lesInnsjoforekomster`).
* `slingringsmonn` (**numerisk skalar**) angir hvilket relativt avvik fra de reelle verdiene som godtas før opplysninger blir korrigert for en vannforekomst. Standardinnstillinga er 0.1 (dvs. 10 %).

Funksjonsverdien er en **tabell** (_dataframe_) med oppdatert informasjon om alle vannforekomster.



### `lesMaalinger`

Funksjonen [`lesMaalinger`](Vannfork.R) leser inn tabellen over målinger fra vannmiljø. Funksjonen har to argumenter:

* `filnavn` (**tekst-skalar**) angir navnet på en fil med målinger. Fila må være et excel-regneark.
* `kolonnenavn` (**tekst-skalar**) angir navnet på en fil med kolonnenavn. Fila må være en semikolondelt tabell. Standardinnstillinga er å lese inn fila "[navnVM.csv](navnVM.csv)".

Funksjonsverdien er en **tabell** (_dataframe_) med informasjon om alle målinger.

Funksjonen forutsetter dessuten at et regneark med målinger er lasta fra [vannmiljø](https://vannmiljo.miljodirektoratet.no/)-databasen:

`https://vannmiljo.miljodirektoratet.no/ > Jeg vil > Søke > Søk i vannregistreringer og miljøgifter`

I fanen "Søk i registreringer" må man

- velge riktig "Parameter",
- eventuelt avgrense med andre kriterier (f.eks. "Prøvedato")
- trykke "Søk",
- trykke "Eksport",
- velge eksporttype "Redigeringsformat",
- trykke "Eksporter til epost".



### `fraVFtilNI`

Funksjonen [`fraVFtilNI`](Dbehandl.R) er forklart [her](forklar.md).


