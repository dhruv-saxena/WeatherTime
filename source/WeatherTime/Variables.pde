import com.francisli.processing.http.*; // library for HTTP requests
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

Calendar cal;
SimpleDateFormat sdf = new SimpleDateFormat("d  MMM   yyyy");  


//HTTP objects
HttpClient client;
HttpRequest Wconditions;
HttpRequest Wforecast;
HttpRequest Whourly10day;
HttpRequest Wastronomy;

//Details
String[] Values = {};
String City   = "Bangalore";
String CityName;
String Place  = "India";
String apiKey = "1c44d615af869e2c";
float scaleFactor = 3.5;
String customColor = "BLUE";
int appColor = #32a4b7;

//Wait period before next automatic HTTP Request
int waitMinutes = 60;
int wait = waitMinutes*60000;

//JSONObjects from which the fields aer updated
com.francisli.processing.http.JSONObject Conditions;
com.francisli.processing.http.JSONObject Forecast;
com.francisli.processing.http.JSONObject Hourly10day;
com.francisli.processing.http.JSONObject Astronomy;


//Fields
String pop;
String temp;
String feelsLike;
String humidity;
String sky;
String sunriseHour;
String sunriseMinute;
String sunsetHour;
String sunsetMinute;
String minTemp;
String maxTemp;
String location;
String dayOfTheWeek;
String dummy;

//Dimensions of artWork
int artWidth = 100;
int artHeight = 180;

//Dimensions of appWindow
int appWidth;
int appHeight;

//PVector(x,y) - Vectors are drawn from (0,0) to (x,y)
PVector a = new PVector(0, -150); // a is the vertical one when the app starts.
PVector b = new PVector(0, 150); // b is the one attached to the mouse.
PVector Vtime = new PVector(0,0); //This vector will be set according to time.
PVector Vb = new PVector(0,0); // This vector will be set according to 'b' - this is just a dummy of 'b' used in the ccwCheck thread.

float angle; // Angle of 'b' vector wrt 'a' vector i.e the vertical.
int Vangle; //  Angle between Vtime and Vb, ie the angle between actual time and 'b' vector.

//X and Y posiitons for the imaginary circle on the tip of the hour hand.
float HourCircleX; 
float HourCircleY;

int HourCircleSize = 100; // Dia of the imaginary circle.
boolean HourCircleOver = false; // Boolean to check if cursor is over the hour circle.
float minuteAngle; // Angle to be calculated for the minute hand during hour hand adjustment.
float secondValue; // seconds() are stored in secondValue. 

//angleNow and anglePrev used in ccwCheck() function
int angleNow = 0; // now and prev comparisions to know if backward rotation happened beyond starting point.
int anglePrev = 0;
int numRotations =0; // Number of times the hour hand crossed its original position. 12 hrs = 1 rotation. This is calculated in ccwCheck() function. For each CW rotation 1 is added, for CCW rotations 1 is subtracted.
int numPeriods = 0; // Number of periods which have to be input in wunderground hourly10day.
int offsetAngle; //Extra angle between any two hour markings. For eg at 2:30, the hour hand would be midway between 2 and 3. So the offsetAngle would be 15 degrees.
int day;         //Day 0 (current day), Day 1 and so on.
boolean AllowHourAdjustment = false; // Boolean for allowing adjustment of hour hand.

float forecastCircleX ; //Parameters for the forecast button
float forecastCircleY ;

boolean forecastCircleOver = false;
boolean forecast = false;
boolean ccw = false;

//Clock Details
float clockDia ;
float hourHandLength ;
float MinSecHandLength ;
float forecastCircleDia ; 


//Shape variables
PShape s_chancesOfRain;
PShape s_feelsLike;
PShape s_humidity;
PShape s_sunriseSunset;

PShape s_clearDay;
PShape s_clearNight;
PShape s_fog;
PShape s_haze;
PShape s_rain;
PShape s_drizzle;
PShape s_mostlyCloudyDay;
PShape s_mostlyCloudyNight;
PShape s_overcast;
PShape s_partlyCloudyDay;
PShape s_partlyCloudyNight;
PShape s_snowingDay;
PShape s_snowingNight;
PShape s_thunderstormDay;
PShape s_thunderstormNight;
PShape s_skyCondition;
PShape s_skyConditionOld;
PShape s_skyConditionNew;


//Font
PFont smallText;
PFont largeText40;
PFont largeText30;
PFont dataText20;

//calender
int date = day();
int month = month();
int year = year();

//Other Variables
int AmPm;
float DayNight;
String AmOrPm;
int HourAngle;

boolean dayTime;
boolean nightTime;

String wordList[] = {"DRIZZLE","RAIN","SNOW","ICE","HAIL","MIST","FOG","SMOKE","ASH","DUST","SAND","HAZE","SPRAY","THUNDERSTORM","THUNDERSTORMS","OVERCAST","CLEAR","PARTLY","MOSTLY","SCATTERED","SQUALLS","FUNNEL","UNKNOWN","CLOUDY","SUNNY","SLEET"};

boolean skyMatch = false;
String  skyRender = "INITIALIZE";
String  skyConditionOld;
String  skyConditionNew;

boolean skySame = true;
boolean firstTime = true;


String outputDate;

int dayPrev = 0;

float yDown;
float yUp;
float dyDown;
float dyUp;
float easing;

float dataTextSize;
float dateTextSize;
float largeTextSize;
float smallTextSize;

int popValue;
