# Spesielle krav til de ulike vannforskriftsparamterne

Funksjonen `fraVFtilNI` sjekker om målinger som er rapporter i vannmiljø-databasen inneholder åpenbare måle- eller rapporteringsfeil (dvs. verdier som er uforenlige med parameterens definisjon). 
I tillegg eksisterer imidlertid spesifikke krav til de fleste vannforskriftsparameterne. 
Om disse har vært oppfylt ved måling eller rapportering, er vanskeligere å teste, og funksjonen `fraVFtilNI` gjør ikke noe forsøk på å oppdage slike feil.
Nedenfor gis en liste over kjente krav og hvordan man eventuelt kan korrigere for at disse ikke er oppfylt.
Merk at lista mest sannsynlig ikke er uttømmende.


## AIP

AIP () skal måles mellom juni og oktober.
Hver måling bør dessuten være basert på minst tre arter.


## HBI2

HBI2 () skal baseres på minst to målinger per år, der den første er tatt på våren (januar–april) og den andre på høsten (oktober–desember).


## PIT

PIT () skal måles mellom juni og oktober.
Hver måling bør dessuten være basert på minst to arter.


## PTI

PTI () skal baseres på minst månedlige prøver gjennom hele vekstsesongen.

Det samme gjelder for andre parametere for kvalitetselementet alger (f.eks. KLFA, CYANOM).


## Raddum

Raddum-indikatorene I og II () har ikke definierte terskelverdier for (svært) humøse vannforekomster. 
Videre har ikke Raddum I definerte terskelverdier for (moderat) kalkrike innsjøer, mens Raddum II _bare_ har definerte terskelverdier for elver.

Merk at Raddum II ikke ... 

Raddum II-målinger er imidlertid enkelt å regne om til Raddum I-verdier. Dette kan gjøres ved hjelp av funksjonen `Raddum2_1`.


## SIc, TIc, WIc

SIc (), TIc () og WIc () skal måles mellom juli og september.

