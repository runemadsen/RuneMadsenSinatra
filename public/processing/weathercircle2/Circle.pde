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

   private color _color1 = #0094f1;
   private color _color2 = #fe6112;
   private float _colorPercent = 0.5;
   private boolean _wireframe = false;
   private color _wireframeColor1;

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

   void update()
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

   void fillArrays()
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

         _angle += 360.0 / _points;
      }
   }

   /* Draw shapes from PVector objects in array
    ________________________________________________ */

   void drawArrays()
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

         _latheAngle += 360.0 / _segments;

         endShape();
      }
   }

   /* Check wireframe
    ________________________________________________ */

   void checkWireframe(int i)
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

   void checkColor(int i)
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

   void setColors(color color1, color color2, float colorPercent)
   {
      _color1 = color1;
      _color2 = color2;
      _colorPercent = colorPercent;
   }

   void setWireframe(boolean wireframe)
   {
      _wireframe = wireframe;
   }
   
   void setWireframeColor(color wireframeColor1)
   {
      _wireframeColor1 = wireframeColor1;
   }
}
