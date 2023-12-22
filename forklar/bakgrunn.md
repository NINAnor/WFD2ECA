# Bakgrunn

Her forklares bakgrunnen for "automatisert dataflyt fra vannforskriften til naturindeks" (basert på tekst klippa fra [Sandvik 2019](http://hdl.handle.net/11250/2631056)):

Med [naturindeksen](https://www.naturindeks.no/) og [vannforskriften](https://lovdata.no/dokument/SF/forskrift/2006-12-15-1446) (jf. [klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/)) har Norge to rammeverk som rapporterer tilstanden for ferskvanns- og kystvannsystemer.
Naturindeksen har tatt i bruk flere ferskvanns- og kystvannsindikatorer som også inngår i vannforskriften ([Schartau mfl. 2016](http://hdl.handle.net/11250/2384734)).
Det bør være et mål at disse indikatorene gir mest mulig sammenfallende beskrivelser i begge rammeverkene. 
Basert på tidligere analyser og anbefalinger om samordning ([Schartau mfl. 2016](http://hdl.handle.net/11250/2384734), [Gundersen mfl. 2018](http://hdl.handle.net/11250/2584222)) har Sandvik ([2019](http://hdl.handle.net/11250/2631056)) beskrevet en dataflyt av data som er samla inn i sammenheng med vannforskriften, til naturindeks.
Dette omfatter også en geografisk oppskalering fra vannforskriftens punktobservasjoner til større administrative enheter som kommuner og fylker.
Denne beskrivelsen av dataflyt ([se sammendraget](dataflyt.md)) ligger til grunn for **R**-koden som er publisert her.

En viktig forutsetning for dataflyt er oppfylt i og med at indikatorene i både vannforskriften og naturindeks er skalert fra 0 til 1, der 1 er referanseverdien.
Vannforskriften oppnår dette gjennom å beregne **nEQR**-verdier (_normaliserte økologiske kvalitetskvotienter_) ved å trunkere, skalere og normalisere indikatorenes måleverdier ([klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), kap. 3.5).
For å ta vare på hele variasjonen i de tilgjengelige dataene, er det imidlertid viktig å utveksle data mellom vannforskrift og naturindeks _før_ dataene blir trunkert. 
De _skalerte_ og _normaliserte_, men _ikke-trunkerte_ indeksverdiene blir her omtalt som **mEQR**-verdier (_modifiserte økologiske kvalitetskvotienter_; [Sandvik 2019](http://hdl.handle.net/11250/2631056), kap. 2.3).

For å kunne oppskalere fra punktmåling til større geografiske områder brukes her en tilnærming med modellering av målingene (på mEQR-skala) og ekstrapolering til vannforekomster som ikke er målt. 
Modelleringa er basert på modellseleksjon av lineære modeller som inkluderer tid (år), typologifaktorer og overvåkingsaktiviteter som forklaringsvariabler for måleverdiene. 
Typologifaktorer omfatter vannforekomstenes klimasone, størrelse, alkalitet, humusinnhold og lignende ([klassifiseringsveileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/), kap. 3.3 og 3.4). 
Disse samvarierer ofte systematisk med indikatorverdiene og må derfor tas høyde for.

Hver vannmåling som registreres i vannforskriftsammenheng, er knytta til nøyaktig én overvåkingsaktivitet, som definerer målingens forvaltningsmessige formål (se [vannmiljø](https://vannmiljokoder.miljodirektoratet.no/activity)). 
De fleste aktiviteter har andre formål enn å gi et representativt bilde av hovedøkosystemets samla tilstand, men iverksettes f.eks. nettopp fordi vannforekomstene har en antatt eller påvist dårlig tilstand (bl.a. forsurings- eller forurensningsovervåking). 
Dette medfører at målinger med dårlig tilstand må antas å være overrepresentert i datamaterialet som er samla inn i vannforskriftsammenheng. 
Det er derfor foreslått en metode for å vekte de ulike overvåkingsaktivitetene for deres representativitet, for på denne måten å kunne korrigere for noe av skjevheten som ligger i datamaterialet ([Sandvik 2019](http://hdl.handle.net/11250/2631056), kap. 2.5).

Ekstrapolering til vannforekomster som det ikke foreligger målinger fra, bør skje i form av prediksjon basert på den beste modellen. 
Usikkerheten kan angis i form av prediksjonsintervaller basert på simuleringer. 
Oppskaleringas siste trinn er å aggregere de målte eller predikerte verdiene for alle relevante vannforekomster ved å ta et gjennomsnitt, som kan være uvekta eller vekta. 
Det foreslås å vekte for vannforekomstenes størrelse, noe som så langt kun er implementert for innsjøvannforekomster. 
Når målet er at alle størrelsesklasser skal bidra noenlunde likt til gjennomsnittet, er løsninga å vekte verdiene for de respektive innsjøvannforekomstenes overflateareal ([Sandvik 2019](http://hdl.handle.net/11250/2631056), kap. 3.2).




