# Forklaringer for funksjonen `hentKlassegrenser`

Funksjonen leser inn klassegrensene for en spesifisert vannforskrifts-parameter.


## Syntaks

```{r}
hentKlassegrenser(filKlasser)
```


## Argumenter

* `filKlasser` (**tekst-skalar**) angir navnet på en fil med klassegrenser. Fila må være et excel-regneark.


## Detaljer

Funksjonen forutsetter at klassegrensene er tilgjengelig i det spesifiserte excel-regnearket.
Tilgjengelige regneark er samla i mappa [klassegr](../klassegr/).
Om et regneark må endres eller et nytt legges til, følg instruksjonene som er [bekrevet her](param.md).


## Funksjonsverdi

Funksjonsverdien er en **numerisk matrise** som inneholder klassegrenser.
Med klassegrense menes terskelverdiene mellom økologiske tilstandsklasser (svært dårlig, dårlig, moderat, god og svært god).
Matrisens kolonner og rader har de følgende navn:

- Kolonnenavnene er `c("min", "SD_nedre", "SD_D", "D_M", "M_G", "G_SG", "SG_øvre", "max")`, som identifiserer klassegrensene samt den dårligste og beste verdien som er teknisk mulig.
- Radnavnene er forkorta vanntyper ("LEL11011" osv.).


## Kode

Funksjonens [kode kan inspiseres her](../R/hentKlassegrenser.R).

