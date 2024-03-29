{{

  Project: EE-7 Practical 1 - Ultrasonic
  Platform: Parallax Project USB Board
  Revision: 1.0
  Author: Kenichi
  Date: 10th Nov 2021
  Log:
    Date: Desc
    v1
    10/11/2021: Creating object file for Ultrasonic sensors & ToF sensors

}}
CON

  ACK = 0                                                   'signals ready for more
  NAK = 1                                                   'signals not ready for more

  '' Reference for HC-SR04 (I2C)
  UltraAdd  = $57

OBJ
  bus[2]   :    "i2cDriver_v2.spin"

PUB Init(sclPin, sdaPin, ObjNum)
  return bus[ObjNum].Init(sclPin, sdaPin)

PUB readSensor(ObjNum) | ackBit, clearBus
{{ Get a reading from Ultrasonic sensor }}
  bus[ObjNum].WriteByteA8(UltraAdd, $01, ackBit)
  waitcnt(cnt + clkfreq/10)
  result := bus[ObjNum].readLongA8(UltraAdd, ackBit)/254/1000
  clearBus := bus[ObjNum].readBus(ackBit)
  return result