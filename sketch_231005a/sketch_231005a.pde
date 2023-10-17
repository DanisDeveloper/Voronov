int[][] matrix;
ArrayList<Point> points;
int cellSize = 1;
int H;
int W;
int D = 90;

void setup(){
  size(1000,800);
  H = height/cellSize;
  W = width/cellSize;
  matrix = new int[H][W];
  points = new ArrayList<Point>();
  noStroke();
  
  int x = 0;
  int y = 0;
  color tempColor = color(random(0,255),random(0,255),random(0,255));
  tempColor = color(map(x,0,W,0,255),map(y,0,H,255,0),map(y,0,H,0,255));
  Point temp = new Point(x,y,tempColor);
  points.add(temp);
  while(x < W){
    while(y < H){
      y += D;
      //tempColor = color(random(0,255),random(0,255),random(0,255));
      tempColor = color(map(x,0,W,0,255),map(y,0,H,255,0),map(y,0,H,0,255));

      Point t = new Point(x,y,tempColor);
      points.add(t);
    }
    x+= (int)(sqrt(3)/2*D);
    y -= D/2;
    while(y > 0){
      y -= D;
      //tempColor = color(random(0,255),random(0,255),random(0,255));
      tempColor = color(map(x,0,W,0,255),map(y,0,H,255,0),map(y,0,H,0,255));
      Point t = new Point(x,y,tempColor);
      points.add(t);
    }
  }
  
  //for(int i=0;i<6;++i){
  //  int newX = (int)(-D*sin(TWO_PI/6.0*i));
  //  int newY = (int)(D * cos(TWO_PI/6.0*i));
  //  tempColor = color(random(0,255),random(0,255),random(0,255));
  //  Point t = new Point(newX+x,newY+y,tempColor);
  //  points.add(t);
  //}
  
  voronov();
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
      if(points.size()!=0)
        fill(points.get(matrix[i][j]).col);
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
      color tempColor = color(random(0,255),random(0,255),random(0,255));
      Point temp = new Point(x,y,tempColor);
      points.add(temp);
      voronov();
    }
  }
}
