

##########################################
# Forberedelser

# Laste inn nødvendige R-pakker
library(foreign)
library(sf)
library(readxl)


# Hjelpefunksjoner

# Tester om argumentene er like - ikke følsom for avrundingsfeil!
"%=%" <- function(arg1, arg2) { 
  attributes(arg1) <- NULL
  attributes(arg2) <- NULL
  return(identical(all.equal(arg1, arg2), TRUE))
}

# Limer sammen tekstvariabler
"%+%" <- function(string1, string2) paste0(string1, string2)

# Sjekker om en variabel inneholder en angitt søketekst
"%contains%" <- function(vector, search) grepl(search, vector, fixed = TRUE)


# Variabler/konstanter som trengs

Typologi <- c( # inneholder navnene på typologifaktorene
  "kategori",
  "økoregion",
  "klimaregion",
  "størrelse",
  "alkalitet",
  "humusinnhold",
  "turbiditet",
  "dybde",
  "kysttype",
  "salinitet",
  "tidevann",
  "bølgeeksponering",
  "miksing",
  "oppholdstid",
  "strøm"
)

Vanntyper <- list( # angir mulige verdier for alle typologifaktorer
  kat = c("C", "L", "R"),
  reg = c("B", "E", "F", "G", "H", "M", "N", "S", "W"),
  son = c("L", "M", "H"),
  stø = 1:5,
  alk = 1:8,
  hum = 0:4,
  tur = 1:3,
  dyp = 1:6,
  kys = 1:8,
  sal = 1:7,
  tid = 1:2,
  eks = 1:3,
  mix = 1:3,
  opp = 1:3,
  str = 1:3
)


##################################################################
# Vannforekomster:
# * Må lastes ned som excel-fil (csv) fra Vann-nett > Rapporter > Vanntyper >
#   Innsjøvannforekomster med vanntypeparametere, påvirkninger, tilstand, potensial og miljømål

nyeKolonner <- c( # kolonner som datarammen V trenger for å fungere
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

# Innlesing av "tolkningstabellen": Hvilke kolonner i vann-nett-tabellen
# svarer til hvilke kolonner i V
navnV <- read.table("navnVN.csv", 
  header = TRUE, sep = ";", quote = "", 
  na.strings = "", strip.white = TRUE, comment.char = "", 
  stringsAsFactors = FALSE, fileEncoding="latin1")

# Innlesing av filene som har blitt lasta ned fra vann-nett
V <- V. <- list()
for (i in c("L", "R", "C")) {
  # leser inn separate tabeller for innsjø- (L), elve- (R) og
  # kystvannforekomster (C)
  test <- readLines("V-" %+% i %+% ".csv", 1)
  # først testes det om tabellformatet er som forventa, 
  # nemlig som tabulatordelt tabell
  if (length(strsplit(test, "\t")[[1]]) < 20) {
    error("FEIL: Datafila fra vann-nett forventes å være en tabulator-delt " %+%
    "tabell, men hadde et annet format.\n") # ¤¤
  }
  V[[i]] <- read.table("V-" %+% i %+% ".csv",
    header = TRUE, sep = "\t", quote = "\"", 
    na.strings = "Not applicable", strip.white = TRUE, comment.char = "", 
    stringsAsFactors = FALSE, fileEncoding="latin1")
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
    cat("FEIL: Kolonnenavnene i den innleste fila \"V-" %+% i %+%
        ".csv\" er ikke som forventa!\n\n")
  }
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
    cat("FEIL: Kolonnenavnene i \"navnVN.csv\" er ikke som forventa!\n\n")
  }
}
# Til slutt kombineres dataene fra de tre vannkategoriene i én felles dataramme
V <- rbind(V.[["L"]], V.[["R"]], V.[["C"]])

