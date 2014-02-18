/*
Returns the angle between 2 vectors.
Returns the angle from v1 to v2 in clockwise direction.
Range: [0..TWO_PI].
*/
float angle(PVector v1, PVector v2) {
      float a = atan2(v2.y, v2.x) - atan2(v1.y, v1.x);
      if (a < 0) 
          a += TWO_PI;
      return a;
}

/*
Checks if mouse is over any given circle.
*/
boolean overCircle(float x, float y, float diameter) {
        float disX = x - mouseX;
        float disY = y - mouseY;
        if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
            return true;
        } 
        else {
            return false;
        }
}

/*
updates HourCircleOver and forecastCircleOver variables according to if overCircle function is returning true or false.
*/
void UpdateOverCircle() {
      if ( overCircle(HourCircleX, HourCircleY, HourCircleSize) ) 
          HourCircleOver = true;
      else 
          HourCircleOver = false;
      
      if ( overCircle(forecastCircleX, forecastCircleY, forecastCircleDia) ) 
          forecastCircleOver = true;
      else 
          forecastCircleOver = false;    
}


/*
Draws the minute and seconds hand. 
*/
void drawHand(float radius, float value, float divider) {
      float x =  radius * cos(value * TWO_PI / divider - PI / 2.0f);
      float y =  radius * sin(value * TWO_PI / divider - PI / 2.0f); 
      line(0, 0, x, y);
}


/*
Draws the hour hand.
*/
void drawHour(float radius) {
      float x =  radius * cos((hour()+minute()/60.0f) * TWO_PI /12 - PI / 2.0f); 
      float y =  radius * sin((hour()+minute()/60.0f) * TWO_PI /12 - PI / 2.0f); 
      line(0, 0, x, y);
}

/*
Sets the position of a vector according to time.
*/
void setAccToHour(PVector v) {
     float timeX,timeY; // x and y positions of v according to actual time 
     timeX =  80.0 * cos((hour()+minute()/60.0f) * TWO_PI /12 - PI / 2.0f); 
     timeY =  80.0 * sin((hour()+minute()/60.0f) * TWO_PI /12 - PI / 2.0f);
     v.set(timeX,timeY,0);   
}

/*
Sets the position of a vector according to 'b' - the vector attached to the mouse.
*/
void setAccTo_b(PVector v) {
     v.set(b.x,b.y,0);   
}

/*
This is a thread.
It continously calculates Vangle amd it also checks if rotation was clockwise or counter clockwise. 
Based on that it adds or subtracts 1 from numRotations.
*/
void ccwCheck(){
    
      while(true){
            setAccToHour(Vtime); //Vtime is set according to time
            setAccTo_b(Vb); //Vb is set according to 'b', while 'b' is set according to time when not in forecast mode, and set according to mouse when in forecast mode.
            Vangle = int(degrees(angle(Vtime,Vb))); //Therefore Vangle is the angle between current time and position of 'b'.
           
           anglePrev = angleNow;
           angleNow = Vangle;
           
           // Large angle values are chosen so that if the user moves the hour hand fast, even then ccw or cw can be noticed.
           if((anglePrev >= 0 && anglePrev <= 30) && (angleNow >= 330 && angleNow <= 359)){
               ccw = true;
               numRotations -= 1;
             }
           
           if(((angleNow >= 0 && angleNow <= 30) && (anglePrev >= 330 && anglePrev <= 359)))  {
               ccw = false;
               numRotations +=1;
             }
           
           if(anglePrev==0 && angleNow==0)
              ccw = false;
          }  
     }

