# Versjoner av WFD2ECA

GitHub-repositoriet **WFD2ECA** (altså [https://github.com/NINAnor/WFD2ECA](https://github.com/NINAnor/WFD2ECA)) inneholder den nyeste versjonen av koden.
Repositoriet er også arkivert på [Zenodo](https://doi.org/10.5281/zenodo.10278000).
Der har hele repositoriet én DOI (<sub><sub>[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10278000.svg)](https://doi.org/10.5281/zenodo.10278000)</sub></sub>).
Denne er alltid lenka opp mot den nyeste av de arkiverte versjonene.
I tillegg har alle arkiverte versjoner hver sin unike DOI.

_Oversikt over publiserte versjoner:_


## Versjon 2.0
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.16811526.svg)](https://doi.org/10.5281/zenodo.16811526)  
Publisert august 2025. _Endringer:_

- Funksjonen `WFD2ECA`, som er tilpassa tilstandsregnskap, er tilføyd ([detaljer](../R/WFD2ECA.md)).
- Argumentet `anadromi` er tilføyd til funksjonene `WFD2ECA` og `fraVFtilNI` ([detaljer](../R/WFD2ECA.md)).
- Argumentet `utMaaling` er tilføyd til funksjonene `WFD2ECA` og `fraVFtilNI` ([detaljer](../R/WFD2ECA.md)).
- Funksjonene `WFD2ECA` og `fraVFtilNI` kan håndtere uskalerte måleverdier med `EQR = FALSE`.
- Funksjonene `WFD2ECA` og `fraVFtilNI` skjuler flere beskjeder med `vis = FALSE` ([detaljer](../R/WFD2ECA.md)).
- Begge funksjonene fjerner målinger med mEQR < &minus;0,2 eller > 1,2 uten å kræsje.
- Det er tilrettelagt dataflyt for seks nye vannforskrifts-parametere ([detaljer](param.md)).
- Målinger og måleenheter leses rett fra vannmiljø-databasens API ([detaljer](lesMaalinger.md)).
- Informasjon om vannlokaliteter leses rett fra vannmiljø-databasens API ([detaljer](lesVannlokaliteter.md)).
- Beskjedene som `lesVannforekomster` gir underveis, er forenkla ([detaljer](lesVannforekomster.md)).
- Det sikres at arealer som hentes fra innsjødatabasen, angis som større enn null ([detaljer](lesInnsjodatabasen.md)).
- Funksjonen `oppdaterNImedVF` kan også laste opp kvartiler til naturindeks-basen ([detaljer](oppdaterNImedVF.md)).
- Funksjonen `trunker` er tilføyd ([detaljer](../R/Funksjon.R)).
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
