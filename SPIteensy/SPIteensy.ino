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


bool printVals = true;
uint8_t sequenceCount = 0;


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
      printVals = false;
      int i;
      /*   for (i = 0; i < 8; i++) {
           mybyteMSB = 3;  // MSB is the command index
           performTransfer(mybyteMSB,  mybyteLSB);
           delay(1);
         } */
      Read16Captures();
      PrintCapturedData();
      Serial.println();
      printVals = true;
    }
    if (ch == '5') {
      Serial.println("5 -- request read operation");
      mybyteMSB = 5;  // MSB is the command index
      performTransfer(mybyteMSB,  mybyteLSB);
    }
    if (ch == '1') {
      Serial.println("1 -- request write operation");
      mybyteMSB = 1;  // MSB is the command index
      performTransfer(mybyteMSB,  mybyteLSB);
    }
    if (ch == '6') {
      Serial.println("6 -- set address");
      mybyteMSB = 6;  // MSB is the command index
      mybyteLSB = 24;  //"000000000011000"
      performTransfer(mybyteMSB,  mybyteLSB);
    }
    if (ch == 'a') {
      Serial.println("6 -- set address 0");
      mybyteMSB = 6;  // MSB is the command index
      mybyteLSB = 0;
      performTransfer(mybyteMSB,  mybyteLSB);
    }
    if (ch == 'b') {
      Serial.println("6 -- set address 8");
      mybyteMSB = 6;  // MSB is the command index
      mybyteLSB = 8;
      performTransfer(mybyteMSB,  mybyteLSB);
    }
    if (ch == 'c') {
      Serial.println("6 -- set address 16");
      mybyteMSB = 6;  // MSB is the command index
      mybyteLSB = 16;
      performTransfer(mybyteMSB,  mybyteLSB);
    }
    if (ch == 'd') {
      Serial.println("6 -- set address 24");
      mybyteMSB = 6;  // MSB is the command index
      mybyteLSB = 24;
      performTransfer(mybyteMSB,  mybyteLSB);
    }
    if (ch == 'm') {  // read all memory
      Serial.println("m -- read all memory");
      printVals = false;
      int i;
      for (i = 0; i < 8; i++) {
        performTransfer(6,  i * 8);  // set address
        delay(1);
        performTransfer(5,  0);  // read operation
        delay(1);
        Read16Captures();
        PrintCapturedData();
        Serial.println();
      }
      printVals = true;

    }
    if (ch == 's') {  // fill FIFO with sequential bytes
      Serial.println("s -- push sequential bytes onto the FIFO");
      int i;
      for (i = 0; i < 8; i++) {
        performTransfer(16 + 2 * i,  sequenceCount);  // commands 16-31 fill the FIFO register with one byte each
        sequenceCount ++;
        delay(1);
      }
      performTransfer(7,  0);  // commands 7 pushes it onto the FIFO

    }
   if (ch == '7') {
      Serial.println("7 --  pushes data onto the FIFO");
      mybyteMSB = 7;  // MSB is the command index
      performTransfer(mybyteMSB,  mybyteLSB);
    }

  }
}


uint8_t valMSB, valLSB;


void performTransfer(int mybyteMSB, int mybyteLSB ) {
  int chipSelectPin = 0;
  SPI1.beginTransaction(SPISettings(10000000, MSBFIRST, SPI_MODE0));
  digitalWrite(chipSelectPin, LOW);
  valMSB = SPI1.transfer(mybyteMSB);
  valLSB = SPI1.transfer(mybyteLSB);
  digitalWrite(chipSelectPin, HIGH);
  SPI1.endTransaction();
  if (printVals) {
    Serial.print(valMSB);
    Serial.print(" ");
    Serial.println(valLSB);
  }
}

uint8_t capturedData[15];

void Read16Captures() {
  int i;
  for (i = 0; i < 16; i++) {
    performTransfer(3,  0);
    delay(1);
    capturedData[valMSB] = valLSB;
  }
}

void PrintCapturedData() {
  int i;
  for (i = 0; i < 8; i++) {
    Serial.print(capturedData[i]);
    Serial.print(" ");
  }
}
