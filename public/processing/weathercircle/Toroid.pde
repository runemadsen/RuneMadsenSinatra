class Toroid
{
   /* Properties
   ____________________________________________________ */
   
   private color _tcolor = color(255, 0, 0);
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
   
   Toroid(color tcolor, float xPos, float yPos, float zPos, float tubeRadius, float totalRadius, int points, int segments, float speed, boolean wireframe)
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
   
   void update()
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
       
       _angle+=360.0/_points;
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
        
       _latheAngle+=360.0/_segments;
       
       endShape();
     } 
     
     popMatrix();
   }
}

