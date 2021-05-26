% Método de las fases que hace hace previo al SIMPLEX para encontrar los
% indices con los cuales debemos empezar 
function [Ib,In] = phases(cost_fn, A_fn, b)

    %Se transforma el problema a formato estándar
    artificial = eye(size(A_fn,1));
    A_fs = [A_fn artificial];
    cost_artificial_fn = ones([1,size(A_fn,1)]);
    cost_zero = zeros([1,size(A_fn,2)]);
    cost_fs = [cost_zero cost_artificial_fn];

    Ib = [];
    In = [];
    for i=1:length(cost_fs)
       if cost_fs(i) ~= 0
           Ib = [Ib i];
       else
           In = [In i];
       end
    end

    
    cost_red = ones(size((cost_fs(:,In)))) .* -1; 
    condicion = 1;
    
    while condicion == 1
        %Paso 1: Encontrar información general
        condicion = 0;
        B = (A_fs(:,Ib));
        B_inv = inv(B);
        Xb = B_inv*b;
        Cb = (cost_fs(:,Ib));


        %Paso 2: Costos reducidos
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
        
        %Cirterio de parada del algoritmo 
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
               for i=length(X):-1:1
                   if X(i) ~= 0 && (length(X)-length(artificial)) < i
                       msg = "Original problem has no feasable solution. Therefore Simplex won't work"
                       f = msgbox(msg)
                       error(msg)
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

        %Paso 3: Criterio de la Razón mínimaa
        yk = B_inv*A_fs(:,variable_entrar);
        min_vals = transpose(Xb./yk);
        new_min_vals = [];
        for i=1:length(min_vals)
            if min_vals(i) ~= inf && min_vals(i) > 0 
               new_min_vals = [new_min_vals min_vals(i)];
           end
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
    
    for i=1:length(cost_artificial_fn)
        In(end) = [];
    end 
end

