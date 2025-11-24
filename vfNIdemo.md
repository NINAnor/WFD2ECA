-   [Forberedelser](#forberedelser)
-   [Nødvendig informasjon om
    vannforekomster](#nødvendig-informasjon-om-vannforekomster)
    -   [Vannforekomster](#vannforekomster)
    -   [NVEs innsjødatabase](#nves-innsjødatabase)
    -   [Vannlokaliteter](#vannlokaliteter)
    -   [Kobling av informasjon](#kobling-av-informasjon)
    -   [Ytterligere datafiler](#ytterligere-datafiler)
-   [Målinger fra
    vannmiljø-databasen](#målinger-fra-vannmiljø-databasen)
-   [Analysen](#analysen)
-   [Visualisering](#visualisering)
-   [Opplasting til
    naturindeks-databasen](#opplasting-til-naturindeks-databasen)

Dette dokumentet viser gangen i å forberede og gjennomføre opplasting av
data som har blitt samla inn i rammen av vannforskriften, til
naturindeks-databasen. Dataflyt til økologiske tilstandsregnskap
fungerer på tilsvarende måte (for detaljert dokumentasjon henvises her
til [ecRxiv](https://github.com/NINAnor/ecRxiv)).

## Forberedelser

Laste inn nødvendige **R**-pakker:

    library(foreign)
    library(sf)
    library(readxl)
    library(raster)
    library(httr)
    library(jsonlite)
    library(stringr)
    library(magrittr)
    library(NIcalc)

Laste inn funksjoner:

    source("R/Funksjon.R")
    for (filnavn in list.files("R", full.names = TRUE)) {
      source(filnavn)
    }

## Nødvendig informasjon om vannforekomster

Før vannforskrift-parametere kan analyseres og forberedes for
naturindeksen, må informasjon om vannforekomster og vannlokaliteter
komme på plass. Skal flere vannforskrift-parametere “flyttes over” til
naturindeks, trenger man bare å gjøre dette trinnet én gang.

### Vannforekomster

Informasjon om vannforekomstene må inntil videre lastes ned manuelt. Det
omfatter informasjon om vannforekomstenes (1) beliggenhet og deres (2)
typologi.

1.  Data over vannforekomstenes beliggenhet må lastes ned som formfil
    (gdb) fra Miljødirektoratet
    (<https://karteksport.miljodirektoratet.no/>). I menyen må man
    foreta de følgende valg:

-   Produkt: “Vannforekomster”
-   Definer område: “nasjonalt”
-   Format: “ESRI Filgeodatabase (ESPG:4326)”

Datasettet man da får tilsendt per e-post, må dekomprimeres og døpes om
til “**VF.gdb**”.

1.  Filer over vannforekomstenes typologi må lastes ned som excel-filer
    (csv) fra [vann-nett](https://vann-nett.no/portal/). For øyeblikket
    (august 2025) er ikke de nødvendige filene tilgjengelig via
    vann-netts eksportfunksjon. Koden er derfor basert på datafiler som
    ble lasta ned i mars 2024. For at filene kan leses inn, må de gis
    følgende navn:

-   “**V-L.csv**” for innsjøvannforekomstene
-   “**V-R.csv**” for elvevannforekomstene
-   “**V-C.csv**” for kystvannforekomstene

Man trenger ikke å laste ned alle tre. Det holder med den vannkategorien
som er relevant for vannforskrift-parameteren eller -parameterne.
Benytta vannkategorier må også spesifiseres ved innlesing (se under).

I tillegg trenger man en tabell som forklarer kolonnenavna i fila fra
vann-nett. Denne fila er nødvendig for å lese inn vannforekomstdataene,
og den ligger i dette arkivet under navnet
“[**navnVN.csv**](data/navnVN.csv)”. Hvis vann-nett endrer
kolonnenavnene i sin nedlastingsløsning, må denne fila [oppdateres
tilsvarende](forklar/hjelpfil.md#vannforekomster-v-.csv-navnvn.csv).

De nødvendige filene er plassert i mappa “[data](data/)”. De leses da
inn i **R** ved hjelp av funksjonen
[`lesVannforekomster`](forklar/lesVannforekomster.md) på følgende måte:

    V <- lesVannforekomster(c("L", "R", "C"), filsti = "data")

    ## 
    ## OBS: Noen vannforekomsters dybde ble justert:
    ## * 6 ganger fra 5 til 2
    ## 
    ## OBS: Noen vannforekomsters humøsitet ble justert:
    ## * 226 turbide brepåvirka vannforekomster ble satt til "klar"
    ## * 81 turbide leirpåvirka vannforekomster ble satt til "humøs"
    ## 
    ## OBS: Noen vannforekomster har ukjente verdier:
    ## * 16 med "n" = "Ukjent" for alkalitet
    ## * 16 med "n" = "Ukjent" for humøsitet
    ## * 2 med "0" = "Ikke satt" for turbiditet
    ## * 16 med "n" = "Ukjent" for turbiditet
    ## * 4 med "7" = "Ukjent middeldyp" for dybde
    ## * 16 med "n" = "" for dybde
    ## * 2 med "0" = "Satt til turbid" for humøsitet
    ## * 1 med "0" = "Ikke satt" for turbiditet
    ## * 4 med "0" = "Udefinert" for salinitet
    ## * 2 med "0" = "Udefinert" for tidevann
    ## * 2 med "0" = "Udefinert" for oppholdstid
    ## * 2 med "0" = "Udefinert" for strøm
    ## * 1115 med "Ikke relevant" for økologisk tilstand
    ## * 17 med "Udefinert" for økologisk tilstand
    ## * 1 med "Udefinert" for økologisk miljømål
    ## * 7976 med "Ikke relevant" for økologisk potensial
    ## * 2 med "Udefinert" for økologisk potensial
    ## * 7975 med "Udefinert" for økologisk potensial miljømål
    ## * 2 med "" for kjemisk tilstand
    ## * 29706 med "Udefinert" for kjemisk tilstand
    ## Disse blir satt til <NA>!
    ## 
    ## OBS: Noen vannforekomsters størrelsesklasse ble justert opp:
    ## * 33 ganger fra 1 til 2
    ## * 1 gang fra 1 til 3
    ## * 49 ganger fra 2 til 3
    ## 
    ## OBS: Noen vannforekomsters størrelsesklasse ble justert ned:
    ## * 141 ganger fra 2 til 1
    ## * 16 ganger fra 3 til 1
    ## * 70 ganger fra 3 til 2
    ## * 22 ganger fra 4 til 1
    ## * 1 gang fra 4 til 2
    ## * 5 ganger fra 4 til 3
    ## 
    ## Innlesing av 32436 vannforekomster var vellykka. (Men legg merke til beskjedene over!)

Utmatinga forteller om mindre avvik fra det man kunne forvente. Men
ingen av dem var kritisk for den videre analysen. I så fall hadde
innlesinga blitt avbrutt med beskjeden “FEIL” og en forklaring.

### NVEs innsjødatabase

Dette trinnet er ikke nødvendig for elve- og kystvannforekomster. Men
for innsjøvannforekomster bør man laste ned en fil over Norges innsjøer
fra [NVE](http://nedlasting.nve.no/gis/):

`http://nedlasting.nve.no/gis/ > Innsjø > Innsjø`

I menyen må man foreta de følgende valg:

-   kartformat “ESRI shapefil (.shp)”
-   koordinatsystem “Geografiske koordinater ETRS89”
-   utvalgsmetode “Overlapper”
-   dekningsområde “Landsdekkende”

Datasettet man da får, er en formfil som heter “Innsjo\_Innsjo”.

I tillegg trenger man en tabell som forklarer kolonnenavna i fila fra
NVE. Denne fila er nødvendig for å lese inn innsjødataene, og den ligger
i dette arkivet under navnet “[**navnNVEl.csv**](data/navnNVEl.csv)”.
Hvis NVE endrer kolonnenavnene i sin nedlastingsløsning, må denne fila
[oppdateres
tilsvarende](forklar/hjelpfil.md#innsjødatabasen-navnnvel.csv).

Filnavnet oppgis som argument når dataene leses inn i **R** ved hjelp av
funksjonen [`lesInnsjodatabasen`](forklar/lesInnsjodatabasen.md):

    nve <- lesInnsjodatabasen("Innsjo_Innsjo.dbf", filsti = "data")

    ## 
    ## OBS: For 3 innsjøer var høyden over havet angitt å være negativ. Disse ble satt til <NA>.
    ## 
    ## OBS: For 4 innsjøer var det norske arealet angitt å være negativ. Disse ble satt til <NA>.
    ## 
    ## OBS: For 1 innsjøer var tilsigsfeltet angitt å være negativ. Disse ble satt til <NA>.
    ## 
    ## OBS: For 589 innsjøer var deres tilsigsfelt angitt å være mindre enn deres areal. For disse ble tilsigsfeltet satt til arealet.
    ## 
    ## Innlesing av innsjødatabasen var vellykka og omfatta 267193 innsjøer. (Men legg merke til beskjedene over!)

Utmatinga forteller om mindre avvik fra det man kunne forvente. Men
ingen av dem var kritisk for den videre analysen. I så fall hadde
innlesinga blitt avbrutt med beskjeden “FEIL” og en forklaring.

### Vannlokaliteter

Informasjon om vannlokaliteter kan leses inn autmatisert via
[vannmiljø-API-en](https://vannmiljoapi.miljodirektoratet.no/swagger/ui/index#/Public)
eller lastes opp manuelt fra
[vannmiljø](https://vannmiljo.miljodirektoratet.no/#/searchwaterlocations).
Her illustreres innlesing fra API-en. Funksjonen som står for
innlesinga, forutsetter at det foreligger en tabell som forklarer
kolonnenavna i fila fra vannmiljø. Denne fila er plassert i mappa
“[data](data/)” under navnet “[**navnVL.csv**](data/navnVL.csv)”. Hvis
vannmiljø endrer kolonnenavnene i sin nedlastingsløsning, må denne fila
[oppdateres
tilsvarende](forklar/hjelpfil.md#vannlokaliteter-vl-.xlsx-navnvl.csv).

De relevante vannkategoriene (“L” for innsjø, “R” for elv og/eller “C”
for kyst) oppgis som argument når vannlokalitene leses inn i R ved hjelp
av funksjonen [`lesVannlokaliteter`](forklar/lesVannlokaliteter.md):

    VL <- lesVannlokaliteter(filsti = "data")

    ## 
    ## Innlesing av 75727 vannlokaliteter var vellykka.

Alt i orden. Ved feil hadde innlesinga blitt avbrutt med beskjeden
“FEIL” og en forklaring.

### Kobling av informasjon

Til slutt kan informasjonen om innsjøvannforekomster (fra vann-nett)
utvides med informasjon fra innsjødatabasen (fra NVE). Dette besørges av
funksjonen
[`oppdaterVannforekomster`](forklar/oppdaterVannforekomster.md). Den
tester samtidig for en rekke mulige feilkilder. Dette trinnet er bare
nødvendig om de(n) aktuelle vannforskrift-parameteren (-parameterne) er
relevant for innsjøer.

    V <- oppdaterVannforekomster(V, nve)

    ## 
    ## OBS: Totalarealet har blitt tilføyd for 24 innsjøer som har en arealandel utenfor Norge. For 7 av disse medførte det en
    ##      oppjustering av størrelsesklassen.
    ## 
    ## OBS: For 25 innsjøer ble høydesonen justert opp basert på deres faktiske høyde over havet.
    ## 
    ## OBS: For 30 innsjøer ble høydesonen justert ned basert på deres faktiske høyde over havet.
    ## 
    ## Oppdatering av vannforekomster var vellykka. (Men legg merke til beskjedene over!)

Igjen forteller utmatinga om mindre avvik fra det man kunne forvente.
Her gjelder det at typifiseringa av vannforekomstene ikke stemte overens
med størrelse og høyde over havet, slik de fremgår av innsjødatabasen.
Under antagelse av at innsjødatabasen er mer pålitelig enn
vannforekomsttypifisering, har typifiseringa blitt justert for enkelte
vannforekomster.

### Ytterligere datafiler

Til slutt trengs det lister over kommune- og fylkesnummer og -navn,
vannforskriftsparametere og overvåkingsaktiviteter. Denne informasjonen
leses inn automatisk, gitt at den er lagra i excel-regneark som heter
henholdsvis “**knr.xlsx**”, “**fnr.xlsx**”, “**VM-param.xlsx**” og
“**VM-aktiv.xlsx**”, og at disse er plassert i mappa “[data](data/)”.
Det tas forbehold om at enkelte målinger kan bli tilordna feil kommune,
i tilfeller der målinger ble tatt i en sammenslått kommune og
tilbakedateres til et tidspunkt før sammenslåinga.

Strukturen på filene ser slik ut:

    Fylker <- as.data.frame(read_xlsx("data/fnr.xlsx", col_types = "text"))
    Parametere  <- as.data.frame(read_xlsx("data/VM-param.xlsx", na = "NA",
                                           col_types = "text"))
    Aktiviteter <- as.data.frame(read_xlsx("data/VM-aktiv.xlsx", na = "NA",
                                           col_types = c("text", "text", "numeric")))

    head(Fylker)

    ##     nr     navn  fra  til
    ## 1 0100  Østfold 1867 2019
    ## 2 0200 Akershus 1867 2019
    ## 3 0300     Oslo 1867 9999
    ## 4 0400  Hedmark 1867 2019
    ## 5 0500  Oppland 1867 2019
    ## 6 0600 Buskerud 1867 2019

    head(Parametere[which(!is.na(Parametere$min)), ])

    ##            id                                                                navn  min  max
    ## 9         AIP                     Forsuringsindeks påvekstalger artssammensetning 5.13 7.42
    ## 15        ANC                                 Syrenøytraliserende kapasitet (ANC) -200  250
    ## 36       ASPT                                      Average Score per Taxon (ASPT)    0   10
    ## 103     ES100            Hurlberts diversitetsindeks (ES100) marin bløtbunnsfauna    0  100
    ## 104 ES100_AKK Hurlberts diversitetsindeks (ES100) akkumulert for alle grabbprøver    0  100
    ## 105 ES100_MID           Hurlberts diversitetsindeks (ES100) for grabbgjennomsnitt    0  100

    head(Aktiviteter)

    ##     id                               navn skaar
    ## 1 ANLA    Overvåking av anadrom laksefisk     0
    ## 2 ANNE                              Annet     0
    ## 3 AREA     Effekter av planlagt arealbruk    -1
    ## 4 BADE             Overvåking av badevann     1
    ## 5 BAPO  Basisovervåking - påvirka områder    -1
    ## 6 BARE Basisovervåking - referanseforhold     3

Filene bør bare [endres](forklar/hjelpfil.md) om bakgrunnsinformasjonen
har blitt endra, og de bør ligge i mappa “data”.

## Målinger fra vannmiljø-databasen

Målingene kan også leses inn autmatisert via
[vannmiljø-API-en](https://vannmiljoapi.miljodirektoratet.no/swagger/ui/index#/Public)
eller lastes opp manuelt fra
[vannmiljø](https://vannmiljo.miljodirektoratet.no/#/searchregistrations).
Funksjonen som står for innlesinga, forutsetter at det foreligger en
tabell som forklarer kolonnenavna i fila fra vannmiljø. Denne fila er
plassert i mappa “[data](data/)” under navnet
“[**navnVM.csv**](data/navnVM.csv)”. Hvis vannmiljø endrer
kolonnenavnene i sin nedlastingsløsning, må denne fila [oppdateres
tilsvarende](forklar/hjelpfil.md#vannmiljø-data-navnvm.csv).

Funksjonen som leser inn målingene, heter
[`lesMaalinger`](forklar/lesMaalinger.md). Den leser inn målingene via
API når Vannmiljø-databasens forkortelse for parameteren oppgis som
argument (f.eks. “ASPT”). Når det oppgis filnavnet på den manuelt
nedlasta excelfila, leses målingene inn fra denne. Det er det siste som
illustreres her:

    DATA <- lesMaalinger("ASPT.xlsx", filsti = "data")

    ## 
    ## Innlesing av 19209 vannmålinger var vellykka.

## Analysen

Når man har kommet hit, kan selve analysen begynne. Den må gjøres
separat for hver vannforskrift-parameter og for hver vannkategori. Hvis
en parameter f.eks. brukes i både innsjøer og elver, må disse analyseres
separat. Som eksempel er ASPT valgt, en bunndyr-forsuringsindeks for
elver.

Analysen består i å

-   koble alle målinger til sine respektive vannforekomster,
-   omregne (skalere) måleverdiene til
    [mEQR-verdier](forklar/asympEQR.md),
-   [tilpasse en modell](forklar/modell.md) som forklarer variasjonen i
    måleverdier med tidsperiode, typologifaktorer og
    [overvåkingsaktivitet](forklar/aktiv.md),
-   [ekstrapolere](forklar/extrapol.md) trolige verdier til
    vannforekomster som det ikke foreligger målinger fra,
-   simulere usikkerheten (sannsynlighetsfordelinga) for de sistnevnte
    og
-   [aggregrere](forklar/arealvekt.md) resultatene opp til de ønska
    administrative enhetene.

Dette trinnet tar sin tid. Utmatinger underveis viser progresjonen.
Simuleringa kan ta spesielt mye tid, avhengig av antall iterasjoner. For
illustrasjonen her er det valgt 1000 iterasjoner. For bruk i naturindeks
bør man velge en større verdi (minst 10 000).

Funksjonen som gjennomfører analysen, heter
[`fraVFtilNI`](R/fraVFtilNI.R) (“fra vannforkrift til naturindeks”). De
første fem funksjonsargumentene må alltid oppgis. De resterende
argumentene, inkludert mange som ikke vises i eksempelkjøringa under,
trenger man bare å oppgi om man ønsker å endre på standardinnstillingene
(som er [forklart her](forklar/fraVFtilNI.md)).

    utmating <- fraVFtilNI(
                           DATA, 
                           vannforekomster = V,
                           vannlokaliteter = VL,
                           parameter = "ASPT",
                           vannkategori = "R",
                           NI.aar = c(1990, 2000, 2010, 2014, 2019, 2024),
                           rapportenhet = c("kommune", "fylke", "landsdel", "norge"),
                           adminAar = 2010,
                           interaksjon = FALSE,
                           iterasjoner = 1000,
                           SEED = 12
                          )

    ## 
    ## 
    ## ****** Fra vannforskrift til naturindeks ******
    ## ***************   versjon 2.1   ***************
    ## 
    ##    Innledende tester
    ##    =================
    ## 
    ## De nødvendige datafilene ble funnet. Da setter vi i gang.
    ## 
    ## 
    ##    Lasting av administrative enheter
    ##    =================================
    ## 
    ## De administrative enhetene er på plass. Per 2010 fantes det 19 fylker og 443 kommuner.
    ## 
    ## 
    ##    Undersøkelse av innmatingsdata
    ##    ==============================
    ## 
    ## Det foreligger 19209 målinger av parameteren ASPT [Average Score per Taxon (ASPT)].
    ## 
    ## OBS: 61 målinger ble ekskludert fordi de ble tatt etter 2024.
    ## 
    ## OBS: 13 målinger ligger utafor parameterens definisjonsområde! Deres verdier er større
    ##      enn 10 (opp til 608). I tillegg til disse 13 ble ytterligere 62 målinger ekskludert,
    ##      fordi de hadde samme oppdragstaker (COWI, Akvaplan-niva AS) og prøvetakingsdato
    ##      (25.09.2017, 28.08.2018).
    ## 
    ## Vennligst vent mens målingene kobles mot vannforekomster!
    ## Ferdig med 100 % av målingene.
    ## 
    ## OBS: 1 måling ble ekskludert fordi den ikke kunne knyttes til noen kjent vannlokalitet.
    ## 
    ## OBS: 941 målinger ble ekskludert fordi deres vannlokaliteter ikke kunne knyttes til noen
    ##      typifisert vannforekomst.
    ## 
    ## OBS: 370 målinger ble ekskludert fordi de ikke ble foretatt i en elvevannforekomst.
    ## 
    ## Alle målinger ble foretatt i de riktige vanntypene.
    ## 
    ## OBS: 26 datapunkt måtte fjernes fra datasettet fordi de ikke oppfyller de spesifikke
    ##      kravene som stilles til målinger av ASPT.
    ## 
    ## OBS: For rapportåret 1990 foreligger bare målinger fra 8 vannforekomster. Det er
    ##      dessverre for få, og denne rapportperioden må derfor utgå.
    ## 
    ## OBS: For rapportåret 2000 foreligger bare målinger fra 15 vannforekomster. Det er
    ##      dessverre for få, og denne rapportperioden må derfor utgå.
    ## 
    ## OBS: Kontrabeskjed - verdier for rapportåret 2000 estimeres "bakfra" (dvs. med data fra
    ##      perioden 2001-2010).
    ## 
    ## Dataene som inngår i modelltilpasninga, inneholder dermed
    ## - 17870 målinger fra
    ## - 5500 vannlokaliteter i
    ## - 3157 vannforekomster i
    ## - 19 fylker
    ## - mellom 2001 og 2024.
    ## 
    ## 
    ##    Skalering til mEQR-verdier
    ##    ==========================
    ## 
    ## Oppsummering av variabelverdier før skalering:
    ##  minimum  ned. kv.    median  gj.snitt  øvr. kv.  maksimum 
    ##  0,00000   5,55556   6,14286   5,99410   6,60000   9,25000 
    ## 
    ## Oppsummering av variabelverdier etter skalering:
    ##  minimum  ned. kv.    median  gj.snitt  øvr. kv.  maksimum 
    ##  0,00000   0,48889   0,63572   0,63704   0,75000   1,19914 
    ## 
    ## 
    ##    Modelltilpasning til målingene
    ##    ==============================
    ## 
    ## OBS: 8 målinger ble ekskludert fordi typologifaktoren "humøsitet" ikke var kjent for dem.
    ## 
    ## 
    ## Modelltilpasning, runde 1:
    ## 
    ## * Aktivitet: EMUD og KART har blitt slått sammen pga. for lite data.
    ## * Aktivitet: ANLA og MYFO har blitt slått sammen pga. for lite data.
    ## * Aktivitet: PASV og TILT har blitt slått sammen pga. for lite data.
    ## * Aktivitet: EMUD+KART og JRBN har blitt slått sammen pga. for lite data.
    ## * Aktivitet: FLYP og BARE har blitt slått sammen pga. for lite data.
    ## * Aktivitet: DEPO og KAVE har blitt slått sammen pga. for lite data.
    ## * Aktivitet: EMUD+JRBN+KART og OEKF har blitt slått sammen.
    ## * Aktivitet: FORS og SKYT har blitt slått sammen.
    ## * Aktivitet: BARE+FLYP og INDU har blitt slått sammen.
    ## * Aktivitet: BAPO og KOMM har blitt slått sammen.
    ## * Aktivitet: ELVE og PASV+TILT har blitt slått sammen.
    ## * Aktivitet: ELVE+PASV+TILT og PROB har blitt slått sammen.
    ## * Aktivitet: BAPO+KOMM og KALK har blitt slått sammen.
    ## * Aktivitet: DEPO+KAVE og KALL har blitt slått sammen.
    ## * Aktivitet: GRUV og VASS har blitt slått sammen.
    ## * Aktivitet: BARE+FLYP+INDU og FORS+SKYT har blitt slått sammen.
    ## * Aktivitet: ANLA+MYFO og RELV har blitt slått sammen.
    ## * Aktivitet: ANNE og ELVE+PASV+PROB+TILT har blitt slått sammen.
    ## * Aktivitet: AREA og BAPO+KALK+KOMM har blitt slått sammen.
    ## * Aktivitet: BARE+FLYP+FORS+INDU+SKYT og EMUD+JRBN+KART+OEKF har blitt slått sammen.
    ## * Aktivitet: BIOM og DEPO+KALL+KAVE har blitt slått sammen.
    ## * Aktivitet: ANNE+ELVE+PASV+PROB+TILT og GRUV+VASS har blitt slått sammen.
    ## * SMVF: ja og nei har blitt slått sammen.
    ## * SMVF har blitt droppa fordi det ikke var forskjell mellom klassene.
    ## * Turbiditet har blitt beholdt uendra (med 2 ulike verdier).
    ## * Region har blitt erstatta med faktisk geografisk bredde.
    ## * Sone har blitt beholdt uendra (med 3 ulike verdier).
    ## * Størrelse: 3 og 4 har blitt slått sammen.
    ## * Alkalitet: 5 og 6 har blitt slått sammen pga. for lite data.
    ## * Alkalitet: 1 og 8 har blitt slått sammen.
    ## * Alkalitet: 5+6 og 7 har blitt slått sammen.
    ## * Humøsitet har blitt beholdt uendra (med 5 ulike verdier).
    ## 
    ## Modelltilpasning, runde 2:
    ## 
    ## * Aktivitet har blitt beholdt uendra (med 7 ulike verdier).
    ## * Turbiditet har blitt beholdt uendra (med 2 ulike verdier).
    ## * Sone har blitt beholdt uendra (med 3 ulike verdier).
    ## * Størrelse har blitt beholdt uendra (med 4 ulike verdier).
    ## * Alkalitet har blitt beholdt uendra (med 5 ulike verdier).
    ## * Humøsitet har blitt beholdt uendra (med 5 ulike verdier).
    ## * Geografisk bredde har blitt beholdt uendra (som numerisk variabel).
    ## 
    ## Oppsummering av den tilpassa modellen ...
    ## 
    ## Modelltype: lineær regresjon
    ## Modellstruktur: vrd ~ per * rar + akt + gbred + son + sto + alk + hum + tur
    ## 
    ## Residualer:
    ##  minimum  ned. kv.    median  gj.snitt  øvr. kv.  maksimum 
    ## -6,22405  -0,50275  -0,12990  -0,02313   0,21789   8,69094 
    ## standardfeil: 1,124 med 17834 frihetsgrader
    ## 
    ## Koeffisienter:
    ##                                                  estimat standardfeil t-verdi Pr(>|t|)    
    ## (konstantledd)                                  -5,24763      0,29527  -17,77  < 1E-12 ***
    ## per2014                                         -1,36020      0,06330  -21,49  < 1E-12 ***
    ## per2019                                         -1,23902      0,05377  -23,04  < 1E-12 ***
    ## per2024                                         -1,67255      0,05139  -32,54  < 1E-12 ***
    ## rar                                              0,20460      0,01865   10,97  < 1E-12 ***
    ## aktANNE+ELVE+GRUV+PASV+PROB+TILT+VASS           -0,48141      0,05156   -9,34  < 1E-12 ***
    ## aktAREA+BAPO+KALK+KOMM                          -0,67267      0,05960  -11,29  < 1E-12 ***
    ## aktBARE+EMUD+FLYP+FORS+INDU+JRBN+KART+OEKF+SKYT -1,04850      0,05809  -18,05  < 1E-12 ***
    ## aktBIOM+DEPO+KALL+KAVE                          -0,27364      0,05791   -4,73  2,3E-06 ***
    ## aktDRIK                                         -1,62428      0,20094   -8,08  < 1E-12 ***
    ## aktLANG                                          1,11341      0,07840   14,20  < 1E-12 ***
    ## gbred                                            0,12559      0,00452   27,79  < 1E-12 ***
    ## sonL                                             0,07901      0,06198    1,27  0,20241    
    ## sonM                                             0,22009      0,06140    3,58  0,00034 ***
    ## sto2                                             0,06642      0,02212    3,00  0,00269 ** 
    ## sto3+4                                           0,20664      0,02816    7,34  < 1E-12 ***
    ## sto5                                             0,01404      0,05786    0,24  0,80822    
    ## alk2                                            -0,21186      0,02962   -7,15  < 1E-12 ***
    ## alk3                                            -0,51017      0,03502  -14,57  < 1E-12 ***
    ## alk4                                            -0,95429      0,04790  -19,92  < 1E-12 ***
    ## alk5+6+7                                         0,09787      0,03696    2,65  0,00810 ** 
    ## hum2                                            -0,13776      0,02355   -5,85  5,0E-09 ***
    ## hum3                                            -0,84509      0,10606   -7,97  < 1E-12 ***
    ## hum4                                            -0,13154      0,05909   -2,23  0,02602 *  
    ## tur3                                            -0,31788      0,04686   -6,78  1,2E-11 ***
    ## per2014:rar                                     -0,18432      0,02998   -6,15  8,0E-10 ***
    ## per2019:rar                                     -0,21440      0,02310   -9,28  < 1E-12 ***
    ## per2024:rar                                     -0,10879      0,02121   -5,13  2,9E-07 ***
    ## ---
    ## Signifikansnivåer:  0 *** 0,001 ** 0,01 * 0,05 . 0,1
    ## 
    ## AIC = 68079,49
    ## R² = 0,2768
    ## F(27, 17834) = 252,8
    ## p < 1E-12
    ## 
    ## 
    ##    Ekstrapolering til ikke-målte vannforekomster
    ##    =============================================
    ## 
    ## Det fins 23343 typifiserte elvevannforekomster.
    ## Av disse har 23095 vannforekomster en vanntype som parameteren ASPT er definert for.
    ## - 1 vannforekomst har den ukjente vanntypen "turbiditet = <NA>";
    ## - 2 vannforekomster har den ukjente vanntypen "humøsitet = <NA>".
    ## Disse blir ekskludert fra ekstrapoleringa, slik at 23092 vannforekomster er igjen.
    ## Det foreligger altså målinger for 14 % av de relevante vannforekomstene (3156 av 23092).
    ## Målingene representerer 9 % av de relevante vannforekomstenes samla lengde (43982 av
    ## 475171 km).
    ## 
    ## 
    ##    Simulering
    ##    ==========
    ## 
    ## Nå begynner simuleringa. Det er valgt 1000 iterasjoner.
    ## Ferdig med 100 % av simuleringene.
    ## Ferdig med 443 av 443 kommuner.
    ## 
    ## Sånn. Da har vi omsider kommet i mål.
    ## ASPTs mEQR-verdier har medianen 0,875 og strekker seg fra 0,022 til 1,200.

## Visualisering

Her kommer noen eksempler på visualiseringer av resultatene. For det
første kan man plotte den simulerte sannsynlighetsfordelinga som et
histogram, f.eks. slik:

    hist(utmating$fylke["1200", "2019", ], 
         breaks=36, 
         main="ASPT i Troms i 2019", 
         xlab="nEQR-verdi", 
         ylab="Trolighet", 
         cex.lab=1.2, cex.main=1.8)

![](/data/Egenutvikling/61308-01_fu_intern_hanno_sandvik/WFD2ECA/vfNIdemo_files/figure-markdown_strict/unnamed-chunk-14-1.png)

De fylkesvise gjennomsnittsresultatene kan vises på kart:

    load("data/norge.map")
    fylkeshistorikk  <- as.data.frame(read_xlsx("data/fnr.xlsx", col_types = "text"))
    rownames(fylkeshistorikk)  <-  fylkeshistorikk$nr
    fylke <- function(i) fylkeshistorikk[as.character(i), "navn"]
    plot(Norge.fylker, asp = 2.1)
    text(6, 70, "ASPT", cex = 2.4, font = 1.6)
    text(6, 69, "fylkesvis", cex = 0.96)
    for (i in dimnames(utmating$fylke)$fylke) {
      plot(Norge.fylker[which(Norge.fylker@data$NAME_1 == fylke(i)), ],
           col=farge(min(1, utmating$fylke[i, "2019", 1])), add = T)
    }
    for (i in seq(0, 0.999, 0.001)) {
      rect(24, 59+i*8, 26, 59+(i+0.001)*8, col = farge(i), border = farge(i))
      }
    for (i in 1:5) {
      rect(24, 59+(i-1)*1.6, 26, 59+i*1.6, col = NA, border = T, lwd = 2.4)
    }
    text(rep(24, 6), 59+0:5*1.6, c("0,0", "0,2", "0,4", "0,6", "0,8", "1,0"), 
         pos = 2, cex = 0.96)
    text(rep(26, 5), 59.8+0:4*1.6, c("SD", "D", "M", "G", "SG"), pos = 4, cex = 1.2)

![](/data/Egenutvikling/61308-01_fu_intern_hanno_sandvik/WFD2ECA/vfNIdemo_files/figure-markdown_strict/unnamed-chunk-15-1.png)

Det samme gjelder de kommunevise resultatene:

    kommunehistorikk <- as.data.frame(read_xlsx("data/knr.xlsx", col_types = "text"))
    kommunehistorikk$Nummer[which(nchar(kommunehistorikk$Nummer) == 3)] <-
      "0" %+% kommunehistorikk$Nummer[which(nchar(kommunehistorikk$Nummer) == 3)]
    rownames(kommunehistorikk) <- kommunehistorikk$Nummer
    plot(Norge.kontur, asp = 2.1, col = grey(0.84))
    text(6, 70, "ASPT", cex = 2.4, font = 1.6)
    text(6, 69, "kommunevis", cex = 0.96)
    for (i in dimnames(utmating$kommune)$kommune) {
      for (kmn in kommunehistorikk[which(kommunehistorikk[, "2008"] == i), "1992"]) {
        plot(Norge.kommuner[which(Norge.kommuner@data$NAME_2 == kmn),], 
             col=farge(min(1, utmating$kommune[i, "2019", 1])), border = NA, add = T)
      }
    }
    plot(Norge.fylker, add = T)
    for (i in seq(0, 0.999, 0.001)) {
      rect(24, 59+i*8, 26, 59+(i+0.001)*8, col = farge(i), border = farge(i))
      }
    for (i in 1:5) {
      rect(24, 59+(i-1)*1.6, 26, 59+i*1.6, col = NA, border = T, lwd = 2.4)
    }
    text(rep(24, 6), 59+0:5*1.6, c("0,0", "0,2", "0,4", "0,6", "0,8", "1,0"), 
         pos = 2, cex = 0.96)
    text(rep(26, 5), 59.8+0:4*1.6, c("SD", "D", "M", "G", "SG"), pos = 4, cex = 1.2)

![](/data/Egenutvikling/61308-01_fu_intern_hanno_sandvik/WFD2ECA/vfNIdemo_files/figure-markdown_strict/unnamed-chunk-16-1.png)

## Opplasting til naturindeks-databasen

Når utmatinga fra modelleringa er klar og har blitt behørig testa, kan
den lastes opp til naturindeks-(NI-)databasen. Disse trinnene er her
bare *illustrert*, men ikke *utført*.

    # For å logge seg inn til NI-databasen trenger man et brukernavn (epost-adressen) og passord.
    # Koden fungerer om disse er lagra som to variabler som heter henholdsvis 
    # "epost.adressen.min" og "passordet.mitt".
    NIcalc::getToken(username = epost.adressen.min, password = passordet.mitt)

    # Så bør man sjekke hvilke indikatorer man har tillatelse til å endre:
    NIindikatorer <- NIcalc::getIndicators()
    # Utmatinga viser indikator-id-en(e) som må benyttes i neste trinn.
    # Indikator-id-ens verdi antas å være lagret i variabelen "indikatorID".
    # Det eksisterende naturindeks-datasettet leses inn:
    NIdata <- NIcalc::getIndicatorValues(indikatorID)

    # Kommunenavn må være identiske i naturindeks og i vannmiljø. Det sjekkes slik:
    sort(unique(NIdata[[1]]$areaName[which(!(NIdata[[1]]$areaName %in% 
                                               dimnames(utmating$kommune)$kommune))]))

    # Eventuelt avvikende kommunenavne må korrigeres, f.eks. slik: 
    dimnames(utmating$kommune)$kommune <- 
      erstatt(dimnames(utmating$kommune)$kommune, "Bø i Nordland", "Bø (No)")
    dimnames(utmating$kommune)$kommune <- 
      erstatt(dimnames(utmating$kommune)$kommune, "Bø i Telemark", "Bø (Te)")
    dimnames(utmating$kommune)$kommune <- 
      erstatt(dimnames(utmating$kommune)$kommune, "Herøy i Møre og Romsdal", "Herøy (MR)")
    dimnames(utmating$kommune)$kommune <- 
      erstatt(dimnames(utmating$kommune)$kommune, "Herøy i Nordland", "Herøy (No)")
    dimnames(utmating$kommune)$kommune <- 
      erstatt(dimnames(utmating$kommune)$kommune, "Nes i Akershus", "Nes (Ak)")
    dimnames(utmating$kommune)$kommune <- 
      erstatt(dimnames(utmating$kommune)$kommune, "Nes i Buskerud", "Nes (Bu)")
    dimnames(utmating$kommune)$kommune <- 
      erstatt(dimnames(utmating$kommune)$kommune, "Os i Hedmark", "Os (He)")
    dimnames(utmating$kommune)$kommune <- 
      erstatt(dimnames(utmating$kommune)$kommune, "Os i Hordaland", "Os (Ho)")
    dimnames(utmating$kommune)$kommune <- 
      erstatt(dimnames(utmating$kommune)$kommune, "Porsáŋgu", "Porsángu")
    dimnames(utmating$kommune)$kommune <- 
      erstatt(dimnames(utmating$kommune)$kommune, "Sande i Møre og Romsdal", "Sande (MR)")
    dimnames(utmating$kommune)$kommune <- 
      erstatt(dimnames(utmating$kommune)$kommune, "Sande i Vestfold", "Sande (Vf)")
    dimnames(utmating$kommune)$kommune <- 
      erstatt(dimnames(utmating$kommune)$kommune, "Våler i Hedmark", "Våler (He)")
    dimnames(utmating$kommune)$kommune <- 
      erstatt(dimnames(utmating$kommune)$kommune, "Våler i Østfold", "Våler (Øf)")

    # Dobbeltsjekke at alt stemmer nå:
    sort(unique(NIdata[[1]]$areaName[which(!(NIdata[[1]]$areaName %in% 
                                               dimnames(utmating$kommune)$kommune))]))

    # Er noen kommuner uten vannforskrifts-data (og hvilke)?
    unique(dimnames(utmating$kommune)$kommune[which(is.na(utmating$kommune), arr.ind = TRUE)[, 1]])

    # Så flettes de modellerte vannforskrifts-dataene inn i de dataene i naturindeksbasen:
    NIdata <- oppdaterNImedVF(NIdata, utmating, avrunding = 4)

    # Sjekk nøye hvilke beskjeder som har blitt utmata i det forrige trinnet!
    # Bare hvis alt ser bra ut, kan man gå videre.

    # Siste trinn er selve opplastinga:
    NIcalc::writeIndicatorValues(NIdata)

Før en opplasting må det oppdaterte datasettet (`utmating`) sjekkes
grundig for eventuelle inkompatibiliteter med NI-databasen. Noen
relevante tester gjennomføres av funksjonen
[`oppdaterNImedVF`](forklar/oppdaterNImedVF.R). Om denne ikke
rapporterer noen feil, har man mulighet til å fullføre opplastinga.
