/**
 * Weather Time  
 *  
 * A desktop application developed to view weather data in a fun way.
 * The application is released under GNU GENERAL PUBLIC LICENSE Version 3. 
 * The code for the application is available at - https://github.com/dhruv-saxena/WeatherTime
 *
 *
 * processing-http library by Francisli is required and is available with the rest of the code at - https://github.com/dhruv-saxena/WeatherTime
 * Alternatively, it is also available at Francisli's github page for the library - https://github.com/francisli/processing-http
 * processing-http library is also released under GNU GENERAL PUBLIC LICENSE Version 3.
 */



 void setup() {

     try{
         String[] lines = loadStrings("Details.txt");
         for (int i=0; i < lines.length; i++) {
              String[] val = split(lines[i], ',');
              Values = append(Values,val[1]);  
             }
      
        City = Values[0];
        CityName = City;
        Place = Values[1];
        apiKey = Values[2];
        scaleFactor = Float.valueOf(Values[3]);
        if(scaleFactor<2.5)
        scaleFactor = 2.5;
        if(scaleFactor>5)
        scaleFactor = 5;
        customColor = Values[4].toUpperCase();
        if(customColor.equals("BLUE")){
                appColor = #32a4b7;
                s_chancesOfRain = loadShape("chancesOfRain_blue.svg");
                }
        else if(customColor.equals("GREEN")){  
                appColor = #4d934d;
                s_chancesOfRain = loadShape("chancesOfRain_green.svg");
                }
        else if(customColor.equals("PURPLE")){  
                appColor = #5d4f99;
                s_chancesOfRain = loadShape("chancesOfRain_purple.svg");
                }
         else if(customColor.equals("RED")){  
                appColor = #ff6666;
              s_chancesOfRain = loadShape("chancesOfRain_red.svg");  
               }
        }catch(Exception e){
          println ("Details.txt file may be Missing/Named Incorrectly/Empty/Corrupted.");
          println ("Giving default data for Bangalore, India.");
          }
        
  
        //This block will handle city names like New Delhi - the request has to be made like New%20Delhi
        String SpaceInCity[] = match(City, " ");
        if(SpaceInCity != null){
          String[] CityCorrect = split(City, " ");
          City = "";
          for(int i=0; i<CityCorrect.length - 1; i++){
              City += CityCorrect[i] + "%20";
              }
          City += CityCorrect[CityCorrect.length -1];
          }
    
         loadImages();
         loadFonts();
        
        appWidth = int(artWidth*scaleFactor);
        appHeight = int(artHeight*scaleFactor);
          
        size(appWidth, appHeight); 
        smooth();
        textAlign(CENTER, CENTER);
        forecastCircleX = width/2;
        forecastCircleY = height/2;
        thread("ccwCheck");
          
        client = new HttpClient(this, "api.wunderground.com");
        thread("makeRequest"); 
        thread("getPeriods");
        thread("checkAmPm");
          
        cal = Calendar.getInstance();
        outputDate = sdf.format(cal.getTime());
          
        //Text Sizes and Fonts defined
        dataTextSize = ceil(4*scaleFactor );
        if(dataTextSize > 20)
           dataTextSize = 20;
        else if (dataTextSize <12)
                 dataTextSize = 12;
          
        dateTextSize = ceil(6*scaleFactor);
          
        largeTextSize = ceil(10*scaleFactor);
        if(largeTextSize > 40)
           largeTextSize = 40;
        else if (largeTextSize <20)
            largeTextSize = 20;
          
        smallTextSize = ceil(3*scaleFactor );
        if(smallTextSize > 14)
           smallTextSize = 14;
        else if (smallTextSize <8)
            smallTextSize = 8;
           
  
     
        //Clock Details
        clockDia = 0.75 * appWidth;
        hourHandLength = clockDia/3.5;
        MinSecHandLength = clockDia/2.2;
        forecastCircleDia = clockDia/5; 
           
        yDown = 0;
        yUp = appHeight*0.18;
        dyDown = appHeight*0.18;
        dyUp = appHeight*0.18;
        easing = 0.08;
    
     }//setup ends

  void draw() {
        
        background(appColor);
        
        UpdateOverCircle(); // check if mouse is hovering over forecast circle, or the hour end adjustment circle
        
        check_NotForecast(); // check if not in forecast mode
        
        reposition_HourAdjustmentCircle(); // reposition the hour hand adjustment circle
           
        renderImages(); // render all images
        
        renderClock(); // render the clock
       
       }

 
 void mouseReleased(){
          AllowHourAdjustment = false; 
          if(numRotations<0){ 
             numRotations = 0;
             forecast = !forecast;
            }

           if( forecast == true && HourCircleOver == true  ) //Ensures weather is not updated unless the mouse is on the hour hand, while in forecast mode.
               updateWeather();
       }              


/*
  When mouse is pressed while the cursor is at the needle end, AllowHourAdjustment becomes true,
  which in turn lets you set the b.x and b.y values in draw().
 */  
 void mousePressed(){ 
      if(HourCircleOver)
         AllowHourAdjustment = true;
       else
           AllowHourAdjustment = false;
     }


 /*
   Just checks if the forecast button has been clicked or not.
   If it is clicked, it reverses the state of the forecast variable.
 */
 void mouseClicked(){ 
      if(forecastCircleOver){
         forecast = !forecast;
              
          if(forecast == false){ //Ensures weather updated according to current conditions everytime the user changes from forecast to present mode.
              updateWeather();
               //get the real date when not in forecast mode.
               cal = Calendar.getInstance();
               outputDate = sdf.format(cal.getTime());
             }
             
         }
             
      }


