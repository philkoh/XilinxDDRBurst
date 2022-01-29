#include <SPI.h>  // include the SPI library:

void setup() {
  Serial.begin(9600);
  // put your setup code here, to run once:
   pinMode(0, OUTPUT);
   pinMode(1, INPUT);
   pinMode(2, OUTPUT);
   pinMode(3, OUTPUT);
   pinMode(4, OUTPUT);
   pinMode(5, OUTPUT);
   pinMode(6, OUTPUT);
   pinMode(7, OUTPUT);
   pinMode(8, OUTPUT);
   pinMode(24, OUTPUT);
   pinMode(25, OUTPUT);
   pinMode(26, OUTPUT);
   pinMode(27, OUTPUT);

    delay(100);
   digitalWrite(0, HIGH);
 //  digitalWrite(1, LOW);
   digitalWrite(2, LOW);
   digitalWrite(3, HIGH);
   digitalWrite(4, LOW);
   digitalWrite(5, LOW);
   digitalWrite(6, HIGH);
   digitalWrite(7, LOW);
   digitalWrite(8, LOW);
   digitalWrite(24, HIGH);
   digitalWrite(25, LOW);
   digitalWrite(26, LOW);
   digitalWrite(27, HIGH);
   delay(100);

    SPI1.setMOSI(26);
   SPI1.setMISO(1);
   SPI1.setSCK(27);
     SPI1.begin();

}

void loop() {
  int chipSelectPin = 0;
  int mybyteMSB = 1;
  int mybyteLSB = 15;
  uint8_t valMSB, valLSB;
  // put your main code here, to run repeatedly:
  delay(200);
  SPI1.beginTransaction(SPISettings(10000000, MSBFIRST, SPI_MODE0));
  digitalWrite(chipSelectPin, LOW);
  valMSB = SPI1.transfer(mybyteMSB);
  valLSB = SPI1.transfer(mybyteLSB);
  digitalWrite(chipSelectPin, HIGH);
  SPI1.endTransaction();
  Serial.print(valMSB);
  Serial.print(" ");
  Serial.println(valLSB);
}
