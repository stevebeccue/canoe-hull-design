## This code is Copyright (C) 2023 Steve Beccue
##
## dxfwrite.m is copyright by
## Copyright (C) 2004 Patrick Labbe
## Copyright (C) 2004 Laurent Mazet <mazet@crm.mot.com>
## Copyright (C) 2005 Larry Doolittle <ldoolitt@recycle.lbl.gov>
#  this was slightly modified and included as dxfwrite2.m
## polylineCentroid.m is copyright by
## Copyright (C) 2021 David Legland
# it is included here
##
##  Thank you to the above authors.
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; If not, see <http://www.gnu.org/licenses/>.



% definitions of canoe and my parameters.
% mold7 is the center hull shape, and shapes are symetric; i.e. mold6 = mold8, etc.
% there are 13 molds specifying the hull shape
% units are pounds and inches
% the prow is not specified in this file							     
HEIGHT = 11.0;            % matthew's is 12.0  
WIDTH7 =17.0;             % matthew's is 17.0
LENGTH= 14*12.0;          % matthew's is 18*12
MYWEIGHT = 250;
CANOEWEIGHT = 40;
NUMPTS = 400;             % arbitrary indpendent parametric variable points. suggest 400
NN     = NUMPTS*.54;      % This constant can be adjusted to alter all hull shapes.  Mostly tubmlehome
water_lbs_per_cubic_inch = 0.036127;
Plotheelflag = 1;         % produce a plot of restoring moment vs heel angle

Lwl = LENGTH - 2*3.5;  %  subtract for prow curve
draft_filename = "displacement_vs_draft.jpg";
stability_filename = "stability_at_max_heel.jpg";
stability_plot_filename = "stability_vs_heel.jpg";

%%%%%%%%%%%%%%%%%%
% note Center of Gravity
% human CG is about 8.37" forward of back and 9.13" above seat (normal sitting)
CGy=9.13+6; CGx=0.0;
CG=[CGx CGy];
%CG=[CGx CGy+3];   % explore change in CG to stability

%%%%%%%%%%%%%%%%%%
% hull molds (right halves) are determined parametrically by trivial polynomials.
% Alter the coefficients at will to set the hull shape.  

% independent parametric variable
t = linspace( 0, NUMPTS, NUMPTS+1 );
%tt = t/54;                      % The constant can be adjusted to alter all hull shapes.
tt = t/NN;

%mold 7
x7 = ((tt)  - 0.15*(tt.^3) );   % The constant can be adjusted to alter hull shape.  Mostly tumblehome shape
xmax7 = max(x7);
x7 = WIDTH7*x7/xmax7;

ytmp = ((tt./1).^3);            % again, change constant to affect hull shape.
ytmpheight = max( ytmp );
y7 = ytmp*HEIGHT/ytmpheight;
points7=[];

tumblehome = WIDTH7 - x7(NUMPTS);   % calculate for this mold only
%%%%%%%%%%%%
%mold 6 and 8
WIDTH6 = 16.5;
%x6 = (sin(tt) - 0.09*tt);
x6 = ((tt)  - 0.15*(tt.^3) );
xmax6 = max(x6);
x6 = WIDTH6*x6/xmax6;

ytmp = ((tt./1).^3);  
ytmpheight = max( ytmp );
y6 = ytmp*HEIGHT/ytmpheight;
points6=[];

%%%%%%%%%%%%
%mold 5 and 9
WIDTH5 = 14.7;
x5 = ((tt)  - 0.15*(tt.^3) );
xmax5 = max(x5);
x5 = WIDTH5*x5/xmax5;
ytmp = ((tt./1).^3);  
ytmpheight = max( ytmp );
y5 = ytmp*HEIGHT/ytmpheight;
points5=[];

%%%%%%%%%%%%
%mold 4 and 10
WIDTH4 = 12.7;
HEIGHT4 = 11.3;
x4 = ((tt)  - 0.15*(tt.^3) );
xmax4 = max(x4);
x4 = WIDTH4*x4/xmax4;
ytmp = ((tt./1).^3);  
ytmpheight = max( ytmp );
y4 = ytmp*HEIGHT4/ytmpheight;
points4=[0,11; 3,11; 3,HEIGHT4;x4(NUMPTS),HEIGHT4];
%points4=[11,11,11,11,HEIGHT4,HEIGHT4,HEIGHT4];


%%%%%%%%%%%%
%mold 3 and 11
WIDTH3 = 10.0;
HEIGHT3 = 11.9;
x3 = ((tt)  - 0.145*(tt.^3) );
xmax3 = max(x3);
x3 = WIDTH3*x3/xmax3;
ytmp = ((tt./1).^3);  
ytmpheight = max( ytmp );
y3 = ytmp*HEIGHT3/ytmpheight;
points3=[0,11; 3,11; 3,HEIGHT3;x3(NUMPTS),HEIGHT3];

