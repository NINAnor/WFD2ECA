# Håndtering av ulike vannforskriftsparametere

Funksjonen `fraVFtilNI` forutsetter at informasjon om vannforskriftsparameteren som skal flyttes fra vannforskriften til naturindeksen, er tilgjengelig i en spesifisert form.

-   <a href="#vannforskriftsparametere-som-er-klare-til-bruk" id="toc-vannforskriftsparametere-som-er-klare-til-bruk">Vannforskriftsparametere som er klare til bruk</a>
-   <a href="#hvordan-flere-vannforskriftsparametere-kan-gjøres-klar-til-bruk" id="toc-hvordan-flere-vannforskriftsparametere-kan-gjøres-klar-til-bruk">Hvordan flere vannforskriftsparametere kan gjøres klar til bruk</a>
-   <a href="#spesielle-krav-til-de-ulike-vannforskriftsparameterne" id="toc-spesielle-krav-til-de-ulike-vannforskriftsparameterne">Spesielle krav til de ulike vannforskriftsparameterne</a>
    -   <a href="#aip" id="toc-aip">AIP</a>
    -   <a href="#aspt" id="toc-aip">ASPT</a>
    -   <a href="#hbi2" id="toc-hbi2">HBI2</a>
    -   <a href="#pit" id="toc-pit">PIT</a>
    -   <a href="#pti" id="toc-pti">PTI</a>
    -   <a href="#raddum" id="toc-raddum">Raddum</a>
    -   <a href="#sic-tic-wic" id="toc-sic-tic-wic">SIc, TIc, WIc</a>


## Vannforskriftsparametere som er klare til bruk

For tolv vannforskriftsparameterne er dataflyten gjort klar til bruk.
Disse listes her opp med vannmiljø-databasens forkortelse (halvfeit), etterfulgt av fullt navn (kursiv), eventuell annen og bedre kjent forkortelse (halvfeit i parentes) samt vanntype (i parentes).
Parametrenes klassegrenser følger [klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/).
Imidlertid er dårligste (nedre eller øvre) grense for svært dårlig tilstand og minste og største mulige verdi ikke alltid angitt i veiledere, så disse presenteres under.

