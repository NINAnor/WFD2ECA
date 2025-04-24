# Håndtering av ulike vannforskriftsparametere

Funksjonen `fraVFtilNI` forutsetter at informasjon om vannforskriftsparameteren som skal flyttes fra vannforskriften til naturindeksen, er tilgjengelig i en spesifisert form.
Parametrenes klassegrenser må bl.a. foreligge i form av regneark.
På denne sida forklares for hvilke parametere slike regneark er klargjort, og hvordan man kan revidere dem eller klargjøre flere.

-   <a href="#vannforskriftsparametere-som-er-relevante" id="toc-vannforskriftsparametere-som-er-relevante">Vannforskriftsparametere som er relevante</a>
-   <a href="#vannforskriftsparametere-som-er-klare-til-bruk" id="toc-vannforskriftsparametere-som-er-klare-til-bruk">Vannforskriftsparametere som er klare til bruk</a>
-   <a href="#hvordan-flere-vannforskriftsparametere-kan-gjøres-klar-til-bruk" id="toc-hvordan-flere-vannforskriftsparametere-kan-gjøres-klar-til-bruk">Hvordan flere vannforskriftsparametere kan gjøres klar til bruk</a>
-   <a href="#spesielle-krav-til-de-ulike-vannforskriftsparameterne" id="toc-spesielle-krav-til-de-ulike-vannforskriftsparameterne">Spesielle krav til de ulike vannforskriftsparameterne</a>


## Vannforskriftsparametere som er relevante

