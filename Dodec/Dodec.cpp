#include "Dodec.h"
#include <fstream>

//  We shall be using OpenGL's Quadric function
//  GLU_FILL means that it won't be wire frame
//  GLU_LINE means it will be wire frame
//  int g_RenderMode=GLU_FILL; // this is for quadrics only
//

int g_RenderMode=GLU_LINE;

int nv,npoly;

const double pi=acos(-1.0);
//pi=acos(-1.0);

// Golden Sections
const double PHI=(sqrt(5.0)+1.0)/2.0;
const double phi=(sqrt(5.0)-1.0)/2.0;
const double cos18=sqrt(2.5*(1.0+1.0/sqrt(5.0)))/2.0;
const double sin18=phi/2.0;
const double cos36=PHI/2.0;
const double sin36=sqrt(2.5*(1.0-1.0/sqrt(5.0)))/2.0;
const double cos54=sin36, sin54=cos36, cos72=sin18, sin72=cos18;

D3Dvec* NodeV;
D3Dvec* NodeP1;
D3Dvec* NodeP2;
D3Dvec* NodeDec;

int** pentag;  
D3Dvec* Dodec;


double xmin,xmax,ymin,ymax,zmin,zmax;
bool   xallpos,xallneg;
bool   yallpos,yallneg;
bool   zallpos,zallneg;

int iplot;

double xrange,yrange,zrange;
double xrangenorm, yrangenorm,zrangenorm;
int   normx,normy,normz;


char *cstrval=(char*)malloc(50);;
//cstrval=(char*)malloc(50);

const int MAX_TEXTURES=300;
unsigned int gl_Texture[MAX_TEXTURES];

/*  FONTS IN
HAVE TRUETYPE FONTS IN
1.  /usr/share/tuxpaint/fonts
2,  /usr/lib/SunJava2-1.4.2/jre/lib/fonts
3.  /usr/X11R6/lib/X11/fonts/truetype
4   plus a few others from games and povray
*/

int width=1024;
int height=768;
const double speed=50;
const double acceleration=1;
const double convert=180.0/pi;
const double twopi=2.0*pi;
// instantaneous rotation angles
double angx=0.0, angy=0.0;
// cumulative versions
double angxcum=0.0, angycum=0.0;

bool upPressed=false;
bool downPressed=false;
bool leftPressed=false;
bool ctrl_leftPressed=false;
bool shift_leftPressed=false;
bool rightPressed=false;
bool ctrl_rightPressed=false;
bool shift_rightPressed=false;
bool p_Pressed=false;
bool MouseOn=true;
bool togglez=false;



