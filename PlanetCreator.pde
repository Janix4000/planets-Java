  /*
  float addon = TWO_PI/float(n);

  float r = Sun.radius + 300;
  PVector MPos = points[0].pos;
  float sunMass = points[0].mass;
  PVector Z = new PVector(0, 0, 1);

  float velocity = sqrt(sunMass*G/(r))/pScl ;

  for (int i =0; i< n; i++ )
  {
    float angle = i * addon;
    float x = cos(angle) * r;
    float y = sin(angle) * r;
    Point temp = new Point(x, y);
    PVector distV = temp.pos.copy();
    distV.sub(MPos);
    temp.vel = distV.cross(Z);

    temp.vel.setMag(velocity);

    points[i+first] = temp;
  }
  */
enum CMode
{
  NONE,
  SIGHT,
  ORBIT,
  VEL,
  POS,
  SIZE,
}

class PlanetCreator
{
  Point planet;
  OrbitCreator OC;
  
  PVector pos;
  PVector vel;
  float radius;
  CMode mode;
  
  float maxSpeed = 2000;
  
  boolean created;
  
  PlanetCreator()
  {
    pos = new PVector();
    vel = new PVector();
    radius = 0;
    mode = CMode.NONE;
    created = false;
    OC = new OrbitCreator();
  }
  
  void MakePlanet()
  {
    mode = CMode.SIGHT;
    created = true;
    planet = new Point(camera.MousePos());
    planet.StrokeON();
  }
  
  void EditPlanet(Point target)
  {
    mode = CMode.SIGHT;
    created = false;
    planet = target;
    planet.StrokeON();
    pos = planet.pos.copy();
  }
  
  void Update()
  {
    switch(mode)
    {
      case NONE:
      break;
      case SIGHT:
      {
      }
      break;
      case POS:
      Pos();
      planet.pos = pos;
      break;
      case VEL:
      Vel();
      planet.setVel(vel);
      break;
      case SIZE:
      Size();
      planet.radius = radius;
      break;
      case ORBIT:
      Orbit();
      break;
    }
  }
  
  void Show()
  {
    if(mode != CMode.NONE)
    {
      planet.Show();
      planet.ShowVectors();
      if(mode == CMode.ORBIT )
      {
        OC.Show();
      }
    }
  }
  
  void End()
  {
    mode = CMode.NONE;
    planet.normMass();
    planet.StrokeOFF();
    if(created)
    {
      planets.add(planet);
    }
  }
  
  void Pos()
  {
    pos = camera.MousePos();
  }
  
  void Vel()
  {
    vel = camera.MousePos().sub(pos);
    vel.limit(maxSpeed);
  }
  
  void Size()
  {
   radius = camera.MousePos().sub(pos).mag();
  }
  
  void Orbit()
  {
    OC.Update();
  }
  
  void AddOrbiter()
  {
    planet.normMass();
    OC.AddOrbiter(planet);
     mode = CMode.ORBIT;
  }
  
  
  void setSize()
  {
    mode = CMode.SIZE;
  }
  void setPos()
  {
    mode = CMode.POS;
  }
  void setVel()
  {
    mode = CMode.VEL;
  }
  void Sight()
  {
    if(mode == CMode.ORBIT)
    {
      OC.End();
    }
    mode = CMode.SIGHT;
  }
  
};