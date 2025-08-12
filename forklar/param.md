# Håndtering av ulike vannforskriftsparametere

Funksjonene [`WFD2ECA`](WFD2ECA.md) og [`fraVFtilNI`](fraVFtilNI.md) forutsetter at informasjon om vannforskriftsparameteren som skal flyttes fra vannforskriften til et økologisk tilstandsregnskap eller naturindeksen, er tilgjengelig i en spesifisert form.
Parametrenes klassegrenser må bl.a. foreligge i form av regneark.
På denne sida forklares for hvilke parametere slike regneark er klargjort, og hvordan man kan revidere dem eller klargjøre flere.

-   <a href="#vannforskriftsparametere-som-er-relevante" id="toc-vannforskriftsparametere-som-er-relevante">Vannforskriftsparametere som er relevante</a>
-   <a href="#vannforskriftsparametere-som-er-klare-til-bruk" id="toc-vannforskriftsparametere-som-er-klare-til-bruk">Vannforskriftsparametere som er klare til bruk</a>
-   <a href="#hvordan-flere-vannforskriftsparametere-kan-gjøres-klar-til-bruk" id="toc-hvordan-flere-vannforskriftsparametere-kan-gjøres-klar-til-bruk">Hvordan flere vannforskriftsparametere kan gjøres klar til bruk</a>
-   <a href="#spesielle-krav-til-de-ulike-vannforskriftsparameterne" id="toc-spesielle-krav-til-de-ulike-vannforskriftsparameterne">Spesielle krav til de ulike vannforskriftsparameterne</a>


## Vannforskriftsparametere som er relevante

