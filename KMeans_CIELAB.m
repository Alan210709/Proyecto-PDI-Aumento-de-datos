%%%%%%%%%%%%%%% K-Means en Espacio de Color CIE L*a*b* %%%%%%%%%%%%%
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
    [filas, columnas, ~] = size(Im);
    
    %Convertir de RGB a Lab
    Im_lab = rgb2lab(Im);
    
    %Extraer solo los canales a* y b* 
    ab = double(Im_lab(:,:,2:3)); 
    X = reshape(ab, filas * columnas, 2); % Matriz de [Pixeles x 2]
    
    %Inicialización de Centroides 
    K = 4;
    M_total = size(X, 1);
    centroides = zeros(K, 2); 
    for k = 1:K
        sub_region = X(k:K:end, :); 
        centroides(k, :) = mean(sub_region, 1);
    end
    
    % Parámetros de control
    max_iter = 100;
    tolerancia = 0.1;
    iter = 0;
    convergido = false;
    
    %Bucle K-Means
    while ~convergido && iter < max_iter
        iter = iter + 1;
        centroides_ant = centroides;
        
        % Distancia Euclidiana en el plano a*b*
        Distancias = zeros(M_total, K);
        for k = 1:K
            diff = (X - centroides(k, :)).^2;
            Distancias(:, k) = sqrt(sum(diff, 2));
        end
        
        [~, etiquetas] = min(Distancias, [], 2);
        
        % Actualización de centros
        for k = 1:K
            puntos = X(etiquetas == k, :);
            if ~isempty(puntos)
                centroides(k, :) = mean(puntos, 1);
            end
        end
        
        if sum(sqrt(sum((centroides - centroides_ant).^2, 2))) < tolerancia
            convergido = true;
        end
    end
    
    L_original = Im_lab(:,:,1);
    L_vector = L_original(:);
    X_rec_lab = [L_vector, centroides(etiquetas, :)];
    Im_lab_final = reshape(X_rec_lab, filas, columnas, 3);
    
    Im_rgb_final = lab2rgb(Im_lab_final);
    Im_mostrar = uint8(Im_rgb_final * 255);

    figure; 
    subplot(1, 2, 1); 
    imshow(I{t});
    title('Imagen Original');
    
    subplot(1, 2, 2);
    imshow(Im_mostrar); 
    title('K-Means en Lab (Visualizado RGB)');
    
    % Guardar imágenes 
    nombre = sprintf('F%d_KMeans_CIE_Lab.jpg', t); 
    imwrite(Im_mostrar, nombre);
end