//==============================================================  run tests

void settings() {
size(1000, 1000, P2D);
}
void setup () {
}
void draw() {
background(255, 255, 255);
My3DPoint eye = new My3DPoint(0, 0, -5000);
My3DPoint origin = new My3DPoint(0, 0, 0);
My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);
//rotated around x
float[][] transform1 = rotateXMatrix(PI/8);
input3DBox = transformBox(input3DBox, transform1);
projectBox(eye, input3DBox).render();
//rotated and translated
float[][] transform2 = translationMatrix(200, 200, 0);
input3DBox = transformBox(input3DBox, transform2);
projectBox(eye, input3DBox).render();
//rotated, translated, and scaled
float[][] transform3 = scaleMatrix(2, 2, 2);
input3DBox = transformBox(input3DBox, transform3);
projectBox(eye, input3DBox).render();
}






//=======================================================================
//============================  PROJECTIONS =============================
//=======================================================================


//==============================================================  Points

class My2DPoint {
  float x;
  float y;
  My2DPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class My3DPoint {
  float x;
  float y;
  float z;
  My3DPoint(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  float norm = eye.z-p.z; 
  float newX = (p.x-eye.x)*eye.z/norm;
  float newY = (p.y-eye.y)*eye.z/norm;
  return new My2DPoint(newX, newY);
}



//==============================================================  Boxes

class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
  this.s = s;
  }
  void render(){
    Line(4,5);
    Line(4,7);Line(5,6);Line(4,0);Line(5,1);
    Line(6,7);Line(0,1);
    Line(7,3);Line(6,2);Line(0,3);Line(1,2);
    Line(2,3);
  }
  private void Line(int a, int b){
    line(s[a].x, s[a].y, s[b].x, s[b].y); 
  }
}

class My3DBox {
  My3DPoint[] p;
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ){
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    this.p = new My3DPoint[]{  new My3DPoint(x,y+dimY,z+dimZ),
                               new My3DPoint(x,y,z+dimZ),
                               new My3DPoint(x+dimX,y,z+dimZ),
                               new My3DPoint(x+dimX,y+dimY,z+dimZ),
                               new My3DPoint(x,y+dimY,z),
                               origin,
                               new My3DPoint(x+dimX,y,z),
                               new My3DPoint(x+dimX,y+dimY,z)
                               };
  }
  My3DBox(My3DPoint[] p) {
    this.p = p;
  }
}

My2DBox projectBox (My3DPoint eye, My3DBox box) {
  My2DPoint[] p2ds = new My2DPoint[box.p.length];
  int i=0;
  for(My3DPoint p3d  : box.p){
    p2ds[i]=projectPoint(eye, p3d);
    i++;
  }
  return new My2DBox(p2ds);
}







//=======================================================================
//============================  TRANSOFRMATIONS =========================
//=======================================================================


//=============================================================== Helper funtions 

My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}
float[] homogeneous3DPoint (My3DPoint p) {
  float[] result = {p.x, p.y, p.z , 1};
  return result;
}
float vectProduct(float[] a, float[] b){
  int c = 0;
  for(int i=0; i<a.length; i++){
    c+= a[i]*b[i];
  }return c;
}


//=============================================================== Transformation Matrices

float[][] rotateXMatrix(float angle) {
  return(new float[][] {{1, 0 , 0 , 0},
                        {0, cos(angle), sin(angle) , 0},
                        {0, -sin(angle) , cos(angle) , 0},
                        {0, 0 , 0 , 1}});
}
float[][] rotateYMatrix(float angle) {
  return(new float[][] {{cos(angle), 0 ,  sin(angle) , 0},
                        {0, 1, 0, 0},
                        {-sin(angle),0 , cos(angle) , 0},
                        {0, 0 , 0 , 1}});
}
float[][] rotateZMatrix(float angle) {
  return(new float[][] {{cos(angle), sin(angle), 0, 0},
                        {-sin(angle) , cos(angle), 0, 0},
                        {0, 0, 1, 0},
                        {0, 0, 0, 1}});
}
float[][] scaleMatrix(float x, float y, float z) {
  return(new float[][] {{x,0,0,0},
                        {0,y,0,0},
                        {0,0,z,0},
                        {0,0,0,1}});
}
float[][] translationMatrix(float x, float y, float z) {
  return(new float[][] {{1,0,0,x},
                        {0,1,0,y},
                        {0,0,1,z},
                        {0,0,0,1}});
}


//=============================================================== Composition

float[] matrixProduct(float[][] a, float[] b) {
  float res[] = new float[b.length];
  for(int i=0; i<b.length; i++){
    res[i] = vectProduct(a[i],b);
  }return res;
}
My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  My3DPoint[] vertices = new My3DPoint[box.p.length];
  for(int i=0; i<box.p.length; i++){
    vertices[i] = euclidian3DPoint(matrixProduct(transformMatrix, homogeneous3DPoint(box.p[i])));
  }
  return new My3DBox(vertices);
}