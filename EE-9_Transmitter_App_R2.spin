{
  Project: EE-9 Transmitter App
  Platform: Parallax Project USB Board
  Revision: 1.0
  Author: Kenichi Kato
  Date: 20th Nov 2021
  Log:
    Date: Desc
    20/11/2021: Used to send instruction codes for testing the robotic platform
    20/11/2021: Tested
    22/11/2021: Sync with EE-9 slides on Flow-chart

}
CON
  _clkmode    = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
  _xinfreq    = 5_000_000
  _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
  _Ms_001     = _ConClkFreq / 1_000


  xbeeTx    = 18  ' DIN , XBee Pin 3
  xbeeRx    = 19  ' DOUT, XBee Pin 2
  xbeeBaud  = 9600

  xbStart   = $7A
  xbForward = $01
  xbReverse = $02
  xbLeft    = $03
  xbRight   = $04
  xbStop    = $AA


VAR ' Global variable


OBJ ' Objects
  XBee    : "FullDuplexSerial.spin"     ' UART Protocol
  'Term    : "FullDuplexSerial.spin"    ' UART/Serial Protocol

  ' Create a hardware definition file

PUB Main

  ' Declaration & Initilisation
  'Term.Start(31, 30, 0, 115200)   ' For debugging purposes
  Pause(2000) ' Wait 2 seconds

  ' Comm with XBee
  XBee.Start(xbeeRx, xbeeTx, 0, xbeeBaud)

  ' Sending instructions to robotic platform

  ' Perform a Forward movement. Test to see if robotic platform moves.
  StartCmd    ' 1st Byte
  MoveForward ' 2nd Byte
  Pause(3000)    ' CommControl waits, MotorControl (continue to move forward)
  StartCmd    ' 1st Byte
  StopCmd     ' 2nd Byte

  repeat

PRI performCrankCourse
{{ Sequence for performing the route as specified in EE-6 assignment}}

  StartCmd
  repeat 10
    MoveForward

  StopCmd
  repeat 4
    TurnRight
  StopCmd
  repeat 10
    MoveForward
  StopCmd
  repeat 4
    TurnLeft
  StopCmd
  repeat 10
    MoveForward
  StopCmd
  repeat 10
    MoveReverse
  StopCmd
  repeat 4
    TurnLeft
  StopCmd
  repeat 10
    MoveReverse
  StopCmd
  repeat 4
    TurnRight
  StopCmd
  repeat 10
    MoveReverse
  StopCmd
  return

PRI StartCmd
  return XBee.Tx(xbStart)

PRI MoveForward
  return XBee.Tx(xbForward)

PRI MoveReverse
  return XBee.Tx(xbReverse)

PRI TurnLeft
  return XBee.Tx(xbLeft)

PRI TurnRight
  return XBee.Tx(xbRight)

PRI StopCmd
  return XBee.Tx(xbStop)


PRI Pause(ms) | t
  t := cnt - 1088                                               ' sync with system counter
  repeat (ms #> 0)                                              ' delay must be > 0
    waitcnt(t += _Ms_001)
  return