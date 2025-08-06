# Illustrasjon av dataflyt fra vannforskrift til naturindeks

Dette dokumentet viser gangen i å forberede og gjennomføre opplasting av
data som har blitt samla inn i rammen av vannforskriften, til
naturindeks-databasen.

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

## Forberedelser

Laste inn nødvendige **R**-pakker:

    library(foreign)
    library(sf)
    library(readxl)
    library(raster)
    library(httr)
    library(jsonlite)
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

2.  Filer over vannforekomstenes typologi må lastes ned som excel-filer
    (csv) fra [vann-nett](https://vann-nett.no/). For øyeblikket
    er ikke de nødvendige filene tilgjengelig via vann-netts
    eksportfunksjon. Koden er derfor basert på datafiler som ble lasta
    ned i mars 2024. For at filene kan leses inn, må de gis følgende
    navn:
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

Filnavnet oppgis som parameter når dataene leses inn i **R** ved hjelp
av funksjonen [`lesInnsjodatabasen`](forklar/lesInnsjodatabasen.md):

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
[vannmiljø-API-en](https://vannmiljowebapi.miljodirektoratet.no/swagger/ui/index#/).
Funksjonen som står for innlesinga, forutsetter at det foreligger en
tabell som forklarer kolonnenavna i fila fra vannmiljø. Denne fila er
plassert i mappa “[data](data/)” under navnet
“[**navnVL.csv**](data/navnVL.csv)”. Hvis vannmiljø endrer
kolonnenavnene i sin nedlastingsløsning, må denne fila [oppdateres
tilsvarende](forklar/hjelpfil.md#vannlokaliteter-vl-.xlsx-navnvl.csv).

Innlesinga skjer ved hjelp av funksjonen
[`lesVannlokaliteter`](forklar/lesVannlokaliteter.md) på følgende måte:

    VL <- lesVannlokaliteter(c("L", "R", "C"), filsti = "data")

    ## 
    ## Innlesing av 105062 vannlokaliteter var vellykka.

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
    ## OBS: Totalarealet har blitt tilføyd for 24 innsjøer som har en arealandel utenfor Norge. For 7 av disse medførte det en oppjustering av størrelsesklassen.
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
“**VM-aktiv.xlsx**”, og at disse er plassert i mappa “data”. Det tas
forbehold om at enkelte målinger kan bli tilordna feil kommune, i
tilfeller der målinger ble tatt i en sammenslått kommune og
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

Målingene fra
[vannmiljø](https://vannmiljo.miljodirektoratet.no/)-databasen kan også
lastes ned automatisert. Funksjonen som står for innlesinga, forutsetter
at det foreligger en tabell som forklarer kolonnenavna i fila fra
vannmiljø. Denne fila er plassert i mappa “[data](data/)” under navnet
“[**navnVM.csv**](data/navnVM.csv)”. Hvis vannmiljø endrer
kolonnenavnene i sin nedlastingsløsning, må denne fila [oppdateres
tilsvarende](forklar/hjelpfil.md#vannmiljø-data-navnvm.csv).

Innlesinga skjer ved hjelp av funksjonen
[`lesMaalinger`](forklar/lesMaalinger.md) på følgende måte:

    DATA <- lesMaalinger("ASPT", filsti = "data")

    ## 
    ## Innlesing av 15138 vannmålinger var vellykka.

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
-   [ekstrapolere](forklar/extrapol.md) trolige verdier til vannforekomster som
    det ikke foreligger målinger fra,
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
    ## ***************   versjon 2.0   ***************
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
    ## Det foreligger 15138 målinger av parameteren ASPT [Average Score per Taxon (ASPT)].
    ## 
    ## OBS: 30 målinger ble ekskludert fordi de ble tatt etter 2024.
    ## 
    ## Alle målinger ligger innafor parameterens definisjonsområde.
    ## 
    ## Vennligst vent mens målingene kobles mot vannforekomster!
    ## Ferdig med 100 % av målingene.
    ## 
    ## Alle målinger kunne knyttes til en vannlokalitet.
    ## 
    ## OBS: 243 målinger ble ekskludert fordi deres vannlokaliteter ikke kunne knyttes til noen
    ##      typifisert vannforekomst.
    ## 
    ## OBS: 3 målinger ble ekskludert fordi de ikke ble foretatt i en elvevannforekomst.
    ## 
    ## Alle målinger ble foretatt i de riktige vanntypene.
    ## 
    ## OBS: 20 datapunkt måtte fjernes fra datasettet fordi de ikke oppfyller de spesifikke
    ##      kravene som stilles til målinger av ASPT.
    ## 
    ## OBS: For rapportåret 1990 foreligger bare målinger fra 0 vannforekomster. Det er
    ##      dessverre for få, og denne rapportperioden må derfor utgå.
    ## 
    ## OBS: For rapportåret 2000 foreligger bare målinger fra 8 vannforekomster. Det er
    ##      dessverre for få, og denne rapportperioden må derfor utgå.
    ## 
    ## OBS: Kontrabeskjed - verdier for rapportåret 2000 estimeres "bakfra" (dvs. med data fra
    ##      perioden 2001-2010).
    ## 
    ## Dataene som inngår i modelltilpasninga, inneholder dermed
    ## - 14787 målinger fra
    ## - 5108 vannlokaliteter i
    ## - 2975 vannforekomster i
    ## - 19 fylker
    ## - mellom 2001 og 2024.
    ## 
    ## 
    ##    Skalering til mEQR-verdier
    ##    ==========================
    ## 
    ## Oppsummering av variabelverdier før skalering:
    ##  minimum  ned. kv.    median  gj.snitt  øvr. kv.  maksimum 
    ##  1,90000   5,60000   6,16667   6,03279   6,61111   9,25000 
    ## 
    ## Oppsummering av variabelverdier etter skalering:
    ##  minimum  ned. kv.    median  gj.snitt  øvr. kv.  maksimum 
    ##  0,08636   0,50000   0,64167   0,64580   0,75278   1,19914 
    ## 
    ## 
    ##    Modelltilpasning til målingene
    ##    ==============================
    ## 
    ## OBS: 4 målinger ble ekskludert fordi typologifaktoren "humøsitet" ikke var kjent for dem.
    ## 
    ## 
    ## Modelltilpasning, runde 1:
    ## 
    ## * Aktivitet: KART og FLYP har blitt slått sammen pga. for lite data.
    ## * Aktivitet: EMUD og OEKF har blitt slått sammen pga. for lite data.
    ## * Aktivitet: ANLA og MYFO har blitt slått sammen pga. for lite data.
    ## * Aktivitet: PASV og DEPO har blitt slått sammen pga. for lite data.
    ## * Aktivitet: BAPO og DRIK har blitt slått sammen pga. for lite data.
    ## * Aktivitet: FLYP+KART og BARE har blitt slått sammen pga. for lite data.
    ## * Aktivitet: DEPO+PASV og GRUV har blitt slått sammen pga. for lite data.
    ## * Aktivitet: JRBN og VASS har blitt slått sammen pga. for lite data.
    ## * Aktivitet: INDU og KALK har blitt slått sammen.
    ## * Aktivitet: AREA og KOMM har blitt slått sammen.
    ## * Aktivitet: KALL og TILT har blitt slått sammen.
    ## * Aktivitet: ELVE og PROB har blitt slått sammen.
    ## * Aktivitet: EMUD+OEKF og INDU+KALK har blitt slått sammen.
    ## * Aktivitet: BARE+FLYP+KART og FORS har blitt slått sammen.
    ## * Aktivitet: DEPO+GRUV+PASV og JRBN+VASS har blitt slått sammen.
    ## * Aktivitet: ANNE og ELVE+PROB har blitt slått sammen.
    ## * Aktivitet: BIOM og KALL+TILT har blitt slått sammen.
    ## * Aktivitet: BARE+FLYP+FORS+KART og SKYT har blitt slått sammen.
    ## * Aktivitet: KAVE og RELV har blitt slått sammen.
    ## * Aktivitet: AREA+KOMM og DEPO+GRUV+JRBN+PASV+VASS har blitt slått sammen.
    ## * SMVF har blitt beholdt uendra (med 2 ulike verdier).
    ## * Turbiditet har blitt beholdt uendra (med 2 ulike verdier).
    ## * Region: W og E har blitt slått sammen.
    ## * Region: M og N har blitt slått sammen.
    ## * Region har blitt erstatta med faktisk geografisk bredde.
    ## * Sone: L og M har blitt slått sammen.
    ## * Størrelse: 1 og 2 har blitt slått sammen.
    ## * Størrelse: 3 og 4 har blitt slått sammen.
    ## * Alkalitet: 5 og 6 har blitt slått sammen pga. for lite data.
    ## * Alkalitet: 7 og 1 har blitt slått sammen pga. for lite data.
    ## * Alkalitet: 7+1 og 8 har blitt slått sammen.
    ## * Humøsitet har blitt beholdt uendra (med 4 ulike verdier).
    ## 
    ## Modelltilpasning, runde 2:
    ## 
    ## * Aktivitet: BIOM+KALL+TILT og KAVE+RELV har blitt slått sammen.
    ## * SMVF har blitt beholdt uendra (med 2 ulike verdier).
    ## * Turbiditet har blitt beholdt uendra (med 2 ulike verdier).
    ## * Sone har blitt beholdt uendra (med 2 ulike verdier).
    ## * Størrelse har blitt beholdt uendra (med 3 ulike verdier).
    ## * Alkalitet har blitt beholdt uendra (med 5 ulike verdier).
    ## * Humøsitet har blitt beholdt uendra (med 4 ulike verdier).
    ## * Geografisk bredde har blitt beholdt uendra (som numerisk variabel).
    ## 
    ## Modelltilpasning, runde 3:
    ## 
    ## * Aktivitet har blitt beholdt uendra (med 8 ulike verdier).
    ## * SMVF har blitt beholdt uendra (med 2 ulike verdier).
    ## * Turbiditet har blitt beholdt uendra (med 2 ulike verdier).
    ## * Sone har blitt beholdt uendra (med 2 ulike verdier).
    ## * Størrelse har blitt beholdt uendra (med 3 ulike verdier).
    ## * Alkalitet har blitt beholdt uendra (med 5 ulike verdier).
    ## * Humøsitet har blitt beholdt uendra (med 4 ulike verdier).
    ## * Geografisk bredde har blitt beholdt uendra (som numerisk variabel).
    ## 
    ## Oppsummering av den tilpassa modellen ...
    ## 
    ## Modelltype: lineær regresjon
    ## Modellstruktur: vrd ~ per * rar + akt + smvf + gbred + son + sto + alk + hum + tur
    ## 
    ## Residualer:
    ##  minimum  ned. kv.    median  gj.snitt  øvr. kv.  maksimum 
    ## -6,55386  -0,35202  -0,08638  -0,01692   0,17967   8,35427 
    ## standardfeil: 1,009 med 14725 frihetsgrader
    ## 
    ## Koeffisienter:
    ##                                        estimat standardfeil t-verdi Pr(>|t|)    
    ## (konstantledd)                        -6,87889      0,32915  -20,90  < 1E-12 ***
    ## per2014                               -1,69153      0,07346  -23,03  < 1E-12 ***
    ## per2019                               -1,58807      0,05724  -27,74  < 1E-12 ***
    ## per2024                               -1,90276      0,05612  -33,91  < 1E-12 ***
    ## rar                                    0,21006      0,01887   11,13  < 1E-12 ***
    ## aktANNE+ELVE+PROB                     -0,72693      0,08484   -8,57  < 1E-12 ***
    ## aktAREA+DEPO+GRUV+JRBN+KOMM+PASV+VASS -1,00936      0,09595  -10,52  < 1E-12 ***
    ## aktBAPO+DRIK                          -2,06829      0,18615  -11,11  < 1E-12 ***
    ## aktBARE+FLYP+FORS+KART+SKYT           -1,59518      0,09655  -16,52  < 1E-12 ***
    ## aktBIOM+KALL+KAVE+RELV+TILT           -0,59199      0,08630   -6,86  7,2E-12 ***
    ## aktEMUD+INDU+KALK+OEKF                -1,18979      0,09026  -13,18  < 1E-12 ***
    ## aktLANG                                0,95306      0,10057    9,48  < 1E-12 ***
    ## smvfnei                                0,07988      0,03231    2,47  0,01345 *  
    ## gbred                                  0,15828      0,00502   31,52  < 1E-12 ***
    ## sonL+M                                 0,21199      0,05830    3,64  0,00028 ***
    ## sto3+4                                 0,07517      0,03056    2,46  0,01390 *  
    ## sto5                                  -0,07647      0,06252   -1,22  0,22129    
    ## alk3                                  -0,40756      0,03224  -12,64  < 1E-12 ***
    ## alk4                                  -0,97609      0,05484  -17,80  < 1E-12 ***
    ## alk5+6                                 0,65300      0,06821    9,57  < 1E-12 ***
    ## alk7+1+8                               0,45276      0,03253   13,92  < 1E-12 ***
    ## hum2                                  -0,19067      0,02913   -6,54  6,2E-11 ***
    ## hum3                                  -1,44071      0,12875  -11,19  < 1E-12 ***
    ## hum4                                  -0,14624      0,07256   -2,02  0,04389 *  
    ## tur3                                  -0,52586      0,05903   -8,91  < 1E-12 ***
    ## per2014:rar                           -0,17580      0,03417   -5,14  2,7E-07 ***
    ## per2019:rar                           -0,20328      0,02531   -8,03  < 1E-12 ***
    ## per2024:rar                           -0,18815      0,02255   -8,34  < 1E-12 ***
    ## ---
    ## Signifikansnivåer:  0 *** 0,001 ** 0,01 * 0,05 . 0,1
    ## 
    ## AIC = 62982,15
    ## R² = 0,3465
    ## F(27, 14725) = 289,2
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
    ## Det foreligger altså målinger for 13 % av de relevante vannforekomstene (2974 av 23092).
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
    ## ASPTs mEQR-verdier har medianen 0,920 og strekker seg fra 0,033 til 1,200.

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

![](/fig/fig1.png)

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

![](/fig/fig2.png)

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

![](/fig/fig3.png)

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
[`oppdaterNImedVF`](forklar/oppdaterNImedVF.md). Om denne ikke rapporterer noen
feil, har man mulighet til å fullføre opplastinga.
