int[][] matrix;
ArrayList<Point> points;
ArrayList<Integer> colorPoints;
int cellSize = 10;
int H;
int W;

void setup(){
  size(1000,800);
  H = height/cellSize;
  W = width/cellSize;
  matrix = new int[H][W];
  points = new ArrayList<Point>();
  colorPoints = new ArrayList<Integer>();
  //noStroke();
}

void voronov(){
  for(int i=0;i<matrix.length;++i){
    for(int j=0;j<matrix[i].length;++j){
      int indexMin = 0;
      int min = width*height;
      for(int k=0;k<points.size();++k){
        int diffx = (j-points.get(k).x);
        int diffy = (i-points.get(k).y);
        int d = diffx*diffx + diffy*diffy;
        if(d < min){
          min = d;
          indexMin = k;
        }
      }
      matrix[i][j] = indexMin;
    }
  }
}

void draw(){
  background(200);
  for(int i=0;i<matrix.length;++i){
    for(int j=0;j<matrix[i].length;++j){
      if(colorPoints.size()!=0)
        fill(colorPoints.get(matrix[i][j]));
      else fill(255);
      rect(j*cellSize,i*cellSize,cellSize,cellSize);
    }
  }
  for(int i=0;i<points.size();++i){
    fill(255);
    rect(points.get(i).x*cellSize,points.get(i).y*cellSize,cellSize,cellSize);
  }
  
  // adding new points
  if(mousePressed){
    int x = mouseX/cellSize;
    int y = mouseY/cellSize;
    boolean flag = true;
    for(int i=0;i<points.size();++i){
      if(points.get(i).x == x && points.get(i).y == y){
        flag = false;
        break;
      }
    }
    if(flag){
      Point temp = new Point(x,y);
      points.add(temp);
      color tempColor = color(random(0,255),random(0,255),random(0,255));
      colorPoints.add(tempColor);
      voronov();
    }
  }
}
