// This Code Generates Random Data Points and Porvides
// a detail and overview visualization of them.
// The user can zoom and pan wherever on the screen and explore through millions or
// even billions of points!
// Written By: Navid Mirmohammadsadeghi

import org.gicentre.utils.move.*;

//HScrollbar hs1, hs2;

ZoomPan zoomer;


int maxI = 100000000;  // a big number
int preferred_num_groups = 100;
float mx,my,ratio,xpt,ypt,xzt,yzt,swt,zoom;


float[] data = new float[maxI];
float[] group_mean = new float[preferred_num_groups];
float[]  x   = new float[preferred_num_groups];
float[]  H   = new float[preferred_num_groups];
float[]  X   = new float[maxI];
float[]  Y   = new float[maxI];

float SUM        = 0.0;
int Selected   = 0;
int bin_share  = floor(maxI/preferred_num_groups);
float max_data;
float min_data;
float x0;
float y0;
float maxD = 0;
float minD = 0;
int Share = floor(maxI/preferred_num_groups);



void setup() {
  size(1500, 800);
  zoomer = new ZoomPan(this);
  frameRate(30);
  //zoom = 1.0;
  //hs1 = new HScrollbar(0, height/2, width, 16, 16);
  //hs2 = new HScrollbar(0, height/2, width, 16, 16);
  // simulate some timeseries data, y = f(t)
  data[0] = 0.0;
  noStroke();
  //for (int i=1; i<maxI; i++) {
  //  data[i] = data[i-1] + random(-1.0, 1.0);
  //}
  float lf = 0.0;  // low frequency
  float hf = 0.0;  // high frequency
  for (int i=1; i<maxI; i++) {
    if(i%1000 == 0)  lf += random(-1.0, 1.0);
    hf += random(-1.0, 1.0) - sign(hf)*0.01;
    data[i] = lf + hf;
  }
  maxD = max(data);
  minD = min(data);
  println(minD, maxD);
  //noLoop();
  colorMode(RGB, 255, 255, 255, 255);
  
  
  for (int j=0; j<maxI; j++){
     SUM += data[j];
     if ((j+1)%Share == 0){
      group_mean[j/Share] = SUM/Share;
      SUM = 0.0;
     }
     
  }
  for (int i=0;i<preferred_num_groups-1;i++){
      x[i] = map(i, 0, preferred_num_groups, 0, width);
      H[i] = map(group_mean[i],min(group_mean),max(group_mean), 0, -height/4);// 10, 500}
     }
  for (int j=0;j<maxI;j++){
     X[j] = map(j,0,maxI,0,width);
     Y[j] = map(data[j],minD,maxD,height,height/2);
   
  }
  
  println("Setup is Complete!");   
     
  

}


void draw() {
  // a very lame visualization
  
  
  
  background(255);
  //scale(zoom);
  //translate(xpt-xzt,ypt-yzt);
  

    
  for (int i=0;i<preferred_num_groups-1;i++){
     //float x = map(i, 0, preferred_num_groups, 0, width);
     //float H = map(group_mean[i],min(group_mean),max(group_mean), -height/4, 0);// 10, 500}
     
     stroke(0,0,255);
     noFill();
     rect(x[i],height/4, 10,H[i]);}
  
  
  
  pushMatrix();
  
  zoomer.transform();
  //float img1Pos = hs1.getPos()-width/2; //-width/2
  stroke(0,0,255);
  for (int j=0;j<maxI;j++){
    //float X = map(j,0,maxI,0,width);
    //float Y = map(data[j],minD,maxD,height/2,height);
    if (j%1000==0 && zoomer.getZoomScale()<20){
      point(X[j],Y[j]);}//-img1Pos*1.5
    else if(zoomer.getZoomScale()>20 && j%500==0){
      point(X[j],Y[j]);}
    else if(zoomer.getZoomScale()>40 && j%100==0){
      point(X[j],Y[j]);}
  }
   
   PVector mousePosition = zoomer.getMouseCoord();
   
   PVector realPos       = zoomer.getCoordToDisp(mousePosition);
   
   float real_x_pos      = realPos.x;
   float real_y_pos      = realPos.y;
   
   int mx =int(mousePosition.x);    // Equivalent to mouseX
   //int my =int(mousePosition.y);    // Equivalent to mouseY
   
   //float Mapped_x = map(mx,0,width,0,width);
   float map_on_overview = map(mx,0,width,0,maxI);
   //float Mapped_y = map(my,height/2,height,0,height);
   //println(ceil(map_on_overview));
   
   
   popMatrix();
   stroke(255,0,0);
   strokeWeight(2);
   //strokeWeight(1.5);
   line(mx,height/4,mx,0);
   line(mx+10,height/4,mx+10,0);
   strokeWeight(1);
   line(0,real_y_pos,real_x_pos,real_y_pos);
   line(real_x_pos,real_y_pos,real_x_pos,height);
   fill(50);
   textSize(20);
   text(data[floor(map_on_overview)],real_x_pos,real_y_pos);
    //hs1.update();
    //hs2.update();
    //hs1.display();
    //hs2.display();
    //stroke(0);
    //line(0, height/2, width, height/2);
    //println(zoomer.getZoomScale());
  
    
    
  }
  
  
  


