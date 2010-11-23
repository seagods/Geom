      integer nhex,npent,ntri
      parameter(nhex=20,npent=12,ntri=180,ndiv=1,ntri2=ntri*ndiv**2)
      real x1(100001),y1(100001),z1(100001)
      real pi
      real vertex(12,3),dodecnode(20,3)
      real trianglesx(ntri,3),trianglesy(ntri,3),trianglesz(ntri,3)
      real triangles2x(ntri2,3)
     &,triangles2y(ntri2,3),triangles2z(ntri2,3)
      real vnodes(92,3),vnodes2(ntri*(ndiv**2+3*ndiv+2)/2,3)  
      real vnode6(ntri*(ndiv**2+3*ndiv+2)/2,3),radius
      integer nodelist1(32,6),nodelist2(ntri,3)
      integer ireg1(ntri),ireg2(ntri2)
      integer nodelist3(ntri2,3),ilist(10001,5)
      integer nnnode
      integer nlists
      nnnode=ntri*(ndiv**2+3*ndiv+2)/2
      pi=acos(-1.)

      radius=0.4

     
      p1=.5*(1.+sqrt(5.))
      p2=.5*(1.-sqrt(5.))
c     hexagons of unit length.
c     

      hexrho=sqrt(.5*(1.+1./sqrt(5.)))
      decarho=p1*sqrt(.5*(1.+1./sqrt(5.)))

c     trig
      coz18=.5*sqrt(2.5*(1.+1./sqrt(5.)))
      sin18=abs(p2/2.)
      coz36=p1/2.
      sin36=.5*sqrt(2.5*(1.-1./sqrt(5.)))
      coz54=sin36
      sin54=coz36
      coz72=sin18
      sin72=coz18


      gee=hexrho*sin54
      aitch=sqrt(3.)/2.
      dee=hexrho-gee
      write(6,*)gee,aitch,dee


      ringhigh1=.5*sqrt(3./4.-dee**2)
      ringhigh2=-.5*sqrt(3./4.-dee**2)
      caphigh=sqrt(1.-gee**2/aitch**2)*aitch

      write(6,*)ringhigh1,ringhigh2,caphigh
c
C     12 vertices of an icosahedron form the centres
C     of the pentagonal faces of a  truncated icosahedron

      vertex(1,1)=0.
      vertex(1,2)=0.
      vertex(1,3)=(ringhigh1+caphigh)/(ringhigh1+caphigh)
c
      vertex(2,1)=hexrho/(ringhigh1+caphigh)
      vertex(2,2)=0.
      vertex(2,3)=ringhigh1/(ringhigh1+caphigh)
c
      vertex(3,1)=hexrho*coz72/(ringhigh1+caphigh)
      vertex(3,2)=hexrho*sin72/(ringhigh1+caphigh)
      vertex(3,3)=ringhigh1/(ringhigh1+caphigh)
c
      vertex(4,1)=-hexrho*coz36/(ringhigh1+caphigh)
      vertex(4,2)=hexrho*sin36/(ringhigh1+caphigh)
      vertex(4,3)=ringhigh1/(ringhigh1+caphigh)
c
      vertex(5,1)=-hexrho*coz36/(ringhigh1+caphigh)
      vertex(5,2)=-hexrho*sin36/(ringhigh1+caphigh)
      vertex(5,3)=ringhigh1/(ringhigh1+caphigh)
c
      vertex(6,1)=hexrho*coz72/(ringhigh1+caphigh)
      vertex(6,2)=-hexrho*sin72/(ringhigh1+caphigh)
      vertex(6,3)=ringhigh1/(ringhigh1+caphigh)
c
      vertex(7,1)=hexrho*coz36/(ringhigh1+caphigh)
      vertex(7,2)=hexrho*sin36/(ringhigh1+caphigh)
      vertex(7,3)=ringhigh2/(ringhigh1+caphigh)
c
      vertex(8,1)=-hexrho*coz72/(ringhigh1+caphigh)
      vertex(8,2)=hexrho*sin72/(ringhigh1+caphigh)
      vertex(8,3)=ringhigh2/(ringhigh1+caphigh)
c
      vertex(9,1)=-hexrho/(ringhigh1+caphigh)
      vertex(9,2)=0.
      vertex(9,3)=ringhigh2/(ringhigh1+caphigh)