/*
Loads all images except chancesOfRain which is loaded in the setup.
*/
void loadImages(){
    
    
    s_feelsLike =     loadShape("feelsLike.svg");
    s_humidity =      loadShape("humidity.svg");
    s_sunriseSunset = loadShape("sunriseSunset.svg");

    s_fog =           loadShape("fog.svg");
    s_haze =          loadShape("haze.svg");
    s_drizzle =       loadShape("drizzle.svg");
    s_overcast =      loadShape("overcast.svg");
    s_rain =          loadShape("rain.svg");
    
    s_clearDay =            loadShape("clearDay.svg");
    s_clearNight =          loadShape("clearNight.svg");
    s_mostlyCloudyDay =     loadShape("mostlyCloudyDay.svg");
    s_mostlyCloudyNight =   loadShape("mostlyCloudyNight.svg");
    s_partlyCloudyDay =     loadShape("partlyCloudyDay.svg");
    s_partlyCloudyNight =   loadShape("partlyCloudyNight.svg");
    s_snowingDay =          loadShape("snowingDay.svg");
    s_snowingNight =        loadShape("snowingNight.svg");
    s_thunderstormDay =     loadShape("thunderstormDay.svg");
    s_thunderstormNight =   loadShape("thunderstormNight.svg");
 
    }

/*
Loads all fonts being used.
*/
void loadFonts(){
  
    smallText = loadFont("HelveticaWorld-Regular-14.vlw"); 
    largeText40 = loadFont("HelveticaNeueLTCom-UltLt-40.vlw");
    largeText30 = loadFont("HelveticaNeueCE-Thin-30.vlw");
    dataText20 = loadFont("HelveticaNeueCE-Thin-20.vlw");
    
    }
  

