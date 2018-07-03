import gab.opencv.*;
import java.awt.Rectangle;
ArrayList AllNode; //all node list
ArrayList<Node[]> AllEdge;
ArrayList contours;
int r = 10; //radius of ellipse
boolean edit =true;
OpenCV opencv;
PImage img;
void setup() {
  img = loadImage("img_1.png");
  AllNode = new ArrayList();
  AllEdge = new ArrayList();
  size(100, 100);
  opencv = new OpenCV(this, img);
  opencv.gray();
  opencv.threshold(50);
  contours = opencv.findContours();
  createNodes();
  surface.setSize(img.width, img.height);
}

void draw() {
  image(img, 0, 0);
  createNodes();
  if (edit) {

    fill(255, 0, 0);
    ellipse(50, 50, 50, 50);
    for (int i = 0; i < AllNode.size(); i++) {
      Node node = (Node)AllNode.get(i);
      node.draw();
    }
    for (int i = 0; i < AllEdge.size(); i++) {
      line(AllEdge.get(i)[0].posX, AllEdge.get(i)[0].posY, AllEdge.get(i)[1].posX, AllEdge.get(i)[1].posY);
    }
  } else {
    for (int i = 0; i < AllNode.size(); i++) {
      Node node = (Node)AllNode.get(i);
      node.draw();
    }
    for (int i = 0; i < AllEdge.size(); i++) {
      line(AllEdge.get(i)[0].posX, AllEdge.get(i)[0].posY, AllEdge.get(i)[1].posX, AllEdge.get(i)[1].posY);
    }
  }
}


int number = 0;
void createNode(int x, int y) {
  AllNode.add(new Node(x, y, number));
  number++;
}

void createEdge(Node a, Node b) {
  a.connectNode.add(b);
  b.connectNode.add(a);
  float cost = dist(a.posX, a.posY, b.posX, b.posY);
  a.connectCost.add(cost);
  b.connectCost.add(cost);
  Node[] t = {a, b};
  AllEdge.add(t);
  line(a.posX, a.posY, b.posX, b.posY);
  fill(0);
  text(cost, (a.posX+b.posX)/2, (a.posY+b.posY)/2);
}

void search(Node start) {
  start.cost = 0;
  while (true) {
    Node processNode = null;
    for (int i = 0; i < AllNode.size(); i++) {
      Node node =  (Node)AllNode.get(i);
      if (node.done || node.cost < 0) {
        continue;
      }
      if (processNode == null) {
        processNode = node;
        continue;
      }
      if (node.cost < processNode.cost) {
        processNode = node;
      }
    }

    if (processNode == null) {
      break;
    }
    processNode.done = true;

    for (int i = 0; i < processNode.connectNode.size(); i++) {
      Node node = (Node)processNode.connectNode.get(i);
      float cost = processNode.cost + (float)processNode.connectCost.get(i);
      boolean needupdate = (node.cost < 0) || (node.cost > cost);
      if (needupdate) {
        node.cost = cost;
        node.previousNode = processNode;
      }
    }
  }
}

void run(Node goal) {
  Node currentNode = goal;
  String path = "Goal -> "; 
  while (true) {
    Node nextNode = currentNode.previousNode;
    if (nextNode == null) {
      break;
    }
    path += nextNode.number + "->";
    currentNode = nextNode;
  }
  print(path);
}

void createNodes() {
  for (int i = 0; i < contours.size(); i++) {
    Contour tmp = (Contour)contours.get(i);
    if (tmp.area() > 46) {
      Rectangle rect = tmp.getBoundingBox();
      stroke(255, 0, 0);
      noFill();
      rect(rect.x, rect.y, rect.width, rect.height);
      //AllNode.add(new Node(rect.x+rect.width/2, rect.y+rect.height/2, number));
      //number++;
    }
  }
}

Node tmp;
boolean k = false;
boolean s = false;
void mousePressed() {
  if (edit) {
    if (dist(mouseX, mouseY, 50, 50) < 25) {
      edit = false;
      return;
    }
    boolean check = false;
    if (AllNode.size() == 0) {
      createNode(mouseX, mouseY);
    } else {
      for (int i = 0; i < AllNode.size(); i++) {
        Node node = (Node)AllNode.get(i);
        if (dist(mouseX, mouseY, node.posX, node.posY)<r) {
          if (k) {
            createEdge(tmp, node);
            k = false;
          } else {
            tmp = node;
            k = true;
          }
          check = true;
        }
      }
      if (!check) {
        createNode(mouseX, mouseY);
      }
    }
  } else {
    for (int i = 0; i < AllNode.size(); i++) {
      Node node = (Node)AllNode.get(i);
      if (dist(mouseX, mouseY, node.posX, node.posY)<r) {
        if (!s) {
          search(node);
          s = true;
          return;
        } else {
          run(node);
        }
      }
    }
  }
}