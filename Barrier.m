%Barrera para Proyecto Optimización
clear all
clc
warning('off')
syms x1 x2 x3 x4 x5 x6 c
vars = [x1 x2 x3 x4 x5 x6];

%Tenemos la función objetiva y conjunto de restricciones de nuestro proyecto 
f= 0.25*x1 + 0.3*x2 + 0.35*x3 + 0.85*x4 + 0.75*x5 + 0.9*x6
r = [-0.06*x1 - 0.14*x2 - 0.3*x3 - 0.6*x4 - 0.8*x5 - 0.9*x6 + 2750000;
     x4 + x5 - 600000;
     x1 - 1500000;
     - x2 + 500000;
     - x4 + 90000;
     x4 - 290000;
     x3 - (70)*x4^0.5] 
    

%Encontrar el q 
q = f;
for i=1:length(r)
    q = q -c*(log(r(i)));
end
q


%Gradiente de q y ecuaciones obtenidas
delta_q = [];
for i=1:length(vars)
    delta_q = [delta_q; diff(q,vars(i))];
end
delta_q

eq1 = delta_q(1)
eq2 = delta_q(2)
eq3 = delta_q(3) 
eq4 = delta_q(4) 
eq5 = delta_q(5) 
eq6 = delta_q(6) 

disp("-----Se esta resolviendo el sistema de ecuaciones aplicando el método de Barrera-----")
%Resuelve el sistema de ecuaciones anteriores  
%disp("CHECKPOINT 0.0")
[solx1,solx2,solx3,solx4,solx5,solx6]= solve(eq1==0,eq2==0,eq3==0,eq4==0,eq5==0,eq6==0);
%disp("CHECKPOINT 0.1")
%Posibles soluciones de las variables al aplicar el metodo de barrera 
%disp("-----Para x1-----")
sol_x1 = [];
for i=1:length(solx1)-1
    sol_x1 = [sol_x1 double(limit(solx1(i)))];
end
sol_x1;

%disp("-----Para x2-----")
sol_x2 = [];
for i=1:length(solx2)-1
    sol_x2 = [sol_x2 double(limit(solx2(i)))];
end
sol_x2;

%disp("-----Para x3-----")
sol_x3 = [];
for i=1:length(solx3)-1
    sol_x3 = [sol_x3 double(limit(solx3(i)))];
end
sol_x3;

%disp("-----Para x4-----")
sol_x4 = [];
for i=1:length(solx4)-1
    sol_x4 = [sol_x4 double(limit(solx4(i)))];
end
sol_x4;

%disp("-----Para x5-----")
sol_x5 = [];
for i=1:length(solx5)-1
    sol_x5 = [sol_x5 double(limit(solx5(i)))];
end
sol_x5;

%disp("-----Para x6-----")
sol_x6 = [];
for i=1:length(solx6)-1
    sol_x6 = [sol_x6 double(limit(solx6(i)))];
end
sol_x6;
%Ahora hay que mirar la factibilidad!!!!!!
disp("-----Hemos obtenido soluciones para las variables!-----") 
disp("-----Ahora se verifica factibilidad con restricciones-----")
disp("-----(dura aproximadamente 2 minutos)-----")

%disp("CHECKPOINT 0")
%Para r1
real_ones_r1 = [];
[a,b,c,d,e,f] = ndgrid(sol_x1,sol_x2,sol_x3,sol_x4,sol_x5,sol_x6);
pairs = [a(:) b(:) c(:) d(:) e(:) f(:)];
for i=1:length(pairs)
    fact1 = subs(r(1),[x1,x2,x3,x4,x5,x6],[pairs(i,1),pairs(i,2),pairs(i,3),pairs(i,4),pairs(i,5),pairs(i,6)]);
    if double(fact1) <= 0
        real_ones_r1 = [real_ones_r1; pairs(i,1),pairs(i,2),pairs(i,3),pairs(i,4),pairs(i,5),pairs(i,6)];
    end
end
real_ones_r1 = unique(real_ones_r1,'rows');

%disp("CHECKPOINT 1")

%para r2 
real_ones_r2 = [];
[p,q,s] = meshgrid(sol_x4, sol_x5,sol_x6);
pairas = [p(:) q(:) s(:)];
for i=1:length(pairas)
    fact1 = subs(r(2),[x4,x5,x6],[pairas(i,1),pairas(i,2),pairas(i,3)]);
    if fact1 <= 0
        real_ones_r2 = [real_ones_r2; pairas(i,1),pairas(i,2),pairas(i,3)];
    end
end
real_ones_r2 = unique(real_ones_r2,'rows');

%disp("CHECKPOINT 2")

%para r3
real_ones_r3 = [];
for i=1:4
    fact3 = subs(r(3),x1,sol_x1(i));
    if double(fact3) <= 0
       real_ones_r3 = [real_ones_r3; sol_x1(i)];
    end
end
real_ones_r3 = unique(real_ones_r3,'rows');

