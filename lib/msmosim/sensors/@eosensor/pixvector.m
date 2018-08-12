function [ es ] = pixvector(this, pix_row, pix_col )
% This function outputs unit vectors from the edges of a pixel toward the aperture of the
% pin hole camera model in sensor coordinate sytems;

e1y = ( pix_col - 1)*this.pixwidth - this.ipwidth/2 ;
e1z = ( pix_row - 1)*this.pixheight - this.ipheight/2 ;

e2y = e1y + this.pixwidth;
e2z = e1z;

e3y = e2y;
e3z = e2z + this.pixheight;

e4y = e1y;
e4z = e3z;

vect1 = [this.F, -e1y, -e1z ]';
u1 = vect1/norm(vect1);

vect2 = [this.F, -e2y, -e2z ]';
u2 = vect2/norm( vect2 );

vect3 = [this.F, -e3y, -e3z ]';
u3 = vect3/norm(vect3);

vect4 =  [this.F, -e4y, -e4z ]';
u4 = vect4/norm(vect4);

es = [ vect1, vect2, vect3, vect4 ];



