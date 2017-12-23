int count = 0;
class Point 
{
  boolean stroked = false;
  int ID;
  PVector pos;
  //PVector lastPos;
  PVector vel;
  PVector lastVel;
  PVector acc;
  PVector lastAcc;
  float radius;
  float maxSpeed = 800;
  boolean lives = true;
  
  float mass;
  
  color baseC;
  color c;
  
  Point(float x, float y)
  {
    ID = count++;
    pos = new PVector(x,y);
    //lastPos = pos.copy();
    vel = new PVector();
    lastVel = vel.copy();
    acc = new PVector();
    lastAcc = new PVector();
    mass= 300;
    normRadius();
    
    vel.mult(random(maxSpeed));
    
    baseC = color(
    floor(random(0,4)*64),
    floor(random(0,4)*64),
    floor(random(0,4)*64));
    c = baseC;
  }
  
  Point()
  {
    this(random(-width, width), random(-height, height));
  }
  
  Point(PVector position)
  {
    this(position.x, position.y);
  }
  
  void Atract(Point target)
  {
    PVector force = target.pos.copy();
    force = force.sub(pos);
    float strength;
    float dSq = force.magSq();
    //dSq = constrain(dSq, 1, 20);
    if(dSq>10)
    {
      dSq *= (pScl*pScl);
      strength = target.mass*G/(dSq);
      force.setMag(strength);
      acc.add(force);
      
      strength = mass*G/(dSq);
      force.setMag(strength);
      force.mult(-1);
      target.acc.add(force);
    }
  }
  
  void Update()
  {
    //lastPos.x = pos.x;
    //lastPos.y = pos.y;
    
    PVector accCopy = acc.copy();
    vel.add(accCopy.mult(1.0/60.0));
    
    PVector velCopy = vel.copy();
    velCopy.mult(1.0/60.0);
    
    pos.add(velCopy);
    
    lastVel = vel.copy();
    lastAcc = acc.copy();
    
    acc.mult(0);
  }
  
  void Show()
  {
    if(stroked)
    {
      stroke(255);
      strokeWeight(2);
    }
    else
    {
      noStroke();
    }
    fill(c);
    ellipse(pos.x, pos.y, 2*radius, 2*radius); 
  }
  
  void ShowVectors()
  {
    stroke(255,255,255);
    strokeWeight(2);
    line(pos.x, pos.y, pos.x+lastAcc.x, pos.y+lastAcc.y);
    
    stroke(255,0,0);
    line(pos.x, pos.y, pos.x+lastVel.x, pos.y+lastVel.y);
  }
  
  void Consume(Point target)
  {
    pos.mult(mass);
    target.pos.mult(target.mass);
    pos.add(target.pos);
    pos.div(target.mass+mass);
    
    vel.mult(mass);
    target.vel.mult(target.mass);
    vel.add(target.vel);
    vel.div(mass+target.mass);
    
    float massProp = mass / (mass+target.mass);
    baseC = lerpColor(baseC, target.baseC, 1-massProp);
    c = baseC;
    
    mass += target.mass;
    normRadius();

    
    target.mass *=0;
    target.vel.mult(0);
    target.acc.mult(0);
    target.Kill();
  }
  
  boolean isOverlapping(PVector t)
  {
    //float rSq = radius * radius;
    //float rTSq = target.radius * target.radius;
    float d = pow(t.x-pos.x,2) + pow(t.y - pos.y,2);
    return d<(radius*radius);
  }
  
  boolean isColladingWith(Point target)
  {
    //float rSq = radius * radius;
    //float rTSq = target.radius * target.radius;
    float d = dist(pos.x, pos.y, target.pos.x, target.pos.y);
    d /= (radius+target.radius);
    return d<1;
  }
  
  void Kill()
  {
    lives = false;
  }
  
  void normRadius()
  {
    radius =  sqrt(mass/PI);
  }
  
  void normMass()
  {
    mass = radius * radius * PI;
  }
  
  void setVel(PVector velocity)
  {
    vel = velocity;
    lastVel = velocity;
  }
  
  boolean isStroked()
  {
    return stroked;
  }
  
  void StrokeON()
  {
    stroked = true;
  }
  
  void StrokeOFF()
  {
    stroked = false;
  }
  
};