%%%%%%%%%%%%
%mold 2 and 12
WIDTH2 = 6.7;
ROCKER2 = 0.1;
HEIGHT2 = 13.3-ROCKER2;
x2 = ((tt)  - 0.13*(tt.^3) );
xmax2 = max(x2);
x2 = WIDTH2*x2/xmax2;
ytmp = (0.2*tt+ (tt./1).^3);  
ytmpheight = max( ytmp );
y2 = ytmp*HEIGHT2/ytmpheight+ROCKER2;
points2=[0,11; 3,11; 3,HEIGHT2+ROCKER2;x2(NUMPTS),HEIGHT2+ROCKER2];

%%%%%%%%%%%%
%mold 1 and 13
WIDTH1 = 3.0;
ROCKER1=0.4;
HEIGHT1 = 15.0-ROCKER1;
x1 = ((tt)    - 0.11*(tt.^3) );
xmax1 = max(x1);
x1 = WIDTH1*x1/xmax1;
ytmp = (0.35*tt + (tt./1).^3);
ytmpheight = max( ytmp );
y1 = ytmp*HEIGHT1/ytmpheight+ROCKER1;
points1=[0,11; 1.5,11; 1.5,HEIGHT1+ROCKER1;x1(NUMPTS),HEIGHT1+ROCKER1];

% end of mold definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


printf( "Beam = %3.1f"", Length = %3.1f"", Tumblehome = %3.2f"".\n", WIDTH7*2.0, LENGTH, tumblehome );

function pnts = square( x,y,step )
  pnts = [ x-step,y-step; x+step,y-step; x+step,y+step; x-step,y+step; x-step,y-step; ];
endfunction

function [dist] = distancePts( x1, y1, x2, y2 )
  dist = sqrt( (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) );
endfunction
  
function dxf_mold( filename, x, y,points )
  mold = [ x; y ];
  mold = mold';
  points = flip(points);
  mold = vertcat( mold,points );
  mold = vertcat( mold, flip([ mold(:,1)*(-1.0), mold(:,2) ]));
  hole = [ 1.49,10.24; 1.51,10.24; 1.51,10.26; 1.49,10.26; 1.49,10.24; ];
  hole2 = square( -1.5,10.25,.01);
  dxfwrite2( filename, mold, hole, hole2 );  % from github, but I should include it here
endfunction

% write out dxf for CNC generation
dxf_mold( "mold1.dxf", x1,y1,points1 );
dxf_mold( "mold2.dxf", x2,y2,points2 );
dxf_mold( "mold3.dxf", x3,y3,points3 );
dxf_mold( "mold4.dxf", x4,y4,points4 );
dxf_mold( "mold5.dxf", x5,y5,points5 );
dxf_mold( "mold6.dxf", x6,y6,points6 );
dxf_mold( "mold7.dxf", x7,y7,points7 );
printf( "See files mold[1-7].dxf for dxf files for CNC code generation.\n" );

