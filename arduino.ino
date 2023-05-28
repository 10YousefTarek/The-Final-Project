#include <Servo.h>
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <SoftwareSerial.h>

#define THRESHOLD 100
#define DTIME 50
#define SENSOR_TL A0  //Top Left sensor pin
#define SENSOR_TR A3  //Top Right sensor pin
#define SENSOR_BL A1  //Bottom Left sensor pin
#define SENSOR_BR A2  //Bottom Right sensor pin

#define HORIZ_LIMIT 180 //Horizontal limit should be the full rotation of a servo
#define VERT_LIMIT 90   //The value is determined depending on the mechanical setup (the angle at which the vertical servo keeps the panel parallel to ground)

Servo horiz;        //Servo for horizontal movement
Servo vert;         //Servo for vertical movement
int horizpos = 90;
int vertpos = 90;

//Smart Home
SoftwareSerial myserial(5, 6); // Bluetooth: Tx = 5, Rx = 6
LiquidCrystal_I2C lcd(0x27, 16, 2);
// rain
#define ra A6
int value;


void setup() 
{
  Serial.begin(9600); 
  horiz.attach(9);
  vert.attach(10);
  vert.write(90);
  horiz.write(90);
  delay(1000);
//Smart Home
  myserial.begin(9600);
  Serial.begin(9600);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(7, OUTPUT);
  pinMode(8, OUTPUT);
  myserial.write("Hello in Bluetooth");

  lcd.init();
  lcd.backlight();

  // GAS
  pinMode(A7, INPUT);
}

void loop() {
   track();
   gas();
   rain();
   Lighting();
}

void track() {
  int tl = analogRead(SENSOR_TL); //Read the value of the TL sensor
  int tr = analogRead(SENSOR_TR); //Read the value of the TR sensor
  int bl = analogRead(SENSOR_BL); //Read the value of the BL sensor
  int br = analogRead(SENSOR_BR); //Read the value of the BR sensor

  int average_top = (tl + tr) / 2;
  int average_down = (bl + br) / 2;
  int average_left = (tl + bl) / 2;
  int average_right = (tr + br) / 2;

  int dif_vert = average_top - average_down;
  int dif_horz = average_left - average_right;

  if ( ((-1 * THRESHOLD) <= dif_vert) && (dif_vert <= THRESHOLD) ) {
    vert.write(90);
  }
  else {
    vert.attach(10); 

    if (average_top > average_down)
    {
      vertpos = --vertpos;
      if (vertpos > VERT_LIMIT)
      {
        vert.detach();
        vertpos = VERT_LIMIT;
      }
    }
    else if (average_top < average_down)
    {
      vertpos = ++vertpos;
      if (vertpos < 0)
      {
        vert.detach();
        vertpos = 0;
      }
    }
    vert.write(vertpos);
  }

  if ( ((-1 * THRESHOLD) <= dif_horz) && (dif_horz <= THRESHOLD) ) {
    horiz.write(90);
  }
  else {
    horiz.attach(9); 

    if (average_left > average_right)
    {
      horizpos = --horizpos;
      if (horizpos < 0)
      {
        horiz.detach();
        horizpos = 0;
      }
    }
    else if (average_left < average_right)
    {
      horizpos = ++horizpos;
      if (horizpos > HORIZ_LIMIT)
      {
        horiz.detach();
        horizpos = HORIZ_LIMIT;
      }
    }
    horiz.write(horizpos);
  }

  delay(DTIME);
}
///////////////////////////////////////////////////////////////////////////////////////////////////
//Smart Home

// GAS
void gas() 
{
  int val = analogRead(A7);
  if (val > 460) {
    digitalWrite(3, HIGH);
    lcd.setCursor(0,0);
    lcd.print("Fire  on");
    myserial.write("15");
    delay(1000);
  } else {
    digitalWrite(3, LOW);
    lcd.setCursor(0,0);
   lcd.print("          ");
  }
 Serial.println(val);
  delay(200);
}


// RAIN
void rain() 
{
  value = analogRead(ra);
  if (value >= 200) {
    lcd.setCursor(0,1);
    lcd.print("Rain on ");
    myserial.write("16");
  }
  else {
    lcd.setCursor(0,1);
    lcd.print("          ");
    //myserial.write("0");
  }
  Serial.println("RAIN = " + String(value));
  delay(100);
}

//Lighting

 void Lighting() 
 {

  if (myserial.available()) {
    int x = myserial.read();
    Serial.println(x);

    // Room 1 (living room)
    if (x == '1') {
      digitalWrite(4, HIGH);
    } else if (x == '2') {
      digitalWrite(4, LOW);
    }

    // Room 2 (crush)
    if (x == '3') {
      digitalWrite(7, HIGH);
    } else if (x == '4') {
      digitalWrite(7, LOW);
    }

    // Room 3 (kitchen)
    if (x == '5') {
      digitalWrite(8, HIGH);
    } else if (x == '6') {
      digitalWrite(8, LOW);
    }
  }

  if (Serial.available()) {
    myserial.write(Serial.read());
  }
}