c
      vertex(10,1)=-hexrho*coz72/(ringhigh1+caphigh)
      vertex(10,2)=-hexrho*sin72/(ringhigh1+caphigh)
      vertex(10,3)=ringhigh2/(ringhigh1+caphigh)
c
      vertex(11,1)=hexrho*coz36/(ringhigh1+caphigh)
      vertex(11,2)=-hexrho*sin36/(ringhigh1+caphigh)
      vertex(11,3)=ringhigh2/(ringhigh1+caphigh)
c
      vertex(12,1)=0.
      vertex(12,2)=0.
      vertex(12,3)=(ringhigh2-caphigh)/(ringhigh1+caphigh)



C     DODECAHEDRAL NODES form the centres of the hexagonal
C     faces of a truncated icosahedron

C     pentagons of unit length.
C     height of top pentagon
C     height of bottom pentagon
      penthigh1=sqrt(.5*(1.+1./sqrt(5.)))*(P1+1.)/2.
      penthigh2=-sqrt(.5*(1.+1./sqrt(5.)))*(P1+1.)/2.
      dechigh1=sqrt(.5*(1.+1./sqrt(5.)))*(P1-1.)/2.
      dechigh2=-sqrt(.5*(1.+1./sqrt(5.)))*(P1-1.)/2.

      pentrho=sqrt(.5*(1.+1./sqrt(5.)))
      decarho=P1*sqrt(.5*(1.+1./sqrt(5.)))



      dodecnode(3,1)=pentrho
      dodecnode(3,2)=0.
      dodecnode(3,3)=penthigh1  
C
      dodecnode(4,1)=pentrho*coz72
      dodecnode(4,2)=pentrho*sin72
      dodecnode(4,3)=penthigh1
C
      dodecnode(5,1)=-pentrho*coz36
      dodecnode(5,2)=pentrho*sin36
      dodecnode(5,3)=penthigh1
C
      dodecnode(1,1)=-pentrho*coz36
      dodecnode(1,2)=-pentrho*sin36
      dodecnode(1,3)=penthigh1
C  
      dodecnode(2,1)=pentrho*coz72
      dodecnode(2,2)=-pentrho*sin72
      dodecnode(2,3)=penthigh1
C
      dodecnode(12,1)=decarho
      dodecnode(12,2)=0.
      dodecnode(12,3)=dechigh1
C
      dodecnode(13,1)=decarho*coz36
      dodecnode(13,2)=decarho*sin36
      dodecnode(13,3)=dechigh2
C
      dodecnode(14,1)=decarho*coz72
      dodecnode(14,2)=decarho*sin72
      dodecnode(14,3)=dechigh1
C
      dodecnode(15,1)=-decarho*coz72
      dodecnode(15,2)=decarho*sin72
      dodecnode(15,3)=dechigh2
C
      dodecnode(6,1)=-decarho*coz36
      dodecnode(6,2)=decarho*sin36
      dodecnode(6,3)=dechigh1
C
      dodecnode(7,1)=-decarho
      dodecnode(7,2)=0.
      dodecnode(7,3)=dechigh2
C
      dodecnode(8,1)=-decarho*coz36
      dodecnode(8,2)=-decarho*sin36
      dodecnode(8,3)=dechigh1
C
      dodecnode(9,1)=-decarho*coz72
      dodecnode(9,2)=-decarho*sin72
      dodecnode(9,3)=dechigh2
C
      dodecnode(10,1)=decarho*coz72
      dodecnode(10,2)=-decarho*sin72
      dodecnode(10,3)=dechigh1
C
      dodecnode(11,1)=decarho*coz36
      dodecnode(11,2)=-decarho*sin36
      dodecnode(11,3)=dechigh2
C
      dodecnode(18,1)=pentrho*coz36
      dodecnode(18,2)=-pentrho*sin36
      dodecnode(18,3)=penthigh2
C
      dodecnode(19,1)=pentrho*coz36
      dodecnode(19,2)=pentrho*sin36
      dodecnode(19,3)=penthigh2
C
      dodecnode(20,1)=-pentrho*coz72
      dodecnode(20,2)=pentrho*sin72
      dodecnode(20,3)=penthigh2
C
      dodecnode(16,1)=-pentrho
      dodecnode(16,2)=0.
      dodecnode(16,3)=penthigh2
