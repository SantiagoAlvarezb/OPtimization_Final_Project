%Barrera para Proyecto Optimización
clear all
clc
warning('off')
syms x1 x2 x3 x4 x5 x6 c
vars = [x1 x2 x3 x4 x5 x6];

%Tenemos la función objetiva y conjunto de restricciones de nuestro proyecto 
f= 0.25*x1 + 0.3*x2 + 0.35*x3 + 0.85*x4 + 0.75*x5 + 0.9*x6
r = [-0.06*x1 - 0.14*x2 - 0.3*x3 - 0.6*x4 - 0.8*x5 - 0.9*x6 + 100000;
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
[solx1,solx2,solx3,solx4,solx5,solx6]= solve(eq1==0,eq2==0,eq3==0,eq4==0,eq5==0,eq6==0);

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

%Ahora hay que mirar la factibilidad
disp("-----Hemos obtenido soluciones para las variables!-----") 
disp("-----Ahora se verifica factibilidad con restricciones-----")
disp("-----(dura aproximadamente 2 minutos)-----")

%Para r1: Miramos todas las posibles combinaciones de los valores sacados
%de las soluciones a ver cuales son factibles
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

%Para r2: Con los valores obtenidos en la sección de código anterior se
%sustituye los valores de x4 y x5 para mirar factibilidad en segunda
%restricción
real_ones_r2 = [];
for i=1:length(real_ones_r1)
    fact1 = subs(r(2),[x4,x5],[real_ones_r1(i,4),real_ones_r1(i,5)]);
    if fact1 <= 0
        real_ones_r2 = [real_ones_r2; real_ones_r1(i,4),real_ones_r1(i,5)];
    end
end
real_ones_r2 = unique(real_ones_r2,'rows');

%disp("CHECKPOINT 2")

%Para r3: Mismo procedimiento que el anterior 
real_ones_r3 = [];
for i=1:length(real_ones_r1)
    fact3 = subs(r(3),x1,real_ones_r1(i,1));
    if double(fact3) <= 0
       real_ones_r3 = [real_ones_r3; real_ones_r1(i,1)];
    end
end
real_ones_r3 = unique(real_ones_r3,'rows');

%Para r4: Mismo procedimiento que el anterior 
real_ones_r4 = [];
for i=1:length(real_ones_r1)
    fact4 = subs(r(4),x2,real_ones_r1(i,2));
    if double(fact4) <= 0
        real_ones_r4 = [real_ones_r4; real_ones_r1(i,2)];
    end
end
real_ones_r4 = unique(real_ones_r4,'rows');

%Para r5: Mismo procedimiento que el anterior
real_ones_r5 = [];
for i=1:length(real_ones_r1)
    fact5 = subs(r(5),x4,real_ones_r1(i,4));
    if double(fact5) <= 0
        real_ones_r5 = [real_ones_r5; real_ones_r1(i,4)];
    end
end
real_ones_r5 = unique(real_ones_r5,'rows');

%Para r6: Mismo procedimiento que el anterior
real_ones_r6 = [];
for i=1:length(real_ones_r1)
    fact6 = subs(r(6),x4,real_ones_r1(i,4));
    if double(fact6) <= 0
        real_ones_r6 = [real_ones_r6; real_ones_r1(i,4)];
    end
end
real_ones_r6 = unique(real_ones_r6,'rows');

%Para r7: Con los valores obtenidos de x3 y x4 que son factibles con las
%demas restricciones, se prueba factibilidad para la séptima restricción
real_ones_r7 = [];
for i=1:length(real_ones_r1)
    fact7 = subs(r(7),[x3,x4],[real_ones_r1(i,3),real_ones_r1(i,4)]);
    if double(fact7) == 0
        real_ones_r7 = [real_ones_r7; real_ones_r1(i,3),real_ones_r1(i,4)];
    end
end
real_ones_r7 = unique(real_ones_r7,'rows');

%Para r1 2.0: Volvemos a sustituir todos los valores obtenidos para asegurarnos
%de que se cumpla factibilidad de la primera restricción
ror1 = [];
for i=1:length(real_ones_r2)
    fact1 = subs(r(1),[x1,x2,x3,x4,x5,x6],[real_ones_r3(1),real_ones_r4(1),real_ones_r7(1,1),real_ones_r7(1,2),real_ones_r2(1,2),real_ones_r1(1,6)]);
    if double(fact1) <= 0
        ror1 = [ror1; real_ones_r3(1),real_ones_r4(1),real_ones_r7(1,1),real_ones_r7(1,2),real_ones_r2(1,2),real_ones_r1(1,6)];
    end
end
ror1 = unique(ror1,'rows');

%Ya tenemos los valores para todas las variables 
%La Solución
disp("-----Tenemos la siguiente solución al problema no lineal!-----")
    disp("Para x1")
    solucion_r1 = ror1(1)
    disp("Para x2")
    solucion_r2 = ror1(2)
    disp("Para x3")
    solucion_r3 = ror1(3)
    disp("Para x4")
    solucion_r4 = ror1(4)
    disp("Para x5")
    solucion_r5 = ror1(5)
    disp("Para x6")
    solucion_r6 = 3000000 - (solucion_r1 + solucion_r2 + solucion_r3 + solucion_r4 + solucion_r5) %Nos aseguramos en que no se vaya por encima del presupuesto    