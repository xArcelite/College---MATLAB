%I do not know if Jacobians are allowed, but would this count as solutions
%to part 2 and 3?

close all; clear;
theta1=0;d1=0;a1=10;alpha1=0; %Link 1 Parameters.
theta2=0;d2=0;a2=10;alpha2=0; %Link 2 Parameters.

deltatheta1=0;deltatheta2=0; deltatheta3=0; %Theta 1, Theta 2 and Velocity
Xc=7.1;Yc=10;
a=0;b=0;

while a==0
    while b==0
%%Setting the constraints
theta1=theta1+deltatheta1/2;
theta2=theta2+deltatheta2/2;
T01=DHmatrix(theta1,d1,a1,alpha1);
T12=DHmatrix(theta2,d2,a2,alpha2);
T02=T01*T12;
P0=[0 0];
P1=transpose(T01(1:2,4));
P2=transpose(T02(1:2,4));
Q1=[P0(1,1) P1(1,1) P2(1,1)];
Q2=[P0(1,2) P1(1,2) P2(1,2)];
disp('End Effector Positions:');disp(T02);
        
%%setting up the grid
plot(Q1,Q2,'-o','LineWidth',3);
axis([-31,31,-31,31]);
grid on;

%%Starting the Jacobian
%Linear velocity jacobian
%Prismatic Equation used: Jv = zi-1
%Revolute Equation used: Jv = zi-1 x (on - oi-1)
Z0=[0;0;1];O=[0;0;0];O2=T02(1:3,4);
Jv1=cross(Z0,(O2-O));
Z1=T01(1:3,3);O1=T01(1:3,4);
Jv2=cross(Z1,(O2-O1));
Jv=[Jv1 Jv2];
disp('Jv:'); disp(Jv);
        
Xi=P2(1,1);Yi=P2(1,2);
Xf=Xc;Yf=Yc; 
Xv=(Xf-Xi);
Yv=(Yf-Yi);
        
%Pseudoinverse Jacobian
        ThetaV=pinv(Jv)*[Xv;Yv;0];
        OrinFinal=atan2d(Yf,Xf);
        OrinStart=atan2d(Yi,Xi);
        Dis_Error=sqrt(Xf^2+Yf^2)- sqrt(Xi^2+Yi^2);
        Orin_error=OrinFinal-OrinStart;
        if abs(Dis_Error)<=0.2 && abs(Orin_error)<=2
            b=1;
        end
        Theta1V=ThetaV(1,1);
        Theta2V=ThetaV(2,1);
        disp('thetadot:');disp(ThetaV);
       
        deltatheta1=radtodeg(Theta1V);
        deltatheta2=radtodeg(Theta2V);
        deltatheta=[deltatheta1;deltatheta2];
        disp('deltatheta');disp(deltatheta);
    end
    if b==1
       [Xc,Yc,buttons] = ginput;
       b=0;
    end
end