# Koding og overfladisk kontroll av vanntypologien
V$kat <- substr(V$typ, 1, 1)
if (all(V$kat %in% c("L", "R", "C"))) {
  for (vkat in c("L", "R", "C")) {
    w <- which(V$kat == vkat)
    hvilke <- list(L = 2:8, R = 2:7, C = c(2, 9:15))[[vkat]]
    for (i in 1:length(hvilke)) {
      verdi <- substr(V$typ[w], i + 1, i + 1)
      na <- which(!(verdi %in% Vanntyper[[hvilke[i]]]))
      if (length(na)) {
        cat("OBS: Noen vannforekomster har ukjente verdier for " %+%
            Typologi[hvilke[i]] %+% ":\n")
        for (j in 1:length(unique(verdi[na]))) {
          ukjent <- sort(unique(verdi[na]))[j]
          cat("* " %+% length(which(verdi[na] == ukjent)) %+% " med \"" %+%
              ukjent %+% "\" = \"" %+% 
              V[w[which(verdi == ukjent)], names(Vanntyper)[hvilke[i]]][1] %+%
              "\"\n")
        }
        cat("Disse blir satt til <NA>!\n\n")
        verdi[na] <- NA
      }
      for (j in unique(verdi)) {
        if (length(unique(V[w[which(verdi == j)], 
                            names(Vanntyper)[hvilke[i]]])) > 1) {
          cat("OBS: Verdien " %+% j %+% " av " %+% Typologi[hvilke[i]] %+%
                " har ulike beskrivelser:\n" %+%
                paste(unique(V[w[which(verdi == j)], names(Vanntyper)[hvilke[i]]]), 
                      collapse = ", ") %+%
                "\nDette blir ignorert!\n\n")
        }
      }
      V[w, names(Vanntyper)[hvilke[i]]] <- verdi
    }
  }
} else {
  cat("FEIL: Det ble funnet ukjente vanntyper (\"" %+%
      paste(sort(unique(V$kat %-% c("L", "R", "C"))), collapse = "\", \"") %+%
      "\")!\n\n")
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
    cat("OBS: Noen vannforekomster har ukjente verdier for økologisk " %+% 
          c("tilstand", "miljømål")[i] %+% ":\n")
    for (j in ukjent) {
      cat("* " %+% length(which(V[na, kolonne] == j)) %+%
          " med \"" %+% j %+% "\"\n")
    }
    cat("Disse blir satt til <NA>!\n\n")
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
    cat("OBS: Noen vannforekomster har ukjente verdier for økologisk " %+% 
          c("potensial", "potensial miljømål")[i] %+% ":\n")
    for (j in ukjent) {
      cat("* " %+% length(which(V[na, kolonne] == j)) %+% 
          " med \"" %+% j %+% "\"\n")
    }
    cat("Disse blir satt til <NA>!\n\n")
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
    cat("OBS: Noen vannforekomster har ukjente verdier for kjemisk " %+% 
          c("tilstand", "miljømål")[i] %+% ":\n")
    for (j in ukjent) {
      cat("* " %+% length(which(V[na, kolonne] == j)) %+%
          " med \"" %+% j %+% "\"\n")
    }
    cat("Disse blir satt til <NA>!\n\n")
  }
  V[na, kolonne] <- NA
}

# Opprydning i variabler
rm(V., fjern, hvilke, i, j, klasser, kolonne, 
   na, navnV, test, ukjent, verdi, vkat, w)


#################################################################################

# NVEs innsjødatabase
# * Må lastes ned som formfil fra NVE:
# http://nedlasting.nve.no/gis/ > Innsjø > Innsjø >> 
#   kartformat "ESRI shapefil (.shp)" > 
#   koordinatsystem "Geografiske koordinater ETRS89" > 
#   utvalgsmetode "Overlapper" > dekningsområde "Landsdekkende"

nyeKolonner <- c( # kolonner som datarammen "nve" trenger for å fungere
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

# Innlesing av "tolkningstabellen": Hvilke kolonner i NVEs tabell
# svarer til hvilke kolonner i "nve"
navnNVE <- read.table("navnNVEl.csv", 
                      header = TRUE, sep = ";", quote = "", 
                      na.strings = "", strip.white = TRUE, comment.char = "", 
                      stringsAsFactors = FALSE, fileEncoding="latin1")

# Innlesing av dbf-delen av NVEs datasett
nve <- read.dbf("innsjo_innsjo.dbf", T)
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
  cat("FEIL: Kolonnenavnene i den innleste fila \"Innsjo_Innsjo.dbf\" " %+%
      "er ikke som forventa!\n\n")
}
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
  cat("FEIL: Kolonnenavnene i \"navnNVE.csv\" er ikke som forventa!\n\n")
}

# Kolonnen for sterkt modifiserte vannforekomster gjøre om til en logisk variabel
nveL$reg <- (nveL$reg %contains% "egulert")
if (!any(nveL$reg)) {
  cat("OBS: Det var ikke mulig å identifisere regulerte innsjøer i NVEs innsjødatabase,\n")
  cat("fordi betegnelsen ser ut til å være endra. Variabelen er satt til <NA>.\n\n")
  nveL$reg <- NA
}

