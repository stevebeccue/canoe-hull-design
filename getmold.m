## This code is Copyright (C) 2023 Steve Beccue
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



% a waterline of mx+b intersects the polyline [ plx, ply ]  return polyline of submerged mold
function [newmold] = getmold( plx, ply, m, b, NUMPTS )
  if( m < 0 ) printf( "make slope (m) non-negative"); return; endif
  ReportErrors = 0;     % set to 1 to have numerical problems reported
  errors = 0;
  count = 0;
  copy = 1;
  copyind = 1;
  mold = [ plx; ply ];
  mold = mold';
  mold = vertcat( mold, flip([ mold(:,1)*(-1.0), mold(:,2) ]));
  N = size( mold,1 );
  startind = NUMPTS/2;
  start = [mold(startind+1),1, mold(startind+1), 2];

  for iii = startind:1:startind+N-1
    i = mod( iii, N-1)+1;
    x3 = mold(i,1); y3 = mold(i,2);
    x4 = mold(i+1,1); y4 = mold(i+1,2);
    x1 = x3;
    x2 = x4;
    y1 = x3*m + b;
    y2 = x4*m + b;
    if( y1 == y3 || y2 == y4 ) printf( "IMPOSSIBLE" ); pause(); endif

    if( copy == 1 )
      newmold(copyind,1 ) = mold(i,1);
      newmold(copyind,2 ) = mold(i,2);
      copyind = copyind+1;
    endif
    
    % intersection    
    if( (((y1 < y3) && (y2 > y4)) || ((y1 > y3) && (y2 < y4))) || (((y1 < y4) && (y2 > y3)) || ((y1 > y4) && (y2 < y3)))  )
        count = count + 1;									 
        pt = [x1*y2-x2*y1,x3*y4-x4*y3]/[y2-y1,y4-y3;(x1-x2),(x3-x4)];
        newmold( copyind,1 ) = pt(:,1);
        newmold( copyind,2 ) = pt(:,2);
        copyind = copyind+1;
        if( copy == 1 ) copy = 0; else copy = 1; endif
    endif
  endfor

%plot( newmold(:,1), newmold(:,2),wl(:,1),wl(:,2)  );
  if( count != 2 )
    errors = errors + 1;
    if( ReportErrors )
       printf( "newmold: Numberical error at m=%g, b=%g.  %d points of intersection\n", m , b, count );
       printf( "Retry with m=%g, b=%g\n", m , b+0.0001*errors );
     endif
     newmold = getmold( plx, ply, m, b+(0.0001*errors),NUMPTS );
  endif
endfunction
