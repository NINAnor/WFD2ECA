# Modelltilpasning

Funksjonen [`fraVFtilNI`](fraVFtilNI.md) ekstrapolerer [mEQR-verdier](mEQR.md) til vannforekomster som det ikke foreligger målinger fra.
Denne [ekstrapoleringa](extrapol.md) er basert på en modell som blir tilpassa til de foreliggende målingene.
Modelltilpasninga gjøres slik:


## Modelltype

Modellen som tilpasses, er en lineær regresjon (**R**-funksjon `lm`).


## Avhengig variabel

Den avhengige variabelen, som er den valgte [vannforskriftsparameteren](param.md), transformeres før modelleringa.
Transformeringa består av to ulike trinn:

* Vannforskriftsparameteren gjøres om til [mEQR-verdier](mEQR.md). Det betyr at nullverdien (dårligste klassegrense for svært dårlig tilstand) tilsvarer 0, og at referanseverdien (beste klassegrense for svært god tilstand) tilsvarer 1, men uten at overskytende verdier blir trunkert. [Måten det gjøres på](asympEQR.md), styres av funksjonsargumentet `EQR`, men standardinnstillinga bør vanligvis ikke endres.
* For selve modelltilpasninga blir mEQR-verdiene i tillegg [logit-transformert](https://en.wikipedia.org/wiki/Logit). Siden mEQR-verdier kan bli mindre enn 0 og større enn 1, benyttes det en tilpassa logit-funksjon ([se funksjonene `skaler` og `reskaler`](../R/Funksjon.R)). Logit-transformeringa kan slås av ved å sette funksjonasrgumentet `logit = FALSE`, men standardinnstillinga bør vanligvis ikke endres. (Logit-transformeringa var ikke del av den [opprinnelige metodebeskrivelsen](http://hdl.handle.net/11250/2631056) og ble først implementert fra og med versjon 1.4. Ved å slå den av, kan man gjenskape utmatinga fra tidligere versjoner. Problemet med manglende logit-transformering er bl.a. at ekstrapolerte verdier kan bli vesentlig mye større enn 1 eller mindre enn 0.)

I modellstrukturen er den avhengige variabelen forkorta som "vrd" (for [måle-]"verdi").


## Forklaringsvariabler

De følgende variablene inkluderes eller testes ut som forklaringsvariabler i modellen:

* rapporteringsperiode (forkorta som "per"), som er minste av årstallene gitt ved funksjonsargumentet `NI.aar` som er lik eller større enn året for en gitt måling 
* "relativt år" (forkorta som "rar"), dvs. antall år en gitt måling er tatt før det nærmeste etterfølgende rapporteringsåret
* [overvåkingsaktivitet](aktiv.md) (forkorta som "akt")
* sterkt modifisert vannforekomst (forkorta som "smvf")
* typologifaktorer, slik de er definert i [veileder 02:2018](https://www.vannportalen.no/veiledere/klassifiseringsveileder/) (kap. 3.3 og 3.4). Disse testes først som kategoriske variabler (nominal eller ordinal), men de ordinale testes (fra og med versjon 1.4) også som kontinuerlige variabler, enten ved at at trinnene erstattes med sine respektive gjennomsnittsverdier, eller ved at det brukes faktiske verdier for de enkelte vannforekomster (det siste er kun tilgjengelig for geografisk bredde, høyde over havet og innsjøareal). Kategoriske variabler er forkorta med tre bokstaver og kontinuerlige variabler med fem bokstaver som følger:
  * "reg"/"gbred" for [øko]region / geografisk bredde,
  * "son"/"høyde" for [høyde]sone / høyde over havet,
  * "stø"/"areal" for størrelse / innsjøareal,
  * "stø"/"tilsf" for størrelse / elvers tilsigsfelt,
  * "alk"/"CaCO3" for alkalitet / kalkinnhold,
  * "hum"/"P_tot" for humøsitet / totalfosfor,
  * "tur" for turbiditet,
  * "dyp"/"dybde" for dybde,
  * "kys"/"kystt" for kysttype,
  * "sal"/"saltk" for salinitet,
  * "tid" for tidevann,
  * "eks"/"ekspo" for eksponering,
  * "mix"/"miksg" for miksing,
  * "opp"/"oppht" for oppholdstid,
  * "str"/"vknop" for strøm

Noen av variablene er kun tilgjengelig for enkelte vanntyper (f.eks. de sju siste kun for kyst).


## Interaksjoner

Det testes (fra og med versjon 1.4) for interaksjoner mellom de ulike variablene og rapporteringsperiode.
Om man ønsker en modell uten interaksjoner, kan dette spesisiferes ved å sette funksjonsargumentet `interaksjon = FALSE`.
Interaksjonen mellom rapporteringsperiode og relativt år inkluderes uansett.


## Vekting

Hver observasjon i modellen vektes med ...


## Modellseleksjon

Modellseleksjonen begynner med en full modell, dvs. en modell som inkluderer alle relevante forklaringsvariabler, inkludert interaksjonen mellom rapporteringsperiode og relativt år. 
Deretter testes de følgende modifikasjonene av startmodellen:

* å slå sammen verdier av nominale variabler (f.eks. brepåvirka og leirpåvirka elver) 
* å slå sammen *nabo*verdier av ordinale variabler (f.eks. størrelsesklassene 3 og 4, men ikke 1 og 4)
* å erstatte ordinale variabler med kontinuerlige varianter av den samme variabelen (f.eks. høydesone med faktisk høyde over havet)
* å droppe variabler helt
* å tilføye en interaksjon mellom en variabel og rapporteringsperiode

Valget mellom to modeller som testes ut, er basert på AIC ([Akaikes informasjonskriterium](https://en.wikipedia.org/wiki/Akaike_information_criterion)). 
Om to modeller har ulik antall parametere, foretrekkes den enklere modellen om dens AIC er lik eller mindre enn den mer komplekse modellens **AIC + 2**.
(Ønskes en annen &Delta;AIC-verdi enn 2, kan dette spesifiseres gjennom funksjonsargumentet `DeltaAIC`.) 
Om to modeller har samme antall parametere, foretrekkes den med lavere AIC.

Parametere som er droppa fra modellen, tas ikke inn igjen.
Rapporteringsperiode, relativt år og interaksjonen mellom disse droppes ikke fra modellen.