void Init(){
   InitialiseGL(SCREEN_WIDTH, SCREEN_HEIGHT);
  // CreateTexture(gl_Texture,"Earth2.bmp",0);

   //lighting  r,b,g,alpha (alpha is for blending)
   glClearColor(1.,1.,1.,1.); //background colour white
   glClearColor(0.,0.,0.,1.); //background colour white

     std::cout << " Max Number of Lights=" << GL_MAX_LIGHTS << endl;

     //To specifiy a light we need to name them as follows
     // from GL_LIGHT0, GL_LIGHT1,GL_LIGHT2,... GL_LIGHTN.

     /* Second Argument can be
       GL_AMBIENT, GL_DIFFUSE,GL_SPECULAR,GL_POSITION,
    GL_SPOT_CUTTOFF, GL_SPOT_DIRECTION, GL_SPOT_EXPONENT,
    GL_CONSTANT_ATTENIATION, GL_LINEAR_ATTENUATION,
    GL_QUADRATIC_ATTENUATION   */
    //
    //colour of the ambient and diffuse light
     float ambient[4]={0.0, 0.0, 0.0, 0.2}; // light from all over
     float diffuse[4]={1.0, 0.0, 0.0, 1.0}; // light component reflecting diffusely
     float specular[4]={1.0, 1.0, 1.0, 1.0}; //light reflecting specularly

     glLightfv(GL_LIGHT0,GL_AMBIENT, ambient);
     glLightfv(GL_LIGHT0,GL_DIFFUSE, diffuse);
     glLightfv(GL_LIGHT0,GL_SPECULAR, specular);

     float gLightPosition[4]={-1000.,-1000.,-1000.,0.0};
  //   float gLightPosition[4]={10000.,0.,0., 1.0};
     //The last number  tells OpenGL that it's
     // a light position if it is non zero. 
     // The first three numbers are the coordinates. If this last entry is zero
     // OpenGL will treat it as a direction, and will work out
     // direction cosines from the first three numbers. 

     glLightfv(GL_LIGHT0,GL_POSITION,gLightPosition);

     glEnable( GL_LIGHT0 );

     glEnable( GL_LIGHTING);

}
void EventLoop(CCam & Camera1)
{
 bool quitit=false;
 SDL_Event event;
 SDL_MouseMotionEvent event2;
 SDL_keysym  *whatkey;
 bool mousedown=false;



//  Go to while(!quitit) to see what happens once data set up

// Go to Render Scene for graphics bit

    bool exitnow=false;

    extern double X,Y,Z;
    X=-1e32;Y=-1e-32;Z=-1e32;
    xmax=X; ymax=Y, zmax=Z;
    xmin=-X; ymin=-Y, zmin=-Z;

    double xunit,yunit,zunit;
    xunit=1.0;yunit=1.0;zunit=1.0;


 //   if_stream opens for input
 //   of_stream opens for output
 //   f_stream opens for both
 //

    NodeV =new D3Dvec[20]; //20 nodes for dodecahedron
    NodeP1=new D3Dvec[5];  // Nodes for a pentagon (unit radius)
    NodeP2=new D3Dvec[5];  // Nodes for another pentagon (unit radius)
                           // P1 rotated by 180 degrees
    NodeDec=new D3Dvec[10];  // Nodes for a decagon will be radius PHI 


    //Pentagon with curcumcircle radius 1.0
    //
    //  convert pentagon to have unit length edges instead of unit radius
    //
    double prad;
    prad=sqrt(  0.5*(1.0+1.0/sqrt(5.0))  );
 //   prad=sqrt( PHI / root 5);

    double PX,PY,PZ;
    PX=sqrt(2.0+PHI)/2.0*prad;
    PY=phi/2.0*prad;
    PZ=0.0;

    NodeP1->SetVec(PX,PY,PZ);
    NodeP2->SetVec(-PX,-PY,PZ);
    (NodeP1+2)->SetVec(-PX,PY,PZ);
    (NodeP2+2)->SetVec(PX,-PY,PZ);

    PX=0.0;
    PY=1.0*prad;
    PZ=0.0;
    (NodeP1+1)->SetVec(PX,PY,PZ);
    (NodeP2+1)->SetVec(PX,-PY,PZ);

    PX=-sqrt(2.0-phi)/2.0*prad;
    PY=-PHI/2.0*prad;
    PZ=0.0;
    (NodeP1+3)->SetVec(PX,PY,PZ);
    (NodeP2+3)->SetVec(-PX,-PY,PZ);
    (NodeP1+4)->SetVec(-PX,PY,PZ);
    (NodeP2+4)->SetVec(PX,-PY,PZ);

    //decagon radius is PHI times pentagon radius

    (NodeDec)->SetVec(
	    PHI*(NodeP1)->GetX(),PHI*(NodeP1)->GetY(),(NodeP1)->GetZ()  );
    (NodeDec+2)->SetVec(
	    PHI*(NodeP1+1)->GetX(),PHI*(NodeP1+1)->GetY(),(NodeP1+1)->GetZ()  );
    (NodeDec+4)->SetVec(
	    PHI*(NodeP1+2)->GetX(),PHI*(NodeP1+2)->GetY(),(NodeP1+2)->GetZ()  );
    (NodeDec+6)->SetVec(
	    PHI*(NodeP1+3)->GetX(),PHI*(NodeP1+3)->GetY(),(NodeP1+3)->GetZ()  );
    (NodeDec+8)->SetVec(
	    PHI*(NodeP1+4)->GetX(),PHI*(NodeP1+4)->GetY(),(NodeP1+4)->GetZ()  );


    (NodeDec+1)->SetVec(
	    PHI*(NodeP2+3)->GetX(),PHI*(NodeP2+3)->GetY(),(NodeP2+3)->GetZ()  );
    (NodeDec+3)->SetVec(
	    PHI*(NodeP2+4)->GetX(),PHI*(NodeP2+4)->GetY(),(NodeP2+4)->GetZ()  );
    (NodeDec+5)->SetVec(
	    PHI*(NodeP2)->GetX(),PHI*(NodeP2)->GetY(),(NodeP2)->GetZ()  );
    (NodeDec+7)->SetVec(
	    PHI*(NodeP2+1)->GetX(),PHI*(NodeP2+1)->GetY(),(NodeP2+1)->GetZ()  );
    (NodeDec+9)->SetVec(
	    PHI*(NodeP2+2)->GetX(),PHI*(NodeP2+2)->GetY(),(NodeP2+2)->GetZ()  );


    cout << (NodeDec)->GetX() << "  " << (NodeDec)->GetY() << endl;
    cout << (NodeDec+1)->GetX() << "  " << (NodeDec+1)->GetY() << endl;
    cout << (NodeDec+2)->GetX() << "  " << (NodeDec+2)->GetY() << endl;
    cout << (NodeDec+3)->GetX() << "  " << (NodeDec+3)->GetY() << endl;
    cout << (NodeDec+4)->GetX() << "  " << (NodeDec+4)->GetY() << endl;
    cout << (NodeDec+5)->GetX() << "  " << (NodeDec+5)->GetY() << endl;
    cout << (NodeDec+6)->GetX() << "  " << (NodeDec+6)->GetY() << endl;
    cout << (NodeDec+7)->GetX() << "  " << (NodeDec+7)->GetY() << endl;
    cout << (NodeDec+8)->GetX() << "  " << (NodeDec+8)->GetY() << endl;
    cout << (NodeDec+9)->GetX() << "  " << (NodeDec+9)->GetY() << endl;

    // SO we have two pentagons of radius 1 and a decagon of radius PHI.
    //
    // The dodecahedron shall have pentagons in the xy plane at +H and -H
    // the heights of the nodes in between shall be at +h and -h
    //
    double H,h;
    
    H=prad*(PHI+1.0)/2.0;
    h=prad*phi/2.0;

    Dodec=new D3Dvec[20];


    // nodes for base pentagon
    (Dodec)->SetVec((NodeP1)->GetX(),(NodeP1)->GetY(),-H);
    (Dodec+1)->SetVec((NodeP1+1)->GetX(),(NodeP1+1)->GetY(),-H);
    (Dodec+2)->SetVec((NodeP1+2)->GetX(),(NodeP1+2)->GetY(),-H);
    (Dodec+3)->SetVec((NodeP1+3)->GetX(),(NodeP1+3)->GetY(),-H);
    (Dodec+4)->SetVec((NodeP1+4)->GetX(),(NodeP1+4)->GetY(),-H);

    //ring of 10 nodes
    (Dodec+5)->SetVec((NodeDec)->GetX(),(NodeDec)->GetY(),-h);
    (Dodec+6)->SetVec((NodeDec+1)->GetX(),(NodeDec+1)->GetY(),h);
    (Dodec+7)->SetVec((NodeDec+2)->GetX(),(NodeDec+2)->GetY(),-h);
    (Dodec+8)->SetVec((NodeDec+3)->GetX(),(NodeDec+3)->GetY(),h);
    (Dodec+9)->SetVec((NodeDec+4)->GetX(),(NodeDec+4)->GetY(),-h);
    (Dodec+10)->SetVec((NodeDec+5)->GetX(),(NodeDec+5)->GetY(),h);
    (Dodec+11)->SetVec((NodeDec+6)->GetX(),(NodeDec+6)->GetY(),-h);
    (Dodec+12)->SetVec((NodeDec+7)->GetX(),(NodeDec+7)->GetY(),h);
    (Dodec+13)->SetVec((NodeDec+8)->GetX(),(NodeDec+8)->GetY(),-h);
    (Dodec+14)->SetVec((NodeDec+9)->GetX(),(NodeDec+9)->GetY(),h);
    

    (Dodec+15)->SetVec((NodeP2+2)->GetX(),(NodeP2+2)->GetY(),H);
    (Dodec+16)->SetVec((NodeP2+1)->GetX(),(NodeP2+1)->GetY(),H);
    (Dodec+17)->SetVec((NodeP2)->GetX(),(NodeP2)->GetY(),H);
    (Dodec+18)->SetVec((NodeP2+4)->GetX(),(NodeP2+4)->GetY(),H);
    (Dodec+19)->SetVec((NodeP2+3)->GetX(),(NodeP2+3)->GetY(),H);

    for(int i=1;i<20;i++){
	    PX=(Dodec+i)->GetX();
	    PY=(Dodec+i)->GetY();
	    PZ=(Dodec+i)->GetX();

	    if(PX < xmin)xmin=PX;
	    if(PY < ymin)ymin=PY;
	    if(PZ < zmin)zmin=PX;

	    if(PX > xmax)xmax=PX;
	    if(PY > ymax)ymax=PY;
	    if(PZ > zmax)zmax=PX;
    }

    xrange=xmax-xmin;
    yrange=ymax-ymin;
    zrange=zmax-zmin;


    cout << "********************************************************" << endl;
    

    cout << 
    (Dodec)->GetX() << " " << (Dodec)->GetY() << " " << (Dodec)->GetZ() << endl;
    cout << 
    (Dodec+1)->GetX() <<" "<< (Dodec+1)->GetY() <<" "<< (Dodec+1)-> GetZ() << endl;
    cout << 
    (Dodec+2)->GetX() <<" "<< (Dodec+2)->GetY() <<" "<< (Dodec+2)-> GetZ() << endl;
    cout <<
    (Dodec+3)->GetX() <<" "<< (Dodec+3)->GetY() <<" "<< (Dodec+3)-> GetZ() << endl;
    cout << 
    (Dodec+4)->GetX() <<" "<< (Dodec+4)->GetY() <<" "<< (Dodec+4)-> GetZ() << endl;
    cout << 
    (Dodec+5)->GetX() <<" "<< (Dodec+5)->GetY() <<" "<< (Dodec+5)-> GetZ() << endl;
    cout << 
    (Dodec+6)->GetX() <<" "<< (Dodec+6)->GetY() <<" "<< (Dodec+6)-> GetZ() << endl;
    cout << 
    (Dodec+7)->GetX() <<" "<< (Dodec+7)->GetY() <<" "<< (Dodec+7)-> GetZ() << endl;
    cout << 
    (Dodec+8)->GetX() <<" "<< (Dodec+8)->GetY() <<" "<< (Dodec+8)-> GetZ() << endl;
    cout << 
    (Dodec+9)->GetX() <<" "<< (Dodec+9)->GetY() <<" "<< (Dodec+9)-> GetZ() << endl;
    cout << 
    (Dodec+10)->GetX() <<" "<< (Dodec+10)->GetY() <<" "<< (Dodec+10)-> GetZ() << endl;
    cout << 
    (Dodec+11)->GetX() <<" "<< (Dodec+11)->GetY() <<" "<< (Dodec+11)-> GetZ() << endl;
    cout << 
    (Dodec+12)->GetX() <<" "<< (Dodec+12)->GetY() <<" "<< (Dodec+12)-> GetZ() << endl;
    cout << 
    (Dodec+13)->GetX() <<" "<< (Dodec+13)->GetY() <<" "<< (Dodec+13)-> GetZ() << endl;
    cout << 
    (Dodec+14)->GetX() <<" "<< (Dodec+14)->GetY() <<" "<< (Dodec+14)-> GetZ() << endl;
    cout << 
    (Dodec+15)->GetX() <<" "<< (Dodec+15)->GetY() <<" "<< (Dodec+15)-> GetZ() << endl;
    cout << 
    (Dodec+16)->GetX() <<" "<< (Dodec+16)->GetY() <<" "<< (Dodec+16)-> GetZ() << endl;
    cout << 
    (Dodec+17)->GetX() <<" "<< (Dodec+17)->GetY() <<" "<< (Dodec+17)-> GetZ() << endl;
    cout << 
    (Dodec+18)->GetX() <<" "<< (Dodec+18)->GetY() <<" "<< (Dodec+18)-> GetZ() << endl;
    cout << 
    (Dodec+19)->GetX() <<" "<< (Dodec+19)->GetY() <<" "<< (Dodec+19)-> GetZ() << endl;

    cout << "******************************************" << endl;

    PX=(Dodec)->GetX(); PY=(Dodec)->GetY(); PZ=(Dodec)->GetZ();
    cout << PX*PX+PY*PY+PZ*PZ << "=square of radial distance from origin" << endl;
    double rad1=sqrt(PX*PX+PY*PY+PZ*PZ);
    PX=(Dodec+5)->GetX(); PY=(Dodec+5)->GetY(); PZ=(Dodec+5)->GetZ();
    cout << PX*PX+PY*PY+PZ*PZ << "=square of radial distance from origin" << endl;
    double rad2=sqrt(PX*PX+PY*PY+PZ*PZ);

    cout << "radius of dodecahedron =" << rad1 <<  endl;



    //pentag is a points to a pointers to integers, make room for 12 of them
    pentag=(int**)calloc(12,sizeof(int*));  //points to 12 pointers to ints
    for( int i=0; i<12; i++){
        *(pentag+i)=(int*)calloc(5,sizeof(int*));//each pointer points to 5 pointers to int
    }


    *(*(pentag+0)+0)=1-1;  //base pentagon
    *(*(pentag+0)+1)=2-1;
    *(*(pentag+0)+2)=3-1;
    *(*(pentag+0)+3)=4-1;
    *(*(pentag+0)+4)=5-1;

    *(*(pentag+1)+0)=6-1; // five more to complete lower half
    *(*(pentag+1)+1)=7-1;
    *(*(pentag+1)+2)=8-1;
    *(*(pentag+1)+3)=2-1;
    *(*(pentag+1)+4)=1-1;

    *(*(pentag+2)+0)=8-1;
    *(*(pentag+2)+1)=9-1;
    *(*(pentag+2)+2)=10-1;
    *(*(pentag+2)+3)=3-1;
    *(*(pentag+2)+4)=2-1;

    *(*(pentag+3)+0)=10-1;
    *(*(pentag+3)+1)=11-1;
    *(*(pentag+3)+2)=12-1;
    *(*(pentag+3)+3)=4-1;
    *(*(pentag+3)+4)=3-1;

    *(*(pentag+4)+0)=12-1;
    *(*(pentag+4)+1)=13-1;
    *(*(pentag+4)+2)=14-1;
    *(*(pentag+4)+3)=5-1;
    *(*(pentag+4)+4)=4-1;

    *(*(pentag+5)+0)=14-1;
    *(*(pentag+5)+1)=15-1;
    *(*(pentag+5)+2)=6-1;
    *(*(pentag+5)+3)=1-1;
    *(*(pentag+5)+4)=5-1;

    *(*(pentag+6)+0)=9-1;  //start ring of five pentagons for upper half
    *(*(pentag+6)+1)=8-1;
    *(*(pentag+6)+2)=7-1;
    *(*(pentag+6)+3)=20-1;
    *(*(pentag+6)+4)=19-1;

    *(*(pentag+7)+0)=11-1;  
    *(*(pentag+7)+1)=10-1;
    *(*(pentag+7)+2)=9-1;
    *(*(pentag+7)+3)=19-1;
    *(*(pentag+7)+4)=18-1;

    *(*(pentag+8)+0)=13-1;  
    *(*(pentag+8)+1)=12-1;
    *(*(pentag+8)+2)=11-1;
    *(*(pentag+8)+3)=18-1;
    *(*(pentag+8)+4)=17-1;

    *(*(pentag+9)+0)=15-1;  
    *(*(pentag+9)+1)=14-1;
    *(*(pentag+9)+2)=13-1;
    *(*(pentag+9)+3)=17-1;
    *(*(pentag+9)+4)=16-1;

    *(*(pentag+10)+0)=7-1;  
    *(*(pentag+10)+1)=6-1;
    *(*(pentag+10)+2)=15-1;
    *(*(pentag+10)+3)=16-1;
    *(*(pentag+10)+4)=20-1;

    *(*(pentag+11)+0)=16-1;    // top pentagon makes 12.
    *(*(pentag+11)+1)=17-1;
    *(*(pentag+11)+2)=18-1;
    *(*(pentag+11)+3)=19-1;
    *(*(pentag+11)+4)=20-1;

 while(!quitit){
        
       while(SDL_PollEvent(&event)){

          switch(event.type){
               case SDL_QUIT:
                 quitit=true;
                 break;
                 case SDL_MOUSEBUTTONDOWN:
                    mousedown=true;
                 break;
                 case SDL_MOUSEBUTTONUP:
                    mousedown=false;
                 break;
                 case SDL_MOUSEMOTION:
                  if(mousedown){
                         if(MouseOn)Camera1.MouseView();}
                  else{
                         if(MouseOn)Camera1.MouseLookAt(); }
                 break;  


               case SDL_KEYDOWN:
                   whatkey=&event.key.keysym;
                   HandleKeyPress(whatkey);
                   break;
               case SDL_KEYUP:
                   whatkey=&event.key.keysym;
                   HandleKeyRelease(whatkey);
               default:
                 break;
                     } // end of case
                } //end of inner loop
              CheckMove(Camera1);
              RenderScene(Camera1);
            } //end of outer loop

}
void RenderScene(CCam & Camera1)
{
  //     std::cout << "In Render\n";

       glClear(GL_COLOR_BUFFER_BIT  | GL_DEPTH_BUFFER_BIT);
       glLoadIdentity();

       //
       //camera  pos      view     up vector
       gluLookAt(
        Camera1.CamPos.GetX(),   Camera1.CamPos.GetY(),  Camera1.CamPos.GetZ(),
        Camera1.CamView.GetX(), Camera1.CamView.GetY(), Camera1.CamView.GetZ(),
        Camera1.CamUp.GetX(),   Camera1.CamUp.GetY(),   Camera1.CamUp.GetZ());   


      //create fonts here
      //Check in Camera.h
      //Camera at (0,0,-5000)
      // stare at (0,0,0)

      //camera angle is 45 degees
      //camera 5000 away
      //-2000. is where xmin will be
      //+2000. is where xmax will be
      //
      //bounding box
 
       double exmin, whymin, zedmin;
       double exmax, whymax, zedmax;
       double exrange, whyrange,zedrange;
       exrange=xrange; whyrange=yrange; zedrange=zrange; 
       exmin=xmin, whymin=ymin; zedmin=zmin;


         double Halfscreen=3000.0;
         double Screen=2.*Halfscreen;
         double maxrange;
         maxrange=exrange;
         if(maxrange < whyrange)maxrange=whyrange;
         if(maxrange < zedrange)maxrange=zedrange;

         double Halfscreenx,Halfscreeny,Halfscreenz;
         Halfscreenx=Halfscreen*exrange/maxrange;
         Halfscreeny=Halfscreen*whyrange/maxrange;
         Halfscreenz=Halfscreen*zedrange/maxrange;
     
         double bbox_x1,bbox_x2;
         double bbox_y1,bbox_y2;
         double bbox_z1,bbox_z2;


         bbox_x1=-Halfscreenx;
         bbox_x2= Halfscreenx;
         bbox_y1=-Halfscreeny;
         bbox_y2= Halfscreeny;
         bbox_z1=-Halfscreenz;
         bbox_z2= Halfscreenz;

	 double x1,y1,z1;
	 double x2,y2,z2;
	 double x3,y3,z3;
	 double x4,y4,z4;

    //  glColor3ub(0,0,0);  // if colour is disabled

      float line_spec[]={0.0,0.0,0.0,1.0};  //line's ref of specular light
      float line_amb[]={0.0,0.0,0.0,1.0};  //line's ref of specular light
      float line_diff[]={0.0,0.0,0.0,0.0};  //line's ref of diffuse light
      float line_shine[]= {0.0};  //lines's sharpness of specular ref 

      glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, line_spec);
      glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, line_amb);
      glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, line_spec);
      glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, line_shine);

      bool  bboxdraw=false;
     if(bboxdraw){
      glBegin(GL_LINES);
          glVertex3f(bbox_x1,bbox_y1,bbox_z1);
          glVertex3f(bbox_x2,bbox_y1,bbox_z1);

          glVertex3f(bbox_x1,bbox_y2,bbox_z1);
          glVertex3f(bbox_x2,bbox_y2,bbox_z1);
          
          glVertex3f(bbox_x1,bbox_y1,bbox_z2);
          glVertex3f(bbox_x2,bbox_y1,bbox_z2);

          glVertex3f(bbox_x1,bbox_y2,bbox_z2);
          glVertex3f(bbox_x2,bbox_y2,bbox_z2);

          glVertex3f(bbox_x1,bbox_y1,bbox_z1);
          glVertex3f(bbox_x1,bbox_y1,bbox_z2);

          glVertex3f(bbox_x1,bbox_y2,bbox_z1);
          glVertex3f(bbox_x1,bbox_y2,bbox_z2);

          glVertex3f(bbox_x2,bbox_y1,bbox_z1);
          glVertex3f(bbox_x2,bbox_y1,bbox_z2);

          glVertex3f(bbox_x2,bbox_y2,bbox_z1);
          glVertex3f(bbox_x2,bbox_y2,bbox_z2);

          glVertex3f(bbox_x1,bbox_y1,bbox_z2);
          glVertex3f(bbox_x1,bbox_y2,bbox_z2);

          glVertex3f(bbox_x1,bbox_y1,bbox_z1);
          glVertex3f(bbox_x1,bbox_y2,bbox_z1);

          glVertex3f(bbox_x2,bbox_y1,bbox_z1);
          glVertex3f(bbox_x2,bbox_y2,bbox_z1);

          glVertex3f(bbox_x2,bbox_y1,bbox_z2);
          glVertex3f(bbox_x2,bbox_y2,bbox_z2);

      glEnd();
     }

      float  xvals[5],yvals[5],zvals[5];

      glLineWidth(10.0);

      for(int i=0;i<12;i++){
	      for(int j=0;j<5;j++){
	      xvals[j]=(Dodec+*(*(pentag+i)+j))->GetX();
	      yvals[j]=(Dodec+*(*(pentag+i)+j))->GetY();
	      zvals[j]=(Dodec+*(*(pentag+i)+j))->GetZ();

              xvals[j]=(float)Halfscreenx*( 2*(xvals[j]-exmin)/exrange -1.0);
              yvals[j]=(float)Halfscreeny*( 2*(yvals[j]-whymin)/whyrange -1.0);
              zvals[j]=(float)Halfscreenz*( 2*(zvals[j]-zedmin)/zedrange -1.0);
               }

	      D3Dvec edge1, edge2,cross,normal;
	      edge1.SetX(xvals[1]-xvals[0]);
	      edge1.SetY(yvals[1]-yvals[0]);
	      edge1.SetZ(zvals[1]-zvals[0]);
	      edge2.SetX(xvals[2]-xvals[0]);
	      edge2.SetY(yvals[2]-yvals[1]);
	      edge2.SetZ(zvals[2]-zvals[1]);

	      cross=edge1*edge2;
	      Normalise(cross);
	      glNormal3f( (float)cross.GetX(), cross.GetY(),cross.GetZ());

            //  glColor3ub(255,0,0);  //(without lighting enabled)
	    //
	      float mat_spec[]={1.0, 1.0, 1.0, 1.0};  //polygon's ref of specular light
	      float mat_diff[]={1.0, 0.0, 0.0, 0.0};  //polygon's ref of diffuse light
	      float mat_amb[]={1.0, 1.0, 1.0, 0.0};  //polygon's ref of ambient light

	      float mat_shine[]= {2.0};  //polygon's specular reflection
	      // 0.0 to 128, small values give sharper specular reflection

	      glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, mat_amb);
	      glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, mat_spec);
	      glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, mat_diff);


	      glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, mat_shine);

	      glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
	      glBegin(GL_POLYGON);
          	glVertex3f( xvals[0],yvals[0],zvals[0] );
          	glVertex3f( xvals[1],yvals[1],zvals[1] );
          	glVertex3f( xvals[2],yvals[2],zvals[2] );
          	glVertex3f( xvals[3],yvals[3],zvals[3] );
          	glVertex3f( xvals[4],yvals[4],zvals[4] );
             glEnd(); 

             //glColor3ub(0,0,0);

	     glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, line_spec);
	     glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, line_diff);
	     glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, line_amb);
   	     glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, line_shine);

             glPolygonMode(GL_FRONT_AND_BACK,GL_LINE);
	     glBegin(GL_POLYGON);
          	glVertex3f( xvals[0],yvals[0],zvals[0] );
          	glVertex3f( xvals[1],yvals[1],zvals[1] );
          	glVertex3f( xvals[2],yvals[2],zvals[2] );
          	glVertex3f( xvals[3],yvals[3],zvals[3] );
          	glVertex3f( xvals[4],yvals[4],zvals[4] ); 
             glEnd();

      }
      
      SDL_GL_SwapBuffers();

}

