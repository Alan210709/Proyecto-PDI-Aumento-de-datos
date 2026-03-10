%%%%%%%%%%%%%%% Gradiente_Laplaciano %%%%%%%%%%%%%
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
    J = double(I{t});

    %%%%%%%%%%%%%% Laplaciano %%%%%%%%%%%%%%%%%%%%
    %Mascara sin considerar esquinas centro positivo
    w=[0 -1 0;-1 4 -1;0 -1 0];
    Gf2=imfilter(J,w,0,'conv'); % convolucion
    c=1;
    LG=J+c*Gf2; % Laplaciano
    
    %%%%%%%%%%%%%% Gradiente %%%%%%%%%%%%%%%%%%%%
    % mascara para x
    wx=[-1 -2 -1;0 0 0;1 2 1];
    Ix=imfilter(J,wx,0,'conv'); % convolucion
    
    % mascara para y
    wy=[-1 0 1;-2 0 2;-1 0 1];
    Iy=imfilter(J,wy,0,'conv'); % convolucion
    
    %suma
    Ix = Ix.^2;
    Iy = Iy.^2;
    Gfxy = sqrt(Ix+Iy); % Magnitud del gradiente
    
    
    %%%%%%%%%%%%% Suavizante de la magnitud del gradiente %%%%%%%%%%%%%%
    % filtro de caja de 3 × 3
    wg=[1 1 1; 1 1 1; 1 1 1];
    suma = sum(wg,'all');
    Mg=imfilter(Gfxy,wg,0,'conv')*1/suma; % convolucion
    
    
    %%%%%%%%%%%%%%%% Mascara del filto %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Mask = LG.*Mg;
    G = J + Mask;
    G = abs(G);
    gama = 0.2;
    G = G.^gama;
    figure; 
    subplot(1, 2, 1); 
    imshow(I{t},[]); 
    title('Imagen Original');
    
    subplot(1, 2, 2);
    imshow(G,[]); 
    title('Imagen Ecualizada');

    % Guardar imagenes
    nombre= sprintf('F%d_Filtrada_Gradiente_Laplaciano.jpg', t); 
    Img = uint8(G);
    imwrite(Img, nombre);
end