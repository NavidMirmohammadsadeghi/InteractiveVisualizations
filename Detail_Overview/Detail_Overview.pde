// Detail and Overview Visualization for Big One Dimensional Data
// This Script Doesn't Provide any Interaction (Look at Zoom_and_Pan for Interaction)
// Written by : Navid Mirmohammadsadeghi



int maxI = 1000000;  // a big number
int preferred_num_groups = 100;



float[] data = new float[maxI];
float[] group_mean = new float[preferred_num_groups];
float[] min_data = new float[preferred_num_groups];
float[] max_data = new float[preferred_num_groups];
float[] low_range = new float[preferred_num_groups];
float[] high_range = new float[preferred_num_groups];
float[] Meidan = new float[preferred_num_groups];
float SUM        = 0.0;
int Selected   = 0;
int bin_share  = floor(maxI/preferred_num_groups);
float zoom = 0.0;

void setup() {
  size(1000, 500);
  // simulate some timeseries data, y = f(t)
  int Share = floor(maxI/preferred_num_groups);
  FloatList invent;
  invent = new FloatList();
  data[0] = 0.0;
  group_mean[0] = 0.0;
  
  for (int i=1; i<maxI; i++)
    data[i] = data[i-1] + random(-1.0, 1.0);
  for (int j=0; j<maxI; j++){
     SUM += data[j];
     invent.append(data[j]);
     if ((j+1)%Share == 0){
      group_mean[j/Share] = SUM/Share;
      min_data[j/Share] = invent.min();
      max_data[j/Share] = invent.max();
      //sorting list
      invent.sort();
      //// 25th percentile 
      int A = round(0.25*invent.size());
      low_range[j/Share] = invent.get(A);
      //// 75th percentile 
      int B = round(0.75*invent.size());
      high_range[j/Share] = invent.get(B);
      //println(min_data[j/100000]+" "+group_mean[j/100000]+" "+max_data[j/100000]+" "+(j/100000)+" "+low_range[j/100000]+" "+ high_range[j/100000]);
      SUM = 0.0;
      invent.clear();
     }
     
  }
  //noLoop(); // this is important for having static or interactive graph
  //println(data[500000]);
  //println(min_data[20]);
  //println(invent[:2,]);
}


void draw() {
  // a very lame visualization
  background(255,255,255);
  //smooth();
  //scale(zoom);
  //fill(70,130,180);
  //noFill();
  //line(0,-500,2000,-500);
  //line(0,600,2000,600);
  beginShape();
  for (int i=0; i<preferred_num_groups-1; i++) {
    float x = map(i, 0, preferred_num_groups, 0, width);
    float h = map(data[i], -10.0, 10.0, -height/2, height/2);
    float h3 = map(group_mean[i],min(data),max(data), height/2, height); //500,0
    float h1 = map(low_range[i],min(data),max(data),height/2,height);     // 500,1000
    float h2 = map(high_range[i],min(data),max(data),height/2,height);
    float H = map(group_mean[i],min(group_mean),max(group_mean), -height/2, 0);  // 10, 500
    float m = map(min_data[i],min(data),max(data), height/2, height); // 500,0
    float M = map(max_data[i],min(data),max(data), height/2, height); // 500,0
    //if (dist(x,0.5*(h1+h2),mouseX,mouseY)<5){
    //  //fill(0);
    //  //text(("this number is "+i),x,0.5*(h1+h2)+5);
    //  int J = i*floor(maxI/(preferred_num_groups*1000));
    //  for(int k = (J-floor(maxI/preferred_num_groups));k<J;k++){
    //    float x1 = map(k,0,J,x-20,x+20);
    //    float y1 = map(data[k],min(data),max(data),height/4,3*height/4);
    //    rect(x1,height/4,10,y1+1);
    //}
    //}
    //if (mousePressed && dist(x,h3,mouseX,mouseY)<3){
    //  Selected +=1;
    //  stroke(255,0,0);
    //  strokeWeight(3);
    //  line(x+5,0,x+5,height/2);
      
    //  //println(Selected);
      
      
    //}
      
 
    stroke(0,0,255);
    rect(x,height/2, 10,H);
    //strokeWeight(2);
    //stroke(0,0,255);
    //line(x,h3,x+1,h3+1); // minimums
    //stroke(255,0,0);
    //line(x,M,x+1,M+1); // maximums
    //stroke(0,204,0);
    //line(x,h,x+1,h+1); // means
    stroke(0,0,255);
    strokeWeight(2);
    line(x,m,x,M); // line between min and max
    stroke(255,0,0);
    strokeWeight(2);
    rect(x-5,0.5*(h1+h2),10,h2-h1);
    stroke(0,204,0);
    strokeWeight(5);
    point(x,h3);
    //stroke(255,0,0);
    //strokeWeight(2);
    //vertex(x,h3);
    //point(x,h1);
    //point(x,h2);
    //stroke(0,0,225);
    //strokeWeight(4);
    //point(x,h3);
    
    
    
    
    
  }
  //endShape();
  //////For MAX
  //////noFill();
  //beginShape();
  //for (int i=0; i<999; i++) {
  //  float x = map(i, 0, 1000, 0, width);
  //  float M = map(max_data[i],min(data),max(data), height/2, height); // 500,0
  //  stroke(0,0,255);
  //  vertex(x,1.01*M);
  //}
  //endShape();
  ////////// for averages
  ////////noFill();
  //beginShape();
  //for (int i=0; i<999; i++) {
  //  float x = map(i, 0, 1000, 0, width);
  //  float h = map(group_mean[i],min(data),max(data), height/2, height); //500,0
  //  stroke(0,204,0);
    
  //  vertex(x,h);
  //}
  //endShape();
  
}
//
//
//int j;
//void draw(){
//  // trying to group every 100000 point into one
//  
//  for (int j=1; j<maxI; j++)
//     SUM += data[j]; 
//     if (j%1000 == 0){
//      group_mean[j/1000] = SUM/1000;
//      SUM = 0.0;
//     }
//     println(SUM);
//     println(group_mean[500]);
//     println("the value of J is " +j);
//}

//void keyPressed(){
//  if (keyCode == UP) zoom +=0.05;
//  else if (keyCode == DOWN) zoom -=0.05;
//}
    
