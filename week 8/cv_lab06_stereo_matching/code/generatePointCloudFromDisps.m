function coords = generatePointCloudFromDisps(disps, PR, PL, Hright, Hleft)
    
% for each pixel (x,y) find the corresponding 3D point
% P2 = Hright*PR ;
% P1 = Hleft*PL ;
P2 = PR ;
P1 = PL ;
coords = zeros([size(disps) 3]);

for y=1:size(disps,1)
    for x=1:size(disps,2)
        %problem
        coords(y,x,1:3) = linTriang(Hleft\[x,y],Hleft\[x-disps(y,x),y],P1,P2) ;
    end
end

end
