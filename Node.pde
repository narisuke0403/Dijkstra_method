class Node {
  int posX, posY, number;
  float cost;
  boolean done = false;
  Node previousNode = null;
  ArrayList connectNode;
  ArrayList connectCost;
  Node(int _x, int _y, int _number) {
    posX = _x;
    posY = _y;
    cost = -1.0;
    number = _number;
    connectNode = new ArrayList();
    connectCost = new ArrayList();
  }

  void draw() {
    int r = 20;
    fill(-1);
    ellipse(posX, posY, r, r);
    fill(0);
    text(number, posX, posY);
  }
}