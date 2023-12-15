# Spesielle krav til de ulike vannforskriftsparameterne

Funksjonen `fraVFtilNI` sjekker om målinger som er rapporter i vannmiljø-databasen inneholder åpenbare måle- eller rapporteringsfeil (dvs. verdier som er uforenlige med parameterens definisjon). 
I tillegg eksisterer imidlertid spesifikke krav til de fleste vannforskriftsparameterne. 
Om disse har vært oppfylt ved måling eller rapportering, er vanskeligere å teste, og funksjonen `fraVFtilNI` gjør ikke noe forsøk på å oppdage slike feil.
Nedenfor gis en liste over kjente krav og hvordan man eventuelt kan korrigere for at disse ikke er oppfylt.
Merk at lista mest sannsynlig ikke er uttømmende.

-   <a href="#aip" id="toc-aip">AIP</a>
-   <a href="#hbi2" id="toc-hbi2">HBI2</a>
-   <a href="#pit" id="toc-pit">PIT</a>
-   <a href="#pti" id="toc-pti">PTI</a>
-   <a href="#raddum" id="toc-raddum">Raddum</a>
-   <a href="#sic-tic-wic" id="toc-sic-tic-wic">SIc, TIc, WIc</a>


## AIP

AIP (forsuringsindeks påvekstalger artssammensetning) skal måles mellom juni og oktober.
Målinger som eventuelt ikke oppfyller kravet om tidspunkt, bør fjernes manuelt ved hjelp av datoen for målinga, før de resterende målingene brukes som innmating til funksjonen `fraVFtilNI`.

Hver måling bør dessuten være basert på minst tre arter.
Antall arter som en AIP-verdi er basert på, fremgår imidlertid ikke av vannmiljø-databasen.


## HBI2

HBI2 (heterotrof begroingsindeks) skal baseres på minst to målinger per år, der den første er tatt på våren (januar–april) og den andre på høsten (oktober–desember). 
Datapunkt som eventuelt ikke oppfyller kravet om antall målinger og deres tidspunkt, bør fjernes manuelt ved hjelp av datoen for målinga, før målingene brukes som innmating til funksjonen `fraVFtilNI`.


## PIT

PIT (trofiindeks påvekstalger artssammensetning) skal måles mellom juni og oktober.
Målinger som eventuelt ikke oppfyller kravet om tidspunkt, bør fjernes manuelt ved hjelp av datoen for målinga, før de resterende målingene brukes som innmating til funksjonen `fraVFtilNI`.

Hver måling bør dessuten være basert på minst to arter.
Antall arter som en PIT-verdi er basert på, fremgår imidlertid ikke av vannmiljø-databasen.


## PTI

PTI (planteplankton trofiindeks, vannmiljø-id "PPTI") skal baseres på minst månedlige prøver gjennom hele vekstsesongen. 
Det samme gjelder for andre parametere for kvalitetselementet planteplankton (f.eks. KLFA, CYANOM).
Datapunkt som eventuelt ikke oppfyller kravet om antall målinger og deres tidspunkt, bør fjernes manuelt ved hjelp av datoen for målinga, før målingene brukes som innmating til funksjonen `fraVFtilNI`.


## Raddum

Raddum-indikatorene I og II (Raddum forsuringsindeks 1 og 2, vannmiljø-id "RADDUM1" og "RADDUM2") har ikke definierte terskelverdier for (svært) humøse vannforekomster. 
Videre har ikke Raddum I definerte terskelverdier for (moderat) kalkrike innsjøer, mens Raddum II _bare_ har definerte terskelverdier for elver.

Merk at kun Raddum I og ikke Raddum II inngår i naturindeksen.
Raddum II-målinger er imidlertid enkelt å regne om til Raddum I-verdier.
Dette kan gjøres ved hjelp av funksjonen `Raddum2_1`:

    DATA.sik <- DATA  # ta eventuelt bækkøpp av datafila, siden Raddum I ikke kan regnes om til Raddum II
    DATA <- Raddum2_1(DATA)
    utmating_Raddum <- fraVFtilNI(DATA, vannforekomster = V, vannlokaliteter = VL,
                                  parameter = "RADDUM1", vannkategori = "R")

Utmatinga vil opplyse om hvor mange Raddum-II-målinger som har blitt regna om til Raddum I.


## SIc, TIc, WIc

SIc (forsuringsindeks makrofytter antall arter innsjø, vannmiljø-id "SIANTL"), TIc (trofiindeks makrofytter antall arter innsjø, vannmiljø-id "TIANTL") og WIc (vannstandsindeks makrofytter, vannmiljø-id "WIANTL") skal måles mellom juli og september.
Målinger som eventuelt ikke oppfyller kravet om tidspunkt, bør fjernes manuelt ved hjelp av datoen for målinga, før de resterende målingene brukes som innmating til funksjonen `fraVFtilNI`.



