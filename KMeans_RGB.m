%%%%%%%%%%%%%%% K-Means RGB %%%%%%%%%%%%%
clc;
clear;
I{1} = imread('./F1.jpg');
I{2} = imread('./F2.jpg');
I{3} = imread('./M1.jpg');
I{4} = imread('./M2.jpg');
I{5} = imread('./D1.jpg');
I{6} = imread('./D2.jpg');

for t=1:6
    Im  = I{t};
    [filas, columnas, planos] = size(Im);
    
    R = double(Im(:,:,1));
    G = double(Im(:,:,2));
    B = double(Im(:,:,3));
    
    X = [R(:), G(:), B(:)];
    M_total = size(X, 1);
    centroides = zeros(4, 3);
    
    for k = 1:4
        sub_region = X(k:4:end, :); 
        centroides(k, :) = mean(sub_region, 1);
    end
    
    % Parámetros de control
    max_iter = 50;    
    tolerancia = 0.5; 
    iter = 0;
    convergido = false;
    
    %Bucle principal de K-Means
    while ~convergido && iter < max_iter
        iter = iter + 1;
        centroides_anteriores = centroides;
        
        Distancias = zeros(M_total, 4);
        for k = 1:4
            diff = (X - centroides(k, :)).^2;
            Distancias(:, k) = sqrt(sum(diff, 2));
        end
        
        [~, etiquetas] = min(Distancias, [], 2);
        
        %Actualización de Centroides 
        for k = 1:4
            puntos_en_grupo = X(etiquetas == k, :);
            if ~isempty(puntos_en_grupo)
                centroides(k, :) = mean(puntos_en_grupo, 1);
            end
        end
        
        %Verificar Convergencia
        cambio = sum(sqrt(sum((centroides - centroides_anteriores).^2, 2)));
        if cambio < tolerancia
            convergido = true;
        end
    end
    
    X_segmentado = centroides(etiquetas, :);
    Im_R_final = reshape(X_segmentado(:,1), filas, columnas);
    Im_G_final = reshape(X_segmentado(:,2), filas, columnas);
    Im_B_final = reshape(X_segmentado(:,3), filas, columnas);
    
    Im_final = uint8(cat(3, Im_R_final, Im_G_final, Im_B_final));

    
    figure; 
    subplot(1, 2, 1); 
    imshow(I{t},[]); 
    title('Imagen Original');
    
    subplot(1, 2, 2);
    imshow(uint8(Im_final),[]); 
    title('K-Means RGB');

    % Guardar imagenes
    nombre= sprintf('F%d_KMeans_RGB.jpg', t); 
    imwrite(uint8(Im_final), nombre);

end