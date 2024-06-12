### lesMaalinger
# Funksjoner til NI_vannf
# ved Hanno Sandvik
# mai 2024
# se https://github.com/NINAnor/NI_vannf
###



lesMaalinger <- function(filnavn,
                         filsti = "data",
                         kolonnenavn = "navnVM.csv") {
  
  # Kolonner som datarammen V trenger for å fungere:
  nyeKolonner <- c(
    "lokid",
    "aktid",
    "oppdrg",
    "oppdrt",
    "parid",
    "medium",
    "navnid",
    "vitnavn",
    "provmet",
    "analmet",
    "tidpkt",
    "odyp",
    "ndyp",
    "dypenh",
    "filt",
    "unntas",
    "operator",
    "verdi",
    "enhet",
    "provnr",
    "detgr",
    "kvantgr",
    "antverdi"
  )
  
  OK <- TRUE
  ut <- NULL

  # Innlesing av "tolkningstabellen": 
  # Hvilke kolonner i vannmiljø-tabellen svarer til hvilke kolonner i DATA
  if (nchar(filsti)) {
    if (substr(filsti, nchar(filsti), nchar(filsti)) %!=% "/" &
        substr(filsti, nchar(filsti), nchar(filsti)) %!=% "\\") {
      filsti <- filsti %+% "/"
    }
  }
  
  DATA <- try(as.data.frame(read_xlsx(filsti %+% filnavn, col_types = "text")))
  if (inherits(DATA, "try-error")) {
    OK <- FALSE
    skriv("Dette skjedde en feil under innlesing av fila \"", filsti %+%
            filnavn, ". Sjekk om fila fins, at det er oppgitt korrekt ",
          "navn på den, og at den er formatert som et excel-regneark.",
          pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
  }
  
  navnVM <- try(read.table(filsti %+% kolonnenavn, 
                           header = TRUE, sep = ";", quote = "", 
                           na.strings = "", strip.white = TRUE, comment.char = "", 
                           stringsAsFactors = FALSE, fileEncoding="latin1"))
  if (inherits(navnVM, "try-error")) {
    OK <- FALSE
    skriv("Dette skjedde en feil under innlesing av fila \"", filsti %+%
            kolonnenavn, ". Sjekk om fila fins, at det er oppgitt korrekt ",
          "navn på den, og at den er formatert som semikolondelt tabell.",
          pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
  }
  
  if (OK) {
    # Så "oversettes" kolonnenavnene
    if (colnames(DATA) %=% navnVM$vm) {
      colnames(DATA) <- navnVM$nytt
      if (all(nyeKolonner %in% navnVM$nytt)) {
        DATA <- DATA[, nyeKolonner]
        DATA$verdi <- as.numeric(erstatt(DATA$verdi, ",", "."))
        DATA$antverdi <- as.numeric(DATA$antverdi)
        DATA$antverdi[which(is.na(DATA$antverdi))] <- 1
      } else {
        OK <- FALSE
        skriv("Kolonnenavnene i \"", kolonnenavn, "\" er ikke som forventa!",
              pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
      }
    } else {
      OK <- FALSE
      skriv("Kolonnenavnene i den innleste datafila fra \"vannmiljø\" er ikke " %+%
              "som forventa!", pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
    }
  }
  if (OK) {
    skriv("Innlesing av ", nrow(DATA), " vannmålinger var vellykka.", 
          linjer.over = 1)
    ut <- DATA
  }
  return(ut)
}

