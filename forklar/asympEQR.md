# Beregning av mEQR-verdier

En rekke vannforskriftsparametere kan få måleverdier som er _bedre_ enn **referanseverdien** eller _dårligere_ enn "**nullverdien**" (der referanseverdien er øvre/beste klassegrense for svært god tilstand og "nullverdi" er nedre/dårligste klassegrense for svært dårlig tilstand, og anførselstegnene brukes fordi "nullverdien" ikke trenger å være lik null).
Standardprosedyren ifølge vannforskriften (se [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/)) er å trunkere slike måleverdier, slik at de førstnevnte får en nEQR-verdi på 1 og de sistnevnte en nEQR-verdi på 0.
For å estimere usikkerhet i tilstandsregnskap og naturindeksen er det derimot viktig å ikke skjule denne variabiliteten i måleverdier.
Derfor har Sandvik ([2019](http://hdl.handle.net/11250/2631056), s. 13&ndash;15) foreslått å beregne "mEQR-verdier", som bare skiller seg fra nEQR-verdier i at de ikke blir trunkert.

Imidlertid forutsetter denne løsninga at man besvarer et oppfølgingsspørsmål:
Hvilken transformering skal man bruke på de overskytende verdiene (bedre enn referanseverdi eller dårligere enn "nullverdi") for å skalere dem til mEQR-skala?
Svaret er ikke gitt i vannforskriften (som jo unngår spørsmålet ved trunkering), og det er heller ikke trivielt.
Løsninga som nå er implementert i funksjonen [`mEQR`](mEQR.md), tar utgangspunkt i formelen for nEQR (jf. [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/)):

$$\mathrm{nEQR} = S_{\mathrm{n}} + \mathrm{0,2} \cdot \displaystyle \frac{x - V_{\mathrm{n}}}{V_{\mathrm{ø}} - V_{\mathrm{n}}} $$

der _S_<sub>n</sub> er den nedre klassegrensa for den respektive tilstandsklassen på nEQR-skala, _V_<sub>n</sub> er den nedre klassegrensa for den respektive tilstandsklassen på parameterens opprinnelig måleskala, _V_<sub>ø</sub> er den øvre klassegrensa for den respektive tilstandsklassen på parameterens opprinnelig måleskala, og _x_ er parameterens måleverdi.

Beregning av mEQR følger beregning av nEQR for alle måleverdier mellom "null-" og referanseverdi.
For de øvrige måleverdiene er beregninga slik:

- I utgangspunktet brukes samme transformering (dvs. samme stigningstall) som for den tilstøtende tilstandsklassen. Det vil si at mEQR for måleverdier som er bedre enn referanseverdien, beregnes med samme formel som måleverdier i svært god tilstand (med _S_<sub>n</sub> = 0,8 og _V_<sub>ø</sub> = referanseverdien), og mEQR for måleverdier som er dårligere enn "nullverdien", beregnes med samme formel som måleverdier i svært dårlig tilstand (med _S_<sub>n</sub> = 0,0 og _V_<sub>n</sub> = "nullverdien").
- Hvis denne verdien imidlertid er større enn 1,2 eller mindre enn &minus;0,2, erstattes den lineære transformeringa med en asymptotisk funksjon som begynner med samme stigningstall som i den tilstøtende tilstandsklassen, og som har 1,2 som sin høyeste verdi (for måleverdier som er bedre enn referanseverdien) eller &minus;0,2 som sin laveste verdi (for måleverdier som er dårligere enn "nullverdien").

## Illustrasjoner

De følgende figurene illustrerer hvordan skaleringa fra måleverdi til mEQR-verdi ser ut for tolv av [parametrene som er klargjort for dataflyt](param.md) (der bakgrunnsfargene symboliserer tilstandsklassene &ndash; _lilla:_ bedre enn referanseverdien, _blå:_ svært god, _grønn:_ god, _gul:_ moderat, _oransje:_ dårlig, _rød:_ svært dårlig, _grå:_ dårligere enn "nullverdien"; den _blå linja_ indikerer referanseverdien, og den _røde linja_ indikerer "nullverdien"):

<img src="../fig/AIP.png" width="420" height="300" /> <img src="../fig/ASPT.png" width="420" height="300" />

<img src="../fig/ES100.png" width="420" height="300" /> <img src="../fig/HBI2.png" width="420" height="300" />

<img src="../fig/ISI.png" width="420" height="300" /> <img src="../fig/MBH.png" width="420" height="300" />

<img src="../fig/NQI1.png" width="420" height="300" /> <img src="../fig/PIT.png" width="420" height="300" />

<img src="../fig/PPBIOMTOVO.png" width="420" height="300" /> <img src="../fig/PPTI.png" width="420" height="300" />

<img src="../fig/RADDUM1.png" width="420" height="300" /> <img src="../fig/TIANTL.png" width="420" height="300" />

Der ikke annet er oppgitt på _x_-aksen, er de opprinnelige måleverdiene enhetsløse indeksverdier.


## Begrunnelse og alternative beregningsmåter

Den følgende figuren bruker PTI ("PPTI" ifølge vannmiljø) for å illustrere ulike måter å håndtere overskytende verdier på:

<img src="../fig/asympPTI.png" width="504" height="360" />

1. **Gjennomtrukket svart linje:** **nEQR**. Vannforskriftens tilnærming er å trunkere EQR-verdier som er større enn 1, til 1, og de som er mindre enn 0, til 0. Ulempen ved bruk av denne tilnærminga for tilstandsregnskap og naturindeksen er at informasjon om parameterens variasjon går tapt.
2. **Rød linje:** _lineær_ **forlengelse** _av transformeringene som er valgt for de tilstøtende tilstandsklassene_. Ulempen er at tilnærminga kan resultere i verdier som er vesentlig mye større enn 1 eller vesentlig mye mindre enn 0. Et gjennomsnitt av to mEQR-verdier tilsvarende beste mulige verdi (1,64) og "nullverdi" (0,00) ville i PTI-eksempelet resultere i svært god tilstand (0,82), noe som er villedende.
3. **Blå linje:** _lineær begrensning til intervallet mellom &minus;0,2 og +1,2_. Dette er løsninga som ble foreslått av Sandvik ([2019](http://hdl.handle.net/11250/2631056)) og var implementert i tidligere versjoner av koden (til og med versjon 1.1). Et gjennomsnitt av to mEQR-verdier tilsvarende beste mulige verdi (1,2) og "nullverdi" (0,0) ville f.eks. resultere i moderat tilstand (0,6), noe som er meningsfullt. Ulempen er at tilnærminga leder til uheldige **knekk** ved 1 og 0.
4. **Punktert svart line:** _forlengelse av transformeringene som er valgt for de tilstøtende tilstandsklassene, men med en_ **asymptotisk** _begrensning til intervallet mellom &minus;0,2 og +1,2 (om nødvendig)_. Dette er løsninga som nå er implementert i koden (fra og med versjon 1.2).

Tallverdien 1,2 som maksimumsverdi for mEQR ble av Sandvik ([2019](http://hdl.handle.net/11250/2631056), s. 14) begrunna slik:
"Avstanden på 0,2 mellom maksimumsverdien og referansetilstanden tilsvarer avstanden mellom de øvrige klassegrensene.
Siden referanseverdien på 1 dermed havner midt mellom den nedre grensa for svært god tilstand og maksimumsverdien, passer dette godt med at noen indikatorer har definert referanseverdien som mediantilstanden ('midtpunktet') av referansevannforekomster"
(f.eks. indikatorer for planteplankton, se [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/)).
Med tanke på at måleverdier fra referanse*vannforekomster* i så fall forventes å ligge i hele intervallet fra nedre grense for svært god tilstand til maksimumsverdien (som tilsvarer mEQR-verdier i intervallet mellom 0,8 og 1,2), bør transformingsfunksjonens stigningstall ikke endre seg sprangvis ved referanse*verdien* (1,0).
Dette er ivaretatt gjennom den asymptotiske tilnærminga som nå er implementert.
For tilstander som er dårligere enn "nullverdien", er det nærliggende å følge samme prosedyre.