# Sjekk av kolonner med tallverdier
for (i in 5:8) {
  w <- which(nveL[, i] < 0)
  if (length(w)) {
    cat("OBS: For " %+% length(w) %+% " innsjøer var " %+%
          c("", "", "", "", "høyden over havet", "arealet", "det norske arealet", "tilsigsfeltet")[i] %+%
          " angitt å være negativ.\n")
    cat("Disse ble satt til <NA>.\n\n")
    nveL[w, i] <- NA
  }
}
w <- which(is.na(nveL$areal) & !is.na(nveL$arealn))
if (length(w)) {
  cat("OBS: For " %+% length(w) %+% " innsjøer var det norske arealet angitt, men ikke det totale.\n")
  cat("For disse ble totalarealet satt til det norske arealet.\n\n")
  nveL$areal[w] <- nveL$arealn[w]
}
w <- which(nveL$areal < nveL$arealn)
if (length(w)) {
  cat("OBS: For " %+% length(w) %+% " innsjøer var det totale arealet angitt å være mindre enn det norske.\n")
  cat("For disse ble totalarealet satt til det norske arealet.\n\n")
  nveL$areal[w] <- nveL$arealn[w]
}
w <- which(nveL$tilsig < nveL$arealn)
if (length(w)) {
  cat("OBS: For " %+% length(w) %+% " innsjøer var deres tilsigsfelt angitt å være mindre enn deres areal.\n")
  cat("For disse ble tilsigsfeltet satt til arealet.\n\n")
  nveL$tilsig[w] <- nveL$areal[w]
}

# Innlesing av formfila av NVEs datasett
koord <- st_read("innsjo_innsjo.shp") # , layer_options="ENCODING=latin1")
Sys.setlocale("LC_ALL", "")


##################################################################
# NVEs elvenett

# Det som fins om hver elvestrekning, er:
# * strekningsnummer
# * streknLnr (unik)
# * elvID
# * vatnLnr (tilsvarer innsjødatabasen?)
# * vassdragNr (id for overordnet nedbørfelt i REGINE)
# * nbfVassNr (det samme??!)

# ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

nve <- read.dbf("elv_elvenett.dbf", T)
for (i in 1:ncol(nve)) {
  if (is.character(nve[, i])) {
    Encoding(nve[, i]) <- "latin1"
  }
}




###################################################################
# Vannlokaliteter

# * Må lastes ned som excel-fil (csv) fra https://vannmiljo.miljodirektoratet.no/ >
# > Jeg vil > Søke > Søk i vannlokaliteter >>
# Søk med kriterier > "Vannkategori" = "Innsjø" / "Elv" / "Kyst" > Søk > Eksporter

nyeKolonner <- c( # kolonner som datarammen VL trenger for å fungere
  "lokid",
  "lokkod",
  "loknam",
  "sjønr",
  "id",
  "kat",
  "X",
  "Y"
)

# Innlesing av "tolkningstabellen": Hvilke kolonner i vannlokalitetstabellen
# svarer til hvilke kolonner i VL
navnVL <- read.table("navnVL.csv", 
                    header = TRUE, sep = ";", quote = "", 
                    na.strings = "", strip.white = TRUE, comment.char = "", 
                    stringsAsFactors = FALSE, fileEncoding="latin1")

# Innlesing av vannlokalitetsfilene som har blitt lasta ned fra vannmiljø
VL <- list()
for (i in c("L", "R", "C")) {
  VL[[i]] <- as.data.frame(read_xlsx("VL-" %+% i %+% ".xlsx", col_types = "text"))
  if (colnames(VL[[i]]) %=% navnVL$VL) {
    colnames(VL[[i]]) <- navnVL$nytt
    if (all(nyeKolonner %in% navnV$nytt)) {
      VL[[i]] <- VL[[i]][, nyeKolonner]
    } else {
      cat("FEIL: Kolonnenavnene i \"navnVN.csv\" er ikke som forventa!\n\n")
    }
  } else {
    cat("FEIL: Kolonnenavnene i den innleste fila \"VL-" %+% i %+%
        ".csv\" er ikke som forventa!\n\n")
  }
}
VL <- rbind(VL[["L"]], VL[["R"]], VL[["C"]])

VL$lokid <- as.numeric(VL$lokid)
VL$sjønr <- as.numeric(VL$sjønr)
VL$X     <- as.numeric(VL$X)
VL$Y     <- as.numeric(VL$Y)

# Fjern koordinater som ikke kan stemme
w <- which(VL$X < -80000 | VL$X > 1200000 | VL$Y < 6400000 | VL$Y > 9000000)
if (length(w)) {
  cat("OBS: For " %+% length(w) %+% " vannlokaliteter var det oppgitt " %+%
      "koordinater som ligger utenfor Norge.\n" %+%
      "Disse koordinatene ble satt til <NA>.\n\n")
  VL$X[w] <- VL$Y[w] <- NA
}












