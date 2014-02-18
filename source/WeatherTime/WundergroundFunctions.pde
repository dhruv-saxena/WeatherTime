/*
HTTP Requests Function
*/
void responseReceived(HttpRequest request, HttpResponse response) {
  //// check for HTTP 200 success code
  if (response.statusCode == 200) {
    if(request == Wconditions){
        println("Conditions  -------------------------");  
        Conditions = response.getContentAsJSONObject();
        Wforecast = client.GET("/api/" + apiKey + "/forecast/q/" + Place + "/" + City + ".json"); //Once it is made sure that 'conditions' is recieved, we request 'forecast'.
    }
    
    else if(request == Wforecast){
         println("Forecast  -------------------------"); 
         Forecast = response.getContentAsJSONObject();
         Wastronomy = client.GET("/api/" + apiKey + "/astronomy/q/" + Place + "/" + City + ".json"); //Once it is made sure that 'forecast' is recieved, we request 'astronomy'.
    }
       
    else if(request == Wastronomy){
         println("Astronomy  -------------------------"); 
         Astronomy = response.getContentAsJSONObject();
         Whourly10day = client.GET("/api/" + apiKey + "/hourly10day/q/" + Place + "/" + City + ".json"); //Once it is made sure that 'astronomy' is recieved, we request 'hourly10day'.
    }
   
    else if(request == Whourly10day){
         println("Hourly10day  -------------------------");
         Hourly10day = response.getContentAsJSONObject();
         if(!forecast)
         updateWeather();   // Once all the requests are recieved, we update the data if the user is not in forecast mode.
    }   
   
  }
  
  else if (response.statusCode != 200)
          println("Could not ping Wunderground API");
}
 
/*
A thread function - this will make the request to the wunderground api.
*/
void makeRequest(){
  while(true){
        Wconditions = client.GET("/api/" + apiKey + "/conditions/q/" + Place + "/" + City + ".json"); 
        delay(wait); 
      }
}

void updateWeather(){
  

  if(!forecast){
   
        
        try{
            temp         =  str(Conditions.get("current_observation").get("temp_c").floatValue());
            String[] tempVal = split(temp, '.');
            temp = tempVal[0];
            feelsLike    =  Conditions.get("current_observation").get("feelslike_c").stringValue();
            humidity     =  Conditions.get("current_observation").get("relative_humidity").stringValue();
            sky          =  Conditions.get("current_observation").get("weather").stringValue();
            location     =  Conditions.get("current_observation").get("display_location").get("full").stringValue();
            

            minTemp      =  Forecast.get("forecast").get("simpleforecast").get("forecastday").get(0).get("low").get("celsius").stringValue(); 
            maxTemp      =  Forecast.get("forecast").get("simpleforecast").get("forecastday").get(0).get("high").get("celsius").stringValue(); 
            
            

            pop          =  Hourly10day.get("hourly_forecast").get(0).get("pop").stringValue();
            sunriseHour  =  Astronomy.get("sun_phase").get("sunrise").get("hour").stringValue();
            sunriseMinute=  Astronomy.get("sun_phase").get("sunrise").get("minute").stringValue();
            sunsetHour   =  Astronomy.get("sun_phase").get("sunset").get("hour").stringValue();
            sunsetMinute=  Astronomy.get("sun_phase").get("sunset").get("minute").stringValue();
            }catch(Exception e){
            println ("some data not avaialable for your city");
        }
        
        
  }
  

  else if(forecast){
 
    if(day != 0){ 
    try{
        if(numPeriods<240){
       
          temp         =  Hourly10day.get("hourly_forecast").get(numPeriods).get("temp").get("metric").stringValue();
          feelsLike    =  Hourly10day.get("hourly_forecast").get(numPeriods).get("feelslike").get("metric").stringValue();
          humidity     =  Hourly10day.get("hourly_forecast").get(numPeriods).get("humidity").stringValue();
          sky          =  Hourly10day.get("hourly_forecast").get(numPeriods).get("condition").stringValue(); 
          pop          =  Hourly10day.get("hourly_forecast").get(numPeriods).get("pop").stringValue();
          
          //These will come from forecast, and can get values upto today + next 3 days. So if day variable becomes 4, null pointer exception will be raised.
          if(day>3){
          minTemp      =  null; 
          maxTemp      =  null; 
          }
          else{
          minTemp      =  Forecast.get("forecast").get("simpleforecast").get("forecastday").get(day).get("low").get("celsius").stringValue(); 
          maxTemp      =  Forecast.get("forecast").get("simpleforecast").get("forecastday").get(day).get("high").get("celsius").stringValue(); 
          }
          

          sunriseHour  =  sunriseHour;
          sunriseMinute=  sunriseMinute;
          sunsetHour   =  sunsetHour;
          sunsetMinute =  sunsetMinute;
        }
        else{ //if more than 240 periods have been crossed, the application cannot give any data, therefore make everything null.
            pop = null;
            temp = null;
            feelsLike = null;
            humidity = null;
            sky = null;
            sunriseHour = null;
            sunriseMinute = null;
            sunsetHour = null;
            sunsetMinute = null;
            minTemp = null;
            maxTemp = null;
          }
    }catch(Exception e){
        println ("some data not avaialable for your city"); //This will be printed to the screen in case a null point exception is raised.
        } 
    }else{//day = 0 //This will happen in case the day is the same and we are forecasting for some hour of the same day. 
    try{
      //temp         =  Hourly10day.get("hourly_forecast").get(Xhour).get("temp").get("metric").stringValue();
        temp         =  Hourly10day.get("hourly_forecast").get(numPeriods).get("temp").get("metric").stringValue();
        feelsLike    =  Hourly10day.get("hourly_forecast").get(numPeriods).get("feelslike").get("metric").stringValue();
        humidity     =  Hourly10day.get("hourly_forecast").get(numPeriods).get("humidity").stringValue();
        sky          =  Hourly10day.get("hourly_forecast").get(numPeriods).get("condition").stringValue(); 
        pop          =  Hourly10day.get("hourly_forecast").get(numPeriods).get("pop").stringValue();
        minTemp      =  Forecast.get("forecast").get("simpleforecast").get("forecastday").get(day).get("low").get("celsius").stringValue(); 
        maxTemp      =  Forecast.get("forecast").get("simpleforecast").get("forecastday").get(day).get("high").get("celsius").stringValue(); 
        

        sunriseHour  =  Astronomy.get("sun_phase").get("sunrise").get("hour").stringValue();
        sunriseMinute=  Astronomy.get("sun_phase").get("sunrise").get("minute").stringValue();
        sunsetHour   =  Astronomy.get("sun_phase").get("sunset").get("hour").stringValue();
        sunsetMinute=  Astronomy.get("sun_phase").get("sunset").get("minute").stringValue();
          
  }catch(Exception e){
        println ("some data not avaialable for your city");
        } 
 
    }

  }
  
   //Print everything you get
    println("pop : " + pop);
    println("temp : " + temp);
    println("feelsLike : " + feelsLike);
    println("humidity : " + humidity);
    println("sky : " + sky);
    println("sunrise : " + sunriseHour + " " + sunriseMinute);
    println("sunset : " + sunsetHour + " " + sunsetMinute);
    println("minTemp : " + minTemp);
    println("maxTemp : " + maxTemp);
    println("location : " + CityName);
}
