{   Project: EE-9 Assignment
    Platform: Parallax Project USB Board
    Revision: 3
    Author: Lim Heng Kiat
    Date: 29 Nov 2021
}

  'Log:
   'Date: Desc
   '22/11/2021

CON
        '_clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        '_xinfreq = 5_000_000

        'creating a pause()
        '_ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        '_Ms_001 = _ConClkFreq / 1_000

        ''[ declare pins for motor]

        motor1 = 10
        motor2 = 11
        motor3 = 12
        motor4 = 13

  motor1Zero = 1480
  motor2Zero = 1480
  motor3Zero = 1480
  motor4Zero = 1480

VAR  ' Global variable
   long SqStack[64] 'Stack space for cog
  long _Ms_001

OBJ  ' Objects

        Motors : "Servo8Fast_vZ2.spin"
        Term   : "FullDuplexSerial.spin"

PUB Start(timer,direct,speed)

  _Ms_001 := timer

  stopcore

  coginit(7, set(direct,speed), @SqStack) 'Launch Main in Cog 7

  return
PRI motorinit

      Motors.Init
      Motors.AddSlowPin(motor1)
      Motors.AddSlowPin(motor2)
      Motors.AddSlowPin(motor3)
      Motors.AddSlowPin(motor4)
      Motors.Start
      Pause(100)
      return
PUB stopcore
  ' set cog 7
  if cogid == 7
    cogstop(7) 'Stop previously launched cog

  return

PUB set(direct,speed)

  motorinit
  stopmotor

repeat
  case long[direct]   ' take direction from main

    1: 'if 1, move forward
      forward(speed)

    2: 'if 2, move reverse
      reverse(speed)

    3: 'if 3, move left
      left(speed)

    3.3:
      loleft(speed)

    4: 'if 4, move right
      right(speed)

    4.4:
      loright(speed)

    0: ' stop motor from moving
      stopmotor

PRI stopmotor
      ' stop motor from moving
      Motors.Set(motor1, motor1Zero)
      Motors.Set(motor2, motor2Zero)
      Motors.Set(motor3, motor3Zero)
      Motors.Set(motor4, motor4Zero)
      return

PRI forward(speed)
            'take speed from main
            Motors.Set(motor1, motor1Zero+long[speed])
            Motors.Set(motor2, motor2Zero+long[speed])
            Motors.Set(motor3, motor3Zero+long[speed])
            Motors.Set(motor4, motor4Zero+long[speed])

PRI reverse(speed)
            'take speed from main
            Motors.Set(motor1, motor1Zero-long[speed])
            Motors.Set(motor2, motor2Zero-long[speed])
            Motors.Set(motor3, motor3Zero-long[speed])
            Motors.Set(motor4, motor4Zero-long[speed])

PRI right(speed)
            'take speed from main
            Motors.Set(motor1, motor1Zero-long[speed])
            Motors.Set(motor2, motor2Zero+long[speed])
            Motors.Set(motor3, motor3Zero-long[speed])
            Motors.Set(motor4, motor4Zero+long[speed])
PRI loright(speed)

            Motors.Set(motor1, motor1Zero)
            Motors.Set(motor2, motor2Zero+long[speed])
            Motors.Set(motor3, motor3Zero)
            Motors.Set(motor4, motor4Zero+long[speed])

PRI left(speed)
            'take speed from main
            Motors.Set(motor1, motor1Zero+long[speed])
            Motors.Set(motor2, motor2Zero-long[speed])
            Motors.Set(motor3, motor3Zero+long[speed])
            Motors.Set(motor4, motor4Zero-long[speed])

PRI loleft(speed)

            Motors.Set(motor1, motor1Zero+long[speed])
            Motors.Set(motor2, motor2Zero)
            Motors.Set(motor3, motor3Zero+long[speed])
            Motors.Set(motor4, motor4Zero)

PRI Pause(ms) | t
  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _MS_001)
  return


DAT
name    byte  "string_data",0