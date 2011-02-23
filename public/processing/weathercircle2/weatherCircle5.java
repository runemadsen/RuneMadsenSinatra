import processing.core.*; 
import processing.xml.*; 

import peasy.org.apache.commons.math.*; 
import peasy.*; 
import peasy.org.apache.commons.math.geometry.*; 
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

public class weatherCircle5 extends PApplet {

/* Imports
 ________________________________________________ */






/* Properties
 ________________________________________________ */

ArrayList objects = new ArrayList();

boolean paused = false;

XMLElement xml;

float orgTemperature = 0.0f;
float orgWindSpeed = 0.0f;
float temperature = 0.0f;
float windSpeed = 0.0f;

int color1 = 0xffe16407;
int color2 = 0xff333333;
int color3 = 0xffa52808;
int notAColor = 0;

String zipCode = "11222";

// circle setup

/* Setup
 ________________________________________________ */

public void setup()
{
   size(900, 900, OPENGL);

   loadXML();

   createCircles();
}

/* Load weather data
 ____________________________________________________ */

public void loadXML()
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
   windSpeed = map(orgWindSpeed, lowSpeed, highSpeed, 0, 0.5f);
}

/* Create Circles
 ________________________________________________ */

public void createCircles()
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

public void draw()
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

public void setLights()
{
   directionalLight(255, 255, 255, 0, 0, -1);
   ambientLight(20, 20, 20);
}

/* Pause handling
 ________________________________________________ */

public void keyPressed()
{
   if( key == ' ' ) paused = paused ? false : true;
}

class Circle extends DisplayObject
{
   /* Properties
    ________________________________________________ */

   // Params

   private int _points;  // Controls number of faces
   private int _segments; // Controls roundness of circle
   private int _circleRadius;
   private int _tubeWidth;
   private int _tubeDepth;

   // Get Set Params

   private int _color1 = 0xff0094f1;
   private int _color2 = 0xfffe6112;
   private float _colorPercent = 0.5f;
   private boolean _wireframe = false;
   private int _wireframeColor1;

   // Basic

   private float _angle = 45;
   private int _latheAngle = 0;
   private PVector _vertices1[];
   private PVector _vertices2[];

   /* Constructor
    ________________________________________________ */

   Circle(int points, int segments, int circleRadius, int tubeWidth, int tubeDepth)
   {
      super();
      
      _points = points;
      _segments = segments;
      _circleRadius = circleRadius;
      _tubeWidth = tubeWidth;
      _tubeDepth = tubeDepth;
   }

   /* Draw function
    ________________________________________________ */

   public void update()
   {
      _latheAngle = 0;

      pushMatrix();

      checkPosition();

      checkRotation();

      fillArrays();

      drawArrays();

      popMatrix();
   }

   /* Fill arrays with PVector objects
   ________________________________________________ */

   public void fillArrays()
   {
      // initialize point arrays
      _vertices1 = new PVector[_points + 1];
      _vertices2 = new PVector[_points + 1];

      // fill arrays
      for(int i = 0; i <= _points; i++)
      {
         _vertices1[i] = new PVector();
         _vertices2[i] = new PVector();

         _vertices1[i].x = _circleRadius + sin(radians(_angle)) * _tubeWidth;
         _vertices1[i].z = cos(radians(_angle)) * _tubeDepth;

         _angle += 360.0f / _points;
      }
   }

   /* Draw shapes from PVector objects in array
    ________________________________________________ */

   public void drawArrays()
   {
      //draw circle
      for(int i=0; i <= _segments; i++)
      {
         checkColor(i);
         checkWireframe(i);

         beginShape(QUAD_STRIP);

         for(int j=0; j <= _points; j++)
         {       
            if(i > 0)
            {
               vertex(_vertices2[j].x, _vertices2[j].y, _vertices2[j].z);
            }

            _vertices2[j].x = cos(radians(_latheAngle)) * _vertices1[j].x;
            _vertices2[j].y = sin(radians(_latheAngle)) * _vertices1[j].x;
            _vertices2[j].z = _vertices1[j].z;

            vertex(_vertices2[j].x, _vertices2[j].y, _vertices2[j].z);
         }

         _latheAngle += 360.0f / _segments;

         endShape();
      }
   }

   /* Check wireframe
    ________________________________________________ */

   public void checkWireframe(int i)
   {
      if(_wireframe)
      {
         if(i < (_segments * _colorPercent))
         {
            stroke(_wireframeColor1);
         }
         else
         {
            stroke(_wireframeColor1);
         }
      }
      else
      {
         noStroke();  
      }
   }

   /* Check color
    ________________________________________________ */

   public void checkColor(int i)
   {
      if(i < (_segments * _colorPercent))
      {
         fill(_color1);
      }
      else
      {
         fill(_color2);
      }
   }

   /* Getter / Setter
    ________________________________________________ */

   public void setColors(int color1, int color2, float colorPercent)
   {
      _color1 = color1;
      _color2 = color2;
      _colorPercent = colorPercent;
   }

