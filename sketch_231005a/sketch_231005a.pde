int[][] matrix;
ArrayList<Point> points;
int cellSize = 1;
int H;
int W;
int D = 20;
String filename = "woman2.jpg";
int range = 15;
boolean invertedRange = false;
PImage img;
color mainDots = color(0);

void setup() {
  size(859, 1000);
  H = height/cellSize;
  W = width/cellSize;
  matrix = new int[H][W];
  points = new ArrayList<Point>();
  noStroke();


  imageDots();
  //beginningDots();
}


void draw() {
  background(200);
  for (int i=0; i<matrix.length; ++i) {
    for (int j=0; j<matrix[i].length; ++j) {
      if (points.size()!=0)
        fill(points.get(matrix[i][j]).col);
      else fill(255);
      rect(j*cellSize, i*cellSize, cellSize, cellSize);
    }
  }
  for (int i=0; i<points.size(); ++i) {
    fill(mainDots);
    //fill(points.get(i).col);
    rect(points.get(i).x*cellSize, points.get(i).y*cellSize, cellSize, cellSize);
  }

  // adding new points
  if (mousePressed) {
    int x = mouseX/cellSize;
    int y = mouseY/cellSize;
    boolean flag = true;
    for (int i=0; i<points.size(); ++i) {
      if (points.get(i).x == x && points.get(i).y == y) {
        flag = false;
        break;
      }
    }
    if (flag) {
      color tempColor = color(random(0, 255), random(0, 255), random(0, 255));
      Point temp = new Point(x, y, tempColor);
      points.add(temp);
      voronov();
    }
  }
  if (keyPressed) {
    //if(key == 's'){
    save(".//data//result"+ range + "_" + filename);
    println("Saved");
    //}
  }
}

void imageDots() {
  // работа с изображением
  img = loadImage(filename);
  img.resize(W, H);
  img.loadPixels();
  int number = W*H/range;
  int r = 3;

  for (int i=0; i<number; ++i) {
    int x = (int)(random(0, W));
    int y = (int)(random(0, H));
    float average = 0;
    int count = 0;
    for (int j=-r; j<r; ++j) {
      for (int k=-r; k<r; ++k) {
        if (x+j >= 0 && x+j < W) {
          if (y+k >=0 && y+k < H) {
            int loc = x+j+W*(y+k);
            average += brightness(img.pixels[loc]);
            ++count;
          }
        }
      }
    }
    average /= count;
    float dist = 0;
    if (invertedRange)
      dist = map(average, 0, 255, range, 0);
    else
    dist = map(average, 0, 255, 0, range);

    boolean addFlag = true;
    for (int j=0; j<points.size(); ++j) {
      if (dist(points.get(j).x, points.get(j).y, x, y)< dist) {
        addFlag = false;
        break;
      }
    }
    if (addFlag) {
      color tempColor = color(random(0, 255), random(0, 255), random(0, 255));
      tempColor = color(average); //
      tempColor = color(img.pixels[x+y*W]);
      points.add(new Point(x, y, tempColor));
    }
  }
  voronov();
}

void beginningDots() {
  // Начальное расставление точек
  int x = 0;
  int y = 0;
  color tempColor = color(random(0, 255), random(0, 255), random(0, 255));
  tempColor = color(map(x, 0, W, 0, 255), map(y, 0, H, 255, 0), map(y, 0, H, 0, 255));
  Point temp = new Point(x, y, tempColor);
  points.add(temp);
  while (x < W) {
    while (y < H) {
      y += D;
      //tempColor = color(random(0,255),random(0,255),random(0,255));
      tempColor = color(map(x, 0, W, 0, 255), map(y, 0, H, 255, 0), map(y, 0, H, 0, 255));

      Point t = new Point(x, y, tempColor);
      points.add(t);
    }
    x+= (int)(sqrt(3)/2*D);
    y -= D/2;
    while (y > 0) {
      y -= D;
      //tempColor = color(random(0,255),random(0,255),random(0,255));
      tempColor = color(map(x, 0, W, 0, 255), map(y, 0, H, 255, 0), map(y, 0, H, 0, 255));
      Point t = new Point(x, y, tempColor);
      points.add(t);
    }
  }
  voronov();
}
void voronov() {
  for (int i=0; i<matrix.length; ++i) {
    for (int j=0; j<matrix[i].length; ++j) {
      int indexMin = 0;
      int min = width*height;
      for (int k=0; k<points.size(); ++k) {
        int diffx = (j-points.get(k).x);
        int diffy = (i-points.get(k).y);
        int d = diffx*diffx + diffy*diffy;
        if (d < min) {
          min = d;
          indexMin = k;
        }
      }
      matrix[i][j] = indexMin;
    }
  }
}