Eksisterende vannforskriftsparametere er beskrevet i [Direktoratsgruppas klassifiseringsveileder](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), og relevante målinger er samla i [vannmiljø-databasen](https://vannmiljo.miljodirektoratet.no/).
Vannforskriftsparametere som den her beskrevne dataflyten er relevante for, er i første rekke slike som også brukes som indikatorer av naturindeksen ([Sandvik 2019](http://hdl.handle.net/11250/2631056)).
I tillegg kan dataflyten være relevant for vannforskriftsparametere som inngår i et fremtidig økologisk tilstandsregnskap ([Fremstad mfl. 2023](https://hdl.handle.net/11250/3104185)).

I den aktuelle versjonen av [naturindeksen](https://www.naturindeks.no/) (dvs. 2019) er det brukt flere vannforskriftsparametere:

- For ferskvann brukes parametrene **AIP**, **ASPT**, **PIT**, **PTI**, **Raddum 1** og **TIc**. For ASPT og Raddum 1 ble naturindeksen i 2019 basert på den her beskrevne dataflyten. Dataflyten er i prinsippet også tilgjengelig for de øvrige parametrene (se [under](#vannforskriftsparametere-som-er-klare-til-bruk)). 
- For kystvann brukes **MBH**, **NQI1**, klorofyll a (vannmiljø-id **KLFA**), "hardbunn vegetasjon algeindeks" (**RSLA**1&ndash;3 og **RSL**4&ndash;5) og "hardbunn vegetasjon nedre voksegrense" (**MSMDI**). Den her beskrevne dataflyten har ikke blitt brukt på noen av disse, men for de to førstnevnte er den i prinsippet tilgjengelig (se [under](#vannforskriftsparametere-som-er-klare-til-bruk)). 


## Vannforskriftsparametere som er klare til bruk

For tolv vannforskriftsparameterne er dataflyten gjort klar til bruk.
Disse listes her opp med vannmiljø-databasens forkortelse (halvfeit), etterfulgt av fullt navn (kursiv), eventuell annen og bedre kjent forkortelse (halvfeit i parentes) samt vanntype (i parentes).
Parametrenes klassegrenser følger [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/).
Imidlertid er dårligste (nedre eller øvre) grense for svært dårlig tilstand ikke alltid angitt i veilederen, heller ikke minste og største _mulige_ verdi, så disse presenteres under.

* **AIP** &ndash; _forsuringsindeks påvekstalger artssammensetning_ (elver): Nedre (dårligste) grense for svært dårlig tilstand er 5,17 (gjennomsnittet for de tre laveste indeksverdiene), men verdier ned til 5,13 er mulig (laveste indeksverdi for en enkeltart; se [klassifiseringsveileder](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab. V5.1.2). Høyeste (beste) mulige verdi er 7,42 (gjennomsnittet for de tre høyeste indeksverdiene).
* **ASPT** &ndash; _Average Score per Taxon_ (elver): Mulige indeksverdier ligger mellom 1 og 10 ([klassifiseringsveileder](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab. V5.3.3). Ifølge [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/) (tab. 3.11) er ASPTs nullverdi imidlertid lik 0 (mulig tolkning: fravær av bunnfauna), så nedre grense for svært dårlig tilstand og laveste mulige verdi er her satt til 0.
* **ES100** &ndash; _Hurlberts diversitetsindeks marin bløtbunnsfauna_ (**ES<sub>100</sub>**, kystvann): Mulige indeksverdier ligger mellom 0 og 100, om 0 brukes for fravær av bløtbunnsfauna. (OBS: Formelen gitt i [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/) er feil; riktig formel er gitt i [Rygg & Norling 2013](http://hdl.handle.net/11250/216238), s. 9.)
* **HBI2** &ndash; _heterotrof begroingsindeks_ (elver): Mulige tallverdier ligger mellom 0 og 400.
* **ISI** &ndash; _indikatorartsindeks marin bløtbunnsfauna_ (kystvann): Nedre (dårligste) grense for svært dårlig tilstand er i [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/) (tab. 9.22) angitt som 0,00, men indeksen kan ikke blir mindre enn 1,58 (laveste indeksverdi for en enkeltart), så laveste mulige verdi er her satt til 1,58. Høyeste (beste) mulige verdi er 37,65 (høyeste indeksverdi for en enkeltart).
* **MBH** &ndash; _Shannon-Wiener diversitetsindeks_ (**H'**, kystvann): Den høyeste referanseverdien er 6,3 ([klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab. 9.22). Siden det ikke fins noen naturlig maksimumsverdi, er den øvre grensa her vilkårlig satt til 7,3 (som tilsvarer det dobbelte [158 arter] av den høyeste referanseverdien [79 arter], gitt maksimal diversitet, dvs. at alle arter er representert med ett individ hver). Laveste (dårligste) mulige verdi er 0,0 (alle individer i prøven tilhører én art). (OBS: formelen for H' som er gitt i [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), mangler et minustegn foran &Sigma;.)
* **NQI1** &ndash; _norsk kvalitetsindeks marin bløtbunnsfauna_ (kystvann): I [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/) er det oppgitt at "NQI1 kan ha verdier mellom 0 og 1". Derfor brukes det her 0 som laveste og 1 som høyeste mulige verdi &ndash; selv om opplysningene gitt samme sted tilsier at NQI1 ikke kan bli mindre enn 0,07 (men se [Borja mfl. 2000](https://doi.org/10.1016/S0025-326X(00)00061-8)), og selv om NQI1 teoretisk kan bli større enn 1 (men slike verdier er åpenbart aldri målt og urealistisk å få i Norge).
* **PIT** &ndash; _trofiindeks påvekstalger artssammensetning_ (elver): Øvre (dårligste) grense for svært dårlig tilstand er 60,84 (gjennomsnittet for de to høyeste indeksverdiene), men verdier opp til 68,91 er mulig (høyeste indeksverdi for en enkeltart; se [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab. V5.1.1). Laveste (beste) mulige verdi er 1,92 (gjennomsnittet for de to laveste indeksverdiene).
* **PPBIOMTOVO** &ndash; _total biomasse planteplankton per volumenhet_ (innsjøer): Den høyeste øvre (dårligste) grensa for svært dårlig tilstand er 7&nbsp;mg/l ([klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab. 4.2). Siden det ikke fins noen naturlig maksimumsverdi, er den øvre grensa her vilkårlig satt til 140&nbsp;mg/l (som tilsvarer det 20-dobbelte av den høyeste grensa for svært dårlig tilstand). Laveste mulige verdi er 0&nbsp;mg/l.
* **PPTI** &ndash; _planteplankton trofiindeks_ (**PTI**, innsjøer): Øvre (dårligste) grense for svært dårlig tilstand er 4,00 ([klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab. 4.2), men verdier opp til 4,99 er mulig (høyeste indeksverdi for en enkeltart; se [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab. V4.1.1). Laveste (beste) mulige verdi er 1,16 (laveste indeksverdi for en enkeltart).
* **RADDUM1** &ndash; _Raddum forsuringsindeks I_ (elver og innsjøer): Indeksen har ikke noen definert referanseverdi. En enkelt måling med indeksverdi 1 oversettes til god tilstand. Kun hvis et gjennomsnitt av minimum 2 prøver har verdien 1, oversettes dette til svært god tilstand ([klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), tab. 4.10a).
* **TIANTL** &ndash; _trofiindeks makrofytter antall arter innsjø_ (**TIc**, innsjøer): Mulige tallverdier ligger mellom &minus;100 og +100. (OBS: Per 2023 var hele 21&nbsp;% av datapunktene i vannmiljø-databasen større enn 100, hadde altså ugyldige verdier.)

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

Gyldige klassegrenser forutsetter at klassegrensene er **mindre enn** naboverdien, _enten_ lest fra venstre til høyre (hvis tilstanden er bedre jo _høyere_ måleverdien er) _eller_ lest fra høyre til venstre (hvis tilstanden er bedre jo _lavere_ måleverdien er); minste og største mulige verdi (ytterpunktene) kan også være **lik** sine naboverdier.
Hvis denne forutsettelsen ikke er oppfylt, vil det føre til feilmeldinger.
Manglende verdier (`NA`) er ikke tillatt i noen av cellene.

Enkelte parametere har ingen fysisk øvre grense.
I slike tilfeller bør den aktuelle verdien (dvs. "max" eller "min") settes vilkårlig til en tallverdi som er så mye større enn den respektive klassegrensen (dvs. "SG_øvre" eller "SD_nedre") at den inkluderer alle realistiske måleverdier (f.eks. det dobbelte artstallet for diversitetsindekser).


## Spesielle krav til de ulike vannforskriftsparameterne

Funksjonen `fraVFtilNI` sjekker om målinger som er rapportert i vannmiljø-databasen, inneholder åpenbare måle- eller rapporteringsfeil (dvs. verdier som er uforenlige med parameterens definisjon). 
I tillegg eksisterer imidlertid spesifikke krav til de fleste vannforskriftsparameterne. 
Noen av disse kravene, men ikke alle, blir kontrollert av funksjonen `fraVFtilNI` (nærmere bestemt av hjelpefunksjonene [`sjekkXXX`](sjekkPar.md)).
Nedenfor gis en liste over foreliggende krav og hvilke av disse som blir kontrollert (der lista over foreliggende krav ikke nødvendigvis er uttømmende).

* **AIP** skal måles mellom juni og oktober. Målinger som ikke oppfyller dette kravet, blir ekskludert (se [`sjekkAIP`](sjekkPar.md)). Standardinnstillinga tillater et slingringsmonn på to uker. Hver AIP-måling bør dessuten være basert på minst tre arter. Dette kravet blir _ikke_ sjekket, siden antall arter som en AIP-verdi er basert på, ikke fremgår av vannmiljø-databasen.
* **ASPT** skal ikke brukes for breelver. Målinger som ikke oppfyller dette kravet, blir ekskludert (se [`sjekkASPT`](sjekkPar.md)).
* **HBI2** skal baseres på minst to målinger per år, der den første er tatt på våren (januar–april) og den andre på høsten (oktober–desember). Målinger som ikke oppfyller dette kravet, blir ekskludert (se [`sjekkHBI2`](sjekkPar.md)).
* **PIT** skal måles mellom juni og oktober. Målinger som ikke oppfyller dette kravet, blir ekskludert (se [`sjekkPIT`](sjekkPar.md)). Standardinnstillinga tillater et slingringsmonn på to uker. Hver PIT-måling bør dessuten være basert på minst to arter. Dette kravet blir _ikke_ sjekket, siden antall arter som en PIT-verdi er basert på, ikke fremgår av vannmiljø-databasen.
* **PPBIOMTOVO** skal baseres på minst månedlige prøver gjennom hele vekstsesongen. Målinger som ikke oppfyller dette kravet, blir ekskludert (se [`sjekkPPBIOMTOVO`](sjekkPar.md)). Standardinnstillinga er som for PTI.
* **PPTI** (PTI) skal baseres på minst månedlige prøver gjennom hele vekstsesongen. Målinger som ikke oppfyller dette kravet, blir ekskludert (se [`sjekkPPBIOMTOVO`](sjekkPar.md)). Standardinnstillinga er å anta at vekstsesongen varer fra mai til oktober, og å kreve at det er tatt minst fire målinger i løpet av denne perioden i Sør-Norge under 200 moh. og minst tre målinger i resten av Norge (dvs. å tillate at det mangler målinger fra noen av månedene).
* **RADDUM1** (Raddum I) skal kun brukes i klare vannforekomster (humøsitet = 1). Målinger som ikke oppfyller dette kravet, blir ekskludert (se [`sjekkRADDUM1`](sjekkPar.md)). Merk at kun Raddum I inngår i naturindeksen, mens Raddum II ikke gjør det. Raddum&nbsp;II-målinger er imidlertid enkelt å regne om til Raddum&nbsp;I-verdier. Dermed kan datagrunnlaget utvides betraktelig (men _bare for elver_, siden Raddum II ikke er definert for innsjøer). Dette kan gjøres ved hjelp av funksjonen [`Raddum2_1`](../R/Funksjon.R), f.eks. slik (når det foreligger én dataramme hver for målinger av Raddum I og Raddum II): `data_Raddum1 <- rbind(data_Raddum1, Raddum2_1(data_Raddum2))`; eller slik (når alle målinger er i samme dataramme): `data <- Raddum2_1(data)`.
* **TIANTL** (TIc) skal måles mellom juli og september. Målinger som ikke oppfyller dette kravet, blir ekskludert (se [`sjekkAIP`](sjekkPar.md)). Standardinnstillinga tillater et slingringsmonn på to uker.

