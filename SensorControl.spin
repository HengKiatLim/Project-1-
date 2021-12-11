{   Project: EE-9 Assignment
    Platform: Parallax Project USB Board
    Revision: 3
    Author: Lim Heng Kiat
    Date: 29 Nov 2021
}


CON
        '_clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        '_xinfreq = 5_000_000
      '_ConClkFreq = ((_clkmode - xtal1 >> 6) * _xinfreq)
      '_Ms_001 = _ConClkFreq / 1_000

''[ declare pin for sensor]
'Ultrasonic 1 (Front)  - I2C Bus 1
ultra1SCL = 6
ultra1SDA = 7
'Ultrasonic 2 (Back)  - I2C Bus 2
ultra2SCL = 8
ultra2SDA = 9
  ' TOF1 (Front) -I2C Bus 3
  tof1SCL = 0 'clk
  tof1SDA = 1 'data
  tof1RST = 14 'reset pin

  'TOF2  (back) -I2C Bus 4
  tof2SCL = 2 'clk
  tof2SDA = 3 'data
  tof2RST = 15 'reset pin

        tofAdd = $29  'default address is $29

VAR  ' Global variable
  long cogIDNum, cogStack[64]
  long _Ms_001

OBJ  ' Objects
  'Term         : "FullDuplexSerial.Spin"   'UART communication for debugging
  Ultra         : "EE-7_Ultra_v2.spin"      '<--Embedded a 2-element obj within EE-7_Ultra_v2
  ToF[2]        : "EE-7_Tof.spin"
  'Create a hardware definition file
PUB Start(mainMSVal,mainToF1Add,mainToF2Add,mainUltra1Add,mainUltra2Add)

  _Ms_001 := mainMSVal

  Stop

  cogIDNum := cognew(sensorCore(mainToF1Add,mainToF2Add,mainUltra1Add,mainUltra2Add),@cogStack)

  return
PUB Stop
  if cogIDNum
    cogstop (cogIDNum~)
PUB sensorCore(mainToF1Add,mainToF2Add,mainUltra1Add,mainUltra2Add)

  'Declaration & Initilisation
  Ultra.Init(ultra1SCL, ultra1SDA, 0)                   'Assigning & init the first element obj in EE-7_Ultra_v2
  Ultra.Init(ultra2SCL, ultra2SDA, 1)                   'Assigning & init the second element obj in EE-7_Ultra_v2

  tofInit                       'Perform init for both ToF sensors

  'Run & get readings
  repeat
    long[mainUltra1Add]:=Ultra.readSensor(0)            'Reading from first element obj
    long[mainUltra2Add]:=Ultra.readSensor(1)            'Reading from second element obj
    long[mainToF1Add]:=ToF[0].GetSingleRange(tofAdd)
    long[mainToF2Add]:=ToF[1].GetSingleRange(tofAdd)
    Pause(50)
PRI tofInit  |  i
{{ }}
  ToF[0].Init(tof1SCL, tof1SDA, tof1RST)
  ToF[0].ChipReset(1)           'Last state is ON position
  Pause(1000)
  ToF[0].FreshReset(tofAdd)
  ToF[0].MandatoryLoad(tofAdd)
  ToF[0].RecommendedLoad(tofAdd)
  ToF[0].FreshReset(tofAdd)

  ToF[1].Init(tof2SCL, tof2SDA, tof2RST)
  ToF[1].ChipReset(1)           'Last state is ON position
  Pause(1000)
  ToF[1].FreshReset(tofAdd)
  ToF[1].MandatoryLoad(tofAdd)
  ToF[1].RecommendedLoad(tofAdd)
  ToF[1].FreshReset(tofAdd)

  return

PRI Pause (ms) | t
  t := cnt - 1088
  repeat (ms#>0)
    waitcnt (t+=_Ms_001)
  return