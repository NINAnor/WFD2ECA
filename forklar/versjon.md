# Versjoner av WFD2ECA

GitHub-repositoriet **WFD2ECA** (altså [https://github.com/NINAnor/WFD2ECA](https://github.com/NINAnor/WFD2ECA)) inneholder den nyeste versjonen av koden.
Repositoriet er også arkivert på [Zenodo](https://doi.org/10.5281/zenodo.10278000).
Der har hele repositoriet én DOI (<sub><sub>[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10278000.svg)](https://doi.org/10.5281/zenodo.10278000)</sub></sub>).
Denne er alltid lenka opp mot den nyeste av de arkiverte versjonene.
I tillegg har alle arkiverte versjoner hver sin unike DOI.

_Oversikt over publiserte versjoner:_


## Versjon 2.0
Publiseres i august 2025. _Endringer:_

- Repositoriet er også tilrettelagt for bruk i økologiske tilstandsregnskap.
- Hovedfunksjonen (tidligere `fraVFtilNI`) heter nå `WFD2ECA`.
- Standardinnstillingene til `WFD2ECA` er tilpassa tilstandsregnskap ([detaljer](WFD2ECA.md)).
- Funksjonen `fraVFtilNI` har fortsatt standardinnstillinger tilpassa naturindeks ([detaljer](fraVFtilNI.md)).
- Begge funksjonene tillater nå modelltilpasning av uskalerte måleverdier med `EQR = FALSE`.
- Begge funksjonene skjuler flere beskjeder med `vis = FALSE`.
- Begge funksjonene tillater lagring og lesing av bearbeida data vha. argumentet `utMaaling`.
- Begge funksjonene kan håndtere anadrom elvestatus som typologifaktor vha. argumentet `anadromi`.
- Begge funksjonene fjerner målinger med mEQR < &minus;0,2 eller > 1,2 uten å kræsje.
- Funksjonen `lesMaalinger` leser data og måleenheter fra vannmiljø-API-en ([detaljer](lesMaalinger.md)).
- Funksjonen `lesVannlokaliteter` leser vannlokaliteter fra vannmiljø-API-en ([detaljer](lesVannlokaliteter.md)).
- Funksjonen `lesVannforekomster` gir mer oversiktlige beskjeder ([detaljer](lesVannforekomster.md)).
- Funksjonen `lesInnsjodatabasen` sørger for at innsjøarealer ikke angis som null ([detaljer](lesInnsjodatabasen.md)).
- Funksjonen `oppdaterNImedVF` kan også laste opp kvartiler til naturindeks-basen ([detaljer](oppdaterNImedVF.md)).
- Den nye funksjonen `trunker` er nå tilgjengelig ([detaljer](../R/Funksjon.R)).
- Kolonnenavna i "klassegr*"-filer er endra til "typ/pess/X0/X20/X40/X60/X80/X100/opt" ([detaljer](../klassegrenser/)).
- Klassegrenser for RADDUM1 ble korrigert ([detaljer](../klassegrenser/)).
- Tillatte verdier ble korrigert for flere parametere i regnearket VM-param.xlsx.
- Særnorske tegn er fjerna fra alle variabel- og kolonnenavn.


## Versjoner av NI_vannf

Før versjon 2.0 het GitHub-repositoriet **NI_vannf**. 
Det hadde de følgende versjonene:

### Versjon 1.5
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15276139.svg)](https://doi.org/10.5281/zenodo.15276139)  
Publisert april 2025. _Endringer:_

- Argumentet `beggeEnder` er tilføyd til funksjonen `fraVFtilNI` ([detaljer](fraVFtilNI.md)).
- Argumentet `tidsvekt` i funksjonen `fraVFtilNI` har fått ny definisjon og standardverdi ([detaljer](fraVFtilNI.md)).
- Argumentet `aktivitetsvekt` i funksjonen `fraVFtilNI` har fått ny standardverdi ([detaljer](fraVFtilNI.md)).
- Usikkerheten for vannforekomster med målinger kvantifiseres som *konfidens*intervaller ([detaljer](dataflyt.md)).
- Funksjonen `oppdaterNImedVF` har blitt helt omskrevet ([detaljer](oppdaterNImedVF.md)).
- Definisjonen av vanntypene L108 og L302 ble korrigert ([detaljer](../R/vanntype.R)).
- Klassegrenser for PIT, PPBIOMTOVO og PTI ble korrigert ([detaljer](../klassegrenser/)).


### Versjon 1.4
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.11625234.svg)](https://doi.org/10.5281/zenodo.11625234)  
Publisert juni 2024. _Endringer:_

- Modelleringa benytter en modifisert logit-link ([detaljer](modell.md)).
- Ordinale forklaringsvariabler kan erstattes med numeriske ([detaljer](modell.md)).
- Modelleringa tester interaksjoner med rapporteringsperiode ([detaljer](modell.md)).
- Vannforekomster som er "satt til turbid", forkastes ikke lenger ([detaljer](lesVannforekomster.md)).
- Beskjedene som [funksjonene](funksjon.md) gir underveis, er forbedra.


### Versjon 1.3
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.11274927.svg)](https://doi.org/10.5281/zenodo.11274927)  
Publisert mai 2024. _Endringer:_

- Også elve- og kystvannforekomster vektes nå med sin størrelse ([detaljer](arealvekt.md)).
- Sterkt modifiserte vannforekomster (SMVF) er tilføyd som forklaringsvariabel.
- Før kjøring sikres det at tegnsettet er kompatibelt med datafilene.


### Versjon 1.2
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10809052.svg)](https://doi.org/10.5281/zenodo.10809052)  
Publisert mars 2024. _Endringer:_

- Funksjonen `mEQR` beregnes nå med asymptotisk begrensning ([detaljer](asympEQR.md)).
- Parameterspesifikke krav til målinger blir sjekka ([detaljer](sjekkPar.md)).
- Det ekstrapoleres kun til vanntyper som det foreligger målinger fra ([detaljer](extrapol.md)).
- Vekting for overvåkingsaktiviteter implementeres på en bedre måte ([detaljer](aktiv.md)).
- Flere mindre forbedringer i [funksjoner](../R/) og [forklaringer](../forklar/).


### Versjon 1.1
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10497345.svg)](https://doi.org/10.5281/zenodo.10497345)  
Publisert januar 2024. _Endringer:_

- Funksjonen `oppdaterNImedVF` er tilføyd ([detaljer](oppdaterNImedVF.md)).
- Datafiler for [klassegrenser](../klassegr/) er tilføyd og delvis korrigert.
- Versjonsnummer er nå del av utmatinga av funksjonen `fraVFtilNI` ([detaljer](fraVFtilNI.md#Funksjonsverdi)).
- Filstrukturen er standardisert, og [forklaringene](../forklar/) er utvida.


### Versjon 1.0
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10278001.svg)](https://doi.org/10.5281/zenodo.10278001)  
Publisert desember 2023.
