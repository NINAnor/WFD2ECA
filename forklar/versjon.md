# Versjoner av NI_vannf

GitHub-repositoriet **NI_vannf** (altså [https://github.com/NINAnor/NI_vannf](https://github.com/NINAnor/NI_vannf)) inneholder den nyeste versjonen av koden.
Repositoriet er også arkivert på [Zenodo](https://doi.org/10.5281/zenodo.10278000).
Der har hele repositoriet én DOI (<sub><sub>[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10278000.svg)](https://doi.org/10.5281/zenodo.10278000)</sub></sub>).
Denne er alltid lenka opp mot den nyeste av de arkiverte versjonene.
I tillegg har alle arkiverte versjoner hver sin unike DOI.

_Oversikt over publiserte versjoner:_


## Versjon 1.2
Publiseres mars 2024. _Endringer:_

- Funksjonen `mEQR` beregnes nå med asymptotisk begrensning ([detaljer](asympEQR.md)).
- Parameterspesifikke krav til målinger blir sjekka ([detaljer](sjekkPar.md)).
- Det ekstrapoleres kun til vanntyper som det foreligger målinger fra ([detaljer](extrapol.md)).
- Vekting for overvåkingsaktiviteter implementeres på en bedre måte ([detaljer](aktiv.md)).
- Flere mindre forbedringer i [funksjoner](../R/) og [forklaringer](../forklar/).


## Versjon 1.1
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10497345.svg)](https://doi.org/10.5281/zenodo.10497345)  
Publisert januar 2024. _Endringer:_

- Funksjonen `oppdaterNImedVF` er tilføyd ([detaljer](oppdaterNImedVF.md)).
- Datafiler for [klassegrenser](../klassegr/) er tilføyd og delvis korrigert.
- Versjonsnummer er nå del av utmatinga av funksjonen `fraVFtilNI` ([detaljer](fraVFtilNI.md#Funksjonsverdi)).
- Filstrukturen er standardisert, og [forklaringene](../forklar/) er utvida.


## Versjon 1.0
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10278001.svg)](https://doi.org/10.5281/zenodo.10278001)  
Publisert desember 2023.
