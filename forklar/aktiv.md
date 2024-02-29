# Korreksjon for overvåkingsaktivitetenes (manglende) representativitet

For hvert datapunkt i [vannmiljø](https://vannmiljo.miljodirektoratet.no/)-databasen er det angitt en «aktivitet» som målingen ble begrunnet med (se [oversikten i vannmiljø](https://vannmiljokoder.miljodirektoratet.no/activity)). 
Som drøftet av Sandvik ([2019](http://hdl.handle.net/11250/2631056), s. 17–19) og Framstad mfl. ([2023](https://hdl.handle.net/11250/3104185)): s. 53, tab. 6 og vedl. 3),
vil dette si at noen målinger foretas fordi man vet eller antar at tilstanden i den berørte vannforekomsten er (nokså) dårlig, mens andre foretas fordi man vet eller antar at tilstanden i den berørte vannforekomsten er (nokså) god. 
Hvis det ikke korrigeres for at slike målinger er forskjøvet mot henholdsvis dårlige og gode forhold, kan dette også lede til feilaktige aggregeringer. 
Det fins flere måter å angripe dette problemet på, bl.a. å vekte ned målinger som ble tatt i sammenheng med aktiviteter der man kan forvente en slagside mot den ene eller andre siden. 
Den «sikreste» metoden er å se bort fra alle målinger som kan ha en slagside, men denne tilnærmingen medfører også en drastisk reduksjon i den tilgjengelige datamengden.

Funksjonen [`fraVFtilNI`](fraVFtilNI.md) muliggjør begge løsningene:

* Standardinnstillinga er at alle målinger brukes (`maksSkjevhet = 3`), men at overvåkingsaktiviteter med lav representativitet får lavere vekt i modellerings- og ekstrapoleringstrinnene (`aktivitetsvekt = 5`). Representativitet er skåra fra 0 (helt eller tilnærma representativ) til henholdsvis +3 (sterkt forskjøvet mot god tilstand) og &minus;3 (sterkt forskjøvet mot dårlig tilstand). Disse skårene er basert på vedlegg 3 av Framstad mfl. ([2023](https://hdl.handle.net/11250/3104185)). Vekten er satt til 5, som vil si at vekten reduseres til en femtedel for hvert skår bort fra 0 (se ligning 1, s. 19, av [Sandvik 2019](http://hdl.handle.net/11250/2631056)). Vekten styres av funksjonsargumentet `aktivitetsvekt`.
* Om man ønsker å ekskludere målinger med lav representativitet helt, kan standardinnstillinga overstyres ved å sette argumentet `maksSkjevhet` lavere enn 3. Ved `maksSkjevhet = 0` brukes f.eks. kun målinger foretatt i forbindelse med de mest representative overvåkingsaktivitetene.

Beregningsmåten av vektinga for overvåkingsaktiviteter ble endra mellom versjon 1.1 og 1.2 av funksjonen [`fraVFtilNI`](fraVFtilNI.md).
Forskjellen er nokså ubetydelig, men hvis det skulle være nødvendig å gjenskape den tidligere beregningsmåten, kan dette oppnås ved å sette funksjonsargumentet `aktVekting` til `FALSE`.

