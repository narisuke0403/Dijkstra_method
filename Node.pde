class Node {
  int posX, posY, cost;
  Node[] connectNode;
  int[] connectCost;
  Node(int _x, int _y) {
    posX = _x;
    posY = _y;
    cost = -1;
    Node[] connectNode;
  }
}
