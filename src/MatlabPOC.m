% Experiments with optimizing load between data centres
% Proof of Concept
% S. Smith
% Feb 15, 2023

Cr = 0.01;  %cost of renewable energy (could be changed to be different for each data centre
Cg = 0.009; %cost of grid energy
L = 14;     %total computational load
TL = 3e-5;  %tranmission loss

l1max = 6;   %max load at data centre 1
l2max = 2;   %max load at data centre 2
l3max = 3;   %max load at data centre 2
l4max = 4;   %max load at data centre 2

r1max = 5;   %max renewable at data centre 1
r2max = 1;   %max renewable at data centre 2
r3max = 1;   %max renewable at data centre 2
r4max = 1;   %max renewable at data centre 2

p1max = 100;     %max renewable at data centre 1
p2max = 100;     %max renewable at data centre 2
p3max = 100;     %max renewable at data centre 2
p4max = 100;     %max renewable at data centre 2

d1 = 5000;    %distance from power plant to data centre 1
d2 = 6000;   %distance from power plant to data centre 2
d3 = 900;   %distance from power plant to data centre 3
d4 = 12000;    %distance from power plant to data centre 4

%objective function, minimize f*x, x = [r1 r2 r3 r4 p1 p2 p3 p4]
f = [Cr Cr Cr Cr Cg Cg Cg Cg];

%inequality less than constraints, r_i + p_i((1-TL*di) <= l^max_i, A*x <= b
A = [1 0 0 0 (1-TL*d1) 0 0 0;
     0 1 0 0 0 (1-TL*d2) 0 0;
     0 0 1 0 0 0 (1-TL*d3) 0;
     0 0 0 1 0 0 0 (1-TL*d4)];
b = [l1max; l2max; l3max; l4max];

%equality constraint, sigma ri + sigma pi = L, Aeq*x = beq
Aeq = [1 1 1 1 (1-TL*d1) (1-TL*d2) (1-TL*d3) (1-TL*d4)];
beq = [L];

%lower bound and upper bound
lb = [0 0 0 0 0 0 0 0];
ub = [r1max r2max r3max r4max p1max p2max p3max p4max];

%minimize cost to solve for x
x = linprog(f, A, b, Aeq, beq, lb, ub)
