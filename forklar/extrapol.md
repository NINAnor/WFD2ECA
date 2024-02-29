# Ekstrapolering til andre vannforekomster

Et trinn av [dataflyten](dataflyt.md) er _ekstrapolering av [mEQR-verdier](mEQR.md) til vannforekomster som det ikke foreligger målinger fra_, basert på modellen som ble tilpassa til målingene.
Funksjonen [`fraVFtilNI`](fraVFtilNI.md) legger opp til to måter å ekstrapolere på:

1. Ekstrapolering skjer til alle (eller flest mulig) vanntyper som den aktuelle vannforskriftsparameteren har definerte referanseverdier og klassegrenser i. Hvis det f.eks. ikke foreligger målinger fra svært store innsjøer (størrelsesklasse 4), ekstrapoleres det likevel til slike innsjøer, basert på antagelsen om at de har samme gjennomsnittlige tilstand som store innsjøer (størrelsesklasse 3). Dette er løsninga som var implementert i tidligere versjoner av koden (til og med versjon 1.1). Den brukes om parameteriseringa til `fraVFtilNI` inneholder `ekstrapolering = "alle"`.
2. Ekstrapolering begrenses til vanntyper som det foreligger målinger fra. Hvis det f.eks. ikke foreligger målinger fra svært store innsjøer, blir slike innsjøer ekskludert fra ekstrapoleringa. Om det derimot foreligger målinger fra svært store innsjøer (størrelsesklasse 4) _og_ middels store innsjøer (størrelsesklasse 2) _og_ disse to størrelsesklassene har samme tilstand ifølge den tilpassa modellen, antas det at den mellomliggende størrelsesklassen 3 (store innsjøer) også har samme tilstand; disse ekstrapoleres det i så fall til. Dette er løsninga som nå er standardinnstillinga (`ekstrapolering = "kjente"`) av funksjonen `fraVFtilNI` (fra og med versjon 1.2).