/*
Renders all Images and takes care of Easing Effects.
*/
void renderImages(){

      noStroke();
      shape(s_feelsLike, 0, 0, appWidth * 0.96,appHeight);
      shape(s_humidity, 0, 0, appWidth,appHeight);
      shape(s_sunriseSunset,0,0,appWidth,appHeight);
      
      //umbrella
      if(pop!=null){
          popValue = Integer.valueOf(pop);
          rectMode(RADIUS);
          fill(#ffffff);
          rect(appWidth*12.3/135, appHeight*18/243,appWidth*10.1/135,appHeight*popValue*0.1/243);
        }
      
        fill(appColor);
        rectMode(CORNER);
        rect(appWidth*0/135, appHeight*20/243, appWidth*30/135, appHeight*15/243);
        noFill();
        stroke(#ffffff);
        shape(s_chancesOfRain, 0, 0, appWidth,appHeight);
      
      if(sky!=null){
        
        fill(#ffffff);
        skyCondition();
        
        //for the first time and for everytime when the sky is same, just draws the image for the weather condition without easing.
        if(skySame || firstTime){
          shape(s_skyCondition,0,0,appWidth,appHeight);
          textFont( smallText, smallTextSize);
          textAlign( CENTER );
      
          if(skyRender.equals("PARTLY") || skyRender.equals("MOSTLY"))
             text( skyRender + " CLOUDY", appWidth*0.49 , yDown+appHeight*0.27 );
          else
             text( skyRender, appWidth*0.49 , yDown+appHeight*0.27 );
            
          textFont(dataText20, dataTextSize);
          textAlign( CENTER );
          text( temp + " C", appWidth*0.49 , yDown+appHeight*0.24 );
          
          firstTime = false; //firstTime is a boolean to check the first time skyCondition() is called. 
         }
        
        else{ // sky conditions have changed, and therefore the old condition needs to be eased out and the new one needs to be eased in.
            yDown = yDown + dyDown * easing;
            dyDown = appHeight*0.18 - yDown;
            shape(s_skyConditionOld,0,yDown,appWidth,appHeight);
            //text//
            textFont( smallText, smallTextSize);
            textAlign( CENTER );
            
            if(skyRender.equals("PARTLY") || skyRender.equals("MOSTLY"))
              text( skyRender + " CLOUDY", appWidth*0.49 , yDown+appHeight*0.27 );
            else
              text( skyRender, appWidth*0.49 , yDown+appHeight*0.27 );
              
              textFont(dataText20, dataTextSize);
              textAlign( CENTER );
              text( temp + " C", appWidth*0.49 , yDown+appHeight*0.24 );
        
            //text//
            if(dyDown<0.5){
              yUp = yUp - dyUp* easing;
              dyUp = yUp;
              shape(s_skyConditionNew,0,yUp,appWidth,appHeight);
              
              textFont( smallText, smallTextSize);
              textAlign( CENTER );
              if(skyRender.equals("PARTLY") || skyRender.equals("MOSTLY"))
              text( skyRender + " CLOUDY", appWidth*0.49 , yUp+appHeight*0.27 );
              else
              text( skyRender, appWidth*0.49 , yUp+appHeight*0.27 );
              
              textFont(dataText20, dataTextSize);
              textAlign( CENTER );
              text( temp + " C", appWidth*0.49 , yUp+appHeight*0.24 );
        
              
              if(dyUp<0.5){
                skySame = true;
                yDown = 0;
                dyDown = appHeight * 0.18;
                yUp = appHeight*0.18;
                dyUp = appHeight*0.18;
                }
              
              }
            
            }  
      
          }
    
      }

/*
Determines the condition of the sky - the icon displayed above the clock.
*/
void skyCondition(){
     
     skyConditionOld = skyRender; //old Sky condition which was there the last time this function was called.
    
      String skyUpper = sky.toUpperCase(); 
      String[] skyList = split(skyUpper, " "); 
      for(int j=0; j<skyList.length; j++){
          for(int i=0; i<wordList.length; i++){
              if(skyList[j].equals(wordList[i])){
                skyMatch = true;
                skyRender = wordList[i];
                break;
                }
              }
           if(skyMatch == true){
              skyMatch = false;
              break;
             }
           else
              skyRender = "UNKNOWN";
         }
      
      
      skyConditionNew = skyRender; // new Sky condition updated after running the for loops
      
      //the first time sky condition old and new will not be same, so it has been checked that it is not the first time.
      if(!(skyConditionOld.equals(skyConditionNew)) && !firstTime)
        {
          skySame = false;
          s_skyConditionOld = s_skyCondition;
        }
    
      
      if(skyRender.equals("CLEAR") || skyRender.equals("SUNNY") ){
        if(dayTime)
           s_skyCondition = s_clearDay;
        else
           s_skyCondition = s_clearNight;
      }
      
       else if(skyRender.equals("MOSTLY") || skyRender.equals("CLOUDY") ){
        if(dayTime)
          s_skyCondition = s_mostlyCloudyDay;
        else
          s_skyCondition = s_mostlyCloudyNight;
      }
      
       else if(skyRender.equals("PARTLY") || skyRender.equals("SCATTERED") ){
         if(dayTime)
            s_skyCondition = s_partlyCloudyDay;
        else
            s_skyCondition = s_partlyCloudyNight;
      }
      
       else if(skyRender.equals("SNOW") || skyRender.equals("ICE") || skyRender.equals("HAIL") || skyRender.equals("SLEET")  ){   
        if(dayTime)
          s_skyCondition = s_snowingDay;
        else
          s_skyCondition = s_snowingNight;
      }
      
        else if(skyRender.equals("THUNDERSTORM") || skyRender.equals("THUNDERSTORMS") || skyRender.equals("SQUALLS") || skyRender.equals("FUNNEL")  ){
        if(dayTime)
          s_skyCondition = s_thunderstormDay;
        else
          s_skyCondition = s_thunderstormNight;
      }
      
        else if(skyRender.equals("FOG") ){
          s_skyCondition = s_fog;
         }
         
         else if(skyRender.equals("HAZE") || skyRender.equals("MIST")){
          s_skyCondition = s_haze;
         }
         
         else if(skyRender.equals("DRIZZLE") || skyRender.equals("SPRAY") ){
          s_skyCondition = s_drizzle;
         }
         
         else if(skyRender.equals("OVERCAST") ){
          s_skyCondition = s_overcast;
         }
         
         else if(skyRender.equals("RAIN") ){
          s_skyCondition = s_rain;
         }
  
         else if(skyRender.equals("UNKNOWN") ){
          s_skyCondition = s_haze;
         }
         
         else if(skyRender.equals("SMOKE") || skyRender.equals("ASH") || skyRender.equals("DUST") || skyRender.equals("SAND")  ){
         s_skyCondition = s_haze;
         }
         
         else{
           s_skyCondition = s_haze;
         }
      
         
         s_skyConditionNew = s_skyCondition;
  }    

/*
Renders all text which remains unchanged
*/
void renderStaticText(){
    fill(#ffffff);
    textFont( smallText, smallTextSize);
    textAlign( LEFT );
    text( "RAIN", appWidth*12/135, appHeight*32/243 );
    textAlign( CENTER );
    text( "FEELS LIKE", appWidth*0.49 , appHeight*32/243 );
    textAlign( RIGHT );
    text( "HUMIDITY", appWidth * 123/135, appHeight*32/243 );
    
    //City Name//
    if(scaleFactor==3 || scaleFactor>3)
       textFont(largeText40, largeTextSize);
    else
        textFont(largeText30, largeTextSize);
    
    textAlign( LEFT );
    text( CityName, appWidth/12 , appHeight*0.8  );
    
    
    //Date//
    textFont(largeText30, dateTextSize);
    textAlign( RIGHT);
    text( outputDate, appWidth*11/12 ,  appHeight*0.8 );//date
    textAlign(CENTER);
    text(AmOrPm, appWidth/2, appHeight/2 + dateTextSize/3);
        
    //pop, feelsLike and humidity values//
    textFont(dataText20, dataTextSize);
    textAlign( LEFT );
    if(pop != null)
       text( pop + "%", appWidth*17/135 , appHeight*27/243  );
    
    textAlign( CENTER );
    if(feelsLike != null)
       text( feelsLike + "C", appWidth*0.49 , appHeight*27/243  );
    
    textAlign( RIGHT );
    if(humidity != null){
      String[] humid = split(humidity, "%");
      text( humid[0] + "%", appWidth*118/135 , appHeight*27/243  );
    }
    
    //sunrise and sunset times//
    textAlign( RIGHT );
    if(sunriseHour != null && sunriseMinute != null){
      text( sunriseHour + ":" + sunriseMinute, appWidth*49/135 , appHeight*218/243  );
    }
  
    textAlign( LEFT );
    if(sunsetHour != null && sunsetMinute != null){
       text( sunsetHour + ":" + sunsetMinute, appWidth*87/135 , appHeight*218/243  );
    }
    
    
    //Min and Max temp//
      textAlign( CENTER );
    if(minTemp != null ){
       text( minTemp + " C" , appWidth*54/135 , appHeight*230/243  );
    }
    
    textAlign( CENTER );
    if(maxTemp != null ){
      text( maxTemp + " C" , appWidth*82/135 , appHeight*230/243  );
    }
  
    noFill();
}

/*
Returns the numnber of periods as well as days. 
Also detects if the user has moved a day forwards/backwards and adjusts the date accordingly.
*/
void getPeriods(){
  while(true){
      offsetAngle = (int(degrees(angle(a,Vtime))))%30;
      numPeriods = numRotations*12 + (Vangle+offsetAngle)/30;
      dayPrev = day;
      day = (hour() + numPeriods)/24;
      if(forecast){
        if( (day - dayPrev) == 1){
            cal.add(Calendar.DATE, 1);
            outputDate = sdf.format(cal.getTime());
          }
        if((dayPrev - day) == 1){
           cal.add(Calendar.DATE, -1);
           outputDate = sdf.format(cal.getTime());
           }
         }    
     }
}

/*
Checks Am or Pm as well as gives if it is night time or day time.
*/
void checkAmPm(){
    while(true){
          AmPm = (hour() + numPeriods)/12;
          if(AmPm%2 == 0)
            AmOrPm = "AM";
          else
            AmOrPm = "PM";
          
          HourAngle = int(degrees(angle(a,Vb)));

        if((sunriseHour != null) && (sunsetHour != null)){         
            DayNight =(hour() + numPeriods)%24;
            
            if( DayNight < (Float.valueOf(sunriseHour)) ){
                nightTime=true;
                dayTime = false;
               }
            else if ( DayNight > Float.valueOf(sunsetHour) /*|| DayNight == Float.valueOf(sunsetHour)*/ ){ 
                nightTime=true;
                dayTime = false;
                }
            else{
                nightTime = false;
                dayTime = true;
                }
          }  
     }
}

/*
If not in forecast mode - this function sets numPeriods and numRotations = 0, and gives angle made by current time with 12'O CLock. 
This angle is used to draw the hour hand later.
Also sets 'b' accordging to time. 
*/  
  void check_NotForecast(){
  if(!forecast){ 
    numPeriods = 0;
    numRotations = 0;
    setAccToHour(b);// set x and y of 'b' according to time
    HourCircleX = b.x + width/2; //Set the hour adjustment circle x and y according to the actual time, so 
    HourCircleY = b.y + height/2; //when not in forecast mode, the adjustment circle gets reset to the actual time
    angle = angle(a,b);  //Angle b/w 'b' vector and vertical i.e the angle between 12'OClock and current time.
  }
 }

/*
Repositions the hour hand adjustment circle according to the changed position of the hour hand. 
Angle is used to draw the hour hand later.
Also, sets 'b' according to the mouse. 
So 'b' is either set according to time(in check_NotForecast) or according to the mouse.
*/
 void reposition_HourAdjustmentCircle(){
    
    if (AllowHourAdjustment && forecast) {
      b.set(mouseX-width/2, mouseY-height/2, 0); // width/2 and height/2 is subtracted from the mouse position, because while drawing the whole thing is translated by width/2 and height/2
      angle = angle(a, b); // Calculate the angle between where the mouse has dragged the hour hand and the vertical(12'O Clock)
      HourCircleX = hourHandLength*cos(angle - PI / 2.0f) + width/2; //Set the adjustment circle x and y according to the angle, so that when the user leaves
      HourCircleY = hourHandLength*sin(angle - PI / 2.0f) + height/2; // the pointer somewhere else after adjustment, the user can still get the adjustment circle at the tip of the hour hand.
  }
 }

/*
Renders the clock
*/
void renderClock(){
 //everything translated to the centre of the screen.  
  pushMatrix();
  translate(width/2, height/2);
  
  //clock starts
  fill(appColor);
  ellipse(0, 0, clockDia, clockDia);
  noFill(); 
  stroke(#ffffff);
  strokeWeight(2);
  ellipse(0, 0, clockDia, clockDia);
  
  
  //hour markings
  for (int i = 0; i < 12; i++) {
      float dx = cos(i * TWO_PI / 12);
      float dy = sin(i * TWO_PI / 12); 
      if(i%3==0)
      continue;
      line(clockDia/2.15 * dx, clockDia/2.15 * dy, clockDia/2.1 * dx, clockDia/2.1 * dy);
  }
  
  //3,6,9,12 hour markings
  for (int i = 0; i < 4; i++) {
      float dx = cos(i * TWO_PI / 4);
      float dy = sin(i * TWO_PI / 4); 
      line(clockDia/2.3 * dx, clockDia/2.3 * dy, clockDia/2.1 * dx, clockDia/2.1 * dy);
  }
  
  strokeWeight(2.5);
  line(0, 0, hourHandLength*cos(angle - PI / 2.0f), hourHandLength*sin(angle - PI / 2.0f));
   
  /*
  Drawing minute and seconds hands according to forecast or !forecast
  minute hand needs to be drawn according to time when not in forecast mode, and according to minuteAngle when in forecast mode.
  */
  if(!forecast){
    drawHand(MinSecHandLength, minute(), 60);
    strokeWeight(1);
    drawHand(MinSecHandLength, second(), 60);
    strokeWeight(2.5);
    secondValue = second();
  }
  else{ //forecast mode
      minuteAngle = (angle%30)*12; //for 30 degree movement of hour hand, the minute hand moves by 360. So for every degree it moves by 12.
      line(0, 0, MinSecHandLength*cos(minuteAngle - PI / 2.0f), MinSecHandLength*sin(minuteAngle - PI / 2.0f));
      strokeWeight(1);
      drawHand(MinSecHandLength, secondValue, 60); //Seconds hand is drawn according to secondValue. This is because in forecast mode we want the seconds hand to freeze.
      strokeWeight(2.5);
  }

  popMatrix();
  
  //forecast circle drawn in the middle
  fill(appColor);
  stroke(#ffffff);
  strokeWeight(2.5);
  ellipse(forecastCircleX, forecastCircleY, forecastCircleDia, forecastCircleDia);
  noFill();

  //render static text here
  renderStaticText();
  }


