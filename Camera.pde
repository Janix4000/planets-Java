
public enum CamMode
  {
    FREE,
    FOLLOW,
    RUN
  };

class Cam
{
  PVector origin;
  PVector pos;
  float maxSpeed = 20;
  
  float scl;
  float maxScl;
  float minScl;
  
  Point target;
  
  CamMode mode;
  
  float time;
  PVector vel;
  float dist;
  
  Cam(float x, float y)
  {
    origin = new PVector(x,y);
    pos = new PVector();
    vel = new PVector();
    maxScl = 1;
    minScl = 0.05;
    scl = maxScl;
    mode = CamMode.FREE;
    target = null;
  }
  
  Cam()
  {
    this(width/2, height/2);
  }
  
  void Update()
  {
    switch(mode)
    {
      case FREE:
      {
        pos.add(vel);
        vel.mult(0);
        //println(pos);
      }
      break;
      case RUN:
      {
        run();
        //println("Biegne za nim!");
      }
      break;
      case FOLLOW:
      {
        pos = target.pos.copy();
        //println("Wolniej kurwa");
      }
      break;
    }
    
    translate(origin.x, origin.y);
    scale(scl);
    translate(-pos.x, -pos.y);
  }
  
  private void run()
  {
    if(time<0.001)
    {
      FollowMode();
      vel.mult(0);
    }
    else
    {
    if(GMode == GameMode.GO)
    {
      PVector velCopy = target.vel.copy();
      velCopy.mult(1.0/60.0);
      pos.add(velCopy);  
    }
    float d = (dt/time)*dist; 
    dist -= d;
    time-=dt;
    vel.setMag(d);
    pos.add(vel);
    //println("Cam: " + pos + " Target: " + target.pos);
    }
  }
  
  void SetNewTarget(Point tar)
  {
    if(tar == null)
    {
      FreeMode();
    }
    else
    {
      target = tar;
      mode = CamMode.RUN;
      vel = target.pos.copy();
      vel.sub(pos);
      dist = vel.mag();
      time = 0.4;
    }
  }
  
  void Move(float x, float y)
  {
    vel.x += x;
    vel.y += y;
    FreeMode();
  }
  
  void Scale(float s)
  {
    scl += s;
    if(scl>maxScl) scl = maxScl;
    else if(scl<minScl) scl = minScl;
  }
  
  void FreeMode()
  {
    mode = CamMode.FREE;
    target = null;
    println("Wolna kamera");
  }
  
  void FollowMode()
  {
    mode = CamMode.FOLLOW;
    println("I follow it");
  }
  
  PVector MousePos()
  {
    float x;
    x = (mouseX - origin.x)/(scl) + pos.x;
    float y;
    y = (mouseY - origin.y)/(scl) + pos.y;
    return new PVector(x,y);
  }
  
  PVector ScreenPos(PVector target)
  {
    float x = (target.x - pos.x)*scl + origin.x;
    float y = (target.y - pos.y)*scl + origin.y;
    return new PVector(x,y);
  }
  
  boolean isFollowing()
  {
    return mode == CamMode.FOLLOW;
  }
  
};