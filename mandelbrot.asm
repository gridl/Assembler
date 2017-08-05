          JOB  MANDELBROT
*GENERATES A MANDELBROT SET ON THE 1401
*KEN SHIRRIFF  HTTP://RIGHTO.COM
          CTL  6641
          ORG  087
X1        DCW  001  *INDEX 1, COL COUNTER TO STORE PIXEL ON LINE
          ORG  333
*
*VALUES ARE FIXED POINT, I.E. SCALED BY 10000
*Y RANGE (-1, 1). 60 LINES YIELDS INC OF 2/60*10000
*
YINC      DCW  333
XINC      DCW  220          *STEP X BY .0220
*
*Y START IS -1, MOVED TO -333*30 FOR SYMMETRY
*
Y0        DCW  -09990       *PIXEL Y COORDINATE
*
*X START IS -2.5
*
X0INIT    DCW  -22000       *LEFT HAND X COORDINATE
X0        DCW  00000        *PIXEL X COORDINATE
ONE       DCW  001
ZR        DCW  00000        *REAL PART OF Z
ZI        DCW  00000        *IMAGINARY PART OF Z
ZR2       DCW  00000000000  *ZR^2
ZI2       DCW  00000000000  *ZI^2
ZRZI      DCW  00000000000  *2 *ZR *ZI
ZMAG      DCW  00000000000  *MAGNITUDE OF Z: ZR^2 + ZI^2
TOOBIG    DCW  00400000000  *4 (SCALED BY 10000 TWICE)
I         DCW  00           *ITERATION LOOP COUNTER
ROW       DCW  01
ROWS      DCW  60
COLS      DCW  132
MAX       DCW  24           *MAXIMUM NUMBER OF ITERATIONS
*
*ROW LOOP
*X1 = 1  (COLUMN INDEX)
*X0 = -2.2 (X COORDINATE)
*
START     LCA  ONE, X1     *ROW LOOP: INIT COL COUNT
          LCA  X0INIT, X0  *X0 = X0INIT
          CS   332         *CLEAR PRINT LINE
          CS               *CHAIN INSTRUCTION
*
*COLUMN LOOP
*
COLLP     LCA  @00@, I     *I = 0
          MCW  X0, ZR      *ZR = X0
          MCW  Y0, ZI      *ZI = Y0
*
*INNER LOOP:
*ZR2 = ZR^2
*ZI2 = ZI^2
*IF ZR2+ZI2 > 4: BREAK
*ZI = 2*ZR*ZI + Y0
*ZR = ZR2 - ZI2 + X0
*
INLP      MCW  ZR, ZR2-6   *ZR2 =  ZR
          M    ZR, ZR2     *ZR2 *= ZR
          MCW  ZI, ZI2-6   *ZI2 =  ZI
          M    ZI, ZI2     *ZI2 *= ZI
          MCW  ZR2, ZMAG   *ZMAG = ZR^2
          A    ZI2, ZMAG   *ZMAG += ZI^2
          C    TOOBIG, ZMAG  *IF ZMAZ > 4: BREAK
          BH   BREAK
          MCW  ZI, ZRZI-6  *ZRZI = ZI
          M    ZR, ZRZI    *ZRZI = ZI*ZR
          A    ZRZI, ZRZI  *ZRZI = 2*ZI*ZR
          MCW  ZRZI-4, ZI  *ZI = ZRZI (/10000)
          MZ   ZRZI, ZI    *TRANSFER SIGN
          A    Y0, ZI      *ZI += Y0
          S    ZI2, ZR2    *ZR2 -= ZI2
          MCW  ZR2-4, ZR   *ZR = ZR2 (/10000)
          MZ   ZR2, ZR     *TRANSFER SIGN
          A    X0, ZR      *ZR += X0
*
*IF I++ != MAX: GOTO INLP
*
          A    ONE, I      *I++
          C    MAX, I      *IF I != MAX THEN LOOP
          BU   INLP
          MCW  @X@, 200&X1  *STORE AN X INTO THE PRINT LINE
BREAK     C    X1, COLS    *COL LOOP CONDITION
          A    ONE, X1
          A    XINC, X0    *X0 += 0.0227
          BU   COLLP
          W                *WRITE LINE
*
*Y0 += YINC
*IF ROW++ != ROWS: GOTO ROWLP
*
          C    ROW, ROWS   *ROW LOOP CONDITION
          A    ONE, ROW
          A    YINC, Y0    *Y0 += 0.0333
          BU   START
FINIS     H    FINIS       HALT LOOP
          END  START
