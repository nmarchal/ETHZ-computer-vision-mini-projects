function f = fminGoldStandard(p, xy, XYZ, w)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];

%compute squared geometric error
total = 0 ;
nbrPoint = size(xy,2) ;
for i = 1:nbrPoint
    newPoint = P*XYZ(:,i) ;
    scale = newPoint(3) ;
    newPoint = 1/scale*newPoint ;
    ErrorVector = (xy(:,i) - newPoint) ;
    total = total + (norm(ErrorVector(1:2)))^2 ;
end
    
%compute cost function value
f = total;
end