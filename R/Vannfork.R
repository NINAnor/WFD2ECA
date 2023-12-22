### Vannforekomster, -lokaliteter m.m.
# Funksjoner til NI_vannf
# ved Hanno Sandvik
# desember 2023
# se https://github.com/NINAnor/NI_vannf
###



lesVannforekomster <- function(vannkategori = c("L", "R", "C"),
                               filsti = "",
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
        hvilke <- list(L = 2:8, R = 2:7, C = c(2, 9:15))[[vkat]]
        for (i in 1:length(hvilke)) {
          verdi <- substr(V$typ[w], i + 1, i + 1)
          na <- which(!(verdi %in% Vanntyper[[hvilke[i]]]))
          if (length(na)) {
            skriv("Noen vannforekomster har ukjente verdier for " %+%
                  Typologi[hvilke[i]] %+% ":",
                  pre = "OBS: ", linjer.over = 1)
            for (j in 1:length(unique(verdi[na]))) {
              ukjent <- sort(unique(verdi[na]))[j]
              skriv(length(which(verdi[na] == ukjent)), " med \"",
                    ukjent %+% "\" = \"", 
                    V[w[which(verdi == ukjent)], names(Vanntyper)[hvilke[i]]][1],
                    "\"", pre = "* ")
            }
            skriv("Disse blir satt til <NA>!")
            verdi[na] <- NA
          }
          for (j in unique(verdi)) {
            if (length(unique(V[w[which(verdi == j)], 
                                names(Vanntyper)[hvilke[i]]])) > 1) {
              skriv("Verdien ", j, " av ", Typologi[hvilke[i]],
                    " har ulike beskrivelser:", pre = "OBS: ")
              skriv(paste(unique(V[w[which(verdi == j)], 
                                   names(Vanntyper)[hvilke[i]]]), 
                          collapse = ", "))
              skriv("Dette blir ignorert!")
            }
          }
          V[w, names(Vanntyper)[hvilke[i]]] <- verdi
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



lesInnsjodatabasen <- function(filnavn = "Innsjo_Innsjo.dbf",
                               kolonnenavn = "navnNVEl.csv") {
  
  # Kolonner som datarammen "nve" trenger for å fungere:
  nyeKolonner <- c( 
    "lnr",
    "nam",
    "reg",
    "mnr",
    "hoh",
    "areal",
    "arealn",
    "tilsig",
    "vassdrag",
    "område",
    "lat",
    "lon"
  )
  
  OK  <- TRUE
  nve <- NULL
  
  # Innlesing av "tolkningstabellen": Hvilke kolonner i NVEs tabell
  # svarer til hvilke kolonner i "nve"
  navnNVE <- try(read.table(kolonnenavn, 
                            header = TRUE, sep = ";", quote = "", 
                            na.strings = "", strip.white = TRUE, comment.char = "", 
                            stringsAsFactors = FALSE, fileEncoding="latin1"))
  if (inherits(navnNVE, "try-error")) {
    OK <- FALSE
    skriv("Dette skjedde en feil under innlesing av fila \"",
          kolonnenavn, ". Sjekk om fila fins, at det er oppgitt korrekt ",
          "navn på den, og at den er formatert som semikolondelt tabell.",
          pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
  }
  if (OK) {
    # Innlesing av dbf-delen av NVEs datasett
    nve <- try(read.dbf(filnavn, T))
    if (inherits(nve, "try-error")) {
      OK <- FALSE
      skriv("Dette skjedde en feil under innlesing av fila \"",
            filnavn, ". Sjekk om fila fins, at det er oppgitt korrekt ",
            "navn på den, og at den er formatert som semikolondelt tabell.",
            pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
    }
  }
  if (OK) {
    for (i in 1:ncol(nve)) {
      if (is.character(nve[, i])) {
        Encoding(nve[, i]) <- "latin1"
      }
    }

    # "Oversettelse" av kolonnenavn
    w <- which(is.na(navnNVE$NVE))
    if (colnames(nve) %=% navnNVE$NVE[-w]) {
      colnames(nve) <- navnNVE$nytt[-w]
    } else {
      OK <- FALSE
      skriv("Kolonnenavnene i den innleste fila \"", filnavn,
            "\" er ikke som forventa!", 
            pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
    }
  }
  if (OK) {
    if (all(nyeKolonner %in% navnNVE$nytt)) {
      nveL <- data.frame(lnr = nve$lnr)
      for (j in 2:length(nyeKolonner)) {
        if (nyeKolonner[j] %in% colnames(nve)) {
          nveL[, nyeKolonner[j]] <- nve[, nyeKolonner[j]]
        } else {
          nveL[, nyeKolonner[j]] <- NA
        }
      }
    } else {
      OK <- FALSE
      skriv("Kolonnenavnene i \"", kolonnenavn, "\" er ikke som forventa!",
            pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
    }
  }
  if (OK) {
    # Kolonnen for sterkt modifiserte vannforekomster gjøre om til en logisk variabel
    nveL$reg <- (nveL$reg %inneholder% "ulert")
    if (!any(nveL$reg)) {
      skriv("Det var ikke mulig å identifisere regulerte innsjøer i NVEs ",
            "innsjødatabase, fordi betegnelsen ser ut til å være endra. ",
            "Variabelen er satt til <NA>.", 
            pre = "OBS: ", linjer.over = 1)
      nveL$reg <- NA
    }
    
    # Sjekk av kolonner med tallverdier
    for (i in 5:8) {
      w <- which(nveL[, i] < 0)
      if (length(w)) {
        skriv("For " %+% length(w) %+% " innsjøer var " %+%
              c("", "", "", "", "høyden over havet", "arealet", 
                "det norske arealet", "tilsigsfeltet")[i] %+%
              " angitt å være negativ. Disse ble satt til <NA>.",
              pre = "OBS: ", linjer.over = 1)
        nveL[w, i] <- NA
      }
    }
    w <- which(is.na(nveL$areal) & !is.na(nveL$arealn))
    if (length(w)) {
      skriv("For " %+% length(w) %+% " innsjøer var det norske arealet angitt, ",
            "men ikke det totale. For disse ble totalarealet satt til det ",
            "norske arealet.", pre = "OBS: ", linjer.over = 1)
      nveL$areal[w] <- nveL$arealn[w]
    }
    w <- which(nveL$areal < nveL$arealn)
    if (length(w)) {
      skriv("For " %+% length(w) %+% " innsjøer var det totale arealet angitt å ",
            "være mindre enn det norske. For disse ble totalarealet satt til det ",
            "norske arealet.", pre = "OBS: ", linjer.over = 1)
      nveL$areal[w] <- nveL$arealn[w]
    }
    w <- which(nveL$tilsig < nveL$arealn)
    if (length(w)) {
      skriv("For " %+% length(w) %+% " innsjøer var deres tilsigsfelt angitt å ",
            "være mindre enn deres areal. For disse ble tilsigsfeltet satt til ",
            "arealet.", pre = "OBS: ", linjer.over = 1)
      nveL$tilsig[w] <- nveL$areal[w]
    }
    
    # Innlesing av formfila av NVEs datasett ¤¤¤ dette er utsatt!
    #koord <- st_read("innsjo_innsjo.shp") # , layer_options="ENCODING=latin1")
    #Sys.setlocale("LC_ALL", "")
    #for (i in 1:nrow(nveL)) {
    #  nveL$lat[i] <- mean(koord$geometry[[i]][[1]][[1]][, 2])
    #  nveL$lon[i] <- mean(koord$geometry[[i]][[1]][[1]][, 1])
    #}
  }
  return(nveL)
}
  


lesVannlokaliteter <- function(vannkategori = c("L", "R", "C"),
                               filsti = "",
                               kolonnenavn = "navnVL.csv") {
  
  # Kolonner som datarammen VL trenger for å fungere:
  nyeKolonner <- c(
    "lokid",
    "lokkod",
    "loknam",
    "sjønr",
    "id",
    "kat",
    "X",
    "Y"
  )
  
  OK <- TRUE
  VL <- list()
  
  vannkategori <- toupper(vannkategori) %A% c("L", "R", "C")
  if (length(vannkategori) %=% 0) {
    OK <- FALSE
    skriv("Parameteren \"vannkategori\" må være minst én av bokstavene \"L\", ",
          "\"R\" og \"C\"!", pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
  }
  if (OK) {
    # Innlesing av "tolkningstabellen": Hvilke kolonner i vannlokalitetstabellen
    # svarer til hvilke kolonner i VL
    if (nchar(filsti)) {
      if (substr(filsti, nchar(filsti), nchar(filsti)) %!=% "/" &
          substr(filsti, nchar(filsti), nchar(filsti)) %!=% "\\") {
        filsti <- filsti %+% "/"
      }
    }
    navnVL <- try(read.table(filsti %+% kolonnenavn, 
                             header = TRUE, sep = ";", quote = "", 
                             na.strings = "", strip.white = TRUE, comment.char = "", 
                             stringsAsFactors = FALSE, fileEncoding="latin1"))
    if (inherits(navnVL, "try-error")) {
      OK <- FALSE
      skriv("Dette skjedde en feil under innlesing av fila \"", filsti %+%
            kolonnenavn, ". Sjekk om fila fins, at det er oppgitt korrekt ",
            "navn på den, og at den er formatert som semikolondelt tabell.",
            pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
    }
  }
  if (OK) {
    # Innlesing av vannlokalitetsfilene som har blitt lasta ned fra vannmiljø
    VL <- list()
    for (i in vannkategori) {
      VL[[i]] <- try(as.data.frame(read_xlsx(filsti %+% "VL-" %+% i %+% ".xlsx", 
                                             col_types = "text")))
      if (inherits(VL[[i]], "try-error")) {
        OK <- FALSE
        skriv("Dette skjedde en feil under innlesing av fila \"", filsti,
              "VL-", i, ".xlsx", ". Sjekk om fila fins, og at det er oppgitt ",
              "korrekt navn på den.",
              pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
      }
      if (OK) {
        if (colnames(VL[[i]]) %=% navnVL$VL) {
          colnames(VL[[i]]) <- navnVL$nytt
          if (all(nyeKolonner %in% navnVL$nytt)) {
            VL[[i]] <- VL[[i]][, nyeKolonner]
          } else {
            OK <- FALSE
            skriv("Kolonnenavnene i \"", kolonnenavn, "\" er ikke som forventa!",
                  pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
          }
        } else {
          OK <- FALSE
          skriv("Kolonnenavnene i den innleste fila \"VL-" %+% i %+%
                  ".csv\" er ikke som forventa!",
                pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
        }
      }
    }
    if (OK) {
      VL. <- VL[[1]]
      if (length(vannkategori) > 1) {
        for (k in 2:length(vannkategori)) {
          VL. <- rbind(VL., VL[[k]])
        }
      }
      VL <- VL.
    }
  }
  if (OK) {
    VL$lokid <- as.numeric(VL$lokid)
    VL$sjønr <- as.numeric(VL$sjønr)
    VL$X     <- as.numeric(VL$X)
    VL$Y     <- as.numeric(VL$Y)
    # Fjern koordinater som ikke kan stemme
    w <- which(VL$X < -80000 | VL$X > 1200000 | VL$Y < 6400000 | VL$Y > 9000000)
    if (length(w)) {
      skriv("For " %+% length(w) %+% " vannlokaliteter var det oppgitt ",
            "koordinater som ligger utenfor Norge.\n",
            "Disse koordinatene ble satt til <NA>.",
            pre = "OBS: ", linjer.over = 1)
      VL$X[w] <- VL$Y[w] <- NA
    }
  }
  return(VL)
}




oppdaterVannforekomster <- function(V, 
                                    nve,
                                    slingringsmonn = 0.1) {
  
  # Fyll på V med data fra nve:
  for (i in which(V$kat == "L")) {
    ID <- as.numeric(unlist(strsplit(V$id[i], "-"))[2])
    if (is.na(ID)) cat(i, V$id[i], "\n")
    w <- which(nve$lnr == ID)
    if (length(w)) {
      w <- w[1]
      V$hoh[i]    <- nve$hoh[w]
      V$areal[i]  <- nve$areal[w]
      V$tilsig[i] <- nve$tilsig[w]
      V$lat[i]    <- nve$lat[w]
      V$long[i]   <- nve$lon[w]
    }
  }
  
  # Sjekk av størrelsesklasser mot faktiske arealer
  slingringsmonn <- 0.1
  bindestreker <- lengths(lengths(gregexec("-", V$id)))
  forLiten <- forStor <- 0
  w <- which(V$kat == "L" & is.na(V$areal))
  if (length(w)) V$areal[w] <- 15 * 10^(as.numeric(V$stø[w]) - 3)
  for (i in 1:3) {
    w <- which(V$kat == "L" & V$stø == i & bindestreker == 2 &
                 V$areal > (5 * 10^(i - 2) * (1 + slingringsmonn)))
    forLiten <- forLiten + length(w)
    if (length(w)) V$stø[w] <- i + 1
  }
  for (i in 4:2) {
    w <- which(V$kat == "L" & V$stø == i &
                 V$areal < (5 * 10^(i - 3) * (1 - slingringsmonn)))
    forStor <- forStor + length(w)
    if (length(w)) V$stø[w] <- i - 1
  }
  if (forLiten) {
    skriv("For " %+% forLiten %+% " innsjøer ble størrelsesklassen " %+%
          "justert opp basert på deres faktiske areal.",
          pre = "OBS: ", linjer.over = 1)
  }
  if (forStor) {
    skriv("For " %+% forStor %+% " innsjøer ble størrelsesklassen " %+%
          "justert ned basert på deres faktiske areal.",
          pre = "OBS: ", linjer.over = 1)
  }
  
  # Sjekk av høydesone mot faktiske høyder over havet
  forLav <- forHoy <- 0
  w <- which(V$kat == "L" & is.na(V$hoh) & V$son == "L")
  if (length(w)) V$hoh[w] <- 50
  w <- which(V$kat == "L" & is.na(V$hoh) & V$son == "M" & 
               V$reg %in% c("E","S","W","M"))
  if (length(w)) V$hoh[w] <- 400
  w <- which(V$kat == "L" & is.na(V$hoh) & V$son == "M" & 
               V$reg %in% c("N", "F"))
  if (length(w)) V$hoh[w] <- 50
  w <- which(V$kat == "L" & is.na(V$hoh) & V$son == "H" & 
               V$reg %in% c("E","S","W"))
  if (length(w)) V$hoh[w] <- 800
  w <- which(V$kat == "L" & is.na(V$hoh) & V$son == "H" & 
               V$reg == "M")
  if (length(w)) V$hoh[w] <- 600
  w <- which(V$kat == "L" & is.na(V$hoh) & V$son == "H" & 
               V$reg %in% c("N", "F"))
  if (length(w)) V$hoh[w] <- 200
  w <- which(V$kat == "L" & V$son == "L" & V$hoh > 800 * (1 + slingringsmonn))
  forLav <- forLav + length(w)
  if (length(w)) V$son[w] <- "H"
  w <- which(V$kat == "L" & V$son == "L" & V$hoh > 200 * (1 + slingringsmonn))
  forLav <- forLav + length(w)
  if (length(w)) V$son[w] <- "M"
  w <- which(V$kat == "L" & V$son == "M" & V$hoh > 500 * (1 + slingringsmonn) &
               V$reg %in% c("N", "F"))
  forLav <- forLav + length(w)
  if (length(w)) V$son[w] <- "H"
  w <- which(V$kat == "L" & V$son == "M" & V$hoh < 200 * (1 - slingringsmonn) &
               V$reg %in% c("E", "S", "W", "M"))
  forHoy <- forHoy <- length(w)
  if (length(w)) V$son[w] <- "L"
  w <- which(V$kat == "L" & V$son == "H" & V$hoh < 200 * (1 - slingringsmonn) &
               V$reg %in% c("E", "S", "W", "M"))
  forHoy <- forHoy <- length(w)
  if (length(w)) V$son[w] <- "L"
  w <- which(V$kat == "L" & V$son == "H" & V$hoh < 200 * (1 - slingringsmonn) &
               V$reg %in% c("N", "F"))
  forHoy <- forHoy <- length(w)
  if (length(w)) V$son[w] <- "M"
  w <- which(V$kat == "L" & V$son == "H" & V$hoh < 400 * (1 - slingringsmonn) &
               V$reg %in% c("E", "S", "W", "M"))
  forHoy <- forHoy <- length(w)
  if (length(w)) V$son[w] <- "M"
  if (forLav) {
    skriv("For " %+% forLav %+% " innsjøer ble høydesonen " %+%
          "justert opp basert på deres faktiske høyde over havet.",
          pre = "OBS: ", linjer.over = 1)
  }
  if (forHoy) {
    skriv("For " %+% forHoy %+% " innsjøer ble høydesonen " %+%
          "justert ned basert på deres faktiske høyde over havet.",
          pre = "OBS: ", linjer.over = 1)
  }
  return(V)
}



lesMaalinger <- function(filnavn,
                         filsti = "",
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
  DATA <- as.data.frame(read_xlsx(filnavn, col_types = "text"))
  
  # Innlesing av "tolkningstabellen": 
  # Hvilke kolonner i vannmiljø-tabellen svarer til hvilke kolonner i DATA
  if (nchar(filsti)) {
    if (substr(filsti, nchar(filsti), nchar(filsti)) %!=% "/" &
        substr(filsti, nchar(filsti), nchar(filsti)) %!=% "\\") {
      filsti <- filsti %+% "/"
    }
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
        skriv("Kolonnenavnene i \"", kolonnenavn, "\" er ikke som forventa!",
              pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
      }
    } else {
      skriv("Kolonnenavnene i den innleste datafila fra \"vannmiljø\" er ikke " %+%
            "som forventa!", pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
    }
    return(DATA)
  }
}


