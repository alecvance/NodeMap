//Node

class Node {
  float x;
  float y;
  float size;
  ArrayList<Route> routes;
  float growthRate;

  Node() {
    // x = random(0, displayWidth);
    // y = random(0, displayHeight);
    size = random(3, 24);  
    growthRate = random(0.75, 1.45);
    routes = new ArrayList<Route>();
    //  distances = new float[numNodes];
  }

  void update(float t) {
    // t = time


    //size = size +  (size * t * (growthRate-1.0));
    // println(size);

    //check routes
    for (Route route : routes) {

      if (route.connection.active) {
        
        if(random(0,1)>0.95){
        float sizeDiff =  this.size - route.destination.size;

        if (sizeDiff > minCharge) {
          float mass = min(sizeDiff,maxBlipSize);
          route.addChargeOfMass(mass);
          this.size = this.size - mass;
        }
      }
      }

      //      route.update();
    }
  }

  void display() {
    ellipseMode(CENTER);

    //

    if (dist(mouseX, mouseY, x, y)<size) {

      stroke(#ff0000, 255);
    }
    else {
      stroke(#ffff00, 127);
    }

    strokeWeight(2.0);
    fill(#ffffff, 250);
    ellipse(x, y, size, size);

    noStroke();
    if (dist(mouseX, mouseY, x, y)<size) {
      fill(#ffff77, 250);

      for (Route route:routes) {
        route.connection.active = true;
      }
    }
    else {
      fill(#777700, 250);
    }
    ellipse(x, y, size/2, size/2);
  }

  float getDistanceTo(Node n) {
    return(sqrt((this.x-n.x)*(this.x-n.x)+(this.y-n.y)*(this.y-n.y)));
  }

  Route connectTo(Node n) {
    Route r = new Route(this, n);
    routes.add(r);
    return r;
  }

  Point point() {
    return new Point(x, y);
  }

  void sortDistances() {
  }
}

