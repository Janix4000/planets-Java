void keyPressed()
{
  switch(GMode)
  {
    case CREATE:
      if (PC.mode == CMode.SIGHT)
      {
        if (key == 'r')
        {
          println("Wielkosc");
          PC.setSize();
        } else if (key == 'v')
        {
          println("Vektorki");
          PC.setVel();
        } else if (key == 'p')
        {
          println("Pozycja");
          PC.setPos();
          camera.FreeMode();
        }
        else if(key == 'o')
        {
          println("Orbita");
          PC.AddOrbiter();
          camera.FreeMode();
        }
        else if (key == ENTER)
        {
          PC.End();
          GMode = GameMode.PAUSE;
          camera.FreeMode();
        }
         else if(key == BACKSPACE)
        {
          
          if(camera.isFollowing())
          {
            removePlanet(camera.target);
            PC.End();
            GMode = GameMode.PAUSE;
            camera.FreeMode();
          }
        }
      }
      if(key == ' ' && PC.mode != CMode.POS)
      {
        camera.SetNewTarget(PC.planet);
      }
    break;
    case PAUSE:
    if (key == ENTER)
      {
        //println("Jestes tutaj");
        GMode = GameMode.CREATE;
        PC.MakePlanet();
        PC.setPos();
      }
   
    break;
    case GO:
      if(planets.size()>0)
      {
        if (key == 'e')
         {
           followed = ++followed < planets.size() ? followed : 0;
           camera.SetNewTarget(planets.get(followed));
         } 
        else if(key == 'q')
         {
           followed = --followed >= 0 ? followed : planets.size()-1;
           camera.SetNewTarget(planets.get(followed));
         }
        
      }
    break;
  }
  
  //In more than one mode
  if (key == ' ')
  {
    if (GMode == GameMode.PAUSE)
    {
      GMode = GameMode.GO;
    } else if(GMode == GameMode.GO)
    {
      GMode = GameMode.PAUSE;
    }
  }
  
}


void mouseClicked()
{
  switch(GMode)
  {
    case CREATE:
      if (mouseButton == LEFT)
      {
        switch(PC.mode)
        {
          case SIGHT:
          Point pointed = getPointed();
          camera.SetNewTarget(pointed);
          if(!(pointed==null))
          {
            PC.End();
            PC.EditPlanet(pointed);
            GMode = GameMode.CREATE;
            println("Edytujesz planete");
          }
          else
          {
            PC.End();
            GMode = GameMode.PAUSE;
          }
          break;
          case SIZE:
          case VEL:
          case POS:
          case ORBIT:
          PC.Sight();
          break;
        }
      }
      
    break;
    
    case PAUSE:
    {
      if (mouseButton == LEFT)
      {
        Point pointed = getPointed();
        camera.SetNewTarget(pointed);
        //println("Nowy target w pausie, czas: " + dc);
        if(!(pointed==null))
        {
          PC.EditPlanet(pointed);
          GMode = GameMode.CREATE;
          println("Edytujesz planete");
        }
        dc = 0;
      }
    }
    break;
    case GO:
    {
      if (mouseButton == LEFT)
      {
        camera.SetNewTarget(getPointed());
      }
    }
    break;
  }
}
   



void KeyBoard()
{
  if (keyPressed)
  {
    if (key == 'd')
    {
      camera.Move(camSpeed, 0);
    }
    if (key == 'a')
    {
      camera.Move(-camSpeed, 0);
    }
    if (key == 's')
    {
      camera.Move(0, camSpeed);
    }
    if (key == 'w')
    {
      camera.Move(0, -camSpeed);
    }
    if (key == '-')
    {
      camera.Scale(-0.05);
    }
    if (key == '+')
    {
      camera.Scale(0.05);
    }
  }
}

void mouseWheel(MouseEvent event) 
{
  float e = event.getCount();
  //println(e);
  e = e < 0 ? 1 : -1;
  camera.Scale(0.05 * e);
}


void AtractAll()
{
  for (int i = planets.size()-1; i >=0; i--)
  {
    Point planet = planets.get(i);

    for (int j = i-1; j >= 0; j--)
    {
      Point planetJ = planets.get(j);

      if (!planet.isColladingWith(planetJ))
      {
        planet.Atract(planetJ);
      } else
      {
        planetJ.Consume(planet);
        removePlanet(i);
        if (i==followed)
        {
          followed = j;
          camera.SetNewTarget(planetJ);
        }
        break;
      }
    }
  }
}

void UpdateAll()
{
  for (int i = planets.size()-1; i >=0; i--)
  {
    planets.get(i).Update();
  }
}

void ShowAll()
{
  for (int i = planets.size()-1; i >=0; i--)
  {
    planets.get(i).Show();
    planets.get(i).ShowVectors();
  }
}

Point getPointed()
{
  Point pointed = null;
  PVector mouse = camera.MousePos();
  for (Point planet : planets)
  {
    if(planet.isOverlapping(mouse))
    {
      pointed = planet;
      break;
    }
  }

 return pointed;
}

void removePlanet(int index)
{
  planets.remove(index);
  if (followed>index)
  {
    followed--;
  }
}

void removePlanet(Point planet)
{
  int index = getPlanetIndex(planet);
  if(index!=-1)
  removePlanet(index);
}

int getPlanetIndex(Point planet)
{
  int i = 0;
  boolean found = false;
  int ID = planet.ID;
  for(; i<planets.size();i++)
  {
    if(planets.get(i).ID==ID)
    {
      found = true;
      break;
    }
  }
  if(!found)i=-1;
  return i;
}