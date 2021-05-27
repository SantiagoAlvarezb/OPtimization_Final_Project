%MODO SIMPLEX SILENCE PARA EL PROYECTO  
% Por favor ingrese las siguientes lineas en la terminal de Matlab y después llame
% la funcion: Simplex_silence(cost_fs, A_fs,b,h)
    %cost_fs = [0.25 0.3 0.3 0.85 0.75 0.9 0 0 0 0 0 0 0];
    %A_fs = [
    %         0.06 0.14 0.3 0.6 0.8 0.9 -1 0 0 0 0 0 0
    %         1 1 1 1 1 1 0 1 0 0 0 0 0  
    %         0 0 0 1 1 0 0 0 1 0 0 0 0;
    %         1 0 0 0 0 0 0 0 0 1 0 0 0;
    %         0 1 0 0 0 0 0 0 0 0 -1 0 0;
    %         0 0 0 1 0 0 0 0 0 0 0 -1 0;
    %         0 0 0 1 0 0 0 0 0 0 0 0 1];  
    %b = [100000;3000000;600000;1500000;500000;90000;290000];
    %h = 1;
    
function [M] = Simplex_silence(cost_fs, A_fs,b,h)
    % h == 1: Para problemas de MAXIMIZACIÓN
    % h == 0: Para problemas de MINIMIZACIÓN
    disp("SHHHHH! Silent Simplex is about to start")
    pause(1)
    disp(".")
    pause(1)
    disp(".")
    pause(1)
    disp(".")
    pause(1)
     
    %Primero se ejecuta el código sobre el método de las dos fases para
    %encontrar un punto inicial 
    [Ib,In] = phases(cost_fs, A_fs, b); 
    Ib;
    In;

    condicion = 1; 
    
    %Se entra al proceso iterativo del SIMPLEX
    while condicion == 1
        condicion = 0;
        
        %Paso 1: Se obtiene las bases, Xb y el valor de Z0
        B = (A_fs(:,Ib));
        B_inv = inv(B);
        Xb = B_inv*b;
                
        Cb = (cost_fs(:,Ib));
        Z0 = Cb*Xb;
        
        if h == 1
            Z0 = -1*Z0;
        end
        
        % Paso 2: Costos Reducidos 
        Cj = (cost_fs(:,In));
        N = (A_fs(:,In));
        Zj = Cb*B_inv*N;
        cost_red = Cj - Zj;
        
        for i=1:length(cost_red)
           if cost_red(i) < 0
               condicion = 1;
               break
           end
        end
        
        if condicion == 0
            X=[];
            indxb=1;
            for i=1:length([Ib In])
                if find(Ib==i)
                    X=[X Xb(indxb)];
                    indxb=indxb+1;
                else
                    X=[X 0];
                end
            end
               break
        end
        
        lowest_num = min(cost_red);
        for i=1:length(cost_red)
           if cost_red(i) == lowest_num && cost_red(i) < 0
               variable_entrar = In(i);
               break
           end
        end

        %Paso 3: Criterio de la razón mínima
        yk = B_inv*A_fs(:,variable_entrar);
        min_vals = transpose(Xb./yk);
        
        new_min_vals = [];
        for i=1:length(min_vals)
            if min_vals(i) ~= inf && min_vals(i) > 0
               new_min_vals = [new_min_vals min_vals(i)];
            end
        end
        
        if length(new_min_vals) == 0
            msg = "Original problem has an unbounded optimal solution!"
            f = msgbox(msg)
            error(msg)
        end

        lowest_num_criterio_min = min(new_min_vals);
        for i=1:length(min_vals)
           if min_vals(i) == lowest_num_criterio_min
               variable_salir = Ib(i);
               break
           end
        end
        
        indice_salir = find(Ib==variable_salir);
        indice_entrar = find(In==variable_entrar);

        Ib_old = Ib;

        Ib(indice_salir) = In(indice_entrar);
        In(indice_entrar) = Ib_old(indice_salir);

        Ib = sort(Ib);
        In = sort(In);
        
        for i=1:length(cost_red)
           if cost_red(i) < 0
               condicion = 1;
               break
           end
        end
    end
    
    disp("-- Optimal Solution --")
    Xb;
    J = transpose(X);
    J(6,1) = 3000000 - (J(1,1) + J(2,1) + J(3,1) + J(4,1) + J(5,1));
    M = J;
    Z0;
end