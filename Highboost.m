%%%%%%%%%%%%%%% HIGHBOOST %%%%%%%%%%%%%
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
    Im = double(I{t});
    [M,N]=size(I{t});

    % filtro de caja de 3 × 3
    w=[1 1 1; 1 1 1; 1 1 1];
    suma = sum(w,'all');
    Ims=imfilter(Im,w,0,'conv')*1/suma; % convolucion
    
    %Mascara
    Mask = Im - Ims;
    
    %Resultado del filtro
    k = 10;
    G = Im + k*Mask;
    figure; 
    subplot(1, 2, 1); 
    imshow(I{t},[]); 
    title('Imagen Original');
    
    subplot(1, 2, 2);
    imshow(G,[]); 
    title('Imagen Ecualizada');

    % Guardar imagenes
    nombre= sprintf('F%d_Filtrada_Highboost.jpg', t); 
    Img = uint8(G);
    imwrite(Img, nombre);
end
