import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class weatherCircle extends PApplet {

/* Imports
____________________________________________________ */



/* Properties
____________________________________________________ */

XMLElement xml;
ArrayList circles = new ArrayList();

int tubeRadius = 7;
int circleRadius = 260;

int numCircles = 7;
String zipCode = "11222";

float temperature = 0.0f;
float windSpeed = 0.0f;

//color color1 = color(159, 205, 234);
//color color2 = color(215, 58, 28);

int color1 = color(166, 180, 203);
int color2 = color(255, 168, 5);

/* Constructor
____________________________________________________ */

public void setup()
{
  size(900, 700, OPENGL);
  background(0);
  
  loadXML();
  
  createCircles();
}

/* Load weather data
____________________________________________________ */

public void loadXML()
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

public void createCircles()
{  
  int tColor;
  
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
     float speed = windSpeed + (0.005f * i);
     
     Toroid circle = new Toroid(tColor, xPos, yPos, zPos, tubeRadius, totalRadius, 15, 50, speed, false);
     
     circles.add(circle);
  }
}

/* Draw
____________________________________________________ */

public void draw()
{    
   setLights();
   
   background(0);
   
   updateCircles();
}

/* Set lights on stage
____________________________________________________ */

public void setLights()
{
   ambientLight(30, 30, 30);
   spotLight(255, 255, 255, 600, 250, 100, 0, 0, -1, PI/3.2f, 0.5f);
   spotLight(255, 255, 255, 220, 480, 100, 0, 0, -1, PI/3.2f, 0.5f);
   spotLight(100, 100, 100, width / 2, height / 2, 500, 0, 0, -1, PI/2, 0.5f);  
}

/* Update the circles
____________________________________________________ */

public void updateCircles()
{
   for (int i = 0; i < circles.size(); i++) 
  {  
     Toroid circle = (Toroid) circles.get(i);
     circle.update();
  }   
}


class Toroid
{
   /* Properties
   ____________________________________________________ */
   
   private int _tcolor = color(255, 0, 0);
   private float _xPos = 0;
   private float _yPos = 0;
   private float _zPos = 0;
   private float _tubeRadius = 50;
   private float _totalRadius = 100;
   private int _points = 10;
   private int _segments = 50;
   private boolean _wireframe = false;
   private float _rotation = 0;
   private float _speed = 0;
   
   private float _angle = 0;
   private float _latheAngle = 0;
   private PVector vertices[], vertices2[];
   
   /* Constructor
   ____________________________________________________ */
   
   Toroid(int tcolor, float xPos, float yPos, float zPos, float tubeRadius, float totalRadius, int points, int segments, float speed, boolean wireframe)
   {
      _tcolor = tcolor;
      _xPos = xPos;
      _yPos = yPos;
      _zPos = zPos;
      _tubeRadius = tubeRadius;
      _totalRadius = totalRadius;
      _points = points;
      _segments = segments;
      _speed = speed;
      
      _wireframe = wireframe;
   }
   
   /* Update
   ____________________________________________________ */
   
   public void update()
   {    
     // set x, y and z
     pushMatrix();
     translate(_xPos, _yPos, _zPos);
     
     if (_wireframe)
     {
       stroke(_tcolor);
       noFill();
     } 
     else 
     {
       noStroke();
       fill(_tcolor);
     }
     
     rotateX(radians(_rotation));
     rotateY(radians(_rotation * 6));
     
     _rotation += _speed;
   
     // initialize point arrays
     vertices = new PVector[_points+1];
     vertices2 = new PVector[_points+1];
   
     // fill arrays
     for(int i=0; i<=_points; i++)
     {
       vertices[i] = new PVector();
       vertices2[i] = new PVector();
       vertices[i].x = _totalRadius + sin(radians(_angle))*_tubeRadius;
        
       vertices[i].z = cos(radians(_angle))*_tubeRadius;
       
       _angle+=360.0f/_points;
     }
   
     // draw toroid
     
     _latheAngle = 0;
     
     for(int i=0; i<=_segments; i++)
     {
       beginShape(QUAD_STRIP);
       
       for(int j=0; j<=_points; j++)
       {
         if (i>0)
         {
           vertex(vertices2[j].x, vertices2[j].y, vertices2[j].z);
         }
         
         vertices2[j].x = cos(radians(_latheAngle))*vertices[j].x;
         vertices2[j].y = sin(radians(_latheAngle))*vertices[j].x;
         vertices2[j].z = vertices[j].z;
         
         vertex(vertices2[j].x, vertices2[j].y, vertices2[j].z);
       }
        
       _latheAngle+=360.0f/_segments;
       
       endShape();
     } 
     
     popMatrix();
   }
}


   static public void main(String args[]) {
      PApplet.main(new String[] { "--bgcolor=#FFFFFF", "weatherCircle" });
   }
}