%disp("CHECKPOINT 3")

%para r4
real_ones_r4 = [];
for i=1:4
    fact4 = subs(r(4),x2,sol_x2(i));
    if double(fact4) <= 0
        real_ones_r4 = [real_ones_r4; sol_x2(i)];
    end
end
real_ones_r4 = unique(real_ones_r4,'rows');

%disp("CHECKPOINT 4")


%para r5
real_ones_r5 = [];
for i=1:4
    fact5 = subs(r(5),x4,sol_x4(i));
    if double(fact5) <= 0
        real_ones_r5 = [real_ones_r5; sol_x4(i)];
    end
end
real_ones_r5 = unique(real_ones_r5,'rows');

%disp("CHECKPOINT 5")


%para r6
real_ones_r6 = [];
for i=1:4
    fact6 = subs(r(6),x4,sol_x4(i));
    if double(fact6) <= 0
        real_ones_r6 = [real_ones_r6; sol_x4(i)];
    end
end
real_ones_r6 = unique(real_ones_r6,'rows');

%disp("CHECKPOINT 6")


%para r7
real_ones_r7 = [];
[t,u] = meshgrid(sol_x3, sol_x4);
paires = [t(:) u(:)];
%length(pairs)
for i=1:length(paires)
    fact7 = subs(r(7),[x3,x4],[paires(i,1),paires(i,2)]);
    if double(fact7) == 0
        real_ones_r7 = [real_ones_r7; paires(i,1),paires(i,2)];
    end
end
real_ones_r7 = unique(real_ones_r7,'rows');

%disp("CHECKPOINT 7")

%Con los valores FIJOS encontrados para ciertas variables volvemos a correr la sección anterior para obtener los valores FIJOS de las otras variables  

%Para r1
ror1 = [];
for i=1:length(real_ones_r2)
    fact1 = subs(r(1),[x1,x2,x3,x4,x5,x6],[real_ones_r3(1),real_ones_r4(1),real_ones_r7(1,1),real_ones_r7(1,2),real_ones_r2(i,2),real_ones_r2(i,3)]);
    if double(fact1) <= 0
        ror1 = [ror1; real_ones_r3(1),real_ones_r4(1),real_ones_r7(1,1),real_ones_r7(1,2),real_ones_r2(i,2),real_ones_r2(i,3)];
    end
end
ror1 = unique(ror1,'rows');

%disp("CHECKPOINT 8")


%para r2 NO TOCAR
ror2 = [];
for i=1:3
    fact2 = subs(r(2),[x4,x5,x6],[real_ones_r7(1,2),ror1(i,5),ror1(i,6)]);
    if double(fact2) <= 0
        ror2 = [ror2; real_ones_r7(1,2),ror1(i,5),ror1(i,6)];
    end
end
ror2 = unique(ror2,'rows');

%disp("CHECKPOINT 9")


%Ya tenemos los valores para todas las variables sin embargo, para unas
%variables hay multiples valores que son factibles
%Entonces sistituimos los valores en la FO y encontramos los valores que
%produzca el max valor 
f= 0.25*x1 + 0.3*x2 + 0.35*x3 + 0.85*x4 + 0.75*x5 + 0.9*x6;
sol1 = subs(f, [x1,x2,x3,x4,x5,x6], [real_ones_r3(1),real_ones_r4(1),real_ones_r7(1,1),real_ones_r7(1,2),ror2(1,2),ror2(1,3)]); 
sol2 = subs(f, [x1,x2,x3,x4,x5,x6], [real_ones_r3(1),real_ones_r4(1),real_ones_r7(1,1),real_ones_r7(1,2),ror2(2,2),ror2(2,3)]);

%La Solución
disp("-----Tenemos la siguiente solución al problema no lineal!-----")
if sol1 > sol2
    disp("Para x1")
    solucion_r1 = real_ones_r3(1)
    disp("Para x2")
    solucion_r2 = real_ones_r4(1)
    disp("Para x3")
    solucion_r3 = real_ones_r7(1,1)
    disp("Para x4")
    solucion_r4 = real_ones_r7(1,2)
    disp("Para x5")
    solucion_r5 = ror2(1,2)
    disp("Para x6")
    solucion_r6 = 3000000 - (solucion_r1 + solucion_r2 + solucion_r3 + solucion_r4 + solucion_r5) 
else
    disp("Para x1")
    solucion_r1 = real_ones_r3(1)
    disp("Para x2")
    solucion_r2 = real_ones_r4(1)
    disp("Para x3")
    solucion_r3 = real_ones_r7(1,1)
    disp("Para x4")
    solucion_r4 = real_ones_r7(1,2)
    disp("Para x5")
    solucion_r5 = ror2(2,2) 
    disp("Para x6")
    solucion_r6 = 3000000 - (solucion_r1 + solucion_r2 + solucion_r3 + solucion_r4 + solucion_r5) 
end    