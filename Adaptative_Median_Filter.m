%%%%%%%%%%%%%%% Adaptative Median Filter %%%%%%%%%%%%%
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
    I_noisy = Im; %imnoise(Im, 'salt & pepper', 0.25);
    
    %Parámetros del filtro
    Smax = 7;            
    [M,N] = size(I_noisy);
    pad_size = floor(Smax/2);
    I_padded = padarray(I_noisy, [pad_size, pad_size], 'symmetric', 'both');
    I_filtered = zeros(M, N);
    
    %Recorrer cada píxel de la imagen original
    for i = 1:M
        for j = 1:N
            x = i + pad_size;
            y = j + pad_size;
            zxy = I_padded(x, y);
            window_size = 3;
            continue_levelA = true;
            
            while continue_levelA
                r = floor(window_size / 2);
                window = I_padded(x-r:x+r, y-r:y+r);
                zmin = min(window(:));
                zmax = max(window(:));
                zmed = median(window(:));
                
                % Nivel A
                if zmin < zmed && zmed < zmax
                    % Nivel B
                    if zmin < zxy && zxy < zmax
                        I_filtered(i, j) = zxy;
                    else
                        I_filtered(i, j) = zmed;
                    end
                    continue_levelA = false;
                    
                else
                    window_size = window_size + 2;
                    if window_size > Smax
                        % Asegurar que la ventana no exceda Smax
                        window_size = Smax;
                        r = floor(window_size / 2);
                        window = I_padded(x-r:x+r, y-r:y+r);
                        zmed = median(window(:));
                        I_filtered(i, j) = zmed;
                        continue_levelA = false;
                    end
                end
            end
        end
    end
    
    %Mostrar resultados
    figure;
    subplot(1,2,1), imshow(Im), title('Original');
    subplot(1,2,2), imshow(I_filtered), title('Imagen filtrada');

    % Guardar imagenes
    nombre= sprintf('F%d_Adaptative_Median_Filter.jpg', t); 
    imwrite(I_filtered, nombre);
end