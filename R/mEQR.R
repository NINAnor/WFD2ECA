### mEQR
# Funksjoner til NI_vannf
# ved Hanno Sandvik
# desember 2023
# se https://github.com/NINAnor/NI_vannf
###



# Beregne mEQR-verdier ("modifiserte EQR-verdier")
mEQR <- function(x, klassegrenser) {
  K <- klassegrenser
  if ((K[8] < K[1]) %=% TRUE) {
    K <- -K
    x <- -x
  }
  x <- ifelse(x < K[1], NA,
       ifelse(x < K[2], (x - K[1]) / (K[2] - K[1]) - 1,
       ifelse(x < K[3], (x - K[2]) / (K[3] - K[2]) + 0,
       ifelse(x < K[4], (x - K[3]) / (K[4] - K[3]) + 1,
       ifelse(x < K[5], (x - K[4]) / (K[5] - K[4]) + 2,
       ifelse(x < K[6], (x - K[5]) / (K[6] - K[5]) + 3,
       ifelse(x < K[7], (x - K[6]) / (K[7] - K[6]) + 4,
       ifelse(x <=K[8], (x - K[7]) / (K[8] - K[7]) + 5,
                        NA))))))))
  return(x * 0.2)
}

