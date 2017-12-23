enum OMode
{
  NONE,
  SIGHT,
  SIZE,
  LENGTH
}

class OrbitCreator
{
  Point parent;
  Point orbiter;
  OMode mode;
  boolean created;
  
  float w;
  float h;
  PVector O;
  
  float rPer;
  float rAp;
  
  PVector per;
  PVector ap;
  
  PVector dDist;
  
  float v;
  PVector vel;
  
  float a, b, e;
  
  float angle;
  
  OrbitCreator()
  {
    mode = OMode.NONE;
    vel = new PVector();
    per = new PVector();
    ap = new PVector();
    O = new PVector();
    dDist = new PVector();
  }
  
  void Update()
  {
    switch(mode)
    {
      case NONE:
      break;
      case SIGHT:
      break;
      case SIZE:
      {
        Size();
      }
      break;
      case LENGTH:
      break;
    }
  }
  
  void AddOrbiter(Point father)
  {
    parent = father;
    created = true;
    orbiter = new Point();
    orbiter.radius = parent.radius/4;
    orbiter.normMass();
    setSize();
    e = 0.3;
    angle =0;
  }
  
  void Size()
  {
    orbiter.pos = camera.MousePos();
    
    dDist = orbiter.pos.copy();
    dDist.sub(parent.pos);
    
    rPer = dDist.mag();
    rAp = ( rPer*(1+e) )/( 1-e );
    
    per.x = 0;
    ap.x = -rAp - rPer;
    
    calculateAngle();
    calculateAB();
    calculateWHO();
    calculateVel();
  }
  
  void Length()
  {}
  
  
  void Show()
  {
    pushMatrix();
    
    translate(parent.pos.x, parent.pos.y);
    rotate(-angle);
    translate(-parent.pos.x, -parent.pos.y);
    
    translate(-(a-rPer),0);
    
    println(angle);
    stroke(255);
    strokeWeight(1);
    noFill();
    ellipse(parent.pos.x, parent.pos.y, w, h);
    popMatrix();
    if(created)
    {
      orbiter.Show();
      orbiter.ShowVectors();
    }
    
  }
  
  void calculateAll()
  {
    calculateAB();
    calculateE();
    calculateWHO();
    calculateVel();
  }
  
  void calculateAB()
  {
    a = (rAp + rPer)/2;
    b = sqrt(rAp * rPer);
    
  }
  
  void calculateE()
  {
    e = (rAp - rPer)/(rAp + rPer);
  }
  
  void calculateWHO()
  {
    w = 2*a;
    h = 2*b;
    O.mult(0);
    O.add(ap);
    O.add(per);
    O.div(2);
  }
  
  void calculateVel()
  {
    v = sqrt( ( (1+e)*parent.mass*G )/( (1-e)*a ) )/pScl;
    //v*=1.01;
    //println(v);
    PVector dist = orbiter.pos.copy();
    dist.sub(parent.pos);
    vel = dist.cross(Z);
    vel.setMag(v);
    vel.add(parent.vel);
    orbiter.setVel(vel);
  }
  
  void calculateAngle()
  {
    angle = PVector.angleBetween(X,dDist);
    if(orbiter.pos.y-parent.pos.y>0) angle = TWO_PI - angle;
  }
  
  void setSize()
  {
    mode = OMode.SIZE;
  }
  
  void Sight()
  {
    mode = OMode.SIGHT;
  }
  
  void End()
  {
    mode = OMode.NONE;
    println("a: "+a+" b: " + " e: "+e+" O: " + O + " rAp: " +rAp + "rPer: " + rPer);
    if(created)
    planets.add(orbiter);
  }
  
}