% calculate weight vs draft
totalweight = MYWEIGHT+CANOEWEIGHT;
molddistance=(LENGTH-24)/12;   % 24" for 2 end molds
DRAFTMIN=1.5;
DRAFTMAX=4.0;
i=1;
mydraft = 0;
for draft_ind = DRAFTMIN:0.05:DRAFTMAX,
  draft(i) = draft_ind;
  volume(i) = 0.0;
  area(i) = 0.0;
  mold7area_below(i) = 0;
  for j = 1:NUMPTS-1,
    waterline = draft_ind;
    if  (y7(j) <= waterline)
       dx = x7(j+1) - x7(j);
       h = waterline - y7(i);
       mold7area_below(i) = mold7area_below(i) + 2 * dx * h;
       % *2 for left/right
       volume(i) = volume(i) + molddistance * 2 * dx * h;
       area(i) = area(i) + molddistance * 2 * ...  
       (distancePts( x7(j+1), y7(j+1),x7(j),y7(j)) + distancePts( x6(j+1), y6(j+1),x6(j),y6(j)) )/2.0;
    endif
     if  (y6(j) <= waterline)
       dx = x6(j+1) - x6(j);
       h = waterline - y6(i);
       % *4 because: 2x for left/right, 2x for fore/aft
       volume(i) = volume(i) + molddistance * 4 * dx * h;
       area(i) = area(i) + molddistance * 4 * ...
       (distancePts( x6(j+1), y6(j+1),x6(j),y6(j)) + distancePts( x5(j+1), y5(j+1),x5(j),y5(j)) )/2.0;
     endif
     if  (y5(j) <= waterline)
       dx = x5(j+1) - x5(j);
       h = waterline - y5(i);
       volume(i) = volume(i) + molddistance * 4 * dx * h;
       area(i) = area(i) + molddistance * 4 * ...
       (distancePts( x5(j+1), y5(j+1),x5(j),y5(j)) + distancePts( x4(j+1), y4(j+1),x4(j),y4(j)) )/2.0;
     endif
     if  (y4(j) <= waterline)
       dx = x4(j+1) - x4(j);
       h = waterline - y4(i);
       volume(i) = volume(i) + molddistance * 4 * dx * h;
       area(i) = area(i) + molddistance * 4 * ...
       (distancePts( x4(j+1), y4(j+1),x4(j),y4(j)) + distancePts( x3(j+1), y3(j+1),x3(j),y3(j)) )/2.0;
     endif
     if  (y3(j) <= waterline)
       dx = x3(j+1) - x3(j);
       h = waterline - y3(i);
       volume(i) = volume(i) + molddistance * 4 * dx * h;
       area(i) = area(i) + molddistance * 4 * ...
       (distancePts( x3(j+1), y3(j+1),x3(j),y3(j)) + distancePts( x2(j+1), y2(j+1),x2(j),y2(j)) )/2.0;
     endif
     if  (y2(j) <= waterline)
       dx = x2(j+1) - x2(j);
       h = waterline - y2(i);
       volume(i) = volume(i) + molddistance * 4 * dx * h;
       area(i) = area(i) + molddistance * 4 * ...
       (distancePts( x2(j+1), y2(j+1),x2(j),y2(j)) + distancePts( x1(j+1), y1(j+1),x1(j),y1(j)) )/2.0;
     endif
     if  (y1(j) <= waterline)
       dx = x1(j+1) - x1(j);
       h = waterline - y1(i);
       volume(i) = volume(i) + molddistance * 4 * dx * h;
       % currently ignoring this area.  say 4*12"*8.5"/2;
     endif
  endfor
  displacement(i) = water_lbs_per_cubic_inch * volume(i);
  if( mydraft == 0 ),
      if( displacement(i) > totalweight )
            mydraft = waterline;
            mydraftindex = i;
            newmold = getmold( x7,y7,0,waterline,NUMPTS);
            CB = polygonCentroid( newmold );
            target_area = CB(:,3);
       endif
  endif
  i = i + 1;
endfor


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make jpeg of hull displacement
hf = figure();
%set( hf, "visible","off");
set (0, "defaultlinelinewidth", 1.5);
 plot( draft,displacement, [DRAFTMIN,DRAFTMAX], [totalweight,totalweight] );
xlabel("inches of draft");
ylabel("lbs displaced");
title("displacement vs draft");
grid on;
print( hf,draft_filename,"-djpeg");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot molds
set (0, "defaultlinelinewidth", 2.5);
plot (0,CGy,x7,y7,x6,y6,x5,y5,x4,y4,points4(:,1),points4(:,2),x3,y3,points3(:,1),points3(:,2),x2,y2,points2(:,1),points2(:,2),x1,y1,points1(:,1),points1(:,2) )

xticks( 0:1:17);
yticks( -1:1:17);
grid on;
axis equal;

%heel=20;
%heelrad = heel*(pi/180);
%plot( 0*cos(heelrad),CGy*sin(heelrad),x7*cos(heelrad),y7*sin(heelrad));

prismatic_coef = volume(mydraftindex)/(Lwl*mold7area_below(mydraftindex));

printf( "Draft at %g lbs is %g inches.\n", totalweight, mydraft );
printf( "Freeboard %g"".  Center depth %g"".  See ""%s"".\n", (HEIGHT-mydraft), HEIGHT, draft_filename );	
printf( "Wetted surface = %7.2f sq"" = %5.2f sq ft\n", area(mydraftindex),area(mydraftindex)/12/12 );
printf( "Prismatic Coefficient = %5.3f\n", prismatic_coef );
				       
volume(mydraftindex)*water_lbs_per_cubic_inch;

% waterline, y = mx + b
% max heel is m=.94, b=-3.5;
m = 0.94;
b = -3.5;
%wl = [-1*(WIDTH7+1), -1*(WIDTH7+1)*m+b; (WIDTH7+1), (WIDTH7+1)*m+b ];
wl = [-1, -1*m+b; (WIDTH7+1), (WIDTH7+1)*m+b ];
mold = getmold( x7,y7,m,b,NUMPTS);
CB = polygonCentroid( mold );
printf( "Bouyant area is %4.1f %4.1f\n", CB(:,3),target_area );
% now place the CG for this heel
rotate_rads = atan(m);
rotate_CG = CG*[cos(rotate_rads),-1*sin(rotate_rads);sin(rotate_rads), cos(rotate_rads) ];