C
      dodecnode(17,1)=-pentrho*coz72
      dodecnode(17,2)=-pentrho*sin72
      dodecnode(17,3)=penthigh2

      do 2 i=1,20
      dodecnode(i,1)=-dodecnode(i,1)
      dodecnode(i,2)=-dodecnode(i,2)
      vnorm=sqrt(dodecnode(i,1)**2
     &+dodecnode(i,2)**2+dodecnode(i,3)**2)
      dodecnode(i,1)=dodecnode(i,1)/vnorm
      dodecnode(i,2)=dodecnode(i,2)/vnorm
      dodecnode(i,3)=dodecnode(i,3)/vnorm
2     continue

C     vertices of bucky ball
 
      do 99 j1=1,3
       vnodes(1,j1)=vertex(1,j1)
     &+(-vertex(1,j1)+vertex(2,j1))/3.
       vnodes(2,j1)=vertex(1,j1)
     &+(-vertex(1,j1)+vertex(2,j1))*2./3.

       vnodes(3,j1)=vertex(2,j1)
     &+(-vertex(2,j1)+vertex(3,j1))/3.
       vnodes(4,j1)=vertex(2,j1)
     &+(-vertex(2,j1)+vertex(3,j1))*2./3.
c
       vnodes(5,j1)=vertex(1,j1)
     &+(-vertex(1,j1)+vertex(3,j1))/3.
       vnodes(6,j1)=vertex(1,j1)
     &+(-vertex(1,j1)+vertex(3,j1))*2./3.

       vnodes(7,j1)=vertex(3,j1)
     &+(-vertex(3,j1)+vertex(4,j1))/3.
        vnodes(8,j1)=vertex(3,j1)
     &+(-vertex(3,j1)+vertex(4,j1))*2./3.


       vnodes(9,j1)=vertex(1,j1)
     &+(-vertex(1,j1)+vertex(4,j1))/3.
        vnodes(10,j1)=vertex(1,j1)
     &+(-vertex(1,j1)+vertex(4,j1))*2./3.

       vnodes(11,j1)=vertex(4,j1)
     &+(-vertex(4,j1)+vertex(5,j1))/3.
       vnodes(12,j1)=vertex(4,j1)
     &+(-vertex(4,j1)+vertex(5,j1))*2./3.

       vnodes(13,j1)=vertex(1,j1)
     &+(-vertex(1,j1)+vertex(5,j1))/3.
        vnodes(14,j1)=vertex(1,j1)
     &+(-vertex(1,j1)+vertex(5,j1))*2./3.
   
       vnodes(15,j1)=vertex(5,j1)
     &+(-vertex(5,j1)+vertex(6,j1))/3.
        vnodes(16,j1)=vertex(5,j1)
     &+(-vertex(5,j1)+vertex(6,j1))*2./3.


       vnodes(17,j1)=vertex(1,j1)
     &+(-vertex(1,j1)+vertex(6,j1))/3.
       vnodes(18,j1)=vertex(1,j1)
     &+(-vertex(1,j1)+vertex(6,j1))*2./3.

       vnodes(19,j1)=vertex(6,j1)
     &+(-vertex(6,j1)+vertex(2,j1))/3.
        vnodes(20,j1)=vertex(6,j1)
     &+(-vertex(6,j1)+vertex(2,j1))*2./3.
  
       vnodes(21,j1)=vertex(6,j1)
     &+(-vertex(6,j1)+vertex(11,j1))/3.
       vnodes(22,j1)=vertex(6,j1)
     &+(-vertex(6,j1)+vertex(11,j1))*2./3.

       vnodes(23,j1)=vertex(11,j1)
     &+(-vertex(11,j1)+vertex(2,j1))/3.
       vnodes(24,j1)=vertex(11,j1)
     &+(-vertex(11,j1)+vertex(2,j1))*2./3.

       vnodes(25,j1)=vertex(11,j1)
     &+(-vertex(11,j1)+vertex(7,j1))/3.
       vnodes(26,j1)=vertex(11,j1)
     &+(-vertex(11,j1)+vertex(7,j1))*2./3.
       vnodes(27,j1)=vertex(7,j1)
     &+(-vertex(7,j1)+vertex(2,j1))/3.
        vnodes(28,j1)=vertex(7,j1)
     &+(-vertex(7,j1)+vertex(2,j1))*2./3.
 
       vnodes(29,j1)=vertex(3,j1)
     &+(-vertex(3,j1)+vertex(7,j1))/3.
       vnodes(30,j1)=vertex(3,j1)
     &+(-vertex(3,j1)+vertex(7,j1))*2./3.
       vnodes(31,j1)=vertex(7,j1)
     &+(-vertex(7,j1)+vertex(8,j1))/3.
       vnodes(32,j1)=vertex(7,j1)
     &+(-vertex(7,j1)+vertex(8,j1))*2./3.

       vnodes(33,j1)=vertex(3,j1)
     &+(-vertex(3,j1)+vertex(8,j1))/3.
       vnodes(34,j1)=vertex(3,j1)
     &+(-vertex(3,j1)+vertex(8,j1))*2./3.
       vnodes(35,j1)=vertex(8,j1)
     &+(-vertex(8,j1)+vertex(4,j1))/3.
       vnodes(36,j1)=vertex(8,j1)
     &+(-vertex(8,j1)+vertex(4,j1))*2./3.


       vnodes(37,j1)=vertex(8,j1)
     &+(-vertex(8,j1)+vertex(9,j1))/3.
       vnodes(38,j1)=vertex(8,j1)
     &+(-vertex(8,j1)+vertex(9,j1))*2./3.
       vnodes(39,j1)=vertex(9,j1)
     &+(-vertex(9,j1)+vertex(4,j1))/3.
       vnodes(40,j1)=vertex(9,j1)
     &+(-vertex(9,j1)+vertex(4,j1))*2./3.
 
       vnodes(41,j1)=vertex(5,j1)
     &+(-vertex(5,j1)+vertex(9,j1))/3.
        vnodes(42,j1)=vertex(5,j1)
     &+(-vertex(5,j1)+vertex(9,j1))*2./3.
       vnodes(43,j1)=vertex(9,j1)
     &+(-vertex(9,j1)+vertex(10,j1))/3.
        vnodes(44,j1)=vertex(9,j1)
     &+(-vertex(9,j1)+vertex(10,j1))*2./3.

       vnodes(45,j1)=vertex(5,j1)
     &+(-vertex(5,j1)+vertex(10,j1))/3.
       vnodes(46,j1)=vertex(5,j1)
     &+(-vertex(5,j1)+vertex(10,j1))*2./3.
       vnodes(47,j1)=vertex(10,j1)
     &+(-vertex(10,j1)+vertex(6,j1))/3.
       vnodes(48,j1)=vertex(10,j1)
     &+(-vertex(10,j1)+vertex(6,j1))*2./3.
  
       vnodes(49,j1)=vertex(10,j1)
     &+(-vertex(10,j1)+vertex(11,j1))/3.
       vnodes(50,j1)=vertex(10,j1)
     &+(-vertex(10,j1)+vertex(11,j1))*2./3.

       vnodes(51,j1)=vertex(12,j1)
     &+(-vertex(12,j1)+vertex(11,j1))/3.
       vnodes(52,j1)=vertex(12,j1)
     &+(-vertex(12,j1)+vertex(11,j1))*2./3.

       vnodes(53,j1)=vertex(12,j1)
     &+(-vertex(12,j1)+vertex(7,j1))/3.
       vnodes(54,j1)=vertex(12,j1)
     &+(-vertex(12,j1)+vertex(7,j1))*2./3.
 
       vnodes(55,j1)=vertex(12,j1)
     &+(-vertex(12,j1)+vertex(8,j1))/3.
       vnodes(56,j1)=vertex(12,j1)
     &+(-vertex(12,j1)+vertex(8,j1))*2./3.
 
       vnodes(57,j1)=vertex(12,j1)
     &+(-vertex(12,j1)+vertex(9,j1))/3.
        vnodes(58,j1)=vertex(12,j1)
     &+(-vertex(12,j1)+vertex(9,j1))*2./3.

       vnodes(59,j1)=vertex(12,j1)
     &+(-vertex(12,j1)+vertex(10,j1))/3.
       vnodes(60,j1)=vertex(12,j1)
     &+(-vertex(12,j1)+vertex(10,j1))*2./3.

