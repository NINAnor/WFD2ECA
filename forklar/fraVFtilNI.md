# Forklaringer for funksjonen `fraVFtilNI`

Funksjonen gjennomfører mesteparten av dataflyten «fra vannforskrift til naturindeks».


## Syntaks

```{r}
fraVFtilNI(DATA, vannforekomster, vannlokaliteter, parameter, vannkategori,
           filKlasser = NULL, NI.aar = c(1990, 2000, 2010, 2014, 2019, 2024),
           rapportenhet = c("kommune", "fylke", "landsdel", "norge"),
           adminAar = 2010, kommHist = "data/knr.xlsx", fylkHist = "data/fnr.xlsx",
           rapportperiode = 10, vedMaalefeil = "dato", maksSkjevhet = 3,
           bareInkluder = NULL, ikkeInkluder = NULL,
           maalingPer = 25, maalingTot = 100,
           ignorerVariabel = NULL, fastVariabel = NULL,
           aktivitetsvekt = 5, antallvekt = 0.5, tidsvekt = 1, arealvekt = 2,
           DeltaAIC = 2, iterasjoner = 100000,
           bredde = NULL, vis = TRUE, tell = TRUE)
```


## Argumenter

-	`DATA` (**tabell**). _Argumentet må angis_. Det skal være navnet på **R**-tabellen som inneholder de relevante målingene fra vannmiljø-databasen.
-	`vannforekomster` (**tabell**). _Argumentet må angis_. Det skal være navnet på **R**-tabellen som inneholder informasjonen om vannforekomster.
- `vannlokaliteter` (**tabell**). _Argumentet må angis_. Det skal være navnet på **R**-tabellen som inneholder informasjonen om vannlokaliteter.
- `parameter` (**tekst-skalar**). _Argumentet må angis_. Det skal være forkortelsen på den relevante vannforskriftsparameteren. (Forkortelsen må følge vannmiljø-databasen. For eksempel er «planteplankton trofiindeks», som er kjent som PTI, i vannmiljø forkortet som «PPTI».)
- `vannkategori` (**tekst-skalar**). _Argumentet må angis_. Det skal være én av bokstavene "L", "R" eller "C", som står for henholdsvis innsjø, elv og kyst.
- `filKlasser` (**tekst-skalar**). Filnavn på excel-regnearket med parameterens klassegrenser. Hvis det ikke er angitt, antas filnavnet å være «klassegrenser_[`parameter`].xslx», altså f.eks. «klassegrenser_ASPT.xslx» for parameteren ASPT.
- `NI.aar` (**numerisk vektor**). Rapporteringsår for naturindeksen, som ett eller flere årstall. Det er disse årene det estimeres verdier for naturindeksen. Hvis argumentet ikke er angitt, antas den å bestå av årstalla 1990, 2000, 2010, 2014, 2019 og 2024.
- `rapportenhet` (**tekst-vektor**). Romlig enhet som verdiene skal skaleres opp til. Tillate svar er én eller flere av «kommune», «fylke», «landsdel» og «Norge». Standardinnstillinga er å bruke alle disse.
- `adminAar` (**numerisk skalar**). Årstallet for kommune- og fylkesinndelinga som skal legges til grunn. Kommune- og fylkesinndelinga ligger ikke fast, og hvis «kommuner» og/eller «fylke» er lavgt som rapportenhet, kan utmatinga være avhengig av året inndelinga skal gjelde for. Standardinnstillinga er Norges administrative inndeling per 2010, som er det som brukes i naturindeks.
- `kommHist` (**tekst-skalar**). Filnavn på excel-regnearket med Norges historiske og nåværende kommunenavn og -numre. Hvis det ikke er angitt, antas filnavnet å være «knr.xlsx».
- `fylkHist` (**tekst-skalar**). Filnavn på excel-regnearket med Norges historiske og nåværende fylkesnavn og -numre. Hvis det ikke er angitt, antas filnavnet å være «fnr.xlsx».
- `rapportperiode` (**numerisk skalar**). Antall år før hvert rapporteringstidspunkt som målinger skal inkluderes fra. Standardinnstillinga er 10 (år). Det betyr f.eks. at målinger fra 1981 til 1990 inngår i estimeringa av verdiene for 1990. Rapportperioden er uansett ikke lenger enn tidsrommet mellom to rapporteringsår. Hvis `NI.aar` f.eks. følger standardinnstillinga, vil det med en rapportperiode på 10 år likevel bare brukes årene 2015–2019 for å beregne verdier for 2019. Settes `rapportperiode` derimot ned til f.eks. 2 (år), vil kun 2018 og 2019 inngå i beregnina av verdier for 2019.
- `vedMaalefeil` (**tekst-skalar**). Argumentet avgjør hva som skal ekskluderes når det avdekkes måleverdier som skal være umulig (som vil si at det foreligger en måle- eller punsjefeil). Mulige svar er «måling» (kun den feilaktige målinga ekskluderes), «dato» (alle målinger utført av samme oppdragstager på samme dato ekskluderes) og «oppdragstager» (alle målinger utført av samme oppdragstager ekskluderes, uansett dato). Standardinnstillinga er «dato».
- `maksSkjevhet` (**numerisk skalar**). Argumentet angir hva som er den høyeste absolutte «skjevhetsskåren» for en overvåkingsaktivitet som blir tatt med i estimeringa. Skjevhetsskår er (omtrentlige) skår som har blitt gott til de ulike overvåkingsaktivitenene, og som prøver å anslå hvor sterk en aktivitetens «slagside» mot enten god (positiv skår) eller dårlig tilstand (negativ skår) er (se [Sandvik 2019](http://hdl.handle.net/11250/2631056), s. 17–19; jf. også [Framstad mfl. 2023](https://hdl.handle.net/11250/3104185), s. 121). Skårene kan være −3, −2, −1, 0, +1, +2 eller +3. Dermed er heltall mellom 0 og 3 meningsfulle verdier for `maksSkjevhet`. Ved 0 inkluderes kun målinger fra overvåkingsaktiviteter som har minimal slagside (noe som reduserer antall tilgjengelige målinger betraktelig. Ved 3 (som er standardinnstillinga) inkluderes alle målinger.
- `bareInkluder` (**liste**). Hvis argumentet er oppgitt, ekskluderes alle målinger som _ikke_ oppfyller de oppgitte kriteriene. Standardinnstillinga er å inkludere alle målinger som er tatt i vannforekomster som det er definert klassegrenser for. Argumentet angis som en liste med to elementer, der den første må hete `typ` og inneholde forkorta typologifaktorer (`reg` for økoregion, `son` for klimasone, `stø` for størrelse, `alk` for alkalitet, `hum` for humusinnhold, `tur` for turbiditet, `dyp` for dybde, `kys` for kysttype, `sal` for salinitet, `tid` for tidevann, `eks` for bølgeeksponering, `mix` for miksing, `opp` for oppholdstid, `str` for strøm), mens den andre må hete `vrd` og inneholde de respektive typologifaktorenes verdier som skal inkluderes. Eksempler:	
`bareInkluder = list(typ = "tur", vrd = 2)` for å begrense analysene til brepåvirka vannforekomster;	
`bareInkluder = list(typ = c("reg", "son"), vrd = c("F", "H"))` for å begrense analysene til vannforekomster i Finnmark og i høydesonen;	
`bareInkluder = list(typ = c("stø", "stø"), vrd = c(1, 2))` for å begrense analysene til de to minste størrelsesklassene.
- `ikkeInkluder` (**liste**). Hvis argumentet er oppgitt, ekskluderes alle målinger som oppfyller de oppgitte kriteriene. Standardinnstillinga er å inkludere alle målinger som er tatt i vannforekomster som det er definert klassegrenser for. Argumentet angis som en liste med to elementer, der den første må hete `typ` og inneholde forkorta typologifaktorer (se forrige avsnitt), mens den andre må hete `vrd` og inneholde de respektive typologifaktorenes verdier som skal ekskluderes. Eksempler:	
`ikkeInkluder = list(typ = "tur", vrd = 2)` for å ekskludere brepåvirka vannforekomster;	
`ikkeInkluder = list(typ = c("reg", "son"), vrd = c("F", "H"))` for å ekskludere vannforekomster i Finnmark og i høydesonen;	
`ikkeInkluder = list(typ = c("stø", "stø"), vrd = c(1, 2))` for å ekskludere de to minste størrelsesklassene.
- `maalingPer` (**numerisk skalar**). Minste antall vannforekomster som det må foreligge målinger fra per rapporteringsperiode, for at det gjøres et forsøk på å estimere verdier for den respektive rapporteringsperioden. Standardinnstillinga er 25.
- `maalingTot` (**numerisk skalar**). Minste antall vannforekomster som det totalt må foreligge målinger fra, for at det gjøres et forsøk på å estimere verdier. Standardinnstillinga er 100.
- `ignorerVariabel` (**tekst-vektor**). Oppgitte typologifaktorer inngår ikke i modelltilpasninga. Standardinnstillinga er å teste ut alle typologifaktorer.
- `fastVariabel` (**tekst-vektor**). Oppgitte typologifaktorer tvinges til å være med i modellen som tilpasses. Standardinnstillinga er å teste ut alle typologifaktorer.
- `aktivitetsvekt` (**numerisk skalar**). Tallverdi som blir brukt for vekting av overvåkingsaktiviteter. Jo høyere vekt, desto mer vektes overvåkingsaktiviteter med høy «skjevhetsskår» ned ved estimering av verdier. Standardinnstillinga er 5, som betyr at aktiviteter får 5 ganger lavere vekt når de har en skår på ±1, 25 ganger lavere vekt når de har en skår på ±2, og 125 ganger lavere vekt når de har en skår på ±3. (Se også argumentet `maksSkjevhet` over, som tillater å ekskludere aktiviteter med visse skjevhetsskår helt.)
- `antallvekt` (**numerisk skalar**). Tallverdi som blir brukt for vekting av antall prøver per måleverdi. Standardinnstillinga er 0,5, som betyr at målinger som baserer seg på flere enkeltprøver får en vekt som tilsvarer kvadratroten av antall enkeltprøver. Ved `antallvekt = 1` vektes målinger med antall enkeltprøver; ved `antallvekt = 0` får alle målinger samme vekt.
- `tidsvekt` (**numerisk skalar**). Tallverdi som blir brukt for nedvekting av eldre målinger. Standardinnstillinga er 1, som betyr at målinger ikke vektes ned. Ved en tidsvekt < 1 vektes målinger ned jo flere år de har blitt tatt før sitt respektive rapportår (med en faktor lik tidsvekt opphøyd i antall år). Meningsfulle verdier er reelle tall mellom 0,5 og 1.
- `arealvekt` (**numerisk skalar**). Tallverdi for vekting av innsjøstørrelse. Meningsfulle verdier er heltall mellom 0 og 3, der 0 innebærer _lik_ vekt for alle innsjøvannforekomster, 1 vekting med innsjøvannforekomstenes idealiserte _diameter_, 2 vekting med innsjø-vannfore¬komstenes faktiske _areal_ og 3 vekting med innsjøvannforekomstenes idealiserte _volum_. Standardinnstillinga er 2, altså vekting med innsjøarealet (se begrunnelse i [Sandvik 2019](http://hdl.handle.net/11250/2631056), s. 21–23).
- `DeltaAIC` (**numerisk skalar**). ΔAIC-verdien angir hvor mye lavere AIC (Akaikes informasjonskriterium) en mer kompleks modell skal ha for å bli foretrukket fremfor en enklere modell. Standardinnstillinga er 2.
- `iterasjoner` (**numerisk skalar**). Antall iterasjoner som skal brukes i simuleringa. Standardinnstillinga er satt til 100 000. Mye lavere bør det ikke være for bruk i naturindeks, men merk at en kjøring med så mange iterasjoner vil ta svært lang tid. For et prøvekjør bør tallet settes betydelig lavere, f.eks. til 1 000.
- bredde¤
- `vis` (**sannhetsverdi-skalar**). Ved `vis = TRUE` (standardinnstillinga) vises fortløpende informasjon om progresjonen. Argumentet er ikke fullt utviklet (som vil si at `vis = FALSE` foreløpig ikke vil slå av alle meldinger).
- tell¤


## Detaljer

Funksjonen gjennomfører [trinn 2 til 15 av dataflyten](dataflyt.md) «fra vannforskrift til naturindeks» som ble beskrevet av Sandvik ([2019](http://hdl.handle.net/11250/2631056)).

De første fem argumentene _må alltid angis_. De øvrige er frivillige, som vil si at det brukes en standardverdi om ikke noe annet angitt.


## Funksjonsverdi

Funksjonen leverer en liste med like mange elementer som rapportenheter (så sant `rapportenhet` var en gyldig innmating). 
Elementene heter `kommune`, `fylke`, `landsdel` og/eller `Norge`, avhengig av argumentet `rapportenhet`. 
Hvert av elementene er en tredimensjonal tabell (_array_) med _E_ × _A_ × _S_ tallverdier, der 
_E_ er antall administrative enheter (dimensjonen heter henholdsvis `kommune`, `fylke`, `landsdel` eller `rike`, med verdier tilsvarende kommunenavnene osv.), 
_A_ er rapportår (`aar`, med verdier gitt gjennom `NI.aar`) og 
_S_ er antall iterasjoner + 1 (`simuleringer`, med verdiene `median`, etterfulgt av én verdi per iterasjon).

Listen har følgende attributter:

- `parameter` (**tekst-skalar**) er vannforskriftsparameteren (dvs. identisk med argumentet `parameter`).
- `vannkategori` (**tekst-skalar**) er vannkategorien (dvs. identisk med argumentet `vannkategori`).
- `tidspunkt` (**tidspunkt**) er tidspunktet når funksjonsverdien ble beregna (dato + klokkeslett).
- `versjon` (**tekst-skalar**) er versjonsnummeret til funksjonen som har blitt brukt.
- `innstillinger` (**liste**) er en liste over de øvrige innstillingene, slik de ble valgt for den aktuelle kjøringa.
- `beskjeder` (**tekst-vektor**) er en samling av de relevante beskjedene som ble produsert under kjøringa.


## Kode

Funksjonens [kode kan inspiseres her](../R/fraVFtilNI.R).


