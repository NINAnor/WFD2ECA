# Oversikt over og endring av hjelpefiler

I mappa [data](../data/) ligger en rekke hjelpefiler som må være til
stede for at [**R**-funksjonene](funksjon.md) fungerer som de skal. Her
forklares hjelpefilenes betydning og hvordan de eventuelt kan endres, i
tilfelle det er nødvendig å oppdatere dem.

-   <a href="#vannforekomster-v-.csv-navnvn.csv"
    id="toc-vannforekomster-v-.csv-navnvn.csv">Vannforekomster (V-*.csv,
    navnVN.csv)</a>
-   <a href="#vannlokaliteter-vl-.xlsx-navnvl.csv"
    id="toc-vannlokaliteter-vl-.xlsx-navnvl.csv">Vannlokaliteter (VL-*.xlsx,
    navnVL.csv)</a>
-   <a href="#innsjødatabasen-navnnvel.csv"
    id="toc-innsjødatabasen-navnnvel.csv">Innsjødatabasen (navnNVEl.csv)</a>
-   <a href="#vannmiljø-data-navnvm.csv"
    id="toc-vannmiljø-data-navnvm.csv">Vannmiljø-data (navnVM.csv)</a>
-   <a href="#vannforskriftsparametere-vm-param.xlsx"
    id="toc-vannforskriftsparametere-vm-param.xlsx">Vannforskriftsparametere
    (VM-param.xlsx)</a>
-   <a href="#måleenheter-vm-enhet.xlsx"
    id="toc-måleenheter-vm-enhet.xlsx">Måleenheter (VM-enhet.xlsx)</a>
-   <a href="#overvåkingsaktiviteter-vm-aktiv.xlsx"
    id="toc-overvåkingsaktiviteter-vm-aktiv.xlsx">Overvåkingsaktiviteter
    (VM-aktiv.xlsx)</a>
-   <a href="#fylker-fnr.xlsx" id="toc-fylker-fnr.xlsx">Fylker
    (fnr.xlsx)</a>
-   <a href="#kommuner-knr.xlsx" id="toc-kommuner-knr.xlsx">Kommuner
    (knr.xlsx)</a>

## Vannforekomster (V-\*.csv, navnVN.csv)

Før kjøring av analyser bør aktuelle filer over vannforekomster lastes
ned fra [vann-nett](https://vann-nett.no/portal/) ([se detaljert
forklaring](lesVannforekomster.md)). Filene er tabulatordelte tekstfiler
med filendelsen “.csv”. Filnavnene på disse filene må endres til
“**V-**” etterfulgt av “**C**”, “**L**” eller “**R**” for henholdsvis
kyst-, innsjø- og elvevannforekomster.

For tolkning av filkolonnene trengs det en oversettelsesfil. Fila heter
“[navnVN.csv](../data/navnVN.csv)” og er en tabulatordelt tekstfil med
fire kolonner. Fila bør bare endres hvis funksjonen
[`lesVannforekomster`](lesVannforekomster.md) genererer feilmeldinger
som antyder at filene som er eksportert fra vann-nett, har endra
kolonnenavn. I så fall må kolonnene “L”, “R” eller “C” av “navnVN.csv”
oppdateres i samsvar med kolonnenavnene i vann-nett-eksporten. Kolonnen
“nytt” må *ikke* endres (med ett eneste unntak: Om vann-nett-eksporten
har nye kolonner, som ikke tidligere har vært med, må disse fylles med
unike, men ellers vilkårlige tegnkombinasjoner også i kolonnen “nytt”,
f.eks. med “n” etterfulgt av et tall).

## Vannlokaliteter (VL-\*.xlsx, navnVL.csv)

