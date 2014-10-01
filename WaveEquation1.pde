//プログラミング演習1
//発表会提出プログラム
//3組 18番 尾高陽太(学生番号 2620130650)
//"波"の模倣
//提出日 2013/07/17

float Angle = 0.0; //initial value of "cameraAngle"
int Height = 200; //initial value of "cameraHeight"
int N = 50; //size of field
int boxWidth = 50; //width of box

void setup() {
  size(1000, 750, P3D); //set window size 1000 x 800 and introduce P3D system
  frameRate(30);
  noStroke();

  //*************** the following are to use Fanction ***************//
  waveSetup(N);
}
void draw() {
  background(0); //set background color

  //*************** the following are to use Fanction ***************//
  cameraMove(N, boxWidth, Angle, Height);
  waveMove(N);
  waveDraw(N, boxWidth);
}
///// Keyboard Event /////
int pose = 0; //this variable "pose" is flag
void keyPressed() {
  //*************** the following are to use Branch Conditon ***************//
  switch(keyCode) {
    /////adjustment of Angle and Height of coordinate of camera /////
  case RIGHT:
    Angle += 0.05;
    break;
  case LEFT:
    Angle -= 0.05;
    break;
  case UP:
    Height += 30;
    break;
  case DOWN:
    Height -= 30;
    break;
    ///// stop and restart drawing /////
  case ' ':
    if (pose == 0) {
      noLoop();
      pose = 1;
    } else if (pose == 1) {
      loop();
      pose = 0;
    }
    break;
  }
}
///// Mouse Event /////
///// stimulate the surface of the water /////
///// mapping window coordinate on water surface coordinate /////
void mousePressed() {
  int k = (int)(N*mouseX/width);
  int l = (int)(N*mouseY/height);
  du_dt[l][N-1-k] = 20.0;
}
//*************** the following are to define the Fanction ***************//
float vel = 0.03; //velociaty of wave
float d = 1.0; //interval of lattice point
float g = 0.0005; //value of gravity

//*************** the following are to define the Array ***************//
float[][] u = new float[N][N]; //cuurrent value of displacement
float[][] du_dt = new float[N][N]; //first-order differentiation of u (variation of displacement)
float[][] d2u_dt2 = new float[N][N]; //second-order differentiation of u

///// the fanction to decide the parameter of "camera()" /////
void cameraMove(int NUM, int boxW, float cameraAngle, int cameraHeight) {
  camera((1.0/2.0)*NUM*boxW*cos(cameraAngle)+(NUM*boxW/2), 
  -(1.0/2.0)*NUM*boxW*sin(cameraAngle)+(NUM*boxW/2), cameraHeight, 
  (NUM*boxW/2), (NUM*boxW/2), 0, 
  1*cos(cameraAngle), -1*sin(cameraAngle), 0);
}
///// the fanctions for setup of wave /////
void waveSetup(int NUM) {
  //*************** the following are to Repeat ***************//
  for (int j = 0; j < NUM; j++) {
    for (int i = 0; i < NUM; i++) {
      //initial condition
      u[i][j] = 0.0;
      du_dt[i][j] = 0.0;
      d2u_dt2[i][j] = 0.0;
    }
  }
}
///// the fanctions for drawing of wave /////
void waveDraw(int NUM, int boxW) {
  //*************** the following are to Repeat ***************//
  for (int k = 0; k < 3; k++) {
    for (int j = 0; j < NUM; j++) {
      for (int i = 0; i < NUM; i++) {
        pushMatrix(); //save the current coordinate system
        translate(boxW/2 + i*boxW, 
        boxW/2 + j*boxW, 
        200*atan(u[i][j]/100)/PI - boxW*k);
        ///// color change "bear" /////
        //*************** the following are to use Branch Conditon ***************//
        /*if (u[i][j] >= 0) {
         fill(255, 255, 500*atan(u[i][j]/20)/PI, 128);
         //fill((10*u[i][j]), (10*u[i][j]), 255);
         } else if (u[i][j] < 0) {
         fill(255, 255, 200*atan(u[i][j]/500)/PI, 128);
         }*/
        ///// color change "ocean" /////
        //**************** the following are to use Branch Conditon ***************//
        if (u[i][j] >= 0) {
          fill(800*atan(u[i][j]/100)/PI, 800*atan(u[i][j]/100)/PI, 255, 128);
        } else if (u[i][j] < 0) {
          fill(200*atan(u[i][j]/500)/PI, 200*atan(u[i][j]/500)/PI, 255, 128);
        }

        box(boxW); //a section of water surface
        popMatrix(); //restore the prior coordinate system
      }
    }
  }
}
///// the fanctions for moveing of wave /////
void waveMove(int NUM) {
  //boundary condition
  //*************** the following are to repeat ***************//
  for (int j = 1; j < NUM-1; j++) {
    for (int i = 1; i < NUM-1; i++) {
      u[0][j] = 1.0;
      u[i][0] = 4.5;
      u[i][NUM-1] = -4.5;
      u[NUM-1][j] = 10.0;
      du_dt[0][j] = 0.0;
      du_dt[i][0] = 0.0;
      du_dt[i][NUM-1] = 0.0;
      du_dt[NUM-1][j] = 0.0;
    }
  }
  ///// Behavior Calculation /////
  //************** the following are to repeat ***************//
  for (int j = 1; j < NUM-1; j++) {
    for (int i = 1; i < NUM-1; i++) {
      //wave equation (to compute acceleration)
      d2u_dt2[i][j] = -g*200*atan(u[i][j]/500)/PI
        + (vel*vel)/(d*d)*(u[i+1][j]+u[i-1][j]+u[i][j+1]+u[i][j-1]-4*u[i][j]);
      //du_dt is integrated value of d2u_dt2 (du_dt is velocity)
      du_dt[i][j] += d2u_dt2[i][j];
      //integral computation for displacement
      u[i][j] += du_dt[i][j];
    }
  }
}