99    continue

      vnorm=sqrt(vnodes(1,1)**2+vnodes(1,2)**2
     &+vnodes(1,3)**2)
      write(6,*)vnodes(1,1),vnodes(1,2)
     &,vnodes(1,3),vnorm

      do 4 i=1,60
        vnodes(i,1)=vnodes(i,1)/vnorm
        vnodes(i,2)=vnodes(i,2)/vnorm  
        vnodes(i,3)=vnodes(i,3)/vnorm
4      continue
C     
C      add icosahdral nodes to vnodes
       do 6 i=1,12
        do 5 j=1,3
          vnodes(i+60,j)=vertex(i,j)
5       continue
6      continue

C      add dodecahdral nodes to vnodes
       do 8 i=1,20
        do 7 j=1,3
          vnodes(i+72,j)=dodecnode(i,j)
7       continue
8      continue



 

C      first in the nodelist, 20 hexagons in a bucky ball
       nodelist1(1,1)=1
       nodelist1(1,2)=2
       nodelist1(1,3)=3
       nodelist1(1,4)=4
       nodelist1(1,5)=6
       nodelist1(1,6)=5

       nodelist1(2,1)=5
       nodelist1(2,2)=6
       nodelist1(2,3)=7
       nodelist1(2,4)=8
       nodelist1(2,5)=10
       nodelist1(2,6)=9

       nodelist1(3,1)=9
       nodelist1(3,2)=10
       nodelist1(3,3)=11
       nodelist1(3,4)=12
       nodelist1(3,5)=14
       nodelist1(3,6)=13

       nodelist1(4,1)=13
       nodelist1(4,2)=14
       nodelist1(4,3)=15
       nodelist1(4,4)=16
       nodelist1(4,5)=18
       nodelist1(4,6)=17

       nodelist1(5,1)=17
       nodelist1(5,2)=18
       nodelist1(5,3)=19
       nodelist1(5,4)=20
       nodelist1(5,5)=2
       nodelist1(5,6)=1

       nodelist1(6,1)=19
       nodelist1(6,2)=21
       nodelist1(6,3)=22
       nodelist1(6,4)=23
       nodelist1(6,5)=24
       nodelist1(6,6)=20

       nodelist1(7,1)=24
       nodelist1(7,2)=23
       nodelist1(7,3)=25
       nodelist1(7,4)=26
       nodelist1(7,5)=27
       nodelist1(7,6)=28

       nodelist1(8,1)=3
       nodelist1(8,2)=28
       nodelist1(8,3)=27
       nodelist1(8,4)=30
       nodelist1(8,5)=29
       nodelist1(8,6)=4

       nodelist1(9,1)=29
       nodelist1(9,2)=30
       nodelist1(9,3)=31
       nodelist1(9,4)=32
       nodelist1(9,5)=34
       nodelist1(9,6)=33


       nodelist1(10,1)=7
       nodelist1(10,2)=33
       nodelist1(10,3)=34
       nodelist1(10,4)=35
       nodelist1(10,5)=36
       nodelist1(10,6)=8

       nodelist1(11,1)=36
       nodelist1(11,2)=35
       nodelist1(11,3)=37
       nodelist1(11,4)=38
       nodelist1(11,5)=39
       nodelist1(11,6)=40

       nodelist1(12,1)=11
       nodelist1(12,2)=40
       nodelist1(12,3)=39
       nodelist1(12,4)=42
       nodelist1(12,5)=41
       nodelist1(12,6)=12

       nodelist1(13,1)=41
       nodelist1(13,2)=42
       nodelist1(13,3)=43
       nodelist1(13,4)=44
       nodelist1(13,5)=46
       nodelist1(13,6)=45

       nodelist1(14,1)=15
       nodelist1(14,2)=45
       nodelist1(14,3)=46
       nodelist1(14,4)=47
       nodelist1(14,5)=48
       nodelist1(14,6)=16

       nodelist1(15,1)=48
       nodelist1(15,2)=47
       nodelist1(15,3)=49
       nodelist1(15,4)=50
       nodelist1(15,5)=22
       nodelist1(15,6)=21

       nodelist1(16,1)=25
       nodelist1(16,2)=52
       nodelist1(16,3)=51
       nodelist1(16,4)=53
       nodelist1(16,5)=54
       nodelist1(16,6)=26


       nodelist1(17,1)=31
       nodelist1(17,2)=54
       nodelist1(17,3)=53
       nodelist1(17,4)=55
       nodelist1(17,5)=56
       nodelist1(17,6)=32

       nodelist1(18,1)=37
       nodelist1(18,2)=56
       nodelist1(18,3)=55
       nodelist1(18,4)=57
       nodelist1(18,5)=58
       nodelist1(18,6)=38


       nodelist1(19,1)=43
       nodelist1(19,2)=58
       nodelist1(19,3)=57
       nodelist1(19,4)=59
       nodelist1(19,5)=60
       nodelist1(19,6)=44

       nodelist1(20,1)=49
       nodelist1(20,2)=60
       nodelist1(20,3)=59
       nodelist1(20,4)=51
       nodelist1(20,5)=52
       nodelist1(20,6)=50

