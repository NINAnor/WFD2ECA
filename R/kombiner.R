### kombiner
# Funksjoner til NI_vannf
# ved Hanno Sandvik
# desember 2023
# se https://github.com/NINAnor/NI_vannf
###



# Kombiner to utmatinger
# (Må kun brukes for ulike vannkategorier innenfor samme parameter!)
kombiner <- function(ut1, ut2) {
  ok <- TRUE
  UT <- ut1
  if (names(ut1) %=% names(ut2) &
      !is.null(attr(ut1, "parameter")) &
      attr(ut1, "parameter") %=% attr(ut2, "parameter") &
      !is.null(attr(ut1, "vannkategori")) &
      !is.null(attr(ut2, "vannkategori"))) {
    for (i in names(ut1)) {
      if (dimnames(ut1[[i]])[1:2] %=% dimnames(ut2[[i]])[1:2]) {
        ny <- array(0, dim = dim(ut1[[i]]) + c(0, 0, dim(ut2[[i]])[3] - 1))
        dimnames(ny) <- list(dimnames(ut1[[i]])[[1]],
                             dimnames(ut1[[i]])[[2]],
                             c("pred", 2:(dim(ny)[3]) - 1))
        ny[, , 2:dim(ut1[[i]])[3]] <- ut1[[i]][, , 2:dim(ut1[[i]])[3]]
        ny[, , dim(ut1[[i]])[3] - 1 +
             2:dim(ut2[[i]])[3]] <- ut2[[i]][, , 2:dim(ut2[[i]])[3]]
        for (j in 1:dim(ny)[1]) {
          for (k in 1:dim(ny)[2]) {
            ny[j, k, 1] <- median(ny[j, k, -1])
          }
        }
        UT[[i]] <- ny
      } else {
        ok <- FALSE
      }
    }
    if (ok) {
      attr(UT, "parameter")     <- attr(ut1, "parameter")
      attr(UT, "vannkategori")  <- attr(ut1, "vannkategori") %+% "," %+%
        attr(ut2, "vannkategori")
      attr(UT, "tidspunkt")     <- Sys.time()
      attr(UT, "innstillinger") <- NULL
      attr(UT, "beskjeder")     <- NULL
    }
  } else {
    ok <- FALSE
  }
  if (ok) {
    return(UT)
  } else {
    skriv("De to utmatingene var ikke kompatible og kunne ikke kombineres!",
          pre = "FEIL: ", linjer.over = 1, linjer.under = 1)
    return(NULL)
  }
}

