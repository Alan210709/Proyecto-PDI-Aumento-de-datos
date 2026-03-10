%%%%%%%%%%%%%%% Filtro adaptativo local %%%%%%%%%%%%%
clc;
clear;
I{1} = imread('./F1.jpg');
I{2} = imread('./F2.jpg');
I{3} = imread('./M1.jpg');
I{4} = imread('./M2.jpg');
I{5} = imread('./D1.jpg');
I{6} = imread('./D2.jpg');

for t=1:6
    I{t} = 0.2989*I{t}(:,:,1) + 0.5870*I{t}(:,:,2) + 0.1140*I{t}(:,:,3);
    Im = im2double(I{t});
    I_noisy = Im;%imnoise(Im, 'gaussian', 0, 0.01);
    noise_var = 0.01;    
    
    % Parámetros del filtro
    n = 5;
    r = floor(n/2);
    
    %Calcular media local y varianza local 
    kernel = ones(n) / n^2;
    local_mean = conv2(I_noisy, kernel, 'same'); % Media local
    local_mean_sq = conv2(I_noisy.^2, kernel, 'same'); % Media local de los cuadrados
    local_var = local_mean_sq - local_mean.^2; % Varianza local: E[x^2] - (E[x])^2
    
    %varianzas con límite superior 1
    if noise_var == 0
        ratio = zeros(size(I_noisy));
    else
        ratio = noise_var ./ local_var;
        ratio(noise_var > local_var) = 1;
        ratio = max(0, min(1, ratio));
    end
    
    %fórmula adaptativa
    I_filtered = I_noisy - ratio .* (I_noisy - local_mean);
    
    %Mostrar resultados
    figure;
    subplot(1,2,1), imshow(Im,[]), title('Imagen original');
    subplot(1,2,2), imshow(I_filtered,[]), title('Imagen filtrada (adaptativo)');
   
    % Guardar imagenes
    nombre= sprintf('F%d_Filtrada_Adaptativo_Local.jpg', t); 
    imwrite(I_filtered, nombre);
end