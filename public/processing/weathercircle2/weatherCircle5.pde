/* Imports
 ________________________________________________ */

import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
import processing.opengl.*;

/* Properties
 ________________________________________________ */

ArrayList objects = new ArrayList();

boolean paused = false;

XMLElement xml;

float orgTemperature = 0.0;
float orgWindSpeed = 0.0;
float temperature = 0.0;
float windSpeed = 0.0;

color color1 = #e16407;
color color2 = #333333;
color color3 = #a52808;
color notAColor = 0;

String zipCode = "11222";

// circle setup

/* Setup
 ________________________________________________ */

void setup()
{
   size(900, 900, OPENGL);

   loadXML();

   createCircles();
}

/* Load weather data
 ____________________________________________________ */

void loadXML()
{
   xml = new XMLElement( this, "http://weather.yahooapis.com/forecastrss?u=c&p=" + zipCode);
   xml = xml.getChild(0);

   int highTemp = 40;
   int lowTemp = -20;

   orgTemperature = Float.parseFloat(xml.getChild("item/yweather:condition").getStringAttribute("temp"));
   //orgTemperature = 40;  // Use to test your own temperature
   temperature = map(orgTemperature, lowTemp, highTemp, 0, 1);

   int highSpeed = 300;
   int lowSpeed = 0;

   orgWindSpeed = Float.parseFloat(xml.getChild("yweather:wind").getStringAttribute("speed"));
   //orgWindSpeed = 30;  // use to test your own wind speed
   windSpeed = map(orgWindSpeed, lowSpeed, highSpeed, 0, 0.5);
}

/* Create Circles
 ________________________________________________ */

void createCircles()
{
   // Each one gets its own life by using its data.

   Circle circle1 = new Circle(4, 40, 50, 5, 3);
   objects.add(circle1); 

   Circle circle2 = new Circle(4, 60, 90, 40, 20);
   objects.add(circle2); 

   Circle circle3 = new Circle(4, 60, 131, 10, 5);
   objects.add(circle3); 

   Circle circle4 = new Circle(4, 60, 190, 60, 30);
   objects.add(circle4); 

   Circle circle5 = new Circle(4, 60, 250, 10, 5);
   objects.add(circle5); 

   float xSpeed = windSpeed;
   float ySpeed = windSpeed / 6;

   for(int i = 0; i < objects.size(); i++)
   {
      Circle theCircle = (Circle) objects.get(i);

      theCircle.setColors(color1, color2, temperature);
      theCircle.setXRot(xSpeed);
      theCircle.setYRot(ySpeed);
      theCircle.setWireframeColor(notAColor);
      //theCircle.setWireframe(true);

      if(i < objects.size() - 1)
      {
         xSpeed += windSpeed / 20;
         ySpeed += windSpeed / 25;
      }
   } 

   CurveText title = new CurveText("Weather Circle", 25, 270);
   title.setTextOffset(335);
   title.setXRot(xSpeed);
   title.setYRot(ySpeed);
   objects.add(title);
   
   CurveText label = new CurveText("Wind Speed: " + orgWindSpeed + " kmh, Temperature: " + orgTemperature + " degrees celsius", 15, 270);
   label.setTextOffset(520);
   label.setXRot(xSpeed);
   label.setYRot(ySpeed);
   objects.add(label);

}

/* Draw
 ________________________________________________ */

void draw()
{
   if(!paused)
   {
      background(0);

      setLights();

      for(int i = 0; i < objects.size(); i++)
      {
         DisplayObject object = (DisplayObject) objects.get(i);
         object.update();
      }
   }
}

/* Set lights
 ________________________________________________ */

void setLights()
{
   directionalLight(255, 255, 255, 0, 0, -1);
   ambientLight(20, 20, 20);
}

/* Pause handling
 ________________________________________________ */

void keyPressed()
{
   if( key == ' ' ) paused = paused ? false : true;
}

