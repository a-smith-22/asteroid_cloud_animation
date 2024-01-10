/*
Astronomy Simulator. Devloped by Andrew Smith. Copyright 2022.
Initial version: 02-03-2022

About:
TBD

Patch notes:
02-04-2022 - Fixed force function, asteroids no longer jet off after near collisions.
02-04-2022 - Added bounce() function to Asteorid class
*/


final boolean reduced_graphics = true; //Whether to display PNG image or plan circle for asteorid design. ]
final boolean record = false; //Whether to record the animation by saving frames into "output" folder. 

final int num_astd = 30000; //Number of asteroids (max 10,000 for faster loading).  
final int radius = 1; //Asteroid radius. Value of 2 (and reduced_graphics true) recommended for larger asteroid numbers.  

//INPUT VALUES ABOVE ^^^

Asteroid [] asteroids = new Asteroid[num_astd]; //Array of Asteroid objects. 

final color bkgd = #053625; //Dark green. 

//Colors of asteroids determined by velocity. Slow: Beige #C0AB87, Med: Yellow #DD9D02, Fast: Grey #D0D1D1.
final color [] colors = {#C0AB87, #C6A86C, #CCA552, #D1A337, #D7A01D, #DD9D02, #DAA72B, #D8B255, #D5BC7E, #D3C7A8, #D0D1D1};

PImage asteroid_img;

void setup() {
  size(800,800);
  //frameRate(2);
  
  asteroid_img = loadImage("asteroid-image.png"); //Load file for asteroid image. 
  
  for(int i=0; i<asteroids.length; i++) {
    asteroids[i] = new Asteroid(random(width), random(height), radius, asteroids);
  } //Create new Asteroid objects randomly placed on screen. 
  
}

void draw() {
  background(bkgd);
  
  for(int i=0; i<asteroids.length; i++) {
    asteroids[i].force();
  } //Calculate the force on each asteroid BEFORE moving. 
  
 for(int i=0; i<asteroids.length; i++) { // 
    asteroids[i].display();
    //asteroids[i].warp(); //Keeps asteroids in frame with a pacman style warp. 
    asteroids[i].bounce(); //Bounces asteroids off the sides of the screen. 
    asteroids[i].move();
  } //Move and display each asteroid.
  
  if(record) {saveFrame("output/frame_###.jpg"); }//Save each frame of animation in "output" folder. 
}