C      second in nodelist, the 12 pentagons in a bucky ball
       nodelist1(1+20,1)=1
       nodelist1(1+20,2)=5
       nodelist1(1+20,3)=9
       nodelist1(1+20,4)=13
       nodelist1(1+20,5)=17


       nodelist1(2+20,1)=2
       nodelist1(2+20,2)=20
       nodelist1(2+20,3)=24
       nodelist1(2+20,4)=28
       nodelist1(2+20,5)=3


       nodelist1(3+20,1)=6
       nodelist1(3+20,2)=4
       nodelist1(3+20,3)=29
       nodelist1(3+20,4)=33
       nodelist1(3+20,5)=7


       nodelist1(4+20,1)=10
       nodelist1(4+20,2)=8
       nodelist1(4+20,3)=36
       nodelist1(4+20,4)=40
       nodelist1(4+20,5)=11

       nodelist1(5+20,1)=14
       nodelist1(5+20,2)=12
       nodelist1(5+20,3)=41
       nodelist1(5+20,4)=45
       nodelist1(5+20,5)=15


       nodelist1(6+20,1)=18
       nodelist1(6+20,2)=16
       nodelist1(6+20,3)=48
       nodelist1(6+20,4)=21
       nodelist1(6+20,5)=19


       nodelist1(7+20,1)=54
       nodelist1(7+20,2)=31
       nodelist1(7+20,3)=30
       nodelist1(7+20,4)=27
       nodelist1(7+20,5)=26


       nodelist1(8+20,1)=56
       nodelist1(8+20,2)=37
       nodelist1(8+20,3)=35
       nodelist1(8+20,4)=34
       nodelist1(8+20,5)=32


       nodelist1(9+20,1)=58
       nodelist1(9+20,2)=43
       nodelist1(9+20,3)=42
       nodelist1(9+20,4)=39
       nodelist1(9+20,5)=38


       nodelist1(10+20,1)=60
       nodelist1(10+20,2)=49
       nodelist1(10+20,3)=47
       nodelist1(10+20,4)=46
       nodelist1(10+20,5)=44

       nodelist1(11+20,1)=52
       nodelist1(11+20,2)=25
       nodelist1(11+20,3)=23
       nodelist1(11+20,4)=22
       nodelist1(11+20,5)=50

       nodelist1(12+20,1)=51
       nodelist1(12+20,2)=59
       nodelist1(12+20,3)=57
       nodelist1(12+20,4)=55
       nodelist1(12+20,5)=53



