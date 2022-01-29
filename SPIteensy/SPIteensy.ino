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
  int mybyteMSB = 1;
  int mybyteLSB = 5;
  char ch;
  // put your main code here, to run repeatedly:
  if (Serial.available() > 0 ) {
    ch = Serial.read();
    if (ch == '2') {
      Serial.println("2 -- get switchCount and captured data entry");
      mybyteMSB = 2;  // MSB is the command index
      performTransfer(mybyteMSB,  mybyteLSB);
    }
    if (ch == '3') {
      Serial.println("3 -- advance switchCount");
      mybyteMSB = 3;  // MSB is the command index
      performTransfer(mybyteMSB,  mybyteLSB);
    }
    if (ch == '4') { 
      Serial.println("4 -- get eight capturedData entries");
      int i;
      for (i = 0; i < 8; i++) {
      mybyteMSB = 3;  // MSB is the command index
      performTransfer(mybyteMSB,  mybyteLSB);
      delay(1);
      }
    }
  }
}


void performTransfer(int mybyteMSB, int mybyteLSB ) {
  int chipSelectPin = 0;
  uint8_t valMSB, valLSB;
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
