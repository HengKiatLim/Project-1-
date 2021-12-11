{   Project: EE-9 Assignment
    Platform: Parallax Project USB Board
    Revision: 3
    Author: Lim Heng Kiat
    Date: 29 Nov 2021
}


CON
        _clkmode = xtal1 + pll16x     'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000
        _ConClkFreq = ((_clkmode - xtal1 >> 6) * _xinfreq)
        _Ms_001 = _ConClkFreq / 1_000

'Config motor controls
 motTypeFor = 1
 motTypeRev = 2
 motTypeLeft = 3
 motTypeRignt = 4

 motSlow = 100
 motNormal = 200
 motFast = 300

'Config Comm controls
  commForward = 1
  commReverse = 2
  commLeft = 3
  commRight = 4
  commStop = 0

'Config for sensor
  senUltraSafeVal = 280         'more than this value
  senTofSafeVal = 190         'less than this value

VAR    'Global variable

'sensor control varible

  long mainToF1Val,mainToF2Val,mainUltra1Val,mainUltra2Val

'Motor Control Var
 long dir,speed

'Comm control var
 long decisionMode

OBJ    'Objects

  Term          : "FullDuplexSerial.Spin"   'UART communication for debugging
  sensor        : "SensorControl.spin"        '<--Object / Blackbox
  comm          : "CommControl.spin"
  motor         : "MotorControl.spin"

  'Create a hardware definition file

PUB Main
'   Term.Start(31, 30, 0, 115200)
'   Pause(500) 'Wait 3 seconds

  'declaration & initilisation

  sensor.Start(_Ms_001,@mainToF1Val,@mainToF2Val,@mainUltra1Val,@mainUltra2Val)

  motor.Start(_Ms_001, @dir,@speed)

  comm.Start(_Ms_001,@decisionMode)

'       decisionMode:=1

  'Semi-Autonomous Behaviour
  repeat
'    Term.Dec(decisionMode)
'    Term.Dec(dir)
'    Term.Dec(speed)
    case decisionMode
      commForward:
        'moves forward after checking sensors
        if ((mainUltra1Val > senUltraSafeVal) and (mainToF1Val < senTofSafeVal))
          dir:= motTypeFor     '<--assigning 1 to motion type
          speed:= motSlow
        else
          dir:=0
          speed:=0

      commReverse:
        'moves reverse after checking sensors
        if ((mainUltra2Val > senUltraSafeVal) and (mainToF2Val < senTofSafeVal))
          dir:= motTypeRev     '<--assigning 2 to motion type
          speed:= motSlow
        else
          dir:=0
          speed:=0

      commLeft:

          dir := motTypeLeft   '<--assigning 3 to motion type
          speed := motSlow

      commRight:

          dir := motTypeRignt  '<--assigning 4 to motion type
          speed := motSlow

      commStop:
        'stop motor
          dir:=0
          speed:=0
'    Term.Str(String(13, "Ultrasonic 1 Readings: "))
'    Term.Dec(mainUltra1Val)
'    Term.Str(String(13, "Ultrasonic 2 Readings: "))
'    Term.Dec(mainUltra2Val)
'    Term.Str(String(13, "ToF 1 Reading: "))
'    Term.Dec(mainToF1Val)
'    Term.Str(String(13, "ToF 2 Reading: "))
'    Term.Dec(mainToF2Val)
'    Pause(150)
'    Term.Tx(0)
PRI Pause (ms) | t
  t := cnt - 1088
  repeat (ms#>0)                ' sync with system counter
    waitcnt (t+=_Ms_001)        ' delay must be > 0
  return