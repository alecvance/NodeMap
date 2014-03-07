// Blip

class Blip {
  Route route;
  float t; // time
  float size;
  //  float dx;
  // float dy;
  float maxTime = 10 * 1000;
  boolean finished = false;

  Blip(Route _route, float _size, float _speed) {
    route = _route;
    size = _size;

    t =millis();

    //  float dx = route.destination.x - route.origin.x;
    //  float dy = route.destination.y - route.origin.y;

    println("New blip of mass "+size);

    maxTime = dist(route.destination.x, route.destination.y, route.origin.y, route.origin.y);

    println("maxTime is "+maxTime);
  }


  void display() {

    float dt = millis() - t;

    if (dt>maxTime) {

      // KILL AND REMOVE~~
      finished = true;
    }
    else {

      //      float x = route.origin.x + dt * cos(dy/dy);
      //     float y = route.origin.y + dt * sin(dx/dy);


      float x = map(dt, 0.0, maxTime, route.origin.x, route.destination.x);
      float y = map(dt, 0.0, maxTime, route.origin.y, route.destination.y);

      ellipseMode(CENTER);
      fill(#ffffff, 127);
      noStroke();    
      ellipse(x, y, size, size);
    }
  }
}

