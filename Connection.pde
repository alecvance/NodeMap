// Connection

class Connection {
  Node node1;
  Node node2;
  float distance;
  float size; // weight
  // Line2D lineRef = new Line2D.Float(100, 100, 200, 200);
  boolean active = true;
  Route[] routes = new Route[2];

  Connection(Node n1, Node n2) {
    node1 = n1;
    node2 = n2;
    distance = n1.getDistanceTo(n2);
    size = sqrt((n1.size + n2.size)/2.0) ; // average of sizes. maybe use a diff formula?

    // Line2D lineRef = new Line2D.Float(node1.x, node1.y, node2.x, node2.y);
  }

  void display() {
    if (active) {

      stroke(127, 127, 0, 127);

      strokeWeight(size);

      line(node1.x, node1.y, node2.x, node2.y);
    }

    routes[0].display();
    routes[1].display();
  }
}

