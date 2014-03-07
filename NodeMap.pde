/**
 * NodeMap
 * by Alec Vance
 *
 */

int numNodes = 18+int(random(1, 16));
int numConnections = (numNodes*(numNodes-1))/2;
float minCharge = 5.0;
float maxBlipSize = 14.0;

Node[] nodes;
Connection[] connections;
//senders, receivers;
float   lastUpdateTime;

void setup() {
  
  frameRate(15);
  
  int w = 1200; //640;  
  int h = 800;// 360;
  int margin = 10;

  /*
  float squareSize = sqrt((w*h)/numNodes);
   int numSquaresH = int(w/squareSize+0.5); // round up
   int numSquaresV = int(h/squareSize+0.5); // round up
   
   float squareSizeH = w/numSquaresH; // no longer "square"
   float squareSizeV = h/numSquaresV; // no longer "square"
   */

  float minSpacing = 40;

  size(w+margin*2, h+margin*2, P2D);
  smooth(8);

  nodes = new Node[numNodes];

  connections = new Connection[numConnections];
  int k = 0; // connection count

  for (int i=0;  i<numNodes; i++) {

    //make new Node

    nodes[i] = new Node();

    boolean needNewLocation = true;
    while (needNewLocation) {
      nodes[i].x = random(0, w) + margin;
      // float x = i*(w/numNodes) + margin;
      nodes[i].y = random(0, h) + margin;

      boolean tooClose = false;
      for (int j=0; j<i; j++) {
        float d = nodes[i].getDistanceTo(nodes[j]);
        if (d<minSpacing) {
          tooClose=true;
        }
      }

      if (!tooClose) needNewLocation=false;
    }     // Done making nodes
  }
  //Make connections
  for (int i=0;  i<numNodes; i++) {
    for (int j=0; j<i; j++) {
      if (i !=j) {
        // make connection
        Connection c = new Connection(nodes[i], nodes[j]);

        Route route1 = nodes[i].connectTo(nodes[j]);
        Route route2 = nodes[j].connectTo(nodes[i]);
        route1.connection = c;
        c.routes[0] = route1;
        route2.connection = c;
        c.routes[1] = route2;
        connections[k++] = c;
        
        
      }
    }
  }

  println("Made " + k + " connections.");

  //Remove connections
  for (int i=0;  i<numConnections; i++) {
    for (int j=0; j<numConnections; j++) {
      Connection c1 = connections[i];
      Connection c2 = connections[j];
      if (c1.active && c2.active) {
        Point intersection = findIntersection(c1.node1.point(), c1.node2.point(), c2.node1.point(), c2.node2.point());

        if (intersection !=null ) {
          if (!pointsAreEqual(intersection, c1.node1.point())) {
            if (!pointsAreEqual(intersection, c1.node2.point())) {
              //remove the longer connection if they cross
              if (c1.distance>c2.distance) {
                c1.active = false;
              }
              else {
                c2.active = false;
              }
            }
          }
        }
      }
    }
    
    lastUpdateTime = millis()-1;
  }

  //Re-add connections
  for (int i=0;  i<numConnections; i++) {
    Connection c1 = connections[i];

    if (! c1.active) {

      int crossings = 0;

      for (int j=0; j<numConnections; j++) {
        if (i != j) {
          Connection c2 = connections[j];
          if (c2.active) {
            Point intersection = findIntersection(c1.node1.point(), c1.node2.point(), c2.node1.point(), c2.node2.point());

            if (intersection !=null ) {
              if (!pointsAreEqual(intersection, c1.node1.point())) {
                if (!pointsAreEqual(intersection, c1.node2.point())) {
                  //count the connection if they cross
                  crossings++;
                }
              }
            }
          }
        }
      }

      if (crossings==0) {
        c1.active = true;
      }
    }
  }


  //Sort distances
  //  for (Node node: nodes)
  // {
  //  node.sortDistances();
  // }
}




void draw() {
  background(0);
  
  float t = millis();
  float d = (t - lastUpdateTime)/1000f;

  for (Node node: nodes)
  {
    node.update(d);
    node.display();
  }

  for (Connection connection: connections)
  {
    connection.display();
  }

  lastUpdateTime = t;
}

// calculates intersection and checks for parallel lines.  
// also checks that the intersection point is actually on  
// the line segment p1-p2  
Point findIntersection(Point p1, Point p2, 
Point p3, Point p4) {  
  float xD1, yD1, xD2, yD2, xD3, yD3;  
  float dot, deg, len1, len2;  
  float segmentLen1, segmentLen2;  
  float ua, ub, div;  

  // calculate differences  
  xD1=p2.x-p1.x;  
  xD2=p4.x-p3.x;  
  yD1=p2.y-p1.y;  
  yD2=p4.y-p3.y;  
  xD3=p1.x-p3.x;  
  yD3=p1.y-p3.y;    

  // calculate the lengths of the two lines  
  len1=sqrt(xD1*xD1+yD1*yD1);  
  len2=sqrt(xD2*xD2+yD2*yD2);  

  // calculate angle between the two lines.  
  dot=(xD1*xD2+yD1*yD2); // dot product  
  deg=dot/(len1*len2);  

  // if abs(angle)==1 then the lines are parallell,  
  // so no intersection is possible  
  if (abs(deg)==1) return null;  

  // find intersection Pt between two lines  
  Point pt=new Point(0, 0);  
  div=yD2*xD1-xD2*yD1;  
  ua=(xD2*yD3-yD2*xD3)/div;  
  ub=(xD1*yD3-yD1*xD3)/div;  
  pt.x=p1.x+ua*xD1;  
  pt.y=p1.y+ua*yD1;  

  // calculate the combined length of the two segments  
  // between Pt-p1 and Pt-p2  
  xD1=pt.x-p1.x;  
  xD2=pt.x-p2.x;  
  yD1=pt.y-p1.y;  
  yD2=pt.y-p2.y;  
  segmentLen1=sqrt(xD1*xD1+yD1*yD1)+sqrt(xD2*xD2+yD2*yD2);  

  // calculate the combined length of the two segments  
  // between Pt-p3 and Pt-p4  
  xD1=pt.x-p3.x;  
  xD2=pt.x-p4.x;  
  yD1=pt.y-p3.y;  
  yD2=pt.y-p4.y;  
  segmentLen2=sqrt(xD1*xD1+yD1*yD1)+sqrt(xD2*xD2+yD2*yD2);  

  // if the lengths of both sets of segments are the same as  
  // the lenghts of the two lines the point is actually  
  // on the line segment.  

  // if the point isn’t on the line, return null  
  if (abs(len1-segmentLen1)>0.01 || abs(len2-segmentLen2)>0.01)  
    return null;  

  // return the valid intersection  
  return pt;
}  

class Point {  
  float x, y;  
  Point(float x, float y) {  
    this.x = x;  
    this.y = y;
  }  

  void set(float x, float y) {  
    this.x = x;  
    this.y = y;
  }
}

boolean pointsAreEqual(Point p1, Point p2) {
  return ((p1.x==p2.x) && (p1.y==p2.y));
}