void HandleKeyPress(SDL_keysym *whatkey)
{ 
             int igetscreen;
             float myspeed=speed;

             switch(whatkey->sym)
             {
                 case SDLK_F1:
                   ToggleFullScreen();
                   break;
                 case SDLK_F2:
                   if(MouseOn==true)
                     {
                      MouseOn=false;
                     }
                     else
                    {
                      MouseOn=true;
                    }
                    break;
                 case SDLK_F9:
                   if(togglez==true)
                        togglez=false;
                   else
                        togglez=true;

                 case SDLK_F10:
                   igetscreen=Screenshot(MainWindow,"screenshot.bmp");
                   break;
                 case SDLK_ESCAPE:
                   SDL_Quit();
                   exit(0);
                   break;
                 case  SDLK_UP:
                   upPressed=true;
                   break;
		 case  SDLK_DOWN:
                   downPressed=true;
                   break;
                 case SDLK_LEFT:
                   leftPressed=true;
                   if( whatkey->mod & KMOD_CTRL)
                   {
                   leftPressed =false;
                   ctrl_leftPressed=true;
                   }
                   if( whatkey->mod & KMOD_SHIFT){
                   leftPressed =false;
                   shift_leftPressed=true;
                   }
                   break;
                 case SDLK_RIGHT:
                   rightPressed=true;
                   if( whatkey->mod & KMOD_CTRL)
                   {
                   rightPressed =false;
                   ctrl_rightPressed=true;
                   }
                   if( whatkey->mod & KMOD_SHIFT){
                   rightPressed =false;
                   shift_rightPressed=true;
                   }
                 default:
                   break;
                 case SDLK_p:
                   p_Pressed=true;
                   break; 
                 case SDLK_F12:
                   iplot++;
                   break;
             }
}

