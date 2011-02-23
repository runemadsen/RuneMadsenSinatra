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

   void update()
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
   
   void setTextOffset(int textOffset)
   {
      _textOffset = textOffset;  
   }
}