* **AIP** &ndash; _forsuringsindeks påvekstalger artssammensetning_ (elver): Nedre (dårligste) grense for svært dårlig tilstand er 5,17 (gjennomsnittet for de tre laveste indeksverdiene; se [klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), s. 68&ndash;69), men verdier ned til 5,13 er mulig (laveste indeksverdi for en enkeltart; se [vedlegg til veileder 02:2018](https://www.vannportalen.no/veiledere/02-2018-vedlegg-til-veileder-klassifisering-av-miljotilstanden-i-vann.pdf), s. 67&ndash;68). Høyeste (beste) mulige verdi er 7,42 (gjennomsnittet for de tre høyeste indeksverdiene). [xls må oppdateres til 7,42]
* **ASPT** &ndash; _Average Score per Taxon_ (elver): Mulige tallverdier ligger mellom 1 og 10 ([klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), s. 76&ndash;79; [vedlegg til veileder 02:2018](https://www.vannportalen.no/veiledere/02-2018-vedlegg-til-veileder-klassifisering-av-miljotilstanden-i-vann.pdf), s. 84). [hva med 0?]
* **ES100** &ndash; _Hurlberts diversitetsindeks marin bløtbunnsfauna_ (kystvann): ??? [fjernes!]
* **HBI2** &ndash; _heterotrof begroingsindeks_ (elver): Mulige tallverdier ligger mellom 0 og 400 ([klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), s. 66&ndash;68). [xls ok]
* **ISI** &ndash; _indikatorartsindeks marin bløtbunnsfauna_ (kystvann): Nedre (dårligste) grense for svært dårlig tilstand er angitt som 0,00 ([klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), s. 166&ndash;167), men indeksen kan ikke blir mindre enn 1,58 (laveste indeksverdi for en enkeltart; se [vedlegg til veileder 02:2018](https://www.vannportalen.no/veiledere/02-2018-vedlegg-til-veileder-klassifisering-av-miljotilstanden-i-vann.pdf), s. 125&ndash;139), så laveste mulige verdi er satt til 1,58. Høyeste (beste) mulige verdi er 37,65 (høyeste indeksverdi for en enkeltart).
* **MBH** &ndash; _Shannon-Wiener diversitetsindeks_ (**H'**, kystvann): Den høyeste referanseverdien er 6,3 ([klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), s. 166). Siden det ikke fins noen naturlig maksimumsverdi, er den øvre grensa her vilkårlig satt til 7,3 (som tilsvarer det dobbelte [158 arter] av den høyeste referanseverdien [79 arter], gitt maksimal diversitet, dvs. at alle arter er representert med ett individ hver). Laveste (dårligste) mulige verdi er 0,0 (alle individer i prøven tilhører én art). [xls ok]
* **NQI1** &ndash; _norsk kvalitetsindeks marin bløtbunnsfauna_ (kystvann): Det er oppgitt at "NQI1 kan ha verdier mellom 0 og 1" ([vedlegg til veileder 02:2018](https://www.vannportalen.no/veiledere/02-2018-vedlegg-til-veileder-klassifisering-av-miljotilstanden-i-vann.pdf), s. 118). Derfor brukes derfor her 0 som laveste og 1 som høyeste mulige verdi, selv om opplysningene gitt i [vedlegg til veileder 02:2018](https://www.vannportalen.no/veiledere/02-2018-vedlegg-til-veileder-klassifisering-av-miljotilstanden-i-vann.pdf) (s. 118&ndash;119) tilsier at NQI1 ikke kan bli mindre enn 0,07 (men se [Borja mfl. 2000](https://doi.org/10.1016/S0025-326X(00)00061-8)), og selv om NQI1 teoretisk kan bli større enn 1 (men slike verdier er åpenbart aldri målt og urealistisk å få i Norge).
* **NSI**, _norsk sensitivitetsindeks marin bløtbunnsfauna_, rev. 2020 (kystvann): Nedre (dårligste) grense for svært dårlig tilstand er i [klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/) (s. 166&ndash;167) angitt som 0,00, men indeksen kan ikke blir mindre enn 4,68 (laveste indeksverdi for en enkeltart; se [vedlegg til veileder 02:2018](https://www.vannportalen.no/veiledere/02-2018-vedlegg-til-veileder-klassifisering-av-miljotilstanden-i-vann.pdf), s. 125&ndash;139), så laveste mulige verdi er satt til 4,68. Høyeste (beste) mulige verdi er 43,91 (høyeste indeksverdi for en enkeltart).
* **PIT** &ndash; _trofiindeks påvekstalger artssammensetning_ (elver): Øvre (dårligste) grense for svært dårlig tilstand er 60,84 (gjennomsnittet for de to høyeste indeksverdiene; [klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), s. 65&ndash;66), men verdier opp til 68,91 er mulig (høyeste indeksverdi for en enkeltart; se [vedlegg til veileder 02:2018](https://www.vannportalen.no/veiledere/02-2018-vedlegg-til-veileder-klassifisering-av-miljotilstanden-i-vann.pdf), s. 62&ndash;64). Laveste (beste) mulige verdi er 1,92 (gjennomsnittet for de to laveste indeksverdiene). [xls må oppdateres til 1,9]
* **PPTI** &ndash; _planteplankton trofiindeks_ (**PTI**, innsjøer): Øvre (dårligste) grense for svært dårlig tilstand er 4,00 ([klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), s. 46&ndash;49), men verdier opp til 4,77 er mulig (høyeste indeksverdi for en enkeltart; se [vedlegg til veileder 02:2018](https://www.vannportalen.no/veiledere/02-2018-vedlegg-til-veileder-klassifisering-av-miljotilstanden-i-vann.pdf), s. 8&ndash;15). Laveste (beste) mulige verdi er 1,16 (laveste indeksverdi for en enkeltart). [xls ok]
* **RADDUM1** &ndash; _Raddum forsuringsindeks I_ (elver og innsjøer): Indeksen har ikke noen definert referanseverdi. En enkelt måling med indeksverdi 1 oversettes til god tilstand. Kun hvis et gjennomsnitt av minimum 2 prøver har verdien 1, oversettes dette til svært god tilstand ([klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), s. 60&ndash;62).
* **TIANTL** &ndash; _trofiindeks makrofytter antall arter innsjø_ (**TIc**, innsjøer): Mulige tallverdier ligger mellom &minus;100 og +100 ([klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), s. 70&ndash;71). (OBS: Per 2023 var hele 21&nbsp;% av datapunktene i vannmiljø-databasen større enn 100, hadde altså ugyldige verdier.) [xls ok]

De relevante filene er samla i mappa "[klassegr](../klassegr)".
Filnavnene er "klassgrenser_", etterfulgt av parameterens vannmiljø-id og filendelsen ".xlsx".
Analysen forventer å finne filen i denne mappa.
Alternativt kan filnavn og -sti angis med funksjonsargumentet `filKlasser`, f.eks. slik:

    utmating_MBH <- fraVFtilNI(data_MBH, vannforekomster = V, vannlokaliteter = VL,
                               parameter = "MBH", vannkategori = "C",
                               filKlasser = "C:/minMappe/klassegrenser_MBH.xlsx")

Hvis klassegrensene for en vannforskriftsparameter blir endra, må informasjonen i mappa "klassegr" oppdateres tilsvarende.
Neste avsnitt forklarer hvordan dette gjøres.


## Hvordan flere vannforskriftsparametere kan gjøres klar til bruk

For at dataflyt fra en vannforskriftsparameter til naturindeksen skal kunne gjennomføres, må to ting være på plass:

- Parameterens minimums- og maksimumsverdi må være angitt i excel-regnearket "VM-param.xlsx".
- Parameterens klassegrenser må være angitt i et separat regneark.

For å gjøre nye parametere klar til dataflyt eller oppdatere klassegrensene etter eventuelle endringer, kan denne informasjonen tilføyes eller oppdateres.

1. Excelarket [VM-param.xlsx](../data/VM-param.xlsx) har fire kolonner. Kolonnenavne (id, navn, min, maks) må ikke endres. Kolonnene inneholder vannmiljø-databasens forkortelse (id) for og fulle navn på parameteren samt dens minste og største mulige verdi. Informasjonen kan endres ved å oppdatere informasjonen om en bestemt vannforskriftsparameter eller legge til en rad for en ny vannforskriftsparameter. Merk at (a) "min" og "maks" her refererer til _minste_ og _største_ tallverdi (ikke til dårligste og beste), dvs. uavhengig av om den minste verdien tilsvarer svært dårlig tilstand eller svært god tilstand; og at (b) "min" og "maks" refererer til minste og største _mulige_ verdi, som _kan_ være hhv. mindre eller større enn nedre klassegrense for svært dårlig tilstand eller øvre klassegrense for svært god tilstand!
2. Excelarket med klassegrenser bør hete "klassegrenser_[ID].xlsx", der "[ID]" erstattes med vannmiljø-databasens parameter-ID (f.eks. "klassegrenser_PPTI.xlsx" for PTI). Om regnearket får et annet navn, må dette oppgis via argumentet `filKlasser` til funksjonen `fraVFtilNI`. Regnearket må ha ni kolonner, som må ha kolonnenavnene "typ", "min", "SD_nedre", "SD_D", "D_M", "M_G", "G_SG", "SG_øvre" og "max". Utover raden med kolonnenavn må regnearket ha én rad per vanntype, der følgende informasjon er oppgitt i hver rad:
    - "typ": forkortelse for vanntypen (gyldige vanntyper er vannforskriftens vanntypekoder [f.eks. LFM33413 eller CS3723222], _trunkerte_ vanntypekoder [f.eks. LFM334 eller CS37, som antas å gjelde for alle vanntyper som _begynner_ med disse tegnene], vanntypekoder med _punktum som plassholder_ [f.eks. LFM3.413 eller C.372..22, som antas å gjelde for alle vanntyper som deler de oppgitte tegnene på de oppgitte plassene] eller _nasjonale_ vanntypekoder [f.eks. L208 eller R301d]);
    - "min": den _dårligste mulige_ verdien for parameteren (merk at verdien for mange, men ikke alle parametere er lik "SD_nedre", og at "min" her referer til den _dårligste_ verdien, som for noen parametere er den minste og for andre den største mulige tallverdien);
    - "SD_nedre": parameterens "nullverdi", dvs. _nedre_ (det vil her si _dårligste_) klassegrense for svært dårlig tilstand;
    - "SD_S": klassegrensa mellom svært dårlig tilstand og dårlig tilstand;
    - "SD_M": klassegrensa mellom dårlig tilstand og moderat tilstand;
    - "M_G": klassegrensa mellom moderat tilstand og god tilstand;
    - "G_SG": klassegrensa mellom god tilstand og svært god tilstand;
    - "SG_øvre": parameterens **referanseverdi**, dvs. _øvre_ (det vil her si _beste_) klassegrense for svært god tilstand;
    - "max": den _beste mulige_ verdien for parameteren (merk at verdien for mange, men ikke alle parametere er lik "SG_øvre", og at "max" her referer til den _beste_ verdien, som for noen parametere er den største og for andre den minste mulige tallverdien);

Som mal kan man bruke et av de foreliggende regnearkene, f.eks. [klassegrenser_AIP.xlsx](../klassegr/klassegrenser_AIP.xlsx).

Gyldige klassegrenser forutsetter at _alle_ klassegrensene er **mindre enn eller lik** naboverdien, _enten_ lest fra venstre til høyre (hvis tilstanden er bedre jo _høyere_ måleverdien er) _eller_ lest fra høyre til venstre (hvis tilstanden er bedre jo _lavere_ måleverdien er).
Hvis denne forutsettelsen ikke er oppfylt, vil det føre til feilmeldinger.
Manglende verdier (`NA`) er ikke tillatt i noen av cellene.

Enkelte parametere har ingen fysisk øvre grense.
I slike tilfeller bør den aktuelle verdien (dvs. "max" eller "min") settes vilkårlig til en tallverdi som er så mye større enn den respektive klassegrensen (dvs. "SG_øvre" eller "SD_nedre") at den inkluderer alle realistiske måleverdier (f.eks. det dobbelte artstallet for diversitetsindekser).


## Spesielle krav til de ulike vannforskriftsparameterne

Funksjonen `fraVFtilNI` sjekker om målinger som er rapportert i vannmiljø-databasen, inneholder åpenbare måle- eller rapporteringsfeil (dvs. verdier som er uforenlige med parameterens definisjon). 
I tillegg eksisterer imidlertid spesifikke krav til de fleste vannforskriftsparameterne. 
Om disse har vært oppfylt ved måling eller rapportering, er vanskeligere å teste, og funksjonen `fraVFtilNI` gjør ikke noe forsøk på å oppdage slike feil.
Nedenfor gis en liste over kjente krav og hvordan man eventuelt kan korrigere for at disse ikke er oppfylt.
Merk at lista mest sannsynlig ikke er uttømmende.


### AIP

AIP (forsuringsindeks påvekstalger artssammensetning) skal måles mellom juni og oktober.
Målinger som eventuelt ikke oppfyller kravet om tidspunkt, bør fjernes manuelt ved hjelp av datoen for målinga, før de resterende målingene brukes som innmating til funksjonen `fraVFtilNI`.

Hver måling bør dessuten være basert på minst tre arter.
Antall arter som en AIP-verdi er basert på, fremgår imidlertid ikke av vannmiljø-databasen.


### ASPT

ASPT (Average Score per Taxon) skal ikke brukes for breelver. 
Eventuelle målinger i breelver kan ekskluderes ved hjelp av argumentet `ikkeInkluder` til funksjonen [`fraVFtilNI`](VFtilNI.md).
Det gjøres ved å spesifisere at man for typologifaktoren "turbiditet" (`typ = "tur"`) skal se bort fra brepåvirka elver (`vrd = 2`):

    utmating_ASPT <- fraVFtilNI(data_ASPT, vannforekomster = V, vannlokaliteter = VL,
                                parameter = "ASPT", vannkategori = "R",
                                ikkeInkluder = list(typ = "tur", vrd = 2))


### HBI2

HBI2 (heterotrof begroingsindeks) skal baseres på minst to målinger per år, der den første er tatt på våren (januar–april) og den andre på høsten (oktober–desember). 
Datapunkt som eventuelt ikke oppfyller kravet om antall målinger og deres tidspunkt, bør fjernes manuelt ved hjelp av datoen for målinga, før målingene brukes som innmating til funksjonen `fraVFtilNI`.


### PIT

PIT (trofiindeks påvekstalger artssammensetning) skal måles mellom juni og oktober.
Målinger som eventuelt ikke oppfyller kravet om tidspunkt, bør fjernes manuelt ved hjelp av datoen for målinga, før de resterende målingene brukes som innmating til funksjonen `fraVFtilNI`.

Hver måling bør dessuten være basert på minst to arter.
Antall arter som en PIT-verdi er basert på, fremgår imidlertid ikke av vannmiljø-databasen.


### PTI

PTI (planteplankton trofiindeks, vannmiljø-id "PPTI") skal baseres på minst månedlige prøver gjennom hele vekstsesongen. 
Det samme gjelder for andre parametere for kvalitetselementet planteplankton (f.eks. KLFA, CYANOM).
Datapunkt som eventuelt ikke oppfyller kravet om antall målinger og deres tidspunkt, bør fjernes manuelt ved hjelp av datoen for målinga, før målingene brukes som innmating til funksjonen `fraVFtilNI`.


### Raddum

Raddum I inngår i naturindeksen, men merk at Raddum II ikke gjør det.
Raddum II-målinger er imidlertid enkelt å regne om til Raddum I-verdier.
Dermed kan datagrunnlaget utvides betraktelig (men _bare for elver_, siden Raddum II ikke er definert for innsjøer).
Dette kan gjøres ved hjelp av funksjonen [`Raddum2_1`](../R/Funksjon.R).
Når det f.eks. foreligger én dataramme hver for målinger av Raddum I (`data_Raddum1`) og Raddum II (`data_Raddum2`), kan det gjøres slik:

    data_Raddum1 <- rbind(data_Raddum1, Raddum2_1(data_Raddum2))
    
    ## 7403 Raddum-II-målinger har blitt regna om til Raddum I.
    
    utmating_Raddum <- fraVFtilNI(data_Raddum1, vannforekomster = V, vannlokaliteter = VL,
                                  parameter = "RADDUM1", vannkategori = "R")

Utmatinga til funksjonen `Raddum2_1` vil opplyse om hvor mange Raddum-II-målinger som har blitt regna om til Raddum I.


### SIc, TIc, WIc

SIc (forsuringsindeks makrofytter antall arter innsjø, vannmiljø-id "SIANTL"), TIc (trofiindeks makrofytter antall arter innsjø, vannmiljø-id "TIANTL") og WIc (vannstandsindeks makrofytter, vannmiljø-id "WIANTL") skal måles mellom juli og september.
Målinger som eventuelt ikke oppfyller kravet om tidspunkt, bør fjernes manuelt ved hjelp av datoen for målinga, før de resterende målingene brukes som innmating til funksjonen `fraVFtilNI`.

