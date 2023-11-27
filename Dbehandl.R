

fraVFtilNI <- function(
    DATA,
    vannforekomster,
    vannlokaliteter,
    parameter,
    vannkategori,
    filKlasser = NULL,
    NI.aar = c(1990, 2000, 2010, 2014, 2019, 2024),
    rapportenhet = c("kommune", "fylke", "landsdel", "norge"),
    adminAar = 2010,
    kommHist = kommunehistorikk,
    fylkHist = fylkeshistorikk,
    rapportperiode = 10,
    vedMaalefeil = "dato",
    maksSkjevhet = 3,
    bareInkluder = NULL,
    ikkeInkluder = NULL,
    maalingPer = 25,
    maalingTot = 100,
    ignorerVariabel = NULL,
    fastVariabel = NULL,
    aktivitetsvekt = 5,
    antallvekt = 0.5,
    tidsvekt = 1,
    arealvekt = 2,
    DeltaAIC = 2,
    minsteAndel = 0.05,
    iterasjoner = 100000,
    bredde = NULL,
    vis = TRUE,
    tell = TRUE
) {
  
  ### Oversikt over parametere
  # DATA: navn på R-datarammen med målinger fra vannmiljø
  # vannforekomster: navnet på R-datarammen med vannforekomster
  # vannlokaliteter: navnet på R-datarammen med vannlokaliteter
  # parameter: vannmiljøs forkortelse på vannforskriftsparameteren
  # vannkategori: "L", "R" eller "C" for innsjø, elv eller kyst
  # filKlasser: filnavn på excel-regnearket med parameterens klassegrenser
  # NI.aar: rapporteringsår for naturindeksen 
  # rapportenhet: romlig enhet til skal skaleres opp til. Kan være én eller flere
  #   av "kommune", "fylke", "landsdel" og "Norge"
  # adminAar: årstallet for kommune- og fylkesinndelinga som skal legges til grunn 
  # kommHist: filnavn på excel-regneark med Norges kommunehistorikk
  # fylkHist: filnavn på excel-regneark med Norges  fylkeshistorikk
  # rapportperiode: hvor mange år før rapporteringstidspunkt skal målinger inkluderes
  # vedMaalefeil: hva skal ekskluderes når det avdekkes feilrapportere verdier
  #   - "måling" (kune feilmålingen ekskluderes)
  #   - "dato" (alle målinger utført av samme oppdragstager på samme dato ekskluderes)
  #   - "oppdragstager" (aller målinger utført av samme oppdragstager ekskluderes)
  # maksSkjevhet: aktiviteter med høyere absolutt skjevhetsskår blir ekskludert
  # bareInkluder: typologifaktorer (hvis oppgitt, blir bare disse hensyntatt)
  # ikkeInkluder: typologifaktorer som skal utelates fra modelleringa
  #   [f.eks. vil list(typ="tur", vrd=2) ekskludere brepåvirka elver]
  # maalingPer: minste antall målinger per rapporteringsperiode
  # maalingTot: minste antall målinger totalt
  # ignorerVariabel: typologifaktorer som ikke skal  inngå i modelltilpasninga
  # fastVariabel: typologifaktorer som ikke skal droppes fra modelltilpasninga
  # aktivitetsvekt: tallverdi som blir brukt for vekting av overvåkingsaktiviteter
  # antallvekt: tallverdi som blir brukt for vekting av antall prøver per maaleverdi
  # tidsvekt: faktor for nedvekting av eldre målinger
  # arealvekt: tallverdi for vekting av innsjøstørrelse
  #   - 0 (lik vekt for alle innsjøvannforekomster)
  #   - 1 (vekting med innsjøvannforekomstenes idealiserte diameter)
  #   - 2 (vekting med innsjøvannforekomstenes areal)
  #   - 3 (vekting med innsjøvannforekomstenes idealiserte volum)
  # DeltaAIC: hvor mye lavere AIC skal en mer kompleks modell ha for å bli valgt
  # minsteAndel: hvor lav må andelen av vannforekomster med data minst være
  # iterasjoner: antall iterasjoner som skal brukes i simuleringa
  # bredde: bredden til beskjeder i antall tegn
  # vis: skal beskjeder om modelltilpasninga vises 
  
  OK <- TRUE
  
  #########################################################################
  skriv("Innledende tester", pre = "   ", linjer.over  = 1)
  skriv("=================", pre = "   ", linjer.under = 1)
  
  # Sjekke om nødvendige funksjonsparametere er oppgitt
  if (missing(DATA)) {
    OK <- FALSE
    skriv("Parameteren \"DATA\" må være oppgitt og inneholde målinger ",
          "som er eksportert fra vannmiljø.",
          pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
  } else {
    if (!is.data.frame(DATA) || 
        !(all(c("lokid", "parid", "verdi", "tidpkt", "aktid") %in% names(DATA)))) {
      OK <- FALSE
      skriv("Datafila har et uventa format!",
            pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
    }
  }
  if (missing(vannforekomster)) {
    OK <- FALSE
    skriv("Parameteren \"vannforekomster\" må være oppgitt og inneholde ",
          "informasjon fra vann-nett om vannforekomstene.",
          pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
  } else {
    if (!is.data.frame(vannforekomster) || 
        !(all(c("id", "typ", "kat", "knr") %in% names(vannforekomster)))) {
      OK <- FALSE
      skriv("Datarammen med vannforekomster har et uventa format!",
            pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
    }
  }
  if (missing(vannlokaliteter)) {
    OK <- FALSE
    skriv("Parameteren \"vannlokaliteter\" må være oppgitt og inneholde ",
          "informasjon fra vannmiljø om vannlokalitetene.",
          pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
  } else {
    if (!is.data.frame(vannlokaliteter) || 
        !(all(c("lokid", "lokkod", "id") %in% names(vannlokaliteter)))) {
      OK <- FALSE
      skriv("Datarammen med vannlokaliteter har et uventa format!",
            pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
    }
  }
  if (missing(parameter) ||
    !(length(parameter) %=% 1 && is.character(parameter))) {
      OK <- FALSE
    skriv("Parameteren \"parameter\" må være oppgitt og bestå av ",
          "en parameter-id fra vannmiljø.",
          pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
  }
  if (missing(vannkategori) ||
      !(length(vannkategori) %=% 1 && vannkategori %in% c("L", "R", "C"))) {
    OK <- FALSE
    skriv("Parameteren \"vannkategori\" må være nøyaktig én av bokstavene \"L\", ",
          "\"R\" eller \"C\"!", pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
  }
  if (!(vedMaalefeil %in% c("måling", "dato", "oppdragstager") &
        length(vedMaalefeil) %=% 1)) {
    vedMaalefeil <- vedMaalefeil[1]
    if (vedMaalefeil %begynner% "m") vedMaalefeil <- "måling"
    if (vedMaalefeil %begynner% "d") vedMaalefeil <- "dato"
    if (vedMaalefeil %begynner% "o") vedMaalefeil <- "oppdragstager"
    if (!(vedMaalefeil %in% c("måling", "dato", "oppdragstager"))) {
      vedMaalefeil <- "dato"
    }
    skriv("Variabelen \"vedMaalefeil\" ble satt til \"", vedMaalefeil, ".",
          pre = "OBS: ", linjer.under = 1)
  }

  # Sjekke om nødvendig informasjon er tilgjengelig
  if (OK) {
    if (exists("Parametere")) {
      if (is.data.frame(Parametere) && 
          names(Parametere) %=% c("id", "navn", "min", "max")) {
        w <- which(Parametere$id == parameter)
        if (length(w) %=% 1) {
          if (any(is.na(Parametere[w, ]))) {
            OK <- FALSE
            skriv("Tillatte verdier er ikke angitt for \"", parameter,
                  "\" i regnearket \"VM-param.xlsx\"!",
                  pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
          }
        } else {
          OK <- FALSE
          skriv("Parameter-id-en \"", parameter, "\" fins ikke i ",
                "regnearket \"VM-param.xlsx\"!",
                pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
        }
      } else {
        OK <- FALSE
      skriv("Kolonnenavnene i regnearket \"VM-param.xlsx\" er ikke som ",
            "forventa!", pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
      }
    } else {
      OK <- FALSE
      skriv("Datarammen \"Parameter\" og/eller regnearket \"VM-param.xlsx\" ",
            "fins ikke!", pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
    }
    if (exists("Aktiviteter")) {
      if (!is.data.frame(Aktiviteter) || 
          names(Aktiviteter) %!=% c("id", "navn", "skaar")) {
        skriv("Kolonnenavnene i regnearket \"VM-aktiv.xlsx\" er ikke som ",
              "forventa!", pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
      }
    } else {
      OK <- FALSE
      skriv("Datarammen \"Aktiviteter\" og/eller regnearket \"VM-aktiv.xlsx\" ",
            "fins ikke!", pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
    }
  }

  if (OK) {
    # Lese inn klassegrenser for den angitte parameteren
    if (is.null(filKlasser)) {
      filKlasser <- "klassegrenser_" %+% parameter %+% ".xlsx"
    }
    KlasseGrenser <- hentKlassegrenser(filKlasser)
    if (is.null(KlasseGrenser)) {
      OK <- FALSE
    }
  }
  
  if (OK) {
    
    skriv("De nødvendige datafilene ble funnet. Da setter vi i gang.",
          linjer.under = 1)
    
    Vf <- vannforekomster
    VL <- vannlokaliteter
    
    #########################################################################
    skriv("Lasting av administrative enheter", pre = "   ", linjer.over  = 1)
    skriv("=================================", pre = "   ", linjer.under = 1)
    
    fylkeshistorikk  <- fylkHist
    kommunehistorikk <- kommHist
    relevanteRader   <- 4:(ncol(kommunehistorikk) - 1)
    rownames(kommunehistorikk) <- kommunehistorikk$Nummer
    
    rapportenhet <- tolower(unique(rapportenhet))
    if (length(rapportenhet)) {
      for (i in 1:length(rapportenhet)) {
        if ("kommuner"   %begynner% rapportenhet[i]) rapportenhet[i] <- "kommune"
        if ("fylker"     %begynner% rapportenhet[i]) rapportenhet[i] <- "fylke"
        if ("landsdeler" %begynner% rapportenhet[i]) rapportenhet[i] <- "landsdel"
        if ("norge"      %begynner% rapportenhet[i]) rapportenhet[i] <- "norge"
      }
    }
    if (!length(rapportenhet %A% c("kommune", "fylke", "landsdel", "norge"))) {
      rapportenhet <- c("kommune", "fylke", "landsdel", "norge")
    }
    if (!is.numeric(adminAar) || length(adminAar) != 1) {
      adminAar <- 9000
    }
    
    kaar <- as.numeric(colnames(kommunehistorikk)[relevanteRader])
    if (adminAar < 1977) {
      adminAar <- 1980
      skriv("Kommunegrenser fra før 1977 er dessverre ikke tilgjengelig. Det ",
            "administrative året ble satt til 1980",
            pre="OBS: ", linjer.under = 1)
    }
    KOM <- sort(unique(kommunehistorikk[, 
                as.character(kaar[max(which(kaar <= adminAar))])])) %-% "."
    
    FYL <- fylkeshistorikk$navn[which(fylkeshistorikk$fra <= adminAar &
                                      fylkeshistorikk$til >= adminAar)]
    FNR <- fylkeshistorikk$nr  [which(fylkeshistorikk$fra <= adminAar &
                                      fylkeshistorikk$til >= adminAar)]
    WF <- list(Ø = c("0" %+% 1:7, 30:34)      %+% "00",
               S = c("08", "09", "10", "40"	) %+% "00",
               V = c(11:14, 46)               %+% "00",
               M = c(15:17, 50)               %+% "00",
               N = c(18:20, 54:56)            %+% "00")
    rownames(fylkeshistorikk) <- fylkeshistorikk$nr
    Vk <- Vf$knr
    Vn <- Vf$kommune
    Fn <- ""
    for (k in 1:nrow(kommunehistorikk)) {
      knr <- kommunehistorikk$Nummer[k]
      w <- unique(unlist(kommunehistorikk[k, relevanteRader]))
      for (kk in w) {
        knr <- c(knr, kommunehistorikk$Nummer[which(kommunehistorikk == kk, arr.ind = TRUE)[, 1]])
      }
      Vk <- erstatt(Vk,         knr[1], paste(sort(unique(knr)), collapse = ","))
      Vk <- erstatt(Vk, "0" %+% knr[1], paste(sort(unique(knr)), collapse = ","))
    }
    for (k in 1:nrow(Vf)) {
      knr <- sort(unique(unlist(strsplit(Vk[k], ","))))
      Vk[k] <- paste(knr, collapse = ",")
      knv <- unique(unlist(kommunehistorikk[knr, 4:ncol(kommunehistorikk)]))
      Vn[k] <- paste(((knv %-% ".") %-% "") %+% ",", collapse = "")
      fnr <- sort(unique(substr(knr, 1, 2))) %+% "00"
      Fn[k] <- paste(fnr, collapse = ",")
    }
    Vf$knr     <- Vk
    Vf$kommune <- Vn
    Fy <- Fn
    for (f in 1:nrow(fylkeshistorikk)) {
      if (adminAar %mellom% fylkeshistorikk[f, c("fra", "til")]) {
        Fy <- erstatt(Fy, fylkeshistorikk$nr[f], fylkeshistorikk$navn[f])
      } else {
        Fy <- erstatt(Fy, fylkeshistorikk$nr[f] %+% ",", "")
        Fy <- erstatt(Fy, fylkeshistorikk$nr[f],         "")
        Fn <- erstatt(Fn, fylkeshistorikk$nr[f] %+% ",", "")
        Fn <- erstatt(Fn, fylkeshistorikk$nr[f],         "")
      }
    }
    Vf$fylke <- Fn
    skriv("De administrative enhetene er på plass. Per ", adminAar,
          ifelse(adminAar < as.numeric(format(Sys.Date(), "%Y")),
                 " fantes", " fins"),
          " det ", length(unique(FYL)), " fylker ",
          ifelse("kommune" %in% rapportenhet,
            "og " %+% length(unique(KOM)) %+% " kommuner.",
            "."),
          linjer.under = 1)
  }
  
  if (OK) {

    ######################################################################
    skriv("Undersøkelse av innmatingsdata", pre = "   ", linjer.over  = 1)
    skriv("==============================", pre = "   ", linjer.under = 1)

    aar <- as.numeric(substr(DATA$tidpkt, 1, 4))
    NI.aar <- sort(NI.aar)
    startaar <- min(NI.aar) - rapportperiode + 1
    sluttaar <- max(NI.aar)
    er.med <- which(DATA$parid == parameter & !is.na(DATA$verdi) &
                      aar >= startaar & aar <= sluttaar)
    rappAar <- NA
    rappAar[er.med] <- aar[er.med]
    for (i in rev(NI.aar)) {
      rappAar[which(aar < i)] <- i
    }
    relaar <- aar - rappAar
    skriv("Det foreligger ", length(which(DATA$parid == parameter)), 
          " målinger av parameteren ", parameter, 
          " [", parameterNavn(parameter), "].", linjer.under = 1)
    feil <- F
    ikke.med <- which(DATA$parid == parameter & aar < startaar)
    if (length(ikke.med)) {
      skriv(length(ikke.med), ifelse(length(ikke.med) == 1,
                                     " måling ble ekskludert fordi den",
                                     " målinger ble ekskludert fordi de"),
            " ble tatt før " %+% startaar %+% ".", pre = "OBS: ", linjer.under = 1)
      feil <- T
    }
    ikke.med <- which(DATA$parid == parameter & aar > sluttaar)
    if (length(ikke.med)) {
      skriv(length(ikke.med), ifelse(length(ikke.med) == 1,
                                     " måling ble ekskludert fordi den",
                                     " målinger ble ekskludert fordi de"),
            " ble tatt etter " %+% sluttaar %+% ".", pre = "OBS: ", linjer.under = 1)
      feil <- T
    }
    ikke.med <- which(DATA$parid == parameter & is.na(aar))
    if (length(ikke.med)) {
      skriv(length(ikke.med), ifelse(length(ikke.med) == 1,
                                     " måling ble ekskludert fordi den",
                                     " målinger ble ekskludert fordi de"),
            " ble foretatt på et ukjent tidspunkt.", pre = "OBS: ", linjer.under = 1)
      feil <- T
    }
    if (!feil) {
      skriv("Alle målinger ble tatt mellom ", min(aar[er.med]), " og ",
            max(aar[er.med]), ".", linjer.under = 1)
    }
    feil1 <- er.med %A% which(DATA$verdi %utafor% tillatteVerdier(parameter))
    if (length(feil1)) {
      feil2 <- range(DATA$verdi[feil1])
      feil3 <- feil1
      if (vedMaalefeil %=% "måling") {
        feil3 <- unique(feil3)
        er.med <- er.med %-% feil3
        skriv(length(feil1), ifelse(length(feil1) == 1, " måling", " målinger"),
              " ligger utafor parameterens definisjonsområde! (Verdiene er mellom ",
              feil2[1], " og ", feil2[2], ".) D", 
              ifelse(length(feil1) == 1, "enne", "isse"), " ble ekskludert.", 
              pre = "OBS: ", linjer.under = 1)
      }
      if (vedMaalefeil %=% "dato") {
        for (i  in (unique(DATA$oppdrt[feil1]) %-% "")) {
          for (j in unique(DATA$tidpkt[feil1])) {
            feil3 <- c(feil3, which(DATA$oppdrt == i & DATA$tidpkt == j &
                                    DATA$parid == parameter))
          }
        }
        feil3 <- unique(feil3)
        er.med <- er.med %-% feil3
        skriv(length(feil1), ifelse(length(feil1) == 1, " måling", " målinger"),
              " ligger utafor parameterens definisjonsområde! (Verdiene er mellom ",
              feil2[1], " og ", feil2[2], ".) I tillegg til d", 
              ifelse(length(feil1) == 1, "enne", "isse " %+% length(feil1)), 
              " ble ytterligere ", (length(feil3) - length(feil1)),
              ifelse((length(feil3) - length(feil1)) == 1," måling", " målinger"), 
              " ekskludert, fordi de hadde samme oppdragstaker (",
              paste(unique(DATA$oppdrt[feil1]), collapse=", "), 
              ") og prøvetakingsdato (", 
              paste(unique(format(as.Date(DATA$tidpkt[feil1]), "%d.%m.%Y")), 
                    collapse=", "), ").", 
              pre = "OBS: ", linjer.under = 1)
      }
      if (vedMaalefeil %=% "oppdragstager") {
        for (i  in (unique(DATA$oppdrt[feil1]) %-% "")) {
          feil3 <- c(feil3, which(DATA$oppdrt == i & DATA$parid == parameter))
        }
        feil3 <- unique(feil3)
        er.med <- er.med %-% feil3
        skriv(length(feil1), ifelse(length(feil1) == 1, " måling", " målinger"),
              " ligger utafor parameterens definisjonsområde! (Verdiene er mellom ",
              feil2[1], " og ", feil2[2], ".) I tillegg til d", 
              ifelse(length(feil1) == 1, "enne", "isse " %+% length(feil1)), 
              " ble ytterligere ", (length(feil3) - length(feil1)),
              ifelse((length(feil3) - length(feil1)) == 1," måling", " målinger"), 
              " ekskludert, fordi de hadde samme oppdragstaker (",
              paste(unique(DATA$oppdrt[feil1]), collapse=", "), ").", 
              pre = "OBS: ", linjer.under = 1)
      }
    } else {
      skriv("Alle målinger ligger innafor parameterens definisjonsområde.", 
            linjer.under = 1)
    }
    rownames(Aktiviteter) <- Aktiviteter$id
    skjev <- er.med %A% which(abs(Aktiviteter[DATA$aktid, "skaar"]) > maksSkjevhet)
    if (length(skjev)) {
      er.med <- er.med %-% skjev
      skriv(length(skjev), ifelse(length(skjev) == 1, " måling", " målinger"),
            " bla samla inn i rammen av en aktivitet som er for lite ",
            "representativ! Disse ble ekskludert.", pre = "OBS: ", linjer.under = 1)
    } else {
      if (maksSkjevhet < 3) {
        skriv("Ingen målinger ble ekskludert pga. aktivitetens skjevhet.",
              linjer.under = 1)
      }
    }
    maaling <- data.frame(vfo="", inn=0, lok=0, are=0, til=0, hoh=0, gbr=0, gle=0,
                          aar=0, per=0, rar=0, akt="",
                          typ="", kat="", reg="", son="", 
                          stø="", alk="", hum="", tur="", dyp="",
                          kom="", fyl="", ant=1, vkt=1, vrd=0,
                          stringsAsFactors = FALSE)
    uten.kode <- uten.id <- numeric()
    skriv("Vennligst vent mens målingene kobles mot vannforekomster!")
    for (i in er.med) {
      lok <- c(which(VL$lokkod == DATA$lokid[i]), which(VL$lokid == DATA$lokid[i]))
      if (length(lok) %=% 1) {
        vfk <- VL$id[lok]
        if (substr(vfk, nchar(vfk), nchar(vfk)) %=% "L") {
          vfk <- which(Vf$id == (substr(vfk, 1, 4) %+% VL$sjønr[lok] %+% "-L"))
          if (!length(vfk)) {
            vfk <- which(Vf$id == VL$id[lok])
          }
        } else {
          vfk <- which(Vf$id == vfk)
        }
        if (length(vfk) %=% 1) {
          maaling <- rbind(maaling, maaling[1,])
          L <- nrow(maaling)
          maaling$vfo[L]   <- Vf$id  [vfk]
          maaling$inn[L]   <- VL$sjøn[lok]
          maaling$lok[L]   <- VL$loki[lok]
          maaling$are[L]   <- Vf$area[vfk]
          maaling$til[L]   <- Vf$tils[vfk]
          maaling$hoh[L]   <- Vf$hoh [vfk]
          maaling$gbr[L]   <- Vf$lat [vfk]
          maaling$gle[L]   <- Vf$long[vfk]
          maaling$aar[L]   <- aar    [i]
          maaling$per[L]   <- rappAar[i]
          maaling$rar[L]   <- relaar [i]
          maaling$akt[L]   <- DATA$ak[i]
          maaling$kom[L]   <- Vf$komm[vfk]
          maaling$fyl[L]   <- Vf$fylk[vfk]
          maaling$vrd[L]   <- DATA$verdi[i]
          maaling$ant[L]   <- DATA$antve[i]
          for (j in colnames(maaling)[13:21]) {
            maaling[L,j]   <- Vf[vfk, j]  
          }
          # ¤ utsatt!
          #if (is.na(maaling$gbr[L])) {
          #  koord          <- as.deg(33, VL$X[lok], VL$Y[lok])
          #  maaling$gbr[L] <- as.vector(koord[1])
          #  maaling$gle[L] <- as.vector(koord[2])}
        } else {
          uten.id <- c(uten.id, i)
        }
      } else {
        uten.kode <- c(uten.kode, i)
      }
      if (tell) {
        cat("Ferdig med " %+% floor(100*(which(er.med == i) / length(er.med))) %+%
              " % av målingene.\r")
      }
    }
    if (tell) {
      cat("\n\n")
    } else {
      cat("Ferdig med 100 % av målingene.\n\n")
    }
    maaling <- maaling[-1,]
    maaling$per <- as.factor(maaling$per)
    
    if (length(uten.kode)) {
      skriv(length(uten.kode), ifelse(length(uten.kode) == 1,
                                      " måling ble ekskludert fordi den",
                                      " målinger ble ekskludert fordi de"),
            " ikke kunne knyttes til noen kjent vannlokalitet!", 
            pre = "OBS: ", linjer.under = 1)
    } else {
      skriv("Alle målinger kunne knyttes til en vannlokalitet.", linjer.under = 1)
    }
    if (length(uten.id)) {
      skriv(length(uten.id),
            ifelse(length(uten.id) == 1,
                   " måling ble ekskludert fordi dens vannlokalitet",
                   " målinger ble ekskludert fordi deres vannlokaliteter"),
            " ikke kunne knyttes til noen typifisert vannforekomst!",
            pre = "OBS: ", linjer.under = 1)
    } else {
      skriv("Alle vannlokaliteter kunne knyttes til en typifisert vannforekomst.",
            linjer.under = 1)
    }
    
    feil <- which(!(maaling$kat %in% vannkategori))
    if (length(feil)) {
      txt1 <- length(feil) %+% ifelse(length(feil) %=% 1, " måling", " målinger")
      txt2 <- " foretatt i en " %+% 
        ifelse(vannkategori %=% "L",
               "innsjø",
               ifelse(vannkategori %=% "R",
                      "elve", 
                      ifelse(vannkategori %=% "C", 
                             "kyst", 
                             "passende ")
               )
        ) %+% "vannforekomst"
      maaling <- maaling[-feil,]
      skriv(txt1, " ble ekskludert fordi de", ifelse(length(feil) %=% 1, "n", ""),
            " ikke ble", txt2, "!", pre = "OBS: ", linjer.under = 1)
      rm(txt1, txt2, feil)
    } else {
      skriv("Alle målinger ble foretatt i den riktige vannkategorien.", 
            linjer.under = 1)
    }
    rader <- nrow(maaling)
    if (!is.null(bareInkluder)) { #### dette er ikke utvikla!!! ¤¤¤
      ta.med <- numeric(0)
      if (is.list(bareInkluder)) {
        for (i in 1:length(bareInkluder$typ)) {
          ok <- which(maaling[, bareInkluder$typ[i]] == bareInkluder$vrd[i])
          if (length(ok)) {
            ta.med <- c(ta.med, ok)
          }
        }
      } else {
        ta.med <- ok <- which(maaling$typ %in% bareInkluder)
      }
      feil <- nrow(maaling) - length(ta.med)
      if (feil %!=% 0) {
        maaling <- maaling[ta.med, ]
        skriv(feil, ifelse(feil %=% 1, 
                           " måling ble ekskludert fordi den",
                           " målinger ble ekskludert fordi de"),
              " ble foretatt i en vanntype som parameteren ikke kan brukes i.",
              pre = "OBS: ", linjer.under = 1)
      }
      rm(ta.med, ok, feil)
    }
    if (!is.null(ikkeInkluder)) {
      fjerna <- 0
      for (i in 1:length(ikkeInkluder$typ)) {
        feil <- which(maaling[, ikkeInkluder$typ[i]] == ikkeInkluder$vrd[i])
        if (length(feil)) {
          fjerna <- fjerna + length(feil)
          maaling <- maaling[-feil, ]
        }
      }
      if (fjerna) {
        skriv(length(feil), ifelse(length(feil) %=% 1,
                                   " måling ble ekskludert fordi den",
                                   " målinger ble ekskludert fordi de"),
              " ble foretatt i en vanntype som parameteren ikke kan brukes i.",
              pre = "OBS: ", linjer.under = 1)
      }
      rm(fjerna, feil)
    }
    if (nrow(KlasseGrenser) > pi) {
      okTyper <- rownames(KlasseGrenser)[which(!apply(is.na(KlasseGrenser),1,any))]
      feil <- which(!(maaling$typ %in% okTyper))
      if (length(feil)) {
        maaling <- maaling[-feil, ]
        skriv(length(feil), ifelse(length(feil) %=% 1,
                                   " måling ble ekskludert fordi den",
                                   " målinger ble ekskludert fordi de"),
              " ble foretatt i en vanntype som parameteren ikke har definerte",
              " referanseverdier og klassegrenser i.",
              pre = "OBS: ", linjer.under = 1)
      }
    }
    if (nrow(maaling) %=% rader) {
      skriv("Alle målinger ble foretatt i de riktige vanntypene.", linjer.under = 1)
    }
    fjernAar <- c()
    for (i in NI.aar) {
      w <- which(maaling$per == i)
      if (length(w) < maalingPer) {
        if (length(w) > 0) {
          maaling <- maaling[-which(maaling$per == i),]
        }
        fjernAar <- c(fjernAar, i)
        skriv("For rapportåret ", i, " foreligger bare ", length(w), 
              " målinger. Det er dessverre for få, og denne rapportperioden må",
              " derfor utgå.", pre = "OBS: ", linjer.under = 1)
      }
    }
    rappAar <- rappAar %-% fjernAar
    NI.aar  <- NI.aar  %-% fjernAar # ¤¤¤ hvis det bare er ett år, funker ikke modelleringa!!! ¤¤¤¤¤
    if (nrow(maaling) < maalingTot) {
      OK <- FALSE
      skriv("De foreliggende ", nrow(maaling), " målingene er dessverre " %+%
              "altfor få til å tilpasse noen modell!",
            pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
    } else {
      skriv("Dataene som inngår i modelltilpasninga inneholder dermed")
      skriv(nrow(maaling), " målinger fra", pre = "- ")
      skriv(length(unique(maaling$lok)), " vannlokaliteter i", pre = "- ")
      skriv(length(unique(maaling$vfo)), " vannforekomster i", pre = "- ")
      skriv(length(unique(unlist(strsplit(maaling$fyl, ","))) %A%
                     (c("0" %+% 1:9, 10:99) %+% "00")), " fylker", pre = "- ")
      skriv("mellom ", min(maaling$aar), " og ", max(maaling$aar), ".", 
            pre = "- ", linjer.under = 1)
    }
  }
  
  if (OK) {
    
    ##################################################################
    skriv("Skalering til mEQR-verdier", pre = "   ", linjer.over  = 1)
    skriv("==========================", pre = "   ", linjer.under = 1)
    
    #maaling. <- maaling
    
    oppsummer <- function(x) {
      x <- unlist(summary(x))
      names(x) <- 
        c("minimum", "ned. kv.", "median", "gj.snitt", "øvr. kv.", "maksimum")
      return(x)
    }
    
    skriv("Oppsummering av variabelverdier før skalering:")
    print(oppsummer(maaling$vrd))
    
    # Spesialbehandling for Raddum I! (del 1 av 2)
    if (parameter == "RADDUM1") {
      maaling$vrd <- ifelse(maaling$ant == 1,
                            ifelse(maaling$vrd > 0.501, 1,
                                   ifelse(maaling$vrd > 0.251, 0.5,
                                          ifelse(maaling$vrd > 0.001, 0.25, 0))), maaling$vrd)
      maaling$vrd[which(maaling$vrd > 1)] <- 1
      for (i in 1:nrow(maaling)) {
        if (maaling$ant[i] %=% 1) {
          maaling$ant[i] <- 1 + (length(which(maaling$lok==maaling$lok[i] &
                                                maaling$aar==maaling$aar[i])) > 1)
        }
        maaling$vrd[i] <- maaling$vrd[i] + (maaling$ant[i] > 1) / 10000
      }
    }
    
    # Skalering
    if (dim(KlasseGrenser) %=% c(1, 8)) {
      # parametere som har de samme terskelverdiene for alle vanntyper:
      K <- as.vector(unlist(KlasseGrenser[1, ]))
      maaling$vrd <- mEQR(maaling$vrd, K)
    } else {
      if (nrow(KlasseGrenser) < pi) {
        # parametere som har de samme terskelverdiene for alle vanntyper innafor vannkategorien:
        VT <- substr(maaling$typ, 1, 1)
        for (v in unique(VT)) {
          K <- as.vector(unlist(KlasseGrenser[toupper(substr(v, 1, 1)), ]))
          maaling$vrd[which(VT == v)] <- mEQR(maaling$vrd[which(VT == v)], K)
        }
      } else {
        # resten, dvs. parametere der terskelverdiene varierer mellom vanntyper:
        for (v in unique(maaling$typ)) {
          K <- as.vector(unlist(KlasseGrenser[v, ]))
          maaling$vrd[which(maaling$typ == v)] <- mEQR(maaling$vrd[which(maaling$typ == v)], K)
        }
      }
    }
    
    # Spesialbehandling for Raddum I! (del 2 av 2)
    if (parameter == "RADDUM1") {
      maaling$vrd[which(maaling$vrd >= 0.8)] <- 0.9
    }
    
    skriv("Oppsummering av variabelverdier etter skalering:", linjer.under = 1)
    print(oppsummer(maaling$vrd))
  }
  
  # dett var dett
  
  if (OK) {
    
    ######################################################################
    skriv("Modelltilpasning til målingene", pre = "   ", linjer.over  = 1)
    skriv("==============================", pre = "   ", linjer.under = 1)
    
    rownames(Aktiviteter) <- Aktiviteter$id
    w <- which(!(toupper(maaling$akt) %in% toupper(Aktiviteter$id)))
    if (aktivitetsvekt > 1 & length(w) > 0) {
      w <- toupper(unique(maaling$akt[w]))
      for (i in 1:length(w)) {
        Aktiviteter <- rbind(Aktiviteter, list(w[i], "?", 0))
        rownames(Aktiviteter)[nrow(Aktiviteter)] <- w[i]
      }
      skriv("Noen målinger er foretatt i sammenheng med overvåkingsaktiviteter som ",
            "ikke har fått tildelt noen aktivitetsvekt ennå. Dette gjelder ",
            paste("\"" %+% w %+% "\"", collapse=", "), ". De respektive skårene ",
            "har blitt satt til 0. Hvis det blir feil, må dette rettes opp!",
            pre = "OBS: ", linjer.under = 1)
    }
    
    rownames(Aktiviteter) <- Aktiviteter$id
    maaling$vkt <- maaling$ant^antallvekt * tidsvekt^maaling$rar *
      as.vector(aktivitetsvekt^(-abs(Aktiviteter[maaling$akt, "skaar"])))
    
    # Fjern typologifaktorer som ikke er definert for vannkategorien
    if (vannkategori == "R") {
      ignorerVariabel <- unique(c(ignorerVariabel, "dyp"))
    }
    
    # Fjern typologifaktorer som ikke er oppgitt
    for (typ in c("reg", "son", "stø", "alk", "hum", "tur", "dyp") %-%
                ignorerVariabel) {
      w <- which(is.na(maaling[, typ]))
      if (length(w)) {
        if (length(w) > nrow(maaling) / 0.25) {
          ignorerVariabel <- c(ignorerVariabel, typ)
          skriv("Typologifaktoren \"", typ, "\" var oppgitt så få ganger at ",
                "den ignoreres!", pre = "OBS: ", linjer.under = 1)
        } else {
          maaling <- maaling[-w, ]
          skriv(length(w), " målinger ble ekskludert fordi typologifaktoren \"",
                typ, "\" ikke var kjent for dem!", pre = "OBS: ", linjer.under = 1)
        }
      }
    }
    
    if (vannkategori == "L") {
      formel. <- "per * rar + akt + reg + son + stø + alk + hum + tur + dyp"
    }
    if (vannkategori == "R") {
      formel. <- "per * rar + akt + reg + son + stø + alk + hum + tur"
    }
    if (vannkategori == "C") {
      formel. <- "per * rar + akt + reg + kys + sal + tid + eks + mix + opp + str"
    }
    
    if (!is.null(ignorerVariabel)) {
      for (i in tolower(ignorerVariabel)) {
        if (formel. %inneholder% i &&
            i %in% c("akt","reg","son","stø","alk","hum","tur","dyp")) {
          formel. <- erstatt(formel., i, "")
        }
      }
      while (formel. %inneholder% "+  +") {
        formel. <- erstatt(formel., "+  +", "+")
      }
      while (substr(formel., nchar(formel.) - 2, nchar(formel.)) == " + ") {
        formel. <- substr(formel., 1, nchar(formel.) - 3)
      }
    }
    if (any(maaling$dyp %in% 4:6)) {
      maaling$dyp[which(as.numeric(maaling$dyp) > 3)] <-
        as.character(as.numeric(maaling$dyp[which(as.numeric(maaling$dyp) > 3)]) - 3)
    }
    f <- function(x) as.formula("vrd ~ " %+% x)
    combine <- function(x, y)
      paste(sort(c(unlist(strsplit(x, "[+]")), unlist(strsplit(y, "[+]")))), collapse="+")
    RF1 <- list(
      akt = sort(unique(maaling$akt)),
      tur = c("1", "2", "3"),
      tid = c("1", "2")
    )
    RF2 <- RF2.sik <- list(
      son = c("L", "M", "H"),
      stø = c("1", "2", "3", "4", "5"),
      alk = c("5", "6", "7", "1", "8", "2", "3", "4"),
      hum = c("4", "1", "2", "3"),
      dyp = c("1", "2", "3"),
      kys = c("1", "7", "2", "3", "4", "5", "6", "8"),
      sal = c("1", "2", "3", "6", "4", "7", "5"),
      eks = c("1", "2", "3"),
      mix = c("1", "2", "3"),
      opp = c("1", "2", "3"),
      str = c("1", "2", "3")
    )
    VN1 <- c(akt = "Aktivitet", tur = "Turbiditet", tid = "Tidevann")
    VN2 <- c(son = "Sone",
             stø = "Størrelse", 
             alk = "Alkalitet", 
             hum = "Humøsitet", 
             dyp = "Dybde",
             kys = "Kysttype",
             sal = "Salinitet",
             eks = "Eksponering",
             mix = "Miksing",
             opp = "Oppholdstid",
             str = "Strøm")
    TV2 <- list(
      son = 1:3,
      stø = 1:5,
      alk = c(-0.8, -0.4, -0.2, -0.1, 0, 0.3, 0.9, 1.5),
      hum = c(0.75, 1.25, 1.75, 2.25),
      dyp = 1:3,
      kys = 1:8,
      sal = c(-0.6, 0.2, 1, 1.1, 1.4, 1.5, 1.6),
      eks = 1:3,
      mix = 1:3,
      opp = 1:3,
      str = 1:3
    )
    RF1a <- list(akt=c(), tur=c(), tid=c())
    RF2a <- list(son=c(), stø=c(), alk=c(), hum=c(), dyp=c(), 
                 kys=c(), sal=c(), eks=c(), mix=c(), opp=c(), str=c())
    maaling.sik <- maaling
    #if (any(maaling$hum == "0"))
    # {maaling$hum[which(maaling$hum == "0")] <- "2"} # her settes turbide vannforkomster = humøs!
    if (any(is.na(maaling$akt))) {
      maaling$akt[which(is.na(maaling$akt))] <- "NA!!"
    }
    runde <- 0
    RF12 <- list(NULL, NULL)
    
    
    while (RF12 %!=% list(RF1, RF2)) {
      runde <- runde + 1
      RF12 <- list(RF1, RF2)
      skriv("Modelltilpasning, runde ", runde, ":", linjer.over=1, linjer.under=1)
      
      # tomme variabler
      REKKEF <- RF1
      VNAVN  <- VN1
      formel <- formel. <- formel.. <- erstatt(formel., ".", "")
      vliste <- names(VN1) %A% unlist(strsplit(formel., " [+] "))
      for (vrb in vliste) {
        endra <- F
        vrb. <- vrbSIK <- maaling[,vrb]
        formel.. <- erstatt(formel., vrb, vrb %+% "..")
        formel.  <- erstatt(formel., vrb, vrb %+% ".")
        vrber <- rekke <- REKKEF[[vrb]]
        for (i in length(vrber):1) {
          if (!(vrber[i] %in% vrb.)) {
            vrber <- rekke <- vrber[-i]
          }
        }
        vnavn <- VNAVN[[vrb]]
        if (length(vrber) < 2) {
          formel. <- erstatt(formel., " + " %+% vrb %+% ".", "")
          vrber <- character()
          endra <- T
          if (vis) {
            skriv(vnavn, " har blitt droppa fordi alle data var fra én klasse.",
                  pre = "* ")
          }
        } else {
          if (length(which(vrb. %in% vrber)) < 50) {
            formel. <- erstatt(formel., " + " %+% vrb %+% ".", "")
            vrber <- character()
            endra <- T
            if (vis) {
              skriv(vnavn, "\ har blitt droppa pga. for lite data.", pre = "* ")
            }
          } else {
            if (!all(vrb. %in% vrber)) {
              natall <- length(which(!(vrb. %in% vrber)))
              if (natall > max(table(vrb.))) {
                formel. <- erstatt(formel., " + " %+% vrb %+% ".", "")
                vrber <- character()
                endra <- T
                if (vis) {
                  skriv(vnavn, " har blitt droppa fordi variabelen hadde for mange ",
                        "manglende verdier.", pre = "* ")
                }
              } else {
                vrb.[which(!(vrb. %in% vrber))] <- RF1a[[vrb]] <-
                  names(table(vrb.))[which(table(vrb.) == max(table(vrb.)))]
              }
            }
          }
        }
        if (endra) {
          assign(vrb %+% ".", vrb.)
          maaling[,vrb] <- vrb.
          REKKEF[[vrb]] <- vrber
          RF1 <- REKKEF
        }
      }
      REKKEF <- RF2
      TALLV  <- TV2
      VNAVN  <- VN2
      vliste <- names(VN2) %A% unlist(strsplit(formel., " [+] "))
      for (vrb in vliste) {
        endra <- F
        vrb. <- vrbSIK <- maaling[,vrb]
        formel.. <- erstatt(formel., vrb, vrb %+% "..")
        formel.  <- erstatt(formel., vrb, vrb %+% ".")
        vrber <- rekke <- REKKEF[[vrb]]
        somtall <- TALLV[[vrb]]
        for (i in length(vrber):1) {
          if (!(vrber[i] %in% vrb.)) {
            vrber <- rekke <- vrber[-i]
            somtall <- somtall[-i]
          }
        }
        vnavn <- VNAVN[[vrb]]
        if (length(vrber) < 2) {
          formel. <- erstatt(formel., " + " %+% vrb %+% ".", "")
          vrber <- character()
          endra <- T
          if (vis) {
            skriv(vnavn, " har blitt droppa fordi alle data var fra én klasse.",
                  pre = "* ")
          }
        } else {
          if (length(which(vrb. %in% vrber)) < 50) {
            formel. <- erstatt(formel., " + " %+% vrb %+% ".", "")
            vrber <- character()
            endra <- T
            if (vis) {
              skriv(vnavn, " har blitt droppa pga. for lite data.", pre = "* ")
            }
          } else {
            if (!all(vrb. %in% vrber)) {
              natall <- length(which(!(vrb. %in% vrber)))
              if (natall > max(table(vrb.))) {
                formel. <- erstatt(formel., " + " %+% vrb %+% ".", "")
                vrber <- character()
                endra <- T
                if (vis) {
                  skriv(vnavn, " har blitt droppa fordi variabelen hadde for mange ",
                        "manglende verdier.", pre = "* ")
                }
              } else {
                vrb.[which(!(vrb. %in% vrber))] <- RF2a[[vrb]] <-
                  names(table(vrb.))[which(table(vrb.) == max(table(vrb.)))]
              }
            }
          }
        }
        
        if (endra) {
          assign(vrb %+% ".", vrb.)
          maaling[,vrb] <- vrb.
          REKKEF[[vrb]] <- vrber
          RF2 <- REKKEF
        }
      }
      
      # nominale variabler
      REKKEF <- RF1
      VNAVN  <- VN1
      formel <- formel. <- formel.. <- erstatt(formel., ".", "")
      vliste <- names(VN1) %A% unlist(strsplit(formel., " [+] "))
      if (!is.null(fastVariabel)) {
        for (i in tolower(fastVariabel)) {
          if (i %in% vliste) {
            vliste <- vliste[-which(vliste == i)]
          }
        }
      }
      for (vrb in vliste) {
        endra <- F
        vrb. <- vrbSIK <- maaling[,vrb]
        formel.. <- erstatt(formel., vrb, vrb %+% "..")
        formel.  <- erstatt(formel., vrb, vrb %+% ".")
        vrber <- rekke <- REKKEF[[vrb]]
        for (i in length(vrber):1) {
          if (!(vrber[i] %in% vrb.)) {
            vrber <- rekke <- vrber[-i]
          }
        }
        vnavn <- VNAVN[[vrb]]
        lengde <- length(vrber)
        if (lengde > 1 & sum(table(vrb.)) >= 50) { #¤¤ 50 + 25 som variabel!!
          while (sort(table(vrb.))[[1]] < 25) { # hvis det er få datapunkt, må_det slås sammen
            pm1 <- names(sort(table(vrb.)))[1]
            aic <- Inf
            VLI <- list(vrb.)
            tekst <- ""
            for (pm2 in names(sort(table(vrb.))[-1])) {
              vrb.. <- vrb.
              vrb..[which(vrb.. == pm1 | vrb.. == pm2)] <- combine(pm1, pm2)
              VLI[[length(VLI) + 1]] <- vrb..
              assign(vrb %+% "..", vrb..)
              aic <- c(aic, AIC(lm(f(formel..), data=maaling, weights=vkt)))
              tekst <- c(tekst, pm1 %+% " og " %+% pm2)
            }
            lav <- order(aic)[1]
            if (aic[lav] < aic[1] + DeltaAIC) {
              vrb. <- VLI[[lav]]
              pm12 <- sort(unlist(strsplit(tekst[lav], " og ")))
              vrber <- vrber %-% pm12
              vrber <- sort(unique(c(vrber, combine(pm12[1], pm12[2]))))
              endra <- T
              if (vis && nchar(tekst[lav])) {
                skriv(vnavn, ": ", tekst[lav],
                      " har blitt slått sammen pga. for lite data.", pre = "* ")
              }
            }
          }
        }
        if (lengde > 1 & length(vrber) < 2) {
          formel. <- erstatt(formel., " + " %+% vrb %+% ".", "")
          vrber <- character()
          endra <- T
          if (vis) {
            skriv(vnavn," har blitt droppa fordi nesten alle data var fra én klasse.",
                  pre = "* ")
          }
        }
        lengde <- length(unique(vrb.))
        if (length(unique(vrb.)) > 1 & sum(table(vrb.)) >= 50) {
          L <- c(length(unique(vrb.)), Inf)
          while(L[1] > 1 & L[2] > L[1]) {
            VLI <- list(vrb.)
            assign(vrb %+% ".", vrb.)
            aic <- AIC(lm(f(formel.), data=maaling, weights=vkt))
            tekst <- ""
            for (i in 2:length(vrber)) {
              for (j in 1:(i-1)) {
                pm1 <- vrber[i]
                pm2 <- vrber[j]
                vrb.. <- vrb.
                vrb..[which(vrb.. == pm1 | vrb.. == pm2)] <- combine(pm1, pm2)
                VLI[[length(VLI) + 1]] <- vrb..
                if (length(unique(vrb..)) == 1) {
                  formel.. <- erstatt(formel.., " + " %+% vrb %+% "..", "")}
                assign(vrb %+% "..", vrb..)
                aic <- c(aic, AIC(lm(f(formel..), data=maaling, weights=vkt)))
                tekst <- c(tekst, pm2 %+% " og " %+% pm1)
              }
            }
            lav <- order(aic)[1]
            if (lav %=% 1) {
              lav <- order(aic)[2]
            }
            if (aic[lav] < aic[1] + DeltaAIC) {
              vrb. <- VLI[[lav]]
              if (nchar(tekst[lav])) {
                pm12 <- sort(unlist(strsplit(tekst[lav], " og ")))
                vrber <- vrber %-% pm12
                vrber <- sort(unique(c(vrber, combine(pm12[1], pm12[2]))))
                endra <- T
                if (vis) {
                  skriv(vnavn, ": ", tekst[lav], " har blitt slått sammen.", 
                        pre = "* ")
                }
              }
            }
            L <- c(length(unique(vrb.)), L)
          }
        }
        if (length(unique(vrb.)) %=% 1 & lengde > 1) {
          formel. <- erstatt(formel., " + " %+% vrb %+% ".", "")
          vrber <- character()
          endra <- T
          if (vis) {
            skriv(vnavn, " har blitt droppa fordi det ikke var forskjell mellom klassene.",
                  pre = "* ")
          }
        }
        if (!endra & vis) {
          skriv(vnavn, " har blitt beholdt uendra (med ", length(unique(vrb.)),
                " ulike verdier).", pre = "* ")
        }
        assign(vrb %+% ".", vrb.)
        maaling[,vrb] <- vrb.
        REKKEF[[vrb]] <- vrber
        RF1 <- REKKEF
      }
      
      # ordinale variabler
      REKKEF <- RF2
      TALLV  <- TV2
      VNAVN  <- VN2
      vliste <- names(VN2) %A% unlist(strsplit(formel., " [+] "))
      if (!is.null(fastVariabel)) {
        for (i in tolower(fastVariabel)) {
          if (i %in% vliste) {
            vliste <- vliste[-which(vliste == i)]
          }
        }
      }
      for (vrb in vliste) {
        endra <- F
        vrb. <- vrbSIK <- maaling[,vrb]
        formel.. <- erstatt(formel., vrb, vrb %+% "..")
        formel.  <- erstatt(formel., vrb, vrb %+% ".")
        vrber <- rekke <- REKKEF[[vrb]]
        for (i in length(vrber):1) {
          if (!(vrber[i] %in% vrb.)) {
            vrber <- rekke <- vrber[-i]
            somtall <- somtall[-i]
          }
        }
        vnavn <- VNAVN[[vrb]]
        somtall <- TALLV[[vrb]]
        lengde <- length(vrber)
        if (length(vrber) > 1 & length(which(vrb. %in% vrber)) >= 50) {
          while(length(which(vrb. == vrber[1])) < 25) { # her slås klasser med for få data sammen
            vrb.[which(vrb. %in% vrber[1:2])] <- paste(vrber[1:2], collapse="+") #  fra venstre
            endra <- T
            if (vis) {
              skriv(vnavn, ": ", paste(vrber[1:2], collapse=" og "),
                    " har blitt slått sammen pga. for lite data.", pre = "* ")
            }
            vrber[2] <- paste(vrber[1:2], collapse="+")
            vrber <- vrber[-1]}
          while(length(which(vrb. == vrber[length(vrber)])) < 25) { # det samme fra høyre
            vrb.[which(vrb. %in% vrber[length(vrber) - 1:0])] <-
              paste(vrber[length(vrber) - 1:0], collapse="+")
            endra <- T
            if (vis) {
              skriv(vnavn, ": ", paste(vrber[length(vrber) - 1:0], collapse=" og "),
                    " har blitt slått sammen pga. for lite data.", pre = "* ")
            }
            vrber[length(vrber) - 1] <- paste(vrber[length(vrber) - 1:0], collapse="+")
            vrber <- vrber[-length(vrber)]
          }
        }
        if (length(vrber) > 1 & length(which(vrb. %in% vrber)) >= 50) { # det samme i midten
          while(any(table(vrb.) < 25)) {
            w <- names(which(table(vrb.) < 25))
            vrb.. <- vrb.
            hvilk1 <- which(vrber == w)
            while(length(which(vrb.. == w)) < 25) {
              vrb..[which(vrb.. == vrber[which(vrber == w) - 1])] <- w
              hvilk1 <- c(hvilk1[1] - 1, hvilk1)}
            assign(vrb %+% "..", vrb..)
            aic1 <- AIC(lm(f(formel..), data=maaling, weights=vkt))
            vrb.. <- vrb.
            hvilk2 <- which(vrber == w)
            while(length(which(vrb.. == w)) < 25) {
              vrb..[which(vrb.. == vrber[which(vrber == w) + 1])] <- w
              hvilk2 <- c(hvilk2,  hvilk2[length(hvilk2)] + 1)
            }
            assign(vrb %+% "..", vrb..)
            aic2 <- AIC(lm(f(formel..), data=maaling, weights=vkt))
            if (aic1 < aic2) {
              vrb.[which(vrb. %in% vrber[hvilk1])] <- paste(vrber[hvilk1], collapse="+")
              endra <- T
              if (vis) {
                skriv(vnavn, ": ", paste(vrber[hvilk1], collapse=" og "),
                      " har blitt slått sammen pga. for lite data.", pre = "* ")
              }
              vrber[max(hvilk1)] <- paste(vrber[hvilk1], collapse="+")
              vrber <- vrber[-hvilk1[1:(length(hvilk1) - 1)]]
            } else {
              vrb.[which(vrb. %in% vrber[hvilk2])] <- paste(vrber[hvilk2], collapse="+")
              endra <- T
              if (vis) {
                skriv(vnavn, ": ", paste(vrber[hvilk2], collapse=" og "),
                      " har blitt slått sammen pga. for lite data.", pre = "* ")
              }
              vrber[hvilk2[1]] <- paste(vrber[hvilk2], collapse="+")
              vrber <- vrber[-hvilk2[2:length(hvilk2)]]
            }
          }
        }
        if (lengde > 1 & length(vrber) < 2) {
          formel. <- erstatt(formel., " + " %+% vrb %+% ".", "")
          vrber <- character()
          endra <- T
          if (vis) {
            skriv(vnavn," har blitt droppa fordi nesten alle data var fra én klasse.",
                  pre = "* ")
          }
        }
        lengde <- length(unique(vrb.))
        if (length(vrber) > 1 & length(which(vrb. %in% vrber)) >= 50) {
          L <- c(length(unique(vrb.)), Inf)
          while(L[1] > 1 & L[2] > L[1]) {
            VLI <- list(vrb.)
            assign(vrb %+% ".", vrb.)
            aic <- AIC(lm(f(formel.), data=maaling, weights=vkt))
            tekst <- ""
            for (j in 2:length(vrber)) {
              i <- vrber[j-1]
              j <- vrber[j]
              vrb.. <- vrb.
              vrb..[which(vrb.. == i | vrb.. == j)] <- i %+% "+" %+% j
              VLI[[length(VLI) + 1]] <- vrb..
              if (length(unique(vrb..)) == 1) {
                formel.. <- erstatt(formel.., " + " %+% vrb %+% "..", "")
              }
              assign(vrb %+% "..", vrb..)
              aic <- c(aic, AIC(lm(f(formel..), data=maaling, weights=vkt)))
              tekst <- c(tekst, i %+% " og " %+% j)
            }
            lav <- order(aic)[1]
            if (lav %=% 1) {
              lav <- order(aic)[2]
            }
            if (aic[lav] < aic[1] + DeltaAIC) {
              vrb. <- VLI[[lav]]
              if (nchar(tekst[lav])) {
                vrber[lav-1] <- vrber[lav-1] %+% "+" %+% vrber[lav]
                vrber <- vrber[-lav]
                endra <- T
                if (vis && nchar(tekst[lav])) {
                  skriv(vnavn, ": ", tekst[lav], " har blitt slått sammen.", 
                        pre = "* ")
                }
              }
            }
            L <- c(length(unique(vrb.)), L)}
          if (length(unique(vrb.)) > 2) {
            vrb.. <- rep(somtall[1], length(vrb.))
            for (i in 2:length(rekke)) {
              vrb..[which(vrbSIK == rekke[i])] <- somtall[i]
            }
            assign(vrb %+% ".", vrb.)
            assign(vrb %+% "..", vrb..)
            if (AIC(lm(f(formel..), data=maaling, weights=vkt)) < 
                AIC(lm(f(formel.),  data=maaling, weights=vkt)) - DeltaAIC) {
              vrb. <- vrb..
              #vrber <- somtall #¤ her trengs det endringer!
              endra <- T
              if (vis) {
                skriv(vnavn, " har blitt omgjort til en numerisk variabel.", pre = "* ")
              }
            }
          }
        }
        if (length(unique(vrb.)) %=% 1 & lengde > 1) {
          formel. <- erstatt(formel., " + " %+% vrb %+% ".", "")
          vrber <- character()
          endra <- T
          if (vis) {
            skriv(vnavn, " har blitt droppa fordi det ikke var forskjell mellom klassene.",
                  pre = "* ")
          }
        }
        if (!endra & vis) {
          skriv(vnavn, " har blitt beholdt uendra (med ", length(unique(vrb.)),
                " ulike verdier).", pre = "* ")
        }
        assign(vrb %+% ".", vrb.)
        maaling[,vrb] <- vrb.
        REKKEF[[vrb]] <- vrber
        RF2 <- REKKEF
      }
    }
    
    formel <- erstatt(formel., ".", "")
    explv <- erstatt(formel, " * ", " ")
    explv <- erstatt(explv,  " + ", " ")
    explv <- unlist(strsplit(explv, " "))
    modell <- lm(f(formel), data=maaling, weights=vkt)
    sdrag <- summary(modell)
    sdrag$call <- f(formel)
    if (vis) {
      print(sdrag)
    }
  }
  
  if (OK) {
    
    #################################################################################
    skriv("Ekstrapolering til ikke-målte vannforekomster",pre = "   ",linjer.over =1)
    skriv("=============================================",pre = "   ",linjer.under=1)
    
    utvalg <- ta.med <- which(Vf$kat == vannkategori)
    txt <- c(ifelse(vannkategori %inneholder% "L", "innsjø", NA),
             ifelse(vannkategori %inneholder% "R", "elve",   NA),
             ifelse(vannkategori %inneholder% "C", "kyst",   NA))
    txt <- paste(na.omit(txt), collapse="- og ")
    skriv("Det fins ", length(utvalg), " typifiserte ", txt, "vannforekomster.")
    if (!is.null(bareInkluder)) {
      ta.med <- numeric(0)
      if (is.list(bareInkluder)) {
        for (i in 1:length(bareInkluder$typ)) {
          ok <- which(Vf[,bareInkluder$typ[i]] == bareInkluder$vrd[i])
          if (length(ok)) {
            ta.med <- c(ta.med, ok)
          }
        }
      } else {
        ta.med <- ok <- which(Vf$type %in% bareInkluder)
      }
    }
    forskj <- length(utvalg) - length(utvalg %A% ta.med)
    utvalg <- utvalg %A% ta.med
    fjern <- numeric(0)
    if (!is.null(ikkeInkluder)) {
      for (i in length(ikkeInkluder$typ)) {
        feil <- which(Vf[,ikkeInkluder$typ[i]] == ikkeInkluder$vrd[i])
        if (length(feil)) {
          fjern <- c(fjern, feil)
        }
      }
    }
    forskj <- forskj + length(which(fjern %in% utvalg))
    if (length(which(fjern %in% utvalg))) {
      utvalg <- utvalg %-% fjern
    }
    if (forskj > 0) {
      skriv("Av disse har ", length(utvalg), " vannforekomster en vanntype som parameteren ",
            parameter, " er definert for.")
    }
    nydata <- matrix("", length(utvalg), length(explv), T, list(Vf$id[utvalg], explv))
    nydata <- as.data.frame(nydata, stringsAsFactors=FALSE)
    hvilke <- 1:length(explv) %-% which(explv %in% c("per", "rar", "akt"))
    nydata[, explv[hvilke]] <- Vf[utvalg, explv[hvilke]]
    if ("dyp" %in% colnames(nydata)) {
      if (any(nydata$dyp %in% 4:6)) {
        nydata$dyp[which(as.numeric(nydata$dyp) > 3)] <-
          as.character(as.numeric(nydata$dyp[which(as.numeric(nydata$dyp) > 3)]) - 3)
      }
    }
    fjern <- numeric(0)
    beskjed <- c()
    for (i in explv[hvilke]) {
      andre <- unique(nydata[,i]) %-% unique(maaling[,i])
      if (length(andre)) {
        for (j in andre) {
          if (i %in% names(RF1)) { # dvs hvis variabelen er nominal
            w <- which(RF1[[i]] %inneholder% j)
            if (length(w)) {
              nydata[which(nydata[,i] == j),i] <- RF1[[i]][w]
            } else {
              if (length(RF1a[[i]]) && any(RF1 %inneholder% RF1a[[i]])) {
                nydata[which(nydata[,i] == j),i] <- RF1a[[i]]
              } else {
                fjern <- c(fjern, which(nydata[,i] == j))
                beskjed[length(beskjed) + 1] <- "er " %+% length(which(nydata[,i]==j)) %+%
                  " vannforekomster av typen \"" %+% tolower(VN1[[i]]) %+% " = " %+% j %+%
                  "\", som det ikke foreligger målinger av " %+% parameter %+% " fra"
              }
            }
          } else { # dvs hvis variabelen er ordinal
            if (is.numeric(maaling[,i])) {
              in.mente <- rep(0, nrow(nydata))
              for (n in 1:length(TV2[[i]])) {
                in.mente[which(nydata[,i] == RF2.sik[[i]][n])] <- TV2[[i]][n]
              }
              nydata[,i] <- in.mente
            } else {
              w <- which(RF2[[i]] %inneholder% j)
              if (length(w)) {
                nydata[which(nydata[,i] == j),i] <- RF2[[i]][w]
              } else {
                if (j %in% RF2.sik[[i]]) {
                  w <- which(RF2.sik[[i]] == j)
                  if (w < which(RF2.sik[[i]] == substr(RF2[[i]][1],1,1))) {
                    nydata[which(nydata[,i] == j),i] <- RF2[[i]][1]
                  }
                  for (n in 1:length(RF2[[i]])) {
                    k <- which(RF2.sik[[i]] == substr(RF2[[i]][n],1,1))
                    l <- which(RF2.sik[[i]] == substr(RF2[[i]][n], nchar(RF2[[i]][n]),
                                                      nchar(RF2[[i]][n])))
                    m <- which(RF2.sik[[i]] == substr(RF2[[i]][min(n+1,length(RF2[[i]]))],1,1))
                    if (w >= k & w <= l) {
                      nydata[which(nydata[,i] == j),i] <- RF2[[i]][n]
                    }
                    if (w > l & w < m) {
                      if (length(which(maaling[,i] == RF2[[i]][n])) >
                          length(which(maaling[,i] == RF2[[i]][n+1]))) {
                        nydata[which(nydata[,i] == j),i] <- RF2[[i]][n]
                      } else {
                        nydata[which(nydata[,i] == j),i] <- RF2[[i]][n+1]
                      }
                    }
                  }
                  if (w > l) {
                    nydata[which(nydata[,i] == j),i] <- RF2[[i]][length(RF2[[i]])]
                  }
                } else {
                  if (length(RF2a[[i]]) && any(RF2 %inneholder% RF2a[[i]])) {
                    nydata[which(nydata[,i] == j),i] <- RF2a[[i]]
                  } else {
                    fjern <- c(fjern, which(nydata[,i] == j))
                    beskjed[length(beskjed) +1] <- "har " %+% length(which(nydata[,i]==j)) %+%
                      " vannforekomst" %+% ifelse(length(which(nydata[,i]==j))==1,"","er") %+%
                      " den ukjente vanntypen \""  %+%  tolower(VN2[[i]])  %+% " = " %+% j %+%
                      "\""
                  }
                }
              }
            }
          }
        }
      }
    }
    if (length(fjern)) {
      utvalg <- utvalg[-fjern]
      nydata <- nydata[-fjern,]
      sluttbeskjed <- ifelse(length(fjern) > 1, "Diss", "Denn") %+%
        "e blir ekskludert fra ekstrapoleringa, slik at " %+% length(utvalg) %+%
        " vannforekomster er igjen."
      if (length(beskjed) > 1) {
        skriv("Dessverre ...")
        for (i in 1:length(beskjed)) {
          skriv(beskjed[i], ifelse(i == length(beskjed), ".", ";"), pre = "- ")
        }
        skriv(sluttbeskjed)
      } else {
        skriv("Dessverre ", beskjed[1], ". ", sluttbeskjed)
      }
    }
    
    felles <- length(unique(maaling$vfo %A% rownames(nydata)))
    if (felles < length(unique(maaling$vfo))) {
      skriv("Det forelå målinger for ", length(unique(maaling$vfo)) - felles,
            " av vannforekomstene som ble fjerna. Disse inngår da heller ikke i ",
            "ekstrapoleringa.", pre = "OBS: ", linjer.under = 1)
    }
    
    andel <- felles / length(utvalg)
    tekst <- "% av de relevante vannforekomstene (" %+% felles %+% " av " %+%
      length(utvalg) %+% ")."
    prefiks <- ""
    lo <- 0
    if (andel < minsteAndel) {
      OK <- FALSE
      tekst <- tekst %+% " Dette er dessverre for lite til å ekstrapolere!"
      prefiks <- "FEIL: "
      lo <- 1
    }
    if (andel < 0.01) {
      skriv("Det foreligger målinger for under 1 ", tekst, 
            pre = prefiks, linjer.over = lo, linjer.under = 1)
    } else {
      skriv("Det foreligger altså målinger for ", round(andel * 100), tekst,
            pre = prefiks, linjer.over = lo, linjer.under = 1)
    }
  }
  
  if (OK) {

    # set.seed(144) # ¤
    
    if (any(names(nydata) == "akt")) {
      akter <- unique(unlist(strsplit(maaling$akt, "[+]")))
      if (!all(akter %in% Aktiviteter$id)) {
        ukjenteAktiviteter <- akter %-% Aktiviteter$id
        for (j in ukjenteAktiviteter) {
          Aktiviteter <- rbind(Aktiviteter, 
                               list(j, "ukjent aktivitet", 0))
          names(Aktiviteter)[nrow(Aktiviteter)] <- j
        }
        skriv("Noen overvåkingsaktiviteter er ukjent! Disse ble nå tildelt en skår på 0. ",
              "(Dette gjelder: ", paste(ukjenteAktiviteter, collapse=", "), ".)",
              pre = "OBS OBS! ", linjer.under = 1)
      }
      avekt <- aktivitetsvekt^(-abs(Aktiviteter$skaar))
      avekt <- avekt[which(Aktiviteter$id %in% akter)]
      bvekt <- rep(0, length(unique(maaling$akt)))
      names(bvekt) <-   sort(unique(maaling$akt))
      for (i in 1:length(avekt)) {
        w <- which(names(bvekt) %inneholder% (Aktiviteter$id %A% akter)[i])
        bvekt[w] <- bvekt[w] + avekt[i]
      }
      avekt <- bvekt / sum(avekt)
      rm(bvekt)
      nydata$akt <- sample(sort(unique(maaling$akt)), nrow(nydata), T, avekt)
    }
    
    nydata$rar <- 0
    
    for (i in explv[hvilke]) {
      if (is.character(maaling[,i]) & !is.character(nydata[,i])) {
        nydata[,i] <- as.character(nydata[,i])
      }
      if (is.numeric(maaling[,i]) & !is.numeric(nydata[,i])) {
        nydata[,i] <- as.numeric(nydata[,i])
      }
    }
    
    konfident <- which(rownames(nydata) %in% maaling$vfo)
    #BLAA
    #  konfident <- matrix(FALSE, nrow(nydata), length(NI.aar))
    #  maalt.gs <- maalt.sd <- matrix(NA, nrow(nydata), length(NI.aar))
    #  colnames(konfident) <- colnames(maalt.gs) <- colnames(maalt.sd) <- NI.aar
    #  rownames(konfident) <- rownames(maalt.gs) <- rownames(maalt.sd) <- rownames(nydata)
    #  for (i in rownames(nydata)) {
    #    for (j in as.character(NI.aar)) {
    #      hvilke <- which(maaling$vfo == i & as.character(maaling$per) == j)
    #      if (length(hvilke)) {
    #        konfident[i,j] <- TRUE
    #        maalt.gs[i,j] <- weighted.mean(maaling$vrd[hvilke], maaling$ant[hvilke])
    #        maalt.sd[i,j] <- -1
    #        if (length(hvilke) > 2) {
    #          maalt.sd[i,j] <- sd(maaling$vrd[hvilke])
    #          if (length(hvilke) < 50) {
    #            maalt.sd[i,j] <- sd(maaling$vrd[hvilke]) / c(NA,0.80,0.89,0.92,0.94,0.95,
    #                                                         0.96,0.97,0.97,0.97,rep(0.98,7),rep(0.99,48))[length(hvilke)]
    #          }
    #        }
    #      }
    #    }
    #  }
    #  if (!any(maalt.sd >= 0)) {
    #    cat("HVA NÅ???\n")
    #  } #¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
    #  if (any(maalt.sd < 0)) {
    #    cv <- as.vector(maalt.sd / (maalt.gs + 1e-6))
    #    md <- lm(cv ~ as.vector(maalt.gs), subset = which(as.vector(maalt.sd) >= 0))
    #    yaa <- md$coeff[1]
    #    stg <- md$coeff[2]
    #    hvilke <- (maalt.sd < 0 & !is.na(maalt.sd))
    #    maalt.sd[hvilke] <- (yaa + stg * maalt.gs[hvilke]) * maalt.gs[hvilke]
    #    rm(cv, md, yaa, stg, hvilke)
    #  }

    nydata$per <- factor(NI.aar[1], levels=levels(maaling$per))
    df <- modell$df
  }

  if (OK) {
    
    ##################################################
    skriv("Simulering", pre = "   ", linjer.over  = 1)
    skriv("==========", pre = "   ", linjer.under = 1)
    
    nsim <- iterasjoner
    UT <- list()
    for (e in tolower(rapportenhet)) {
      UT[e] <- NA
      if ("fylker" %begynner% e) {
        names(UT)[length(UT)] <- "fylke"
        UT$fylke <- array(0, c(length(FYL), length(NI.aar), nsim + 1),
                          list(fylke=FNR, aar=NI.aar, 
                               simuleringer=c("pred", 1:nsim)))
      }
      if ("kommuner" %begynner% e) {
        names(UT)[length(UT)] <- "kommune"
        UT$kommune <- array(0, c(length(KOM), length(NI.aar), nsim + 1),
                            list(kommune=KOM, aar=NI.aar, 
                                 simuleringer=c("pred", 1:nsim)))
      }
      if ("landsdeler" %begynner% e) {
        names(UT)[length(UT)] <- "landsdel"
        UT$landsdel <- array(0, c(5, length(NI.aar), nsim + 1),
                             list(landsdel=c("Østlandet", "Sørlandet", "Vestlandet", 
                                             "Midt-Norge", "Nord-Norge"),
                                  aar=NI.aar, simuleringer=c("pred", 1:nsim)))
      }
      if ("norge" %begynner% e) {
        names(UT)[length(UT)] <- "Norge"
        UT$Norge <- array(0, c(1, length(NI.aar), nsim + 1),
                          list(rike="Norge", aar=NI.aar, 
                               simuleringer=c("pred", 1:nsim)))
      }
    }

    # Simulering -----------------------------------------------
    
    {
      areal <- rep(1, nrow(nydata))
      if (vannkategori %=% "L") {
        areal <- Vf$areal[utvalg]
        areal[which(areal < 0.5)] <- 0.5
        w <- which(is.na(areal))
        if (length(w)) {
          areal[w] <- c(0.5, 1.58, 15.8, 158)[Vf$stø[utvalg[w]]]
        }
        areal <- areal^(arealvekt/2)
      }
      # BLAA
      # alle.maalt <- matrix(TRUE, length(KOM), length(NI.aar), dimnames=list(KOM, NI.aar))
      if (nsim < 1) {
        simdata   <- array(0, c(nrow(nydata), length(NI.aar), 1),
                           list(vannforekomst=rownames(nydata), aar=NI.aar, 
                                simuleringer="pred"))
        for (j in 1:length(NI.aar)) {
          nydata$per <- factor(NI.aar[i], levels=levels(maaling$per))
          pred <- predict(modell, nydata, TRUE, interval="pred", level=0.5, weights=1)
          simdata[,i,1] <- pred$fit[,1]
        }
      } else {
        skriv("Nå begynner simuleringa. Det er valgt ", nsim, " iterasjoner.",
              ifelse(nsim > 1000, " Dette vil ta sin tid.", ""))
        s <- 0
        while (s < nsim) {
          SIM <- min(1000, nsim - s)
          simdata   <- array(0, c(nrow(nydata), length(NI.aar), SIM),
                             list(vannforekomst=rownames(nydata), aar=NI.aar, 
                                  simuleringer=1:SIM))
          for (i in (1:SIM + s)) {
            slumptall <- rt(nrow(nydata), df)
            names(slumptall) <- rownames(nydata)
            if (any(names(nydata) == "akt")) {
              nydata$akt <- sample(sort(unique(maaling$akt)), nrow(nydata), T, avekt)
              # BLAA
              # for (j in which(apply(konfident, 1, any))) {
              #   nydata$akt[j] <- sample(unique(maaling$akt[which(maaling$vfo ==
              #                                                      rownames(nydata)[j])]), 1)
              # }
            }
            for (j in 1:length(NI.aar)) {
              nydata$per <- factor(NI.aar[j], levels=levels(maaling$per))
              pred <- predict(modell, nydata, TRUE, interval="pred", level=0.5, weights=1)
              conf <- predict(modell,nydata[konfident,],TRUE,interval="conf",level=0.5,weights=1) # !BLAA
              pred$fit[,2] <- 0.5 * (pred$fit[,3] - pred$fit[,2]) / qt(0.75, df)
              pred <- pred$fit[,1:2]
              # BLAA
              # pred[konfident[,j],1] <- maalt.gs[konfident[,j],j]
              # pred[konfident[,j],2] <- maalt.sd[konfident[,j],j]
              colnames(pred)[2] <- "SD"
              simdata[, j, i - s] <- pred[,1] + pred[,2] * slumptall
            }
            if (tell) {
              cat("Ferdig med " %+% floor(100*i/nsim) %+% " % av simuleringene.\r")
            }
          }
          if (tell) {
            cat("\n")
          } else {
            cat("Ferdig med 100% av simuleringene.\n")
          }
          rm(slumptall)
          gc(verbose = FALSE)
          
          
          # Oppskalering til rapporteringsenheter
          
          for (e in rapportenhet) {
            if ("fylker" %begynner% e) {
              for (j in as.character(NI.aar)) {
                for (f in FNR) {
                  w <- which(Vf$fylke %inneholder% f)
                  w <- which(rownames(nydata) %in% Vf$id[w])
                  if (length(w)) {
                    if (length(w) > 1) {
                      UT$fylke[f, j, 1:SIM + s + 1] <- apply(simdata[w, j, ], 2, 
                                                             weighted.mean,
                                                             areal[w], na.rm = TRUE)
                    } else {
                      UT$fylke[f, j, 1:SIM + s + 1] <- simdata[w, j, ]
                    }
                  } else {
                    UT$fylke[f, j, 1:SIM + s + 1] <- NA
                  }
                }
              }
            }
            
            if ("kommuner" %begynner% e) {
              if (adminAar > 1976) {
                for (k in KOM) {
                  w <- which(Vf$kommune %inneholder% (k %+% ","))
                  w <- which(rownames(nydata) %in% Vf$id[w])
                  if (length(w)) {
                    if (length(w) > 1) {
                      for (j in as.character(NI.aar)) {
                        UT$kommune[k, j, 1:SIM + s + 1] <-
                          apply(simdata[w, j, ], 2, weighted.mean, 
                                areal[w], na.rm = TRUE)
                        # BLAA
                        # alle.maalt[k,j] <- alle.maalt[k,j] & all(konfident[w,j])
                      }
                    } else {
                      UT$kommune[k, , 1:SIM + s + 1] <- simdata[w,,]
                      # BLAA
                      # alle.maalt[k,] <- alle.maalt[k,] & konfident[w,]
                    }
                  } else {
                    UT$kommune[k, , 1:SIM + s + 1] <- NA
                  }
                  if (tell) {
                    cat("Ferdig med " %+% which(KOM==k) %+% " av " %+% 
                        length(KOM) %+% " kommuner.\r")
                  }
                }
                if (tell) {
                  cat("\n")
                } else {
                  cat("Ferdig med " %+% length(KOM) %+% " av " %+% 
                        length(KOM) %+% " kommuner.\n")
                }
              }
            }
            if ("landsdeler" %begynner% e) {
              for (j in as.character(NI.aar)) {
                for (f in 1:5) {
                  w <- c()
                  for (k in 1:length(WF[[f]])) {
                    w <- c(w, which(Vf$fylke %inneholder% WF[[f]][k]))
                  }
                  w <- which(rownames(nydata) %in% Vf$id[w])
                  if (length(w)) {
                    if (length(w) > 1) {
                      UT$landsdel[f, j, 1:SIM + s + 1] <- 
                        apply(simdata[w, j, ], 2, weighted.mean,
                              areal[w], na.rm=TRUE)
                    } else {
                      UT$landsdel[f, j, 1:SIM + s + 1] <- simdata[w, j, ]
                    }
                  } else {
                    UT$landsdel[f, j, 1:SIM + s + 1] <- NA
                  }
                }
                #skriv(j, ":", linjer.over = 1)
                #sdrag <- UT$landsdel[,j,1]
                #names(sdrag) <- c("Østlandet","Sørlandet","Vestlandet","Midt-Norge","Nord-Norge")
                #print(sdrag)}}
              }
            }
            if ("norge" %begynner% e) {
              for (j in as.character(NI.aar)) {
                UT$Norge[1, j, 1:SIM + s + 1] <- apply(simdata[, j, ], 2, weighted.mean,
                                                       areal, na.rm=TRUE)
              }
              #skriv("Norge:", linjer.over = 1)
              #sdrag <- UT$Norge[1,,1]
              #print(sdrag)}}
            }
          }
          
          rm(simdata)
          gc(verbose = FALSE)
          s <- i
        }
      }
      for (i in 1:length(UT)) {
        for (j in 1:length(NI.aar)) {
          for (k in 1:dim(UT[[i]])[1]) {
            UT[[i]][k, j, 1] <- median(UT[[i]][k, j, -1], na.rm=TRUE)
          }
        }
      }
    }
  }
  
  if (OK) {
    skriv("Sånn. Da har vi omsider kommet i mål.", linjer.over = 1 , linjer.under = 1)
    return(UT)
  } else {
    return(NULL)
  }
}
    