   public void setWireframe(boolean wireframe)
   {
      _wireframe = wireframe;
   }
   
   public void setWireframeColor(int wireframeColor1)
   {
      _wireframeColor1 = wireframeColor1;
   }
}
class CurveText extends DisplayObject
{
   /* Properties
    ________________________________________________ */

   PFont _font;
   String _message = " text along a curve ";     
   float _circleRadius = 100;  
   float _textOffset = 0;
   int _fontSize;

   /* Constructor
    ________________________________________________ */

   CurveText(String message, int fontSize, float circleRadius)
   {
      _fontSize = fontSize;
      _circleRadius = circleRadius;
      _message = message;
      
      _font = createFont("Helvetica-40.vlw", _fontSize, true);
   }  

   /* Update
    ________________________________________________ */

   public void update()
   {
      textFont(_font);  
      textAlign(CENTER); 
      
      pushMatrix();
      
      checkPosition();

      checkRotation();
      
      noFill();  
      stroke(0); 
    
      float arcLength = _textOffset;  
  
      for (int i = 0; i < _message.length(); i++)              
      {   
         char currentChar = _message.charAt(i);   
         float w = textWidth(currentChar);   
         
         arcLength += w/2;  
          
         float theta = PI + arcLength / _circleRadius;  
         
         pushMatrix();  
 
         translate(_circleRadius*cos(theta), _circleRadius*sin(theta));  
         rotate(theta + PI/2);   
         
         fill(255);   
         text(currentChar,0,0);   
         popMatrix();  
         
         arcLength  +=  w/2;
      }
      
      popMatrix();
   }
   
   /* Getter / Setter
   ________________________________________________ */
   
   public void setTextOffset(int textOffset)
   {
      _textOffset = textOffset;  
   }
}


class DisplayObject
{
   /* Properties
   ________________________________________________ */
   
   protected float _xPos = 0;
   protected float _yPos = 0;
   protected float _zPos = 0;
   
   protected float _xRot = 0;
   protected float _yRot = 0;
   protected float _zRot = 0;
   
   protected float _curYRot = 0;
   protected float _curXRot = 0;
   protected float _curZRot = 0;
   
   /* Constructor 1
   ________________________________________________ */
   
   DisplayObject()
   {
      _xPos = width / 2;
      _yPos = height / 2;
      _zPos = 0;
   }
   
   /* Constructor 1
   ________________________________________________ */
   
   DisplayObject(float xPos,float yPos, float zPos)
   {
      _xPos = xPos;
      _yPos = yPos;
      _zPos = zPos;
   }
   
   /* Constructor 2
   ________________________________________________ */
   
   DisplayObject(float xPos,float yPos, float zPos, float xRot, float yRot, float zRot)
   {
      _xPos = xPos;
      _yPos = yPos;
      _zPos = zPos;
      
      _xRot = xRot;
      _yRot = yRot;
      _zRot = zRot;
   }
   
   /* Abstract
   ________________________________________________ */
   
   public void update()
   {
      println("Update must be overriden in subclass");
   }
   
   /* Methods
   ________________________________________________ */
   
   protected void checkRotation()
   {
      rotateY(_curYRot); 
      _curYRot += _yRot;

      rotateX(_curXRot); 
      _curXRot += _xRot; 
      
      rotateZ(_curZRot);
      _curZRot += _zRot;
   }
   
   protected void checkPosition()
   {
      translate(_xPos, _yPos, _zPos);
   }
   
   /* Getter / Setter
   ________________________________________________ */
   
   public void setXPos(float xPos)
   {
      _xPos = xPos;  
   }
   
   public float getXPos()
   {
      return _xPos;  
   }
   
   public void setYPos(float yPos)
   {
      _yPos = yPos;  
   }
   
   public float getYPos()
   {
      return _yPos;  
   }
   
   public void setZPos(float zPos)
   {
      _zPos = zPos;  
   }
   
   public float getZPos()
   {
      return _zPos;  
   }
   
   public void setXRot(float xRot)
   {
      _xRot = xRot;  
   }
   
   public float getXRot()
   {
      return _xRot;  
   }
   
   public void setYRot(float yRot)
   {
      _yRot = yRot;  
   }
   
   public float getYRot()
   {
      return _yRot;  
   }
   
   public void setZRot(float zRot)
   {
      _zRot = zRot;  
   }
   
   public float getZRot()
   {
      return _zRot;  
   }
   
   public void setCurXRot(float curXRot)
   {
      _curXRot = curXRot;  
   }
   
   public float getCurXRot()
   {
      return _curXRot;  
   }
   
   public void setCurYRot(float curYRot)
   {
      _curYRot = curYRot;  
   }
   
   public float getCurYRot()
   {
      return _curYRot;  
   }
   
   public void setCurZRot(float curZRot)
   {
      _curZRot = curZRot;  
   }
   
   public float getCurZRot()
   {
      return _curZRot;  
   }
   
   
}

   static public void main(String args[]) {
      PApplet.main(new String[] { "--bgcolor=#FFFFFF", "weatherCircle5" });
   }
}
