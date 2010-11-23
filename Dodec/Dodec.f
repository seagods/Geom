      double precision pi
      integer npent, nvertex
      parameter(npent=2, nvertex=5)

C     vertices of a template pentagon
      double precision  vertex(nvertex,3)
C     vertices of npent pentagons + radii and shifts from template
      double precision pentvert(nvertex,3,npent), radius(npent)
      double precision shift(npent,3)
C     node list for output to graphics prog
      integer nodelist(nvertex,npent)
      integer nodenumber(npent*nvertex)
C
      pi=acos(-1.)

C     Big Phi Golden Section     
      p1=.5d0*(sqrt(5d0)+1d0)
C     Little Phi Golden Section
      p2=.5d0*(sqrt(5d0)-1d0)

      coz18=.5*sqrt(2.5*(1.+1./sqrt(5.)))
      sin18=abs(p2/2.)
      coz36=p1/2.
      sin36=.5*sqrt(2.5*(1.-1./sqrt(5.)))
      coz54=sin36
      sin54=coz36
      coz72=sin18
      sin72=coz18


      vertex(1,1)=sqrt(2d0+p1)/2d0
      vertex(1,2)=p2/2d0
      vertex(1,3)=0d0

      vertex(2,1)=0d0
      vertex(2,2)=1d0
      vertex(2,3)=0d0

      vertex(3,1)=-sqrt(2d0+p1)/2d0
      vertex(3,2)=p2/2d0
      vertex(3,3)=0d0

      vertex(4,1)=-sqrt(2d0-p2)/2d0
      vertex(4,2)=-p1/2d0
      vertex(4,3)=0d0

      vertex(5,1)=sqrt(2d0-p2)/2d0
      vertex(5,2)=-p1/2d0
      vertex(5,3)=0d0

      do 10 i=1,npent
        shift(i,1)=dble(i-1)
        shift(i,2)=dble(i-1)
        shift(i,3)=dble(i-1)
10    continue
      do 20 i=1,npent
       radius(i)=0.4*dble(i)
20    continue

      do 50 k=1,npent
        do 40 i=1,nvertex
          nodenumber(i+(k-1)*nvertex)=i+(k-1)*nvertex
          pentvert(i,1,k)=vertex(i,1)*radius(k)+shift(k,1)
          pentvert(i,2,k)=vertex(i,2)*radius(k)+shift(k,2)
          pentvert(i,3,k)=vertex(i,3)*radius(k)+shift(k,3)
40      continue          
50    continue


      open(1,file="pentagons.dat",status="unknown")
      write(1,*)npent,nvertex

      do 100 k=1,npent
        do 90 j=1,nvertex
          write(1,*)
     &    nodenumber(j+(k-1)*nvertex),
     &    pentvert(j,1,k),pentvert(j,2,k),pentvert(j,3,k)
90      continue
100   continue
      do 110 i=1,npent*nvert
         write(1,*)nodenumber(i)
110   continue


      write(6,*)"p2=",p2
C
      stop  
      end   
