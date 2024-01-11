# Forklaringer for funksjonen `oppdaterVannforekomster`

Funksjonen kobler informasjonen om innsjøvannforekomster (fra vann-nett) med informasjon fra innsjødatabasen (fra NVE).

_Innhold:_ [syntaks](#syntaks) – [argumenter](#argumenter) – [detaljer](#detaljer) – [funksjonsverdi](#funksjonsverdi) – [kode](#kode)


## Syntaks

```{r}
oppdaterVannforekomster(V, nve, slingringsmonn = 0.1)
```


## Argumenter

* `V` er **R**-tabellen for vannforekomster (som må ha blitt lest inn ved hjelp av [`lesVannforekomster`](lesVannforekomster.md)).
* `nve` er **R**-tabellen for innsjødatabasen (som må ha blitt lest inn ved hjelp av [`lesInnsjoforekomster`](lesInnsjoforekomster.md)).
* `slingringsmonn` (**numerisk skalar**) angir hvilket relativt avvik fra de reelle verdiene som godtas før opplysninger blir korrigert for en vannforekomst. Standardinnstillinga er 10 %.


## Detaljer

Funksjonen trengs bare om de(n) aktuelle vannforskrift-parameteren (-parameterne) er relevant for innsjøer.
Den må i så fall benyttes etter at `V` har blitt lest inn ved hjelp av [`lesVannforekomster`](lesVannforekomster.md) og `nve` har blitt lest inn ved hjelp av [`lesInnsjoforekomster`](lesInnsjoforekomster.md), og før den oppdaterte tabellen brukes som innmating for [`fraVFtilNI`](fraVFtilNI).


## Funksjonsverdi

Funksjonsverdien er en **tabell** (_dataframe_) med oppdatert informasjon om alle vannforekomster.
Tabellens kolonner er de samme som for argumentet `V` (se [`lesVannforekomster`](lesVannforekomster.md)).


## Kode

Funksjonens [kode kan inspiseres her](../R/oppdaterVannforekomster.R).