C      nodelist for hexagons split into triangles
       kounter=1
       do 10 i=1,20
         do 9 j=1,6

          if(j.ne.6)then
            nodelist2(6*(i-1)+j,1)=nodelist1(i,j)
            nodelist2(6*(i-1)+j,2)=nodelist1(i,j+1)
            nodelist2(6*(i-1)+j,3)=i+72
            else
            nodelist2(6*(i-1)+j,1)=nodelist1(i,j)
            nodelist2(6*(i-1)+j,2)=nodelist1(i,1)
            nodelist2(6*(i-1)+j,3)=i+72
          endif
          ireg1(6*(i-1)+j)=i

C         write(6,*)nodelist2(6*(i-1)+j,1),6*(i-1)+j,j,i
C        write(6,*)nodelist2(6*(i-1)+j,2),6*(i-1)+j,j,i
C         write(6,*)nodelist2(6*(i-1)+j,3),6*(i-1)+j,j,i
9        continue
10        continue

C      nodelist for pentagons split into triangles
       kounter=1
       do 12 i=1,12
         do 11 j=1,5
          if(j.ne.5)then
            nodelist2(120+5*(i-1)+j,1)=nodelist1(20+i,j)
            nodelist2(120+5*(i-1)+j,2)=nodelist1(20+i,j+1)
            nodelist2(120+5*(i-1)+j,3)=i+60
            else
            nodelist2(120+5*(i-1)+j,1)=nodelist1(20+i,j)
            nodelist2(120+5*(i-1)+j,2)=nodelist1(20+i,1)
            nodelist2(120+5*(i-1)+j,3)=i+60
          endif
          ireg1(120+5*(i-1)+j)=20+i