void HandleKeyRelease(SDL_keysym *whatkey)
{ 
             switch(whatkey->sym)
             {
                 case  SDLK_UP:
                   upPressed=false;
                   break;
		 case  SDLK_DOWN:
                   downPressed=false;
                   break;
                 case SDLK_LEFT:
                   leftPressed=false;
                   shift_leftPressed=false;
                   ctrl_leftPressed=false;
                   break;
                 case SDLK_RIGHT:
                   rightPressed=false;
                   shift_rightPressed=false;
                   ctrl_rightPressed=false;
                   break;
                 default:
                   break;
                 case SDLK_p:
                   p_Pressed=false;
                   break; 
             }
}

void CheckMove(CCam & Camera1)
{
    if(downPressed)Camera1.CamMove(-speed);
    if(upPressed)Camera1.CamMove(speed);
             
    if(leftPressed)Camera1.CamRotatePos(-speed/1000);
    if(rightPressed)Camera1.CamRotatePos(speed/1000);

    //assumes noone does ctrl and shift together!
    if(shift_leftPressed)Camera1.CamRotateView(-speed/1000);
    if(shift_rightPressed)Camera1.CamRotateView(speed/1000);
    if(ctrl_leftPressed)Camera1.CamStrafe(speed);
    if(ctrl_rightPressed)Camera1.CamStrafe(-speed);

    if(p_Pressed){

    FILE *fp=fopen("MyFileName.ps","wb");
    GLint buffsize=0;
    GLint state=GL2PS_OVERFLOW;
    GLint viewport[4];
    glGetIntegerv(GL_VIEWPORT, viewport);

    while(state==GL2PS_OVERFLOW){
       buffsize+=1024*1024;
//     could use GL2PS_USE_CURRENT_VIEWPORT,
       int ips=gl2psBeginPage("MyTitle","MyProducer",viewport,
               GL2PS_PS,GL2PS_BSP_SORT,GL2PS_SILENT | 
	       GL2PS_SIMPLE_LINE_OFFSET | GL2PS_BEST_ROOT,GL_RGBA,0,NULL,
               0,0,0,buffsize,fp,"MyFileName.ps");
       RenderScene(Camera1);
       state=gl2psEndPage();

       }  //end while loop
      fclose(fp);
    } // end p_Pressed

}
