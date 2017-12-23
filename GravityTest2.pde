float G = 2;
PVector Z;
PVector X;

ArrayList <Point> planets;
boolean isPlay = false;

int followed = -1;
float camSpeed = 15;
float pScl = (1.0/32.0);

float dc = 0;
float dt = 1.0/60.0;

Cam camera;
PlanetCreator PC;
GameMode GMode;

//PrintWriter output;

void setup()
{
  //output = createWriter("frames.txt");
  
  Z = new PVector(0,0,1);
  X = new PVector(1,0,0);
  
  camera = new Cam();
  PC = new PlanetCreator();
  
  planets = new ArrayList<Point>();
  
  GMode = GameMode.PAUSE;
  
  size(1200, 700);
  frameRate(60);
}

///////////////////////////////////////////////////////////////////////////////

void draw()
{

  KeyBoard();

  camera.Update();
  PC.Update();
  background(0);
  
  if(GMode == GameMode.GO)
  {
  AtractAll();
  UpdateAll();
  }
  ShowAll();
  PC.Show();

 dt = 1.0/frameRate;
 dc += dt;
  //println(frameRate);
  
}