// Route is one way that points to a connection

class Route {
  Node origin;
  Node destination;
  Connection connection;
  //float size; // weight
  float chargesMass = 0; 
  ArrayList <Blip>blips;


  Route(Node _origin, Node _destination) {
    origin = _origin;
    destination = _destination;
    blips = new ArrayList<Blip>();
  }

  float distance() {
    return connection.distance;
  }

  void addChargeOfMass(float mass) {
    chargesMass += mass;
    float speed = 200.0/1000.0 / pow(1.1, mass) ;
    Blip blip = new Blip(this, mass, speed);
    blips.add(blip);
  }


  void display() {
    for (int i = blips.size()-1; i >= 0; i--) {
      Blip blip = blips.get(i);
      blip.display();
      if (blip.finished) {
        // Items can be deleted with remove().
        this.destination.size += blip.size;
        blip.size = 0;
        blips.remove(i);
      }
    }
  }
}
