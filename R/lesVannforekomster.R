### lesVannforekomster
# Funksjoner til NI_vannf
# ved Hanno Sandvik
# februar 2024
# se https://github.com/NINAnor/NI_vannf
###



lesVannforekomster <- function(vannkategori = c("L", "R", "C"),
                               filsti = "data",
                               kolonnenavn = "navnVN.csv") {
  
  # Kolonner som datarammen V trenger for å fungere:
  nyeKolonner <- c( 
    "id",
    "nam",
    "typ",
    "nas",
    "int",
    "kat",
    "reg",
    "son",
    "stø",
    "alk",
    "hum",
    "tur",
    "dyp",
    "kys",
    "sal",
    "tid",
    "eks",
    "mix",
    "opp",
    "str",
    "smvf",
    "øtil",
    "øpot",
    "ktil",
    "ømål",
    "pmål",
    "kmål",
    "vassdrag",
    "område",
    "region",
    "knr",
    "kommune",
    "fylke",
    "hoh",
    "areal",
    "dybde",
    "tilsig",
    "utmx",
    "utmy",
    "lat",
    "long"
  )
  
  OK <- TRUE
  V <- V. <- list()
  
  vannkategori <- toupper(vannkategori) %A% c("L", "R", "C")
  if (length(vannkategori) %=% 0) {
    OK <- FALSE
    skriv("Parameteren \"vannkategori\" må være minst én av bokstavene \"L\", ",
          "\"R\" og \"C\"!", pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
  }
  if (OK) {
    # Innlesing av "tolkningstabellen": 
    # Hvilke kolonner i vann-nett-tabellen svarer til hvilke kolonner i V
    if (nchar(filsti)) {
      if (substr(filsti, nchar(filsti), nchar(filsti)) %!=% "/" &
          substr(filsti, nchar(filsti), nchar(filsti)) %!=% "\\") {
        filsti <- filsti %+% "/"
      }
    }
    navnV <- try(read.table(filsti %+% kolonnenavn, 
                            header = TRUE, sep = ";", quote = "", 
                            na.strings = "", strip.white = TRUE, comment.char = "", 
                            stringsAsFactors = FALSE, fileEncoding="latin1"))
    if (inherits(navnV, "try-error")) {
      OK <- FALSE
      skriv("Dette skjedde en feil under innlesing av fila \"", filsti %+%
              kolonnenavn, ". Sjekk om fila fins, at det er oppgitt korrekt ",
            "navn på den, og at den er formatert som semikolondelt tabell.",
            pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
    }
  }
  if (OK) {
    # Innlesing av filene som har blitt lasta ned fra vann-nett
    for (i in vannkategori) {
      if (OK) {
        # leser inn separate tabeller for innsjø- (L), elve- (R) og
        # kystvannforekomster (C)
        test <- try(readLines(filsti %+% "V-" %+% i %+% ".csv", 1))
        if (inherits(test, "try-error")) {
          OK <- FALSE
          skriv("Dette skjedde en feil under innlesing av fila \"", filsti,
                "V-", i, ".csv", ". Sjekk om fila fins, og at det er oppgitt ",
                "korrekt navn på den.",
                pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
        }
      }
      if (OK) {
        # først testes det om tabellformatet er som forventa, 
        # nemlig som tabulatordelt tabell
        if (length(strsplit(test, "\t")[[1]]) < 20) {
          OK <- FALSE
          skriv("Datafila fra vann-nett forventes å være en tabulator-delt " %+%
                  "tabell, men hadde et annet format.",
                pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
        }
      }
      if (OK) {
        V[[i]] <- try(read.table(filsti %+% "V-" %+% i %+% ".csv",
                                 header = TRUE, sep = "\t", quote = "\"", 
                                 na.strings = "Not applicable", 
                                 strip.white = TRUE, comment.char = "", 
                                 stringsAsFactors = FALSE, fileEncoding="latin1"))
        if (inherits(V[[i]], "try-error")) {
          OK <- FALSE
          skriv("Dette skjedde en feil under innlesing av fila \"", filsti,
                "V-", i, ".csv", ". Sjekk om fila fins, og at det er oppgitt ",
                "korrekt navn på den.",
                pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
        }
      }
      if (OK) {
        # Tabellene fra vann-nett kan inneholde flere rader per vannforekomst
        # (nemlig en per påvirkning per vannforekomst). Her fjernes alle bortsett
        # fra den første.
        fjern <- numeric(0)
        for (j in unique(V[[i]][, 1])) {
          fjern <- c(fjern, which(V[[i]][, 1] == j)[-1]) 
        }
        V[[i]] <- V[[i]][-fjern, ]
        V[[i]] <- V[[i]][order(V[[i]][, 1]), ]
        w <- which(is.na(navnV[, i]))
        if (colnames(V[[i]]) %=% navnV[-w, i]) {
          colnames(V[[i]]) <- navnV$nytt[-w]
        } else {
          OK <- FALSE
          skriv("Kolonnenavnene i den innleste fila \"V-" %+% i %+%
                  ".csv\" er ikke som forventa!", 
                pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
        }
      }
      if (OK) {
        # Så "oversettes" kolonnenavnene
        if (all(nyeKolonner %in% navnV$nytt)) {
          V.[[i]] <- data.frame(id = V[[i]]$id)
          for (j in 2:length(nyeKolonner)) {
            if (nyeKolonner[j] %in% colnames(V[[i]])) {
              V.[[i]][, nyeKolonner[j]] <- V[[i]][, nyeKolonner[j]]
            } else {
              V.[[i]][, nyeKolonner[j]] <- NA
            }
          }
        } else {
          OK <- FALSE
          skriv("Kolonnenavnene i \"navnVN.csv\" er ikke som forventa!",
                pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
        }
      }
    }
    if (OK) {
      # Til slutt kombineres dataene fra de tre vannkategoriene i én felles dataramme
      V <- V.[[1]]
      if (length(vannkategori) > 1) {
        for (k in 2:length(vannkategori)) {
          V <- rbind(V, V.[[k]])
        }
      }
    }
  }
  if (OK) {
    # Koding og overfladisk kontroll av vanntypologien
    V$kat <- substr(V$typ, 1, 1)
    if (all(V$kat %in% c("L", "R", "C"))) {
      for (vkat in vannkategori) {
        w <- which(V$kat == vkat)
        hvilke <- get("Typologi" %+% vkat)
        Vanntyper$reg <- Vanntyper[["reg" %+% vkat]]
#        hvilke <- list(L = 2:8, R = 2:7, C = c(2, 9:15))[[vkat]]
        for (i in 1:length(hvilke)) {
          verdi <- substr(V$typ[w], i + 1, i + 1)
          na <- which(!(verdi %in% Vanntyper[[hvilke[i]]]))
          if (length(na)) {
            skriv("Noen vannforekomster har ukjente verdier for " %+%
                    tolower(Typologi[hvilke[i]]) %+% ":",
                  pre = "OBS: ", linjer.over = 1)
            for (j in 1:length(unique(verdi[na]))) {
              ukjent <- sort(unique(verdi[na]))[j]
              skriv(length(which(verdi[na] == ukjent)), " med \"",
                    ukjent %+% "\" = \"", 
                    V[w[which(verdi == ukjent)], hvilke[i]][1],
                    "\"", pre = "* ")
            }
            skriv("Disse blir satt til <NA>!")
            verdi[na] <- NA
          }
          for (j in unique(verdi)) {
            if (length(unique(V[w[which(verdi == j)], hvilke[i]])) > 1) {
#              if (length(unique(V[w[which(verdi == j)], 
#                                names(Vanntyper)[hvilke[i]]])) > 1) {
              skriv("Verdien ", j, " av ", Typologi[hvilke[i]],
                    " har ulike beskrivelser:", pre = "OBS: ")
              skriv(paste(unique(V[w[which(verdi == j)], hvilke[i]]), 
                          collapse = ", "))
              skriv("Dette blir ignorert!")
            }
          }
          V[w, hvilke[i]] <- verdi
        }
        if (vkat %=% "L") {
          # Estimert dybde likestilles med kjent dybde
          for (d in 4:6) {
            ww <- which(V$kat == vkat & V$dyp == d)
            if (length(ww)) {
              V$dyp[ww] <- d - 3
              V$typ[ww] <- substr(V$typ[ww], 1, 7) %+% (d - 3)
            }
          }
        }
      }
    } else {
      skriv("Det ble funnet ukjente vannkategorier (\"",
            paste(sort(unique(V$kat %-% c("L", "R", "C"))), collapse = "\", \""),
            "\")!", pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
    }
    
    # Kolonnen for sterkt modifiserte vannforekomster gjøre om til en logisk variabel
    V$smvf <- (V$smvf == "Sterkt modifisert")
    
    # Sjekk av kolonnene for økologisk og kjemisk tilstand, potensial og mål
    for (i in 1:2) {
      kolonne <- c("øtil", "ømål")[i]
      klasser <- c("Svært god", "God", "Moderat", "Dårlig", "Svært dårlig")
      V[which(V[, kolonne] == "Svært godt"), kolonne] <- "Svært god"
      V[which(V[, kolonne] ==       "Godt"), kolonne] <-       "God"
      na <- which(!(V[, kolonne] %in% klasser))
      if (length(na)) {
        ukjent <- sort(unique(V[na, kolonne]))
        skriv("Noen vannforekomster har ukjente verdier for økologisk " %+% 
                c("tilstand", "miljømål")[i] %+% ":", 
              pre = "OBS: ", linjer.over = 1)
        for (j in ukjent) {
          skriv(length(which(V[na, kolonne] == j)) %+%
                  " med \"" %+% j %+% "\"", pre = "* ")
        }
        skriv("Disse blir satt til <NA>!")
      }
      V[na, kolonne] <- NA
    }
    for (i in 1:2) {
      kolonne <- c("øpot", "pmål")[i]
      klasser <- c("Svært godt", "Godt", "Moderat", "Dårlig", "Svært dårlig")
      V[which(V[, kolonne] == "Svært god"), kolonne] <- "Svært godt"
      V[which(V[, kolonne] ==       "God"), kolonne] <-       "Godt"
      na <- which(!(V[, kolonne] %in% klasser))
      if (length(na)) {
        ukjent <- sort(unique(V[na, kolonne]))
        skriv("Noen vannforekomster har ukjente verdier for økologisk " %+% 
                c("potensial", "potensial miljømål")[i] %+% ":",
              pre = "OBS: ", linjer.over = 1)
        for (j in ukjent) {
          skriv(length(which(V[na, kolonne] == j)) %+% 
                  " med \"" %+% j %+% "\"", pre = "* ")
        }
        skriv("Disse blir satt til <NA>!")
      }
      V[na, kolonne] <- NA
    }
    for (i in 1:2) {
      kolonne <- c("ktil", "kmål")[i]
      klasser <- c("God", "Dårlig")
      V[which(V[, kolonne] ==       "Godt"), kolonne] <-       "God"
      na <- which(!(V[, kolonne] %in% klasser))
      if (length(na)) {
        ukjent <- sort(unique(V[na, kolonne]))
        skriv("Noen vannforekomster har ukjente verdier for kjemisk " %+% 
                c("tilstand", "miljømål")[i] %+% ":", 
              pre = "OBS: ", linjer.over = 1)
        for (j in ukjent) {
          skriv(length(which(V[na, kolonne] == j)) %+%
                  " med \"" %+% j %+% "\"", pre = "* ")
        }
        skriv("Disse blir satt til <NA>!")
      }
      V[na, kolonne] <- NA
    }
  }
  return(V)
}

