/* Imports
____________________________________________________ */

import processing.opengl.*;

/* Properties
____________________________________________________ */

XMLElement xml;
ArrayList circles = new ArrayList();

int tubeRadius = 7;
int circleRadius = 260;

int numCircles = 7;
String zipCode = "11222";

float temperature = 0.0;
float windSpeed = 0.0;

//color color1 = color(159, 205, 234);
//color color2 = color(215, 58, 28);

color color1 = color(166, 180, 203);
color color2 = color(255, 168, 5);

/* Constructor
____________________________________________________ */

void setup()
{
  size(900, 700, OPENGL);
  background(0);
  
  loadXML();
  
  createCircles();
}

/* Load weather data
____________________________________________________ */

void loadXML()
{
  xml = new XMLElement( this, "http://weather.yahooapis.com/forecastrss?u=c&p=" + zipCode);
  xml = xml.getChild(0);
  
  temperature = Float.parseFloat(xml.getChild("item/yweather:condition").getStringAttribute("temp"));
  //temperature = 25;  // Use to test your own temperature
  temperature = floor(map(temperature, -25, 40, 0, numCircles));
  
  windSpeed = Float.parseFloat(xml.getChild("yweather:wind").getStringAttribute("speed"));
  //windSpeed = 100;  // use to test your own wind speed
  windSpeed = map(windSpeed, 0, 500, 0, 10);
  
}

/* Init setup
____________________________________________________ */

void createCircles()
{  
  color tColor;
  
  for (int i = 0; i < numCircles; i++) 
  {  
     if(i > (numCircles - 1) - temperature)
     {
        tColor = color2;
     }
     else
     {
        tColor = color1;
     }
     
     float xPos = width / 2;
     float yPos = height / 2;
     float zPos = 0;
     float totalRadius = circleRadius - ((tubeRadius + 6) * i);
     float speed = windSpeed + (0.005 * i);
     
     Toroid circle = new Toroid(tColor, xPos, yPos, zPos, tubeRadius, totalRadius, 15, 50, speed, false);
     
     circles.add(circle);
  }
}

/* Draw
____________________________________________________ */

void draw()
{    
   setLights();
   
   background(0);
   
   updateCircles();
}

/* Set lights on stage
____________________________________________________ */

void setLights()
{
   ambientLight(30, 30, 30);
   spotLight(255, 255, 255, 600, 250, 100, 0, 0, -1, PI/3.2, 0.5);
   spotLight(255, 255, 255, 220, 480, 100, 0, 0, -1, PI/3.2, 0.5);
   spotLight(100, 100, 100, width / 2, height / 2, 500, 0, 0, -1, PI/2, 0.5);  
}

/* Update the circles
____________________________________________________ */

void updateCircles()
{
   for (int i = 0; i < circles.size(); i++) 
  {  
     Toroid circle = (Toroid) circles.get(i);
     circle.update();
  }   
}


