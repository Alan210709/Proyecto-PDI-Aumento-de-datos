%%%%%%%%%%%%%%% Ecualización %%%%%%%%%%%%%
clc;
clear;
I{1} = imread('./F1.jpg');
I{2} = imread('./F2.jpg');
I{3} = imread('./M1.jpg');
I{4} = imread('./M2.jpg');
I{5} = imread('./D1.jpg');
I{6} = imread('./D2.jpg');

for t=1:6
    %Conversión a escala de grises
    I{t} = 0.2989*I{t}(:,:,1) + 0.5870*I{t}(:,:,2) + 0.1140*I{t}(:,:,3);

    % Guardar imagenes
    if t<3
        nombre= sprintf('F%d_Escala_Grises.jpg', t); 
    elseif t<5 && t>2
        nombre= sprintf('M%d_Escala_Grises.jpg', t); 
    else
        nombre= sprintf('D%d_Escala_Grises.jpg', t); 
    end
    Img = uint8(I{t});
    imwrite(Img, nombre);
end
