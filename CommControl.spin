{   Project: EE-9 Assignment
    Platform: Parallax Project USB Board
    Revision: 3
    Author: Lim Heng Kiat
    Date: 29 Nov 2021
}


CON
'        _clkmode = xtal1 + pll16x     'Standard clock mode * crystal frequency = 80 MHz
'        _xinfreq = 5_000_000
'        _ConClkFreq = ((_clkmode - xtal1 >> 6) * _xinfreq)
'        _Ms_001 = _ConClkFreq / 1_000

        commRxPin               = 21  'dout
        commTxPin               = 20  'din
        commBaud                = 9600

        commStart               = $7A
        commForward             = $01
        commReverse             = $02
        commLeft                = $03
        commRight               = $04
        commStopAll             = $AA
VAR    'Global variable
  long cog2IDNum, cog2Stack[64]
  long _Ms_001
OBJ    'Objects

  Comm      : "FullDuplexSerial.Spin"
  'Term          : "FullDuplexSerial.Spin"
PUB Start(timer,decision)

  _Ms_001 := timer

  Stop

  cog2IDNum := cognew(Main(decision),@cog2Stack)

  return
PUB Stop
  if cog2IDNum
    cogstop (cog2IDNum~)
PUB Main(decision)|rxValue

  'Declaration & initilisation
  Comm.Start(commTxPin, commRxPin, 0,commBaud)
  Pause(50)' wait 2 second

  'Run & get readings
  repeat

'    long[decision]:=1
    rxValue := Comm.RxCheck
    if (rxValue == commStart)
      repeat
        rxValue := Comm.RxCheck
        case rxValue
          commForward:
                                long[decision]:=1


          commReverse:
                                long[decision]:=2


          commLeft:
                                long[decision]:=3


          commRight:
                                long[decision]:=4


          commStopAll:
                                long[decision]:=0

PRI Pause (ms) | t
  t := cnt - 1088
  repeat (ms#>0)                ' sync with system counter
    waitcnt (t+=_Ms_001)        ' delay must be > 0
  return