11        continue
12        continue


       do 14 i=1,ntri
         do 13 j=1,3
       trianglesx(i,j)=vnodes(nodelist2(i,j),1)
       trianglesy(i,j)=vnodes(nodelist2(i,j),2)
       trianglesz(i,j)=vnodes(nodelist2(i,j),3)
13         continue
14      continue

      kounter=0
      do 19 i=1,ntri
        kounterold=kounter
        do 16 j=0,ndiv
          do 15 k=0,ndiv-j
            kounter=kounter+1
            vnodes2(kounter,1)=trianglesx(i,1)
     &+real(k)/real(ndiv)*(-trianglesx(i,1)+trianglesx(i,2))
     &+real(j)/real(ndiv)*(-trianglesx(i,1)+trianglesx(i,3))
            vnodes2(kounter,2)=trianglesy(i,1)
     &+real(k)/real(ndiv)*(-trianglesy(i,1)+trianglesy(i,2))
     &+real(j)/real(ndiv)*(-trianglesy(i,1)+trianglesy(i,3))
            vnodes2(kounter,3)=trianglesz(i,1)
     &+real(k)/real(ndiv)*(-trianglesz(i,1)+trianglesz(i,2))
     &+real(j)/real(ndiv)*(-trianglesz(i,1)+trianglesz(i,3))
          vnorm=vnodes2(kounter,1)**2+vnodes2(kounter,2)**2
     &+ vnodes2(kounter,3)**2
           vnorm=sqrt(vnorm)
           vnodes2(kounter,1)=vnodes2(kounter,1)/vnorm   
           vnodes2(kounter,2)=vnodes2(kounter,2)/vnorm   
           vnodes2(kounter,3)=vnodes2(kounter,3)/vnorm   
15        continue
16      continue
      kounter2=1
      do 18 j=1,ndiv
        iadd=ndiv
         isum=0
         isumold=0
        do 17 k=1,2*j-1
         if(mod(k,2).eq.1)isum=isum+iadd

         if(mod(k,2).eq.0)then
         nodelist3((i-1)*ndiv**2+kounter2,1)=kounterold+j+isumold
         nodelist3((i-1)*ndiv**2+kounter2,2)=kounterold+j+1+isum
         nodelist3((i-1)*ndiv**2+kounter2,3)=kounterold+j+isum
         else
         nodelist3((i-1)*ndiv**2+kounter2,1)=kounterold+j+isumold
         nodelist3((i-1)*ndiv**2+kounter2,2)=kounterold+j+1+isumold
         nodelist3((i-1)*ndiv**2+kounter2,3)=kounterold+j+1+isum
       endif
          ireg2((i-1)*ndiv**2+kounter2)=ireg1(i)

         if(mod(k,2).eq.0)isumold=isum
         if(mod(k,2).eq.1)iadd=iadd-1
         kounter2=kounter2+1
17        continue
18      continue

19    continue
      

       do 21 i=1,ntri2
         do 20 j=1,3
       triangles2x(i,j)=vnodes2(nodelist3(i,j),1)
       triangles2y(i,j)=vnodes2(nodelist3(i,j),2)
       triangles2z(i,j)=vnodes2(nodelist3(i,j),3)
20         continue
21      continue

      do 25 i=1,ntri2

        x1(3*(i-1)+1)=triangles2x(i,1)
        x1(3*(i-1)+2)=triangles2x(i,2)
        x1(3*(i-1)+3)=triangles2x(i,3)

        y1(3*(i-1)+1)=triangles2y(i,1)
        y1(3*(i-1)+2)=triangles2y(i,2)
        y1(3*(i-1)+3)=triangles2y(i,3)

        z1(3*(i-1)+1)=triangles2z(i,1)
        z1(3*(i-1)+2)=triangles2z(i,2)
        z1(3*(i-1)+3)=triangles2z(i,3)

C        write(6,*)x1(i),y1(i),z1(i)," triangles "

25    continue

C
      do 200 i=1,ntri*(ndiv**2+3*ndiv+2)/2
       kkount=0
       do 190 j=2,ntri*(ndiv**2+3*ndiv+2)/2
         k=ntri*(ndiv**2+3*ndiv+2)/2-j+2
         dist=(vnodes2(i,1)-vnodes2(k,1))**2
     &+(vnodes2(i,2)-vnodes2(k,2))**2
     &+(vnodes2(i,3)-vnodes2(k,3))**2
          if(dist.le.1e-10.and.i.ne.k)then
            kkount=kkount+1
            ilist(i,kkount)=k  
C           write(6,*)ilist(i,kkount),i,kkount
         endif
190    continue
200   continue
C
C     remove unnecessary nodes from nodelist3
      do 300 i=1,ntri*(ndiv**2+3*ndiv+2)/2
        do 290 j=1,5
          if(ilist(i,j).ne.0)then
            if(ilist(i,j).gt.i)then
            vnodes2(ilist(i,j),1)=-1e12
            vnodes2(ilist(i,j),2)=-1e12
            vnodes2(ilist(i,j),3)=-1e12
            endif

            do 280 k=1,ntri2
       if(nodelist3(k,1).eq.ilist(i,j))then
       if(nodelist3(k,1).gt.i)then
           nodelist3(k,1)=i
       endif
       endif
       if(nodelist3(k,2).eq.ilist(i,j))then
       if(nodelist3(k,2).gt.i)then
          nodelist3(k,2)=i
       endif
       endif
       if(nodelist3(k,3).eq.ilist(i,j))then
       if(nodelist3(k,3).gt.i)then
          nodelist3(k,3)=i
       endif
       endif
280         continue
          endif
290     continue

300   continue

      kounter=0
      do 310 i=1,ntri*(ndiv**2+3*ndiv+2)/2
         if(vnodes2(i,1).gt.-1e6)then
           kounter=kounter+1
           vnode6(kounter,1)=vnodes2(i,1)
           vnode6(kounter,2)=vnodes2(i,2)
           vnode6(kounter,3)=vnodes2(i,3)
C       rename node numbers in nodelist3
        do 305 j=1,ntri2
          if(nodelist3(j,1).eq.i)nodelist3(j,1)=kounter
          if(nodelist3(j,2).eq.i)nodelist3(j,2)=kounter
          if(nodelist3(j,3).eq.i)nodelist3(j,3)=kounter
305     continue
        endif
310   continue

      open(1,file="Target.dat")
      nlists=1
      iout=-2
      ntet=200
      nface=ntri2
      nvc=kounter
      npolh=1
      write(1,*)nface,3
C
C      2D texture coordinates
      do 320 i=1,ntri2
        write(1,*) vnode6(nodelist3(i,1),1)*radius*10
     &            ,vnode6(nodelist3(i,1),2)*radius*10
     &            ,vnode6(nodelist3(i,1),3)*radius*10-2
        write(1,*) vnode6(nodelist3(i,2),1)*radius*10
     &            ,vnode6(nodelist3(i,2),2)*radius*10
     &            ,vnode6(nodelist3(i,2),3)*radius*10-2
        write(1,*) vnode6(nodelist3(i,3),1)*radius*10
     &            ,vnode6(nodelist3(i,3),2)*radius*10
     &            ,vnode6(nodelist3(i,3),3)*radius*10-2
320   continue
C     Face pointer list, last points to next (non existant) polyhedron
C      write(1,*)(1+(i-1)*3,i=1,ntri2+1)
C     Face type list
C      write(1,*)(1,i=1,ntri2)
C     Face node list
C     do 330 i=1,ntri2
C       write(1,*)(nodelist3(i,k),k=1,3)
C330   continue
C      write(1,*)(ireg2(i),i=1,ntri2)
C     
C
C
C      was used for GEOMPACK didnt work.
C      write(1,*)1,ntri2+1
C     polyhedron face list
C      write(1,*)(i,i=1,ntri2)
C
      stop  
      end   