hf2 = figure();
%plot( mold(:,1), mold(:,2), CB(:,1), CB(:,2), wl(:,1), wl(:,2), rotate_CG(:,1),rotate_CG(:,2) );
CBb = CB(:,2) - (-1/m)*CB(:,1);
CBline = [ 0, 0*(-1/m)+CBb; 15, 15*(-1/m)+CBb ];
plot( mold(:,1), mold(:,2), CB(:,1), CB(:,2), wl(:,1), wl(:,2),rotate_CG(:,1),rotate_CG(:,2), CG(:,1),CG(:,2), CBline(:,1),CBline(:,2) );
xlabel( "inches" );
text( rotate_CG(:,1)+.4,rotate_CG(:,2), "CG at heel angle");
text( CB(:,1)+.4,CB(:,2), "Center of bouancy at heel angle");
text( CG(:,1)+.4,CG(:,2), "CG");
axis equal;
grid on;
check_statement = "";
if( CB(:,1) < rotate_CG(:,1) ) check_statement = "NOT"; endif
print( hf2, stability_filename,"-djpeg");
printf( "Maximum heel is M=%g= %5.2f degrees.  Center of Bouyancy = (%5.2f,%5.2f) is %s outboard of rotated CG X = %5.2f, so there is %s secondary stability\n", m, atand(m),CB(:,1),CB(:,2),check_statement,rotate_CG(:,1),check_statement );

if( Plotheelflag ) 
% plot of correcting moment vs heel
% this is a rough approximation, using the center mold.  It ignores the true shape of the hull in heel
gz = [];
heelangle = [];
CByinter = [];
i = 1;	  
for m = 0.1:.05:.9
    b = 3.0;
    area = target_area+1;
while( (area > target_area || area < target_area-5) && b > -3.5 )
    b = b -.01;
    wl = [-(WIDTH7+1), -(WIDTH7+1)*m+b; (WIDTH7+1), (WIDTH7+1)*m+b];
    mold = getmold( x7,y7,m,b,NUMPTS);
    CB = polygonCentroid( mold );
    area = CB(:,3);
endwhile
% if normal form of line is ax + by + c = 0;
% distance from (x0,y0) to line is |ax0 + by0 + c|/sqrt(a^2+b^2) is gz the "righting arm"
  CBy = CB(:,2) - (-1/m)*CB(:,1);
  CBline = [ 0, -0*(-1/m)+CBy; 15, 15*(-1/m)+CBy ];
  CBa = -1/m;
  CBb = -1;
  CBc = CBy;
  gz(i) =  ((CBa*CG(:,1) - CG(:,2) + CBc))/sqrt(CBa*CBa + CBb*CBb);
  heelangle(i) = atand(m);
  CByinter(i) = CBy;
  %printf( "max water %g\n", max(mold(:,2)));
if( max(mold(:,2)) > HEIGHT-0.01 )
    printf( "taking on water at %4.1f degrees\n", heelangle(i) );  
  endif
printf( "heel angle %4.1f degrees: righting arm %4.2f inches.\n", heelangle(i), gz(i) );

hf3 = figure();
%plot( mold(:,1), mold(:,2), CB(:,1), CB(:,2), wl(:,1), wl(:,2));
%plot( mold(:,1), mold(:,2), CB(:,1), CB(:,2), wl(:,1), wl(:,2),rotate_CG(:,1),rotate_CG(:,2), CG(:,1),CG(:,2), CBline(:,1),CBline(:,2) );
plot( mold(:,1), mold(:,2), CB(:,1), CB(:,2), wl(:,1), wl(:,2),CG(:,1),CG(:,2), CBline(:,1),CBline(:,2) );
yextent2 = (CBy + 2)/2;
ycenter = yextent2 - 1;
xextent = (max(mold(:,1)) - min(min(mold(:,1)),-1)) + 2 ;
xcenter = ( min(min(mold(:,1)),-1) + max(mold(:,1)) )/2;
ylim( [ -1, CBy+1 ] );
xlim( [ xcenter - xextent/2, xcenter + xextent/2 ] )
%xlabel( "inches" );
%text( rotate_CG(:,1)+.4,rotate_CG(:,2), "CG at heel angle");
if( max(mold(:,2)) > HEIGHT-0.01 )
  text( CG(:,1)+.4, CG(:,2)-5, "Taking on water");
endif
title1 = sprintf( "heel of %4.1f degrees", heelangle(i) );
title(title1);
text( CB(:,1)+.4,CB(:,2), "Center of bouancy at heel angle");
text( CG(:,1)+.4,CG(:,2), "CG");
axis equal;
grid on;
fn = sprintf( "stab%d", i );
print( hf3, fn, "-djpeg");

i = i + 1;
endfor	  


fig_heel = figure();
plot( heelangle, gz );
ylabel( "restoring moment (righting arm) - inches" );
xlabel( "heel - degrees");
%plot( heelangle, CByinter );
print( fig_heel, stability_plot_filename, "-djpeg" );
endif
