class Asteroid {
     
  int rad; //Size of each asteroid.
  
  //"min_dis" seems to work best at 10, emperically found. Could use rad/2 for larger asteroids. 
  final float min_dis = 10; //Force is only calculated for distances over this value. 
  final float max_spd = 6; //Used for color mapping. All speeds above limit are shown as purple. 

  PVector pos;
  PVector vel; 
  PVector acc; //Physics states of each asteroid. 
  
  Asteroid [] others; //Array of other asteroid objects, used for force calculations. 
  
  final float gravc = 1; //Gravitational constant scalar
  
  Asteroid(float tempX, float tempY, int tempRad, Asteroid[] otherTemp) {
    pos = new PVector(tempX,tempY);//Assign position of each asteroid.
    vel = new PVector(0,0); 
    acc = new PVector(0,0); //Stationary and non-accelerating at start. 
    
    rad = tempRad; //Set asteroid size. 

    others = otherTemp; 
  } //Constructor function to assign position and velocity values. 
  
  void force() {
    //Calculate the force (acceleration) each asteroid feels from others. 
    for(int i=0; i<num_astd; i++){ //Loop through all asteroids. 
      PVector dr = new PVector(others[i].pos.x - pos.x, others[i].pos.y - pos.y); //Points from asteorid to others[i].
      float dr_mag = dr.mag(); //Distance from asteroid to others[i].
      if(dr_mag > min_dis) { //Prevents computing the force of an asteroid on itself.
        float g_mag = 1/sq(dr_mag); //Computes 1/d^2 for magnitude of force of other[i] on asteroid. 
        PVector g_dir = dr.normalize(); //Normalize vector pointing from asteroid to other[i], direction of gravitational acceleration. 
        //Multiply dir vector (dr) by g_mag scalar, gravity constant (gravc), and masses to get the force of other[i] on asteroid.  
        acc.set(acc.x + gravc*g_mag*g_dir.x, acc.y + gravc*g_mag*g_dir.y); //Add gravity direction, magnitude, and constant as component for acceleration. 
      }
    } //Add the forces of all other asteroids (other[i]) on the asteroid to compute the acceleration. 
  }
  
  void warp() {
    //Warps asteroids to other side of screen if they travel out of frame. 
    if(pos.x > width) { pos.x = 0; }
    if(pos.x < 0) { pos.x = width; }
    if(pos.y > height) { pos.y = 0; }
    if(pos.y < 0) { pos.y = height; }
  }
  
  void bounce() {
    //Bounces asteroids off the sides of the screen (pure elastic collision). 
    if(pos.x > width  || pos.x < 0) { vel.x *= -1; }
    if(pos.y > height || pos.y < 0) { vel.y *= -1; }
  }
  
  void move() {
    //Move each asteroid based on the acceleration and position.
    //vel.add(acc); //Velocity is increased by the acceleration. 
    //pos.add(vel); //Position is changed by the velocity. 
    
    vel.set(vel.x + acc.x, vel.y + acc.y);
    pos.set(pos.x + vel.x, pos.y + vel.y);
    
    acc.set(0,0); //Acceleration is reset for next calculation, velocity remains the same. 
  }
  
  void display() {
    //Display each asteroid with equal size and shape. Maps color of asteroids based on speed or distance from center.
    
    /*
    //Map color based on distance from center.
    float cen_dis_sq = sq(pos.x-width/2)+sq(pos.y-height/2); //dist(pos.x, pos.y, width/2, height/2); //Distance from center of screen. 
    int col_val = int( map(cen_dis_sq, 0, max_color_rad, 0, colors.length-1) ); 
    if(col_val > colors.length-1) { col_val = colors.length-1; } //Bounds col_val to [0,10]
    */
    
    //Map color on speed. Faster asteroids are purple with slower ones brown. 
    float spd = vel.mag();
    int col_val = int( map(spd, 0, max_spd, 0, colors.length-1) );
    if(col_val > colors.length-1) { col_val = colors.length-1; } //Bounds colors to list.
    

    if(!reduced_graphics) {
    //Uses asteroid image to create halo effect with tinted colors. 
    pushMatrix();
    translate(-asteroid_img.width/2, -asteroid_img.height/2); //Center image on asteorid position. 
    asteroid_img.resize(rad,rad); //Set asteroid size
    tint(colors[col_val]); //Changes color of asteroid. 
    image(asteroid_img,pos.x,pos.y); //Display image as asteroid. 
    popMatrix();
    }
    
    if(reduced_graphics) {
    //Use simplified ellipse for faster processing. 
    fill(colors[col_val]); noStroke(); //Changes color of asteroid.
    ellipse(pos.x, pos.y, rad, rad);
    }
    
  } 
    
}
