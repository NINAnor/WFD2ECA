# Forklaringer for funksjonen `WFD2ECA`

Funksjonen gjennomfører mesteparten av dataflyten fra vannforskrift (WFD, *Water Framework Directive*) til økologisk tilstandsregnskap (ECA, *ecological condition account*).

_Innhold:_ [syntaks](#syntaks) – [argumenter](#argumenter) – [detaljer](#detaljer) – [funksjonsverdi](#funksjonsverdi) – [kode](#kode)


## Syntaks

```{r}
WFD2ECA(DATA, vannforekomster, vannlokaliteter, parameter, vannkategori,
        filKlasser = NULL, rapportaar = c(2012, 2015, 2018, 2021, 2024),
        rapportenhet = c("norge", "landsdel"), adminAar = 2010, 
        kommHist = "../data/knr.xlsx", fylkHist = "../data/fnr.xlsx",
        paramFil = "../data/VM-param.xlsx", aktivFil = "../data/VM-aktiv.xlsx",
        rapportperiode = 3, vedMaalefeil = "dato", maksSkjevhet = 3,
        utMaaling = FALSE, bareInkluder = NULL, ikkeInkluder = NULL,
        maalingPer = 50, maalingTot = 200, maalingTyp = 50, maalingInt = 50,
        EQR = "asymptotisk",
        ignorerVariabel = NULL, fastVariabel = NULL, 
        trend = NA, anadrom = FALSE,
        aktVekting = TRUE, aktivitetsvekt = 3, 
        antallvekt = 0.5, tidsvekt = 1, arealvekt = 2,
        logit = TRUE, DeltaAIC = 2, interaksjon = TRUE, 
        ekstrapolering = "kjente", beggeEnder = FALSE, 
        iterasjoner = 10000, SEED = NULL,
        bredde = NULL, vis = TRUE, tell = TRUE, 
        ...)
```


## Argumenter

- `DATA` (**tabell**). _Argumentet må angis_. Det skal være **R**-tabellen som inneholder de relevante målingene fra vannmiljø-databasen (som utmating av funksjonen [`lesMaalinger`](lesMaalinger.md)).
- `vannforekomster` (**tabell**). _Argumentet må angis_. Det skal være **R**-tabellen som inneholder informasjonen om vannforekomster (som utmating av funksjonen [`lesVannforekomster`](lesVannforekomster.md) eller [`oppdaterVannforekomster`](oppdaterVannforekomster.md)).
- `vannlokaliteter` (**tabell**). _Argumentet må angis_. Det skal være **R**-tabellen som inneholder informasjonen om vannlokaliteter (som utmating av funksjonen [`lesVannlokaliteter`](lesVannlokaliteter.md)).
- `parameter` (**tekst-skalar**). _Argumentet må angis_. Det skal være forkortelsen på den relevante vannforskriftsparameteren. (Forkortelsen må følge vannmiljø-databasen. For eksempel er «planteplankton trofiindeks», som er kjent som PTI, i vannmiljø forkorta som «PPTI». Se [hvilke parametere som er klargjort for dataflyt](param.md).)
- `vannkategori` (**tekst-skalar**). _Argumentet må angis_. Det skal være én av bokstavene "L", "R" eller "C", som står for henholdsvis innsjø, elv og kyst.
- `filKlasser` (**tekst-skalar**). Filnavn på excel-regnearket med parameterens klassegrenser. Hvis det ikke er angitt, antas filnavnet å være «klassegrenser_[`parameter`].xslx», altså f.eks. «klassegrenser_ASPT.xslx» for parameteren ASPT.
- `rapportaar` (**numerisk vektor**). Rapporteringsår for naturregnskapet, som ett eller flere årstall. Det er disse årene det estimeres verdier for naturregnskapet. Hvis argumentet ikke er angitt, antas den å bestå av årstalla 2012, 2015, 2018, 2021 og 2024. (Frem til versjon 1.5 het dette argumentet `NI.aar`.)
- `rapportenhet` (**tekst-vektor**). Romlig enhet som verdiene skal skaleres opp til. Tillate svar er én eller flere av «kommune», «fylke», «landsdel» og «Norge». Standardinnstillinga er å bruke de to siste.
- `adminAar` (**numerisk skalar**). Årstallet for kommune- og fylkesinndelinga som skal legges til grunn. Kommune- og fylkesinndelinga ligger ikke fast, og hvis «kommuner» og/eller «fylke» er valgt som rapportenhet, kan utmatinga være avhengig av året inndelinga skal gjelde for. Standardinnstillinga er Norges administrative inndeling per 2010.
- `kommHist` (**tekst-skalar**). Filnavn på excel-regnearket med Norges historiske og nåværende kommunenavn og -numre. Hvis det ikke er angitt, antas filnavnet å være «knr.xlsx».
- `fylkHist` (**tekst-skalar**). Filnavn på excel-regnearket med Norges historiske og nåværende fylkesnavn og -numre. Hvis det ikke er angitt, antas filnavnet å være «fnr.xlsx».
- `paramFil` (**tekst-skalar**). Filnavn på excel-regnearket med informasjon om vannforskriftsparametere. Hvis det ikke er angitt, antas filnavnet å være «VM-param.xlsx». (Argumentet ble tilføyd i versjon 1.2.)
- `aktivFil` (**tekst-skalar**). Filnavn på excel-regnearket med informasjon om overvåkingsaktiviteter. Hvis det ikke er angitt, antas filnavnet å være «VM-aktiv.xlsx». (Argumentet ble tilføyd i versjon 1.2.)
- `rapportperiode` (**numerisk skalar**). Antall år før hvert rapporteringstidspunkt som målinger skal inkluderes fra. Standardinnstillinga er 3 (år). Det betyr f.eks. at målinger fra 2022 til 2024 inngår i estimeringa av verdiene for 2024. Rapportperioden er uansett ikke lenger enn tidsrommet mellom to rapporteringsår.
- `vedMaalefeil` (**tekst-skalar**). Argumentet avgjør hva som skal ekskluderes når det avdekkes måleverdier som skal være umulig (som vil si at det foreligger en måle- eller punsjefeil). Mulige svar er «måling» (kun den feilaktige målinga ekskluderes), «dato» (alle målinger utført av samme oppdragstager på samme dato ekskluderes) og «oppdragstager» (alle målinger utført av samme oppdragstager ekskluderes, uansett dato). Standardinnstillinga er «dato».
- `maksSkjevhet` (**numerisk skalar**). Argumentet angir hva som er den høyeste absolutte «skjevhetsskåren» for en overvåkingsaktivitet som blir tatt med i estimeringa. Skjevhetsskår er (omtrentlige) skår som har blitt gitt til de ulike overvåkingsaktivitenene, og som prøver å anslå hvor sterk aktivitetens «slagside» mot enten god (positiv skår) eller dårlig tilstand (negativ skår) er (se [utdypende forklaring](aktiv.md)). Skårene kan være −3, −2, −1, 0, +1, +2 eller +3. Dermed er heltall mellom 0 og 3 meningsfulle verdier for `maksSkjevhet`. Ved 0 inkluderes kun målinger fra overvåkingsaktiviteter som har minimal slagside (noe som reduserer antall tilgjengelige målinger betraktelig). Ved 3 (som er standardinnstillinga) inkluderes alle målinger.
- `utMaaling` (**sannhetsverdi-** eller **tekst-skalar**). Ved `utMaaling = TRUE` lagres et datasett med målinger som er tilordna til hver sin vannforekomst, som en variabel (tabell/dataramme) hvis navn blir oppgitt. Hvis det angis et variabelnavn, blir denne variabelen (som må være en tabell/dataramme) innlest og brukt istedenfor å kobles til vannforekomster på nytt. Dette kan spare en god del tid om store datasett brukes flere ganger. (Argumentet ble tilføyd i versjon 2.0.)
- `bareInkluder` (**liste**). Hvis argumentet er oppgitt, ekskluderes alle målinger som _ikke_ oppfyller de oppgitte kriteriene. Standardinnstillinga er å inkludere alle målinger som er tatt i vannforekomster som det er definert klassegrenser for. Argumentet angis som en liste med to elementer, der den første må hete `typ` og inneholde forkorta typologifaktorer (`reg` for økoregion, `son` for klimasone, `sto` for størrelse, `alk` for alkalitet, `hum` for humusinnhold, `tur` for turbiditet, `dyp` for dybde, `kys` for kysttype, `sal` for salinitet, `tid` for tidevann, `eks` for bølgeeksponering, `mix` for miksing, `opp` for oppholdstid, `str` for strøm; se [klassifiseringsveilederen](https://www.vannportalen.no/veiledere/klassifiseringsveileder/)), mens den andre må hete `vrd` og inneholde de respektive typologifaktorenes verdier som skal inkluderes. Eksempler:	
`bareInkluder = list(typ = "tur", vrd = 2)` for å begrense analysene til brepåvirka vannforekomster;	
`bareInkluder = list(typ = c("reg", "son"), vrd = c("F", "H"))` for å begrense analysene til vannforekomster i Finnmark og i høydesonen;	
`bareInkluder = list(typ = c("sto", "sto"), vrd = c(1, 2))` for å begrense analysene til de to minste størrelsesklassene.
- `ikkeInkluder` (**liste**). Hvis argumentet er oppgitt, ekskluderes alle målinger som oppfyller de oppgitte kriteriene. Standardinnstillinga er å inkludere alle målinger som er tatt i vannforekomster som det er definert klassegrenser for. Argumentet angis som en liste med to elementer, der den første må hete `typ` og inneholde forkorta typologifaktorer (se forrige avsnitt), mens den andre må hete `vrd` og inneholde de respektive typologifaktorenes verdier som skal ekskluderes. Eksempler:	
`ikkeInkluder = list(typ = "tur", vrd = 2)` for å ekskludere brepåvirka vannforekomster;	
`ikkeInkluder = list(typ = c("reg", "son"), vrd = c("F", "H"))` for å ekskludere vannforekomster i Finnmark og i høydesonen;	
`ikkeInkluder = list(typ = c("sto", "sto"), vrd = c(1, 2))` for å ekskludere de to minste størrelsesklassene.
- `maalingPer` (**numerisk skalar**). Minste antall vannforekomster som det må foreligge målinger fra per rapporteringsperiode for at det gjøres et forsøk på å estimere verdier for den respektive rapporteringsperioden. Standardinnstillinga er 50.
- `maalingTot` (**numerisk skalar**). Minste antall vannforekomster som det totalt må foreligge målinger fra for at det gjøres et forsøk på å estimere verdier. Standardinnstillinga er 200.
- `maalingTyp` (**numerisk skalar**). Minste antall målinger som må foreligge for en typologifaktor for at det gjøres et forsøk på å inkludere typologifaktoren i [modellen](modell.md). Standardinnstillinga er 50. (Argumentet ble tilføyd i versjon 1.2.)
- `maalingInt` (**numerisk skalar**). Minste antall målinger som må foreligge for hver kombinasjon av to parametere for at en interaksjonen mellom dem testes i [modellen](modell.md). Standardinnstillinga er 50. (Argumentet ble tilføyd i versjon 1.4.)
- `EQR` (**tekst-** eller **sannhetsverdi-skalar**). Måten mEQR-verdier (eller nEQR-verdier) blir beregna på. Standardinnstillinga er "asymptotisk". Tilgjengelige alternativ er "forlengelse", "knekk", "nEQR" og `FALSE`. Det siste alternativet bruker uskalerte måleverdier. (Se [utdypende forklaring](asympEQR.md). Argumentet ble tilføyd i versjon 1.2, alternativet "FALSE" i versjon 2.0.)
- `ignorerVariabel` (**tekst-vektor**). Oppgitte typologifaktorer inngår ikke i [modelltilpasninga](modell.md). Standardinnstillinga er å teste ut alle typologifaktorer.
- `fastVariabel` (**tekst-vektor**). Oppgitte typologifaktorer tvinges til å være med i [modellen som tilpasses](modell.md). Standardinnstillinga er å teste ut alle typologifaktorer.
- `trend` (**sannhetsverdi-skalar**). Ved `trend = TRUE` inkluderes en trend for hver rapporteringsperiode i modellen (inkludert interaksjon med rapporteringsperiode). Ved `trend = FALSE` estimeres ikke noen trend innenfor rapporteringsperioder. Ved `trend = NA` (standardinnstillinga) estimeres trender kun om rapporteringsperiodene er lenger enn 3&nbsp;år. (Argumentet ble tilføyd i versjon 2.0.)
- `anadrom` (**sannhetsverdi-skalar**). Ved `anadrom = FALSE` (standardinnstillinga) behandles anadrome og ikke-anadrome vassdrag likt (dvs. vassdrag med eller uten laksefisk). Ved `anadrom = TRUE` behandles anadromi som en typologifaktor, som vil si at klassegrenser tillates å variere mellom anadrome og ikke-anadrome vassdrag. Dette er bare relevant for enkelte forsurings-parametere (ANC og LAL) og i elver; det forutsetter at datarammen for vannforekomster har en kolonne som heter "anadr" og inneholder anadromistatus; og det medfører videre at turbiditet utgår som typologifaktor. (Argumentet ble tilføyd i versjon 2.0.)
- `aktVekting` (**sannhetsverdi-skalar**). Måten vekting for overvåkingsaktivitet gjennomføres på. De to tilgjengelige alternativene gir veldig like resultater. Standardinnstillinga (`aktVekting = TRUE`) bør bare endres for å gjenskape resultater av tidligere versjoner av funksjonen (versjon 1.1 eller tidligere).
- `aktivitetsvekt` (**numerisk skalar**). Tallverdi som blir brukt for vekting av overvåkingsaktiviteter. Jo høyere vekt, desto mer vektes overvåkingsaktiviteter med høy «skjevhetsskår» ned ved estimering av verdier. Standardinnstillinga er 3 (men den var 5 frem til versjon 1.4), som betyr at aktiviteter får 3 ganger lavere vekt når de har en skår på ±1, 9 ganger lavere vekt når de har en skår på ±2, og 27 ganger lavere vekt når de har en skår på ±3. (Se også argumentet `maksSkjevhet` over, som tillater å ekskludere aktiviteter med visse skjevhetsskår helt, og [utdypende forklaring](aktiv.md).)
- `antallvekt` (**numerisk skalar**). Tallverdi som blir brukt for vekting av antall prøver per måleverdi. Standardinnstillinga er 0,5, som betyr at målinger som baserer seg på flere enkeltprøver får en vekt som tilsvarer kvadratroten av antall enkeltprøver. Ved `antallvekt = 1` vektes målinger med antall enkeltprøver; ved `antallvekt = 0` får alle målinger samme vekt.
- `tidsvekt` (**numerisk skalar**). Tallverdi som blir brukt for nedvekting av eldre målinger. Standardinnstillinga er 1, som betyr lik vekting av alle tidspunkt. Derimot ville `tidsvekt = 0.9` bety at en måling som er tatt ett år før det respektive rapportåret, vektes ned med 10&nbsp;%, en måling som er tatt to år før det respektive rapportåret, med 19&nbsp;% (1 &minus; 0,9<sup>2</sup>) osv. Meningsfulle verdier er reelle tall mellom 0,5 (sterk nedvekting) og 1 (ingen nedvekting). (Argumentets definisjon ble endra i versjon 1.5. For å gjenskape tidligere utmatinger, må man nå benytte den resiproke verdien av den tidligere tidsvekten.)
- `arealvekt` (**numerisk skalar**). Tallverdi for vekting av vannforekomstenes størrelse. Standardinnstillinga er 2, som innebærer vekting med vannforekomstenes areal. Andre potensielt meningsfulle verdier er heltall mellom 0 og 3. (Se [utdypende forklaring](arealvekt.md).)
- `logit` (**sannhetsverdi-skalar**). Ved `logit = TRUE` (standardinnstillinga) logit-transformeres mEQR-verdiene i modelltilpasninga. (Se [utdypende forklaring](modell.md). Argumentet ble tilføyd i versjon 1.4.)
- `DeltaAIC` (**numerisk skalar**). ΔAIC-verdien angir hvor mye lavere AIC (Akaikes informasjonskriterium) en mer kompleks modell skal ha for å bli foretrukket fremfor en enklere modell. Standardinnstillinga er 2.
- `interaksjon` (**sannhetsverdi-skalar**). Ved `interaksjon = TRUE` (standardinnstillinga) testes interaksjoner mellom rapporteringsperiode og de øvrige forklaringsvariablene under [modellseleksjonen](modell.md). Med `FALSE` droppes interaksjoner. (Argumentet ble tilføyd i versjon 1.4.)
- `ekstrapolering` (**tekst-skalar**). Ved `ekstrapolering = "kjente"` (standardinnstillinga) ekstrapoleres økologisk tilstand bare til vannforekomster som har en typologi som det faktisk foreligger målinger for. Alternativet er `ekstrapolering = "alle"`, som innebærer at det forsøkes å ekstrapolere økologisk tilstand til alle vannforekomster som parameteren er definert for. (Se [utdypende forklaring](extrapol.md). Argumentet ble tilføyd i versjon 1.2.)
- `beggeEnder` (**sannhetsverdi-skalar**). Ved `beggeEnder = TRUE` estimeres en verdi for rapportåret i forkant av det nærmeste rapportåret som har tilstrekkelig data. Standardinnstillinga er `FALSE`. (Argumentet ble tilføyd i versjon 1.5.)
- `iterasjoner` (**numerisk skalar**). Antall iterasjoner som skal brukes i simuleringa. Standardinnstillinga er satt til 10 000. Lavere bør det ikke være for bruk i naturregnskap, men merk at en kjøring med så mange iterasjoner vil ta lang tid. For et prøvekjør bør tallet settes betydelig lavere, f.eks. til 1 000.
- `SEED` (**numerisk skalar**). "Frø" eller "såkorn"" for slumptallgeneratoren. Ifølge standardinnstillinga (`SEED = NULL`) genereres ulike slumptall ved hver kjøring. Ved å angi et heltall i stedet kan man sikre at flere kjøringer benytter de samme slumptallene. (Argumentet ble tilføyd i versjon 1.2.)
- `bredde` (**numerisk skalar**). Maksimal bredde på beskjeder i antall tegn. Standardinnstillinga er å la skjermbredden bestemme.
- `vis` (**sannhetsverdi-skalar**). Ved `vis = TRUE` (standardinnstillinga) vises fortløpende informasjon om progresjonen. Ved `vis = FALSE` vises bare beskjeder som er over middels viktig.
- `tell` (**sannhetsverdi-skalar**). Ved `tell = TRUE` (standardinnstillinga) vises prosentvis fremskritt ved trinn som tar lang tid.
- `...`. Argumenter som brukes av [funksjonene som sjekker parameterspesifikke krav](sjekkPar.md), i den grad man ønsker å endre deres standardinnstillinger ([se detaljer](sjekkPar.md)). Mulige argumenter er avhengig av vannforskriftsparameteren, men inkluderer per nå `slingring`, `fraMaaned`, `tilMaaned`, `antallSyd` og `antallNor`. (Denne funksjonaliteten ble tilføyd i versjon 1.2.)


## Detaljer

Funksjonen gjennomfører [trinn 2 til 15 av dataflyten](dataflyt.md) fra vannforskrift til økologisk tilstandsregnskap, slik det har blitt implementert og dokumentert i [ecRxiv](https://github.com/NINAnor/ecRxiv) (se f.eks. dokumentasjonen for [PIT](https://github.com/NINAnor/ecRxiv/tree/main/indicators/NO_WPIT_001)).

De første fem argumentene _må alltid angis_. De øvrige er frivillige, som vil si at det brukes en standardverdi om ikke noe annet angitt.

Funksjonen [`fraVFtilNI`](fraVFtilNI.md) benytter samme kode som `WFD2ECA`, men har avvikende standardinnstillinger.


## Funksjonsverdi

Funksjonen leverer en liste med like mange elementer som rapportenheter (så sant `rapportenhet` var en gyldig innmating). 
Elementene heter `kommune`, `fylke`, `landsdel` og/eller `Norge`, avhengig av argumentet `rapportenhet`. 
Hvert av elementene er en tredimensjonal tabell (_array_) med _E_ × _A_ × _S_ tallverdier, der 
_E_ er antall administrative enheter (dimensjonen heter henholdsvis `kommune`, `fylke`, `landsdel` eller `rike`, med verdier tilsvarende kommunenavnene osv.), 
_A_ er rapportår (`aar`, med verdier gitt gjennom `rapportaar`) og 
_S_ er antall iterasjoner + 1 (`simuleringer`, med verdiene `median`, etterfulgt av én verdi per iterasjon).

Listen har følgende attributter:

- `parameter` (**tekst-skalar**) er vannforskriftsparameteren (dvs. identisk med argumentet `parameter`).
- `vannkategori` (**tekst-skalar**) er vannkategorien (dvs. identisk med argumentet `vannkategori`).
- `tidspunkt` (**tidspunkt**) er tidspunktet når funksjonsverdien ble beregna (dato + klokkeslett).
- `versjon` (**tekst-skalar**) er versjonsnummeret til funksjonen som har blitt brukt.
- `innstillinger` (**liste**) er en liste over de øvrige innstillingene, slik de ble valgt for den aktuelle kjøringa.
- `beskjeder` (**tekst-vektor**) er en samling av de relevante beskjedene som ble produsert under kjøringa.


## Kode

Funksjonens [kode kan inspiseres her](../R/WFD2ECA.R).