Før kjøring av analyser bør aktuelle filer over vannlokaliteter lastes
ned fra [vannmiljø](https://vannmiljo.miljodirektoratet.no/)-databasen
([se detaljert forklaring](lesVannlokaliteter.md)). Filene er
excel-regneark med filendelsen “.xlsx”. Filnavnene på disse filene må
endres til “**VL-**” etterfulgt av “**C**”, “**L**” eller “**R**” for
henholdsvis kyst-, innsjø- og elvevannforekomster.

For tolkning av filkolonnene trengs det en oversettelsesfil. Fila heter
“[navnVL.csv](../data/navnVL.csv)” og er en tabulatordelt tekstfil med
to kolonner. Fila bør bare endres hvis funksjonen
[`lesVannlokaliteter`](lesVannlokaliteter.md) genererer feilmeldinger
som antyder at filene som er eksportert fra vannmiljø-databasen, har
endra kolonnenavn. I så fall må kolonnen “VL” av “navnVL.csv” oppdateres
i samsvar med kolonnenavnene i vannmiljø-eksporten. Kolonnen “nytt” må
*ikke* endres (med ett eneste unntak: Om vannmiljø-eksporten har nye
kolonner, som ikke tidligere har vært med, må disse fylles med unike,
men ellers vilkårlige tegnkombinasjoner også i kolonnen “nytt”, f.eks.
med “n” etterfulgt av et tall).

## Innsjødatabasen (navnNVEl.csv)

Før innsjødata analyseres, bør aktuelle filer over innsjøer lastes ned
fra [NVEs
innsjødatabase](https://www.nve.no/kart/kartdata/vassdragsdata/innsjodatabase/)
([se detaljert forklaring](lesInnsjodatabasen.md)). Filene er en pakke
med formfiler med bl.a. filendelsene “.dbf” og “.shp”. Filnavnet på
dbf-fila må angis som argument `filnavn` for funksjonen
[`lesInnsjodatabasen.md`](lesInnsjodatabasen.md), f.eks. slik:
`lesInnsjodatabasen(filnavn = "Innsjo_Innsjo.dbf")`.

For tolkning av filkolonnene trengs det en oversettelsesfil. Fila heter
“[navnNVEl.csv](../data/navnNVEl.csv)” og er en tabulatordelt tekstfil
med to kolonner. Fila bør bare endres hvis funksjonen
`lesInnsjodatabasen` genererer feilmeldinger som antyder at filene som
er eksportert fra innsjødatabasen, har endra kolonnenavn. I så fall må
kolonnen “NVE” av “navnNVEl.csv” oppdateres i samsvar med kolonnenavnene
i NVE-eksporten. Kolonnen “nytt” må *ikke* endres (med ett eneste
unntak: Om NVE-eksporten har nye kolonner, som ikke tidligere har vært
med, må disse fylles med unike, men ellers vilkårlige tegnkombinasjoner
også i kolonnen “nytt”, f.eks. med “n” etterfulgt av et tall).

## Vannmiljø-data (navnVM.csv)

Målingene som ønskes analysert, må lastes ned fra
[vannmiljø](https://vannmiljo.miljodirektoratet.no/)-databasen ([se
detaljert forklaring](lesMaalinger.md)). Filen er et excel-regneark med
filendelsen “.xlsx”. Filen kan få et valgfritt navn (f.eks. 
parameterforkortelsen), som må angis som argument `filnavn` for funksjonen
[`lesMaalinger.md`](lesMaalinger.md), f.eks. slik:
`lesMaalinger(filnavn = "ASPT.xlsx")`.

For tolkning av filkolonnene trengs det en oversettelsesfil. Fila heter
“[navnVM.csv](../data/navnVM.csv)” og er en tabulatordelt tekstfil med
to kolonner. Fila bør bare endres hvis funksjonen
[`lesMaalinger`](lesMaalinger.md) genererer feilmeldinger som antyder at
filene som er eksportert fra vannmiljø-databasen, har endra kolonnenavn.
I så fall må kolonnen “vm” av “navnVM.csv” oppdateres i samsvar med
kolonnenavnene i vannmiljø-eksporten. Kolonnen “nytt” må *ikke* endres
(med ett eneste unntak: Om vannmiljø-eksporten har nye kolonner, som
ikke tidligere har vært med, må disse fylles med unike, men ellers
vilkårlige tegnkombinasjoner også i kolonnen “nytt”, f.eks. med “n”
etterfulgt av et tall).

## Vannforskriftsparametere (VM-param.xlsx)

Tilgjengelige vannforskriftsparametere er samla i excel-regnearket
[VM-param.xlsx](../data/VM-param.xlsx). Om det er behov for å oppdatere
eller endre denne, bør man følge [en spesifikk
mal](param.md#hvordan-flere-vannforskriftsparametere-kan-gjøres-klar-til-bruk).

## Måleenheter (VM-enhet.xlsx)

Tilgjengelige måleenheter er samla i excel-regnearket
[VM-enhet.xlsx](../data/VM-enhet.xlsx). Den kan endres etter behov.

## Overvåkingsaktiviteter (VM-aktiv.xlsx)

Tilgjengelige overvåkingsaktiviteter er samla i excel-regnearket
[VM-aktiv.xlsx](../data/VM-aktiv.xlsx). Om det er behov for å oppdatere
eller endre denne, bør man følge [en spesifikk mal](aktiv.md).

## Fylker (fnr.xlsx)

For tilordning av vannforekomster til fylker trengs en oversikt over
fylkeshistorikken. Denne fila heter [fnr.xlsx](../data/fnr.xlsx) og er
et excel-regneark med fire kolonner, der `nr` er fylkesnummeret, `navn`
er fylkets navn, og `fra` og `til` angir årstallene for fylkets
eksistens. Det må være én rad per fylkesnummer, selv om fylkesnavnet er
identisk. For eksisterende fylker er `til` vilkårlig satt til årstallet
`9999`. Radene er sortert etter fylkesnummer, men rekkefølgen er ellers
uten betydning.

## Kommuner (knr.xlsx)

For tilordning av vannforekomster til kommuner trengs en oversikt over
kommunehistorikken. Denne fila heter [knr.xlsx](../data/knr.xlsx) og er
et excel-regneark. I skrivende stund har regnearket 18 kolonner. De tre
første inneholder *kommunenummeret* (`Nummer`), *status* (`Status`:
“Utgått”, “Gyldig” eller “Sendt inn”) og det offisielle *navnet* som er
eller har vært knytta til dette kommunenummeret (`Navn`). Deretter følger
et antall kolonner som har årstall som kolonnenavn. Det må lages en slik
kolonne for hvert år med kommunesammenslåinger eller -oppløsninger.
Navnene i disse kolonnene skal tilsvare navnet den daværende kommunen
hadde (eller navnet på kommunen den tidligere kommunen hørte til)
i det aktuelle året. Den siste kolonnen inneholder alternative
offisielle navn (f.eks. norske navn for samiske kommuner og motsatt).
Radene er sortert etter kommunenummer, men rekkefølgen er ellers uten
betydning.
