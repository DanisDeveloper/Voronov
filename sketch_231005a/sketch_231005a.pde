import processing.video.*;
Capture cam;
boolean inverted = true;

int[][] matrix;
ArrayList<Point> points;
int cellSize = 4;
int H;
int W;
PGraphics pg;

void setup(){
  size(640,480);
  H = height/cellSize;
  W = width/cellSize;
  matrix = new int[H][W];
  points = new ArrayList<Point>();
  noStroke();
  
  pg = createGraphics(width, height);
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();
  }
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
  //background(200);
  if (cam.available()) {
    cam.read();
    if (inverted) {
      cam.loadPixels();
      for (int i=0; i<height; ++i) {
        for (int j=0; j<width; ++j) {
          int loc = i*width + j;
          cam.pixels[loc] = 255 - cam.pixels[loc];
        }
      }
      cam.updatePixels();
    }
  }
  pg.beginDraw();
  
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
  pg.mask(cam);
  pg.endDraw();
  image(pg, 0, 0);
}
