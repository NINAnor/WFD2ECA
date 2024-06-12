# Arealvekt

Som siste trinn i [dataflyten](dataflyt.md) aggregerer funksjonen "[`fraVFtilNI`](fraVFtilNI.md)" [mEQR-verdiene](mEQR.md) som ble målt i eller [ekstrapolert](extrapol.md) for de ulike vannforekomstene, opp til kommune-, fylkes-, landsdelsnivå eller hele Norge ("rapportenhet").
Denne aggregeringa er basert på et gjennomsnitt av vannforekomstene, der gjennomsnittet kan være vekta eller uvekta.
Valget styres av funksjonsargumentet `arealvekt`, som kan ha de følgende verdiene:

* `arealvekt = 0` innebærer lik vekt for alle vannforekomster (dvs. et _uvekta_ gjennomsnitt),
* `arealvekt = 1` innebærer vekting med vannforekomstenes idealiserte _diameter_,
* `arealvekt = 2` innebærer vekting med vannforekomstenes faktiske _areal_, 
* `arealvekt = 3` innebærer vekting med vannforekomstenes idealiserte _volum_.

Standardinnstillinga er 2 for alle vannkategorier (fra og med versjon 1.3).
Dette er basert på at naturindeksen praktiserer arealvekta gjennomsnitt for romlig aggregering av indeksverdier ([Certain mfl. 2011](http://dx.doi.org/10.1371/journal.pone.0018930), [Pedersen & Nybø 2015](http://hdl.handle.net/11250/286693)).
Ved innsjøvannforekomster vil vekting for innsjøareal dessuten bety at størrelses*klassene* samla sett får tilnærma lik vekt under aggregeringa (se [Sandvik 2019](http://hdl.handle.net/11250/2631056), s. 21–23).

Selv om standardinnstillinga er sterkt å anbefale, kan alle fire verdier brukes for innsjøvannforekomster.
For elve- og kystvannforekomster er kun arealvektene 0 og 2 meningsfulle.
Frem til versjon 1.2 var 0 var den eneste tilgjengelige vekta for elve- og kystvannforekomster (mens standardinnstillinga for innsjøvannforekomster var 2 i alle versjoner).

Vannforekomstenes diametere (og volum) er ikke faktiske verdier, men beregna som arealenes kvadratrot (opphøyd i tredje). Formelen som brukes for vektinga, er _areal_<sup>&nbsp;_vekt_&nbsp;/&nbsp;2</sup>.

For elver antas vannforekomstens areal å være proporsjonal til dens lengde (som vil si at en konstant bredde legges til grunn).