Eksisterende vannforskriftsparametere er beskrevet i [Direktoratsgruppas klassifiseringsveileder](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), og relevante målinger er samla i [vannmiljø-databasen](https://vannmiljo.miljodirektoratet.no/).
Vannforskriftsparametere som den her beskrevne dataflyten er relevante for, er i første rekke slike som også brukes som indikatorer i et økologisk tilstandsregnskap ([Fremstad mfl. 2023](https://hdl.handle.net/11250/3104185)) eller av naturindeksen ([Sandvik 2019](http://hdl.handle.net/11250/2631056)).

* De fleste vannforskriftsparameterne kan i prinsippet være relevante som indikatorer for et økologisk tilstandsregnskap ([Fremstad mfl. 2023](https://hdl.handle.net/11250/3104185)). Indikatorene som har blitt prioritert, er ferskvannsindikatorer med et tilstrekkelig datagrunnlag i vannmiljø-databasen. Per august 2025 er [**ASPT**](https://github.com/NINAnor/ecRxiv/tree/main/indicators/NO_WSPT_001), [**AIP**](https://github.com/NINAnor/ecRxiv/tree/main/indicators/NO_WAIP_001), [**ANC**](https://github.com/NINAnor/ecRxiv/tree/main/indicators/NO_WANC_001_002), [**KLFA**](https://github.com/NINAnor/ecRxiv/tree/main/indicators/NO_WCHL_001), [**LAL**](https://github.com/NINAnor/ecRxiv/tree/main/indicators/NO_WLAL_001_002), [**PH**](https://github.com/NINAnor/ecRxiv/tree/main/indicators/NO_WPHX_001_002), [**PIT**](https://github.com/NINAnor/ecRxiv/tree/main/indicators/NO_WPIT_001), [**PPBIOMTOVO**](https://github.com/NINAnor/ecRxiv/tree/main/indicators/NO_WPPB_001), [**PTI**](https://github.com/NINAnor/ecRxiv/tree/main/indicators/NO_WPTI_001), [**P-TOT**](https://github.com/NINAnor/ecRxiv/tree/main/indicators/NO_WTPX_001_002) og [**RAMI**](https://github.com/NINAnor/ecRxiv/tree/main/indicators/NO_WAMI_001) gjort klar til bruk (se [under](#vannforskriftsparametere-som-er-klare-til-bruk)) og beskrevet med hver sin indikatordokumentasjon på [ecRxiv](https://github.com/NINAnor/ecRxiv) (som forkortelsene lenker til).
* I den aktuelle versjonen av [naturindeksen](https://www.naturindeks.no/) (dvs. 2024) er det brukt flere vannforskriftsparametere. For ferskvann er dette **AIP**, **ASPT**, **PIT**, **PTI**, **Raddum&nbsp;1** og **TIc**, hvorav ASPT og Raddum&nbsp;1 benytter den her beskrevne dataflyten (og de øvrige kunne i prinsippet benytte den, se [under](#vannforskriftsparametere-som-er-klare-til-bruk)). For kystvann brukes **MBH**, **NQI1**, **KLFA**, **RSLA**1&ndash;3, **RSL**4&ndash;5 og **MSMDI**, hvorav de to førstnevnte i prinsippet kunne benytte dataflyten (se [under](#vannforskriftsparametere-som-er-klare-til-bruk)). 


## Vannforskriftsparametere som er klare til bruk

For 18 vannforskriftsparameterne er dataflyten gjort klar til bruk.
Disse listes her opp med vannmiljø-databasens forkortelse (halvfeit), etterfulgt av fullt navn (kursiv), eventuell annen og bedre kjent forkortelse (halvfeit i parentes) samt vanntype (i parentes).
Parametrenes klassegrenser, inkludert beste grense for svært god tilstand (forkorta X<sub>100</sub>), følger [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/).
Imidlertid er dårligste grense for svært dårlig tilstand (forkorta X<sub>0</sub>) ikke alltid angitt i veilederen, heller ikke beste og dårligste _mulige_ verdi (_optimum_ og _pessimum_), så disse presenteres under.

* **AIP** &ndash; _forsuringsindeks påvekstalger artssammensetning_ (elver): X<sub>0</sub> er 5,17 (gjennomsnittet for de tre laveste indeksverdiene), men verdier ned til 5,13 er mulig (laveste indeksverdi for en enkeltart; se [klassifiseringsveileder](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab.&nbsp;V5.1.2). Optimum er 7,42 (gjennomsnittet for de tre høyeste indeksverdiene).
* **ANC** &ndash; _syrenøytraliserende kapasitet_ (elver og innsjøer): X<sub>0</sub> er ikke oppgitt i [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), men er &minus;100. Det fins ingen naturlige maksimums- eller minimumsverdier, så pessimum er vilkårlig satt til &minus;200 (det dobbelte av X<sub>0</sub>) og optimum til +250 (det dobbelte av den høyeste verdien for X<sub>100</sub>).
* **ASPT** &ndash; _Average Score per Taxon_ (elver): Mulige indeksverdier ligger mellom 1 og 10 ([klassifiseringsveileder](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab.&nbsp;V5.3.3). Ifølge [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/) (tab.&nbsp;3.11) er ASPTs nullverdi imidlertid lik 0 (mulig tolkning: fravær av bunnfauna), så X<sub>0</sub> og pessimum er her satt til&nbsp;0.
* **ES100** &ndash; _Hurlberts diversitetsindeks marin bløtbunnsfauna_ (**ES<sub>100</sub>**, kystvann): Mulige indeksverdier ligger mellom 0 og 100, om 0 brukes for fravær av bløtbunnsfauna. (OBS: Formelen gitt i [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/) er feil; riktig formel er gitt i [Rygg & Norling 2013](http://hdl.handle.net/11250/216238), s.&nbsp;9.)
* **HBI2** &ndash; _heterotrof begroingsindeks_ (elver): Mulige tallverdier ligger mellom 0 og 400.
* **ISI** &ndash; _indikatorartsindeks marin bløtbunnsfauna_ (kystvann): X<sub>0</sub> er i [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/) (tab.&nbsp;9.22) angitt som 0,00, men indeksen kan ikke blir mindre enn 1,58 (laveste indeksverdi for en enkeltart), så pessimum er her satt til 1,58. Optimum er 37,65 (høyeste indeksverdi for en enkeltart).
* **KLFA** &ndash; _klorofyll a_ (innsjøer og kystvann): Mulige tallverdier er &ge;&nbsp;0 uten noen naturlig maksimumsverdi. Siden nEQR beregnes basert på den inverse variabelverdien ([klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab.&nbsp;3.11), trengs det ikke noe endelig pessimum.
* **LAL** &ndash; _labilt aluminium_ (elver og innsjøer): se KLFA over.
* **MBH** &ndash; _Shannon-Wiener diversitetsindeks_ (**H'**, kystvann): Den høyeste verdien for X<sub>100</sub> er 6,3 ([klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab.&nbsp;9.22). Siden det ikke fins noen naturlig maksimumsverdi, er optimum her vilkårlig satt til 7,3 (som tilsvarer det dobbelte [158 arter] av den høyeste referanseverdien [79 arter], gitt maksimal diversitet, dvs. at alle arter er representert med ett individ hver). Pessimum er 0,0 (alle individer i prøven tilhører én art). (OBS: formelen for H' som er gitt i [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), mangler et minustegn foran&nbsp;&Sigma;.)
* **NQI1** &ndash; _norsk kvalitetsindeks marin bløtbunnsfauna_ (kystvann): I [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/) er det oppgitt at "NQI1 kan ha verdier mellom 0 og 1". Derfor brukes det her 0 som pessimum og 1 som optimum &ndash; selv om opplysningene gitt samme sted tilsier at NQI1 ikke kan bli mindre enn 0,07 (men se [Borja mfl. 2000](https://doi.org/10.1016/S0025-326X(00)00061-8)), og selv om NQI1 teoretisk kan bli større enn 1 (men slike verdier er åpenbart aldri målt og urealistisk å få i Norge).
* **PH** &ndash; _pH_ (elver og innsjøer): I [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/) (tab.&nbsp;3.11) er det oppgitt at X<sub>0</sub> er 0, selv om verdier under 3 er urealistiske. Optimum er satt til 7,2, som er litt høyere enn den høyeste verdien for X<sub>100</sub>. Større verdier er mulig (til godt over 10), men disse er så alkaliske at de ikke kan sies å representere noen forbedring av tilstanden, og slike målinger blir derfor ekskludert.
* **PIT** &ndash; _trofiindeks påvekstalger artssammensetning_ (elver): X<sub>0</sub> er 60,84 (gjennomsnittet for de to høyeste indeksverdiene), men verdier opp til 68,91 er mulig (høyeste indeksverdi for en enkeltart; se [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab.&nbsp;V5.1.1). Optimum er 1,92 (gjennomsnittet for de to laveste indeksverdiene).
* **PPBIOMTOVO** &ndash; _total biomasse planteplankton per volumenhet_ (innsjøer): Den høyeste verdien for X<sub>0</sub> er 7&nbsp;mg/l ([klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab.&nbsp;4.2). Siden det ikke fins noen naturlig maksimumsverdi, er pessimum her vilkårlig satt til 140&nbsp;mg/l (som tilsvarer det 20-dobbelte av den høyeste verdien for X<sub>0</sub>). Optimum er 0&nbsp;mg/l.
* **PPTI** &ndash; _planteplankton trofiindeks_ (**PTI**, innsjøer): X<sub>0</sub> er 4,00 ([klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab.&nbsp;4.2), men verdier opp til 4,99 er mulig (høyeste indeksverdi for en enkeltart; se [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab.&nbsp;V4.1.1). Optimum er 1,16 (laveste indeksverdi for en enkeltart).
* **P-TOT** &ndash; _totalfosfor_ (elver og innsjøer): se KLFA over.
* **RADDUM1** &ndash; _Raddum forsuringsindeks I_ (elver og innsjøer): Indeksen har ikke noen definert referanseverdi. En enkelt måling med indeksverdi 1 oversettes til god tilstand. Kun hvis et gjennomsnitt av minimum 2 prøver har verdien 1, oversettes dette til svært god tilstand ([klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab.&nbsp;4.10a).
* **RAMI** &ndash; _River Acidification Macroinvertebrate Index_ (elver): Mulige indeksverdier ligger mellom 2 og 8 ([klassifiseringsveileder](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab.&nbsp;V5.3.1). Ifølge [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/) (tab.&nbsp;3.11) er RAMIs nullverdi imidlertid lik 0 (mulig tolkning: fravær av makroinvertebrater), så X<sub>0</sub> og pessimum er her satt til&nbsp;0.
* **TIANTL** &ndash; _trofiindeks makrofytter antall arter innsjø_ (**TIc**, innsjøer): Mulige tallverdier ligger mellom &minus;100 og +100. (OBS: Per desember 2023 var hele 21&nbsp;% av datapunktene i vannmiljø-databasen større enn 100, hadde altså ugyldige verdier.)

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

For at dataflyt av en vannforskriftsparameter til et økologisk tilstandsregnskap eller til naturindeksen skal kunne gjennomføres, må to ting være på plass:

- Parameterens minimums- og maksimumsverdi må være angitt i excel-regnearket "VM-param.xlsx".
- Parameterens klassegrenser må være angitt i et separat regneark.

For å gjøre nye parametere klar til dataflyt eller oppdatere klassegrensene etter eventuelle endringer, kan denne informasjonen tilføyes eller oppdateres.

1. Excelarket [VM-param.xlsx](../data/VM-param.xlsx) har fire kolonner. Kolonnenavne (id, navn, min, max) må ikke endres. Kolonnene inneholder vannmiljø-databasens forkortelse (id) for og fulle navn på parameteren samt dens minste og største mulige verdi. Informasjonen kan endres ved å oppdatere informasjonen om en bestemt vannforskriftsparameter eller legge til en rad for en ny vannforskriftsparameter. Merk at (a) "min" og "max" her refererer til _minste_ og _største_ tallverdi (ikke til dårligste og beste), dvs. uavhengig av om den minste verdien tilsvarer svært dårlig tilstand eller svært god tilstand; og at (b) "min" og "max" refererer til minste og største _mulige_ verdi, som _kan_ være hhv. mindre eller større enn nedre klassegrense for svært dårlig tilstand eller øvre klassegrense for svært god tilstand!
2. Excelarket med klassegrenser bør hete "klassegrenser_[ID].xlsx", der "[ID]" erstattes med vannmiljø-databasens parameter-ID (f.eks. "klassegrenser_PPTI.xlsx" for PTI). Om regnearket får et annet navn, må dette oppgis via argumentet `filKlasser` til funksjonen `WFD2ECA` eller `fraVFtilNI`. Regnearket må ha ni kolonner, som må ha kolonnenavnene "typ", "pess", "X0", "X20", "X40", "X60", "X80", "X100" og "opt". Utover raden med kolonnenavn må regnearket ha én rad per vanntype, der følgende informasjon er oppgitt i hver rad:
    - "typ": forkortelse for vanntypen (gyldige vanntyper er vannforskriftens vanntypekoder [f.eks. LFM33413 eller CS3723222], _trunkerte_ vanntypekoder [f.eks. LFM334 eller CS37, som antas å gjelde for alle vanntyper som _begynner_ med disse tegnene], vanntypekoder med _punktum som plassholder_ [f.eks. LFM3.413 eller C.372..22, som antas å gjelde for alle vanntyper som deler de oppgitte tegnene på de oppgitte plassene] eller _nasjonale_ vanntypekoder [f.eks. L208 eller R301d]);
    - "pess": den _dårligste mulige_ verdien (_pessimum_) for parameteren (merk at verdien for mange, men ikke alle parametere er lik "X0", og at den dårligste kan være den minste eller største tallverdien);
    - "X0": parameterens "nullverdi", dvs. _nedre_ (det vil her si _dårligste_) klassegrense for svært dårlig tilstand (tilsvarende [nEQR](mEQR.md) = 0,00);
    - "X20": klassegrensa mellom svært dårlig tilstand og dårlig tilstand (tilsvarende nEQR = 0,20);
    - "X40": klassegrensa mellom dårlig tilstand og moderat tilstand (tilsvarende nEQR = 0,40);
    - "X60": klassegrensa mellom moderat tilstand og god tilstand (tilsvarende nEQR = 0,60);
    - "X80": klassegrensa mellom god tilstand og svært god tilstand (tilsvarende nEQR = 0,80);
    - "X100": parameterens **referanseverdi**, dvs. _øvre_ (det vil her si _beste_) klassegrense for svært god tilstand (tilsvarende nEQR = 1,00);
    - "opt": den _beste mulige_ verdien (_optimum_) for parameteren (merk at verdien for mange, men ikke alle parametere er lik "X100", og at den beste kan være den minste eller største tallverdien).

Som mal kan man bruke et av de foreliggende regnearkene, f.eks. [klassegrenser_AIP.xlsx](../klassegr/klassegrenser_AIP.xlsx).

Gyldige klassegrenser forutsetter at klassegrensene er **mindre enn** naboverdien, _enten_ lest fra venstre til høyre (hvis tilstanden er bedre jo _høyere_ måleverdien er) _eller_ lest fra høyre til venstre (hvis tilstanden er bedre jo _lavere_ måleverdien er); minste og største _mulige_ verdi (ytterpunktene) kan også være **lik** sine naboverdier.
Hvis denne forutsettelsen ikke er oppfylt, vil det føre til feilmeldinger.
Manglende verdier (`NA`) er ikke tillatt i noen av cellene.

Enkelte parametere har ingen fysisk øvre grense.
I slike tilfeller bør den aktuelle verdien (dvs. "pess" eller "opt") settes vilkårlig til en tallverdi som er så mye større enn den respektive klassegrensen (dvs. "X100" eller "X0") at den inkluderer alle realistiske måleverdier (f.eks. det dobbelte artstallet for diversitetsindekser).


## Spesielle krav til de ulike vannforskriftsparameterne

Funksjonene [`WFD2ECA`](WFD2ECA.md) og [`fraVFtilNI`](fraVFtilNI.md) sjekker om målinger som er rapportert i vannmiljø-databasen, inneholder åpenbare måle- eller rapporteringsfeil (dvs. verdier som er uforenlige med parameterens definisjon). 
I tillegg eksisterer imidlertid spesifikke krav til de fleste vannforskriftsparameterne. 
Noen av disse kravene, men ikke alle, blir kontrollert av funksjonene `WFD2ECA` og `fraVFtilNI` (nærmere bestemt av hjelpefunksjonene [`sjekkXXX`](sjekkPar.md)).
Nedenfor gis en liste over foreliggende krav og hvilke av disse som blir kontrollert (der lista over foreliggende krav ikke nødvendigvis er uttømmende).

* **AIP** skal måles mellom juni og oktober. Målinger som ikke oppfyller dette kravet, blir ekskludert (se [`sjekkAIP`](sjekkPar.md)). Standardinnstillinga tillater et slingringsmonn på to uker. Hver AIP-måling bør dessuten være basert på minst tre arter. Dette kravet blir _ikke_ sjekket, siden antall arter som en AIP-verdi er basert på, ikke fremgår av vannmiljø-databasen.
* **ANC** skal baseres på minst fire målinger per år (én per årstid). Målinger som ikke oppfyller dette kravet, blir ekskludert (se [`sjekkANC`](sjekkPar.md)).
* **ASPT** skal ikke brukes for breelver. Målinger som ikke oppfyller dette kravet, blir ekskludert (se [`sjekkASPT`](sjekkPar.md)).
* **HBI2** skal baseres på minst to målinger per år, der den første er tatt på våren (januar–april) og den andre på høsten (oktober–desember). Målinger som ikke oppfyller dette kravet, blir ekskludert (se [`sjekkHBI2`](sjekkPar.md)).
* **KLFA** (klorofyll _a_) skal baseres på minst månedlige prøver gjennom hele vekstsesongen. Målinger som ikke oppfyller dette kravet, blir ekskludert (se [`sjekkKLFA`](sjekkPar.md)). Standardinnstillinga er å anta at vekstsesongen varer fra mai til oktober, og å kreve at det er tatt minst fire målinger i løpet av denne perioden i Sør-Norge under 200 moh. og minst tre målinger i resten av Norge (dvs. å tillate at det mangler målinger fra noen av månedene).
* **LAL** (labilt aluminium) skal baseres på minst fire målinger per år (én per årstid). Målinger som ikke oppfyller dette kravet, blir ekskludert, og blant de gyldige målingene blir kun den med høyest måleverdi i et år benytta (se [`sjekkLAL`](sjekkPar.md)).
* **PH** skal håndteres som ANC (se over og [`sjekkPH`](sjekkPar.md)).
* **PIT** skal håndteres som AIP (se over og [`sjekkPIT`](sjekkPar.md)).
* **PPBIOMTOVO** skal håndteres som KLFA (se over og [`sjekkPPBIOMTOVO`](sjekkPar.md)).
* **PPTI** (PTI) skal håndteres som KLFA (se over og [`sjekkPPTI`](sjekkPar.md)).
* **P-TOT** (totalfosfor) skal håndteres som KLFA (se over og [`sjekkPTOT`](sjekkPar.md)).
* **RADDUM1** (Raddum I) skal kun brukes i klare vannforekomster (humøsitet = 1). Målinger som ikke oppfyller dette kravet, blir ekskludert (se [`sjekkRADDUM1`](sjekkPar.md)). Merk at kun Raddum I inngår i naturindeksen, mens Raddum II ikke gjør det. Raddum&nbsp;II-målinger er imidlertid enkelt å regne om til Raddum&nbsp;I-verdier. Dermed kan datagrunnlaget utvides betraktelig (men _bare for elver_, siden Raddum II ikke er definert for innsjøer). Dette kan gjøres ved hjelp av funksjonen [`Raddum2_1`](../R/Funksjon.R), f.eks. slik (når det foreligger én dataramme hver for målinger av Raddum I og Raddum II): `data_Raddum1 <- rbind(data_Raddum1, Raddum2_1(data_Raddum2))`; eller slik (når alle målinger er i samme dataramme): `data <- Raddum2_1(data)`.
* **TIANTL** (TIc) skal måles mellom juli og september. Målinger som ikke oppfyller dette kravet, blir ekskludert (se [`sjekkTIANTL`](sjekkPar.md)). Standardinnstillinga tillater et slingringsmonn på to uker.

