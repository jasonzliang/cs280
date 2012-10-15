note: The code assumes the it is located inside the 'code' folder and that the training/testing data is located inside another 'data' folder. The data folder is left empty for size reasons so put your own train_small.mat, test.mat inside it.

1)Running "runRawPixel" gives the accuracy results for using raw pixel values as features.

2)Running "runSpatial" gives the accuracy results for using spatial pyramids/summing up pixel intensities as features.

3)Running "runHOG" gives the accuracy results for using normalized PHOGs with tap filter. 

4)Running "runHOG2" gives the accuracy results for using unnormalized PHOGs with tap filter. 

5)Running "runHOG3" gives the accuracy results for using normalized PHOGs with gaussian derivative filter. 