//void mouseDragged(){
//  xpt-=(pmouseX-mouseX)/zoom;
//  ypt-=(pmouseY-mouseY)/zoom;
//}
//void mouseWheel(MouseEvent event) {
//  swt-=event.getCount();
//  if (swt==0) {
//    zoom=1.0;
//  } else if (swt>=1 && swt<=10) {
//    zoom=pow(2, swt);
//  } else if (swt<=-1 && swt>=-10) {
//    zoom=1/pow(2, abs(swt));
//  }
//  xzt=((zoom-1)*width/2)/zoom;
//  yzt=((zoom-1)*height/2)/zoom;
//  if(event.getCount()<=-1){
//  xpt-=(mouseX-width/2)/zoom;
//  ypt-=(mouseY-height/2)/zoom;
//  } else {
//  xpt+=(mouseX-width/2)/(pow(2, swt+1));
//  ypt+=(mouseY-height/2)/(pow(2, swt+1));
//  }
//}

int sign(float d) {
  return d>0.0 ? 1 : d<0.0 ? -1 : 0;
}

/// This Section is for the added scrollbar idea
//
//
///
//


//class HScrollbar {
//  int swidth, sheight;    // width and height of bar
//  float xpos, ypos;       // x and y position of bar
//  float spos, newspos;    // x position of slider
//  float sposMin, sposMax; // max and min values of slider
//  int loose;              // how loose/heavy
//  boolean over;           // is the mouse over the slider?
//  boolean locked;
//  float ratio;

//  HScrollbar (float xp, float yp, int sw, int sh, int l) {
//    swidth = sw;
//    sheight = sh;
//    int widthtoheight = sw - sh;
//    ratio = (float)sw / (float)widthtoheight;
//    xpos = xp;
//    ypos = yp-sheight/2;
//    spos = xpos + swidth/2 - sheight/2;
//    newspos = spos;
//    sposMin = xpos;
//    sposMax = xpos + swidth - sheight;
//    loose = l;
//  }

//  void update() {
//    if (overEvent()) {
//      over = true;
//    } else {
//      over = false;
//    }
//    if (mousePressed && over) {
//      locked = true;
//    }
//    if (!mousePressed) {
//      locked = false;
//    }
//    if (locked) {
//      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
//    }
//    if (abs(newspos - spos) > 1) {
//      spos = spos + (newspos-spos)/loose;
//    }
//  }

//  float constrain(float val, float minv, float maxv) {
//    return min(max(val, minv), maxv);
//  }

//  boolean overEvent() {
//    if (mouseX > xpos && mouseX < xpos+swidth &&
//       mouseY > ypos && mouseY < ypos+sheight) {
//      return true;
//    } else {
//      return false;
//    }
//  }

//  void display() {
//    noStroke();
//    fill(204);
//    rect(xpos, ypos, swidth, sheight);
//    if (over || locked) {
//      fill(0, 0, 0);
//    } else {
//      fill(102, 102, 102);
//    }
//    rect(spos, ypos, sheight, sheight);
//  }

//  float getPos() {
//    // Convert spos to be values between
//    // 0 and the total width of the scrollbar
//    return spos * ratio;
//  }
//}
