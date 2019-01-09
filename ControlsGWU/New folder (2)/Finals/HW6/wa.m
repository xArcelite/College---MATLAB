circleCenter = [13; 13]; 
radius = 2; 

for phi = 0:0.4:2*pi 
xCircle = radius*cos(phi) + circleCenter(1); 
yCircle = radius*sin(phi) + circleCenter(2); 
scatter(xCircle,yCircle,'filled','r'); 
end
