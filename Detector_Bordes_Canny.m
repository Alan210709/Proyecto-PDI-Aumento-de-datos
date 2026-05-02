%%%%%%%%%%%%%%% Detector de Bordes de Canny %%%%%%%%%%%%%
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
    %J = im2double(I{t});
    J = double(I{t});
    % sigma = 1.5;
    % J = filtroGaussEspacio(sigma)
    [filas, columnas] = size(J);
    
    %%%%%%%%%%%%%% Gradiente %%%%%%%%%%%%%%%%%%%%
    % mascara para x
    wx=[-1 -2 -1;0 0 0;1 2 1];
    Ix=imfilter(J,wx,0,'conv'); % convolucion
    
    % mascara para y
    wy=[-1 0 1;-2 0 2;-1 0 1];
    Iy=imfilter(J,wy,0,'conv'); % convolucion
    
    %%%%%%%%%%%%%%%%%% Magnitud del gradiente %%%%%%%%%%%%
    %suma
    Ix2 = Ix.^2;
    Iy2 = Iy.^2;
    Mfxy = sqrt(Ix2+Iy2); % Magnitud del gradiente
    
    
    %%%%%%%%%%%%%%%%%% Dirección del gradiente %%%%%%%%%%%%
    Dfxy = rad2deg(atan2(Iy,Ix)); %Dirección del gradiente
    Direc=zeros(11,11); 
    for i = 1:filas
        for j = 1:columnas
            aux = Dfxy(i,j); 
    
            if aux >= -22.5 && aux < 22.5
                Direc(i,j)=0;
            
            elseif aux >= 22.5 && aux < 67.5
                Direc(i,j)=-45;
    
            elseif aux >= 67.5 && aux < 112.5
                Direc(i,j)=90;
    
            elseif aux >= 112.5 && aux < 157.5
                Direc(i,j)=45;
    
            elseif aux >= -67.5 && aux <-22.5
                Direc(i,j)=45;
    
            elseif aux >= -112.5 && aux < -67.5 
                Direc(i,j)=-90;
    
            elseif aux >= -157.5 && aux < -112.5 
                Direc(i,j)=-45;
            
            else
                Direc(i,j)=180;
            end
        end
    end
    
    
    %%%%%%%%%%%%%%%% Supresión de no maximos %%%%%%%%%%%%%%%%%%%%%%%
    Maux = padarray(Mfxy, [1 1], 0, 'both');
    NMS = zeros(filas, columnas);
    
    for i = 2:filas+1
        for j = 2:columnas+1
            
            ang = Direc(i-1, j-1);
            mag = Maux(i,j);
    
            % 0 y 180 → izquierda-derecha
            if ang == 0 || ang == 180
                if mag >= Maux(i, j-1) && mag >= Maux(i, j+1)
                    NMS(i-1,j-1) = mag;
                end
         
    
            % 90 y -90 → arriba-abajo
            elseif ang == 90 || ang == -90
                if mag >= Maux(i-1, j) && mag >= Maux(i+1, j)
                    NMS(i-1,j-1) = mag;
                end
    
            % 45 → diagonal "\"
            elseif ang == 45
                if mag >= Maux(i-1, j-1) && mag >= Maux(i+1, j+1)
                    NMS(i-1,j-1) = mag;
                end
    
            % -45 → diagonal "/"
            elseif ang == -45
                if mag >= Maux(i-1, j+1) && mag >= Maux(i+1, j-1)
                    NMS(i-1,j-1) = mag;
                end
    
            end
    
        end
    end
    
    figure; 
    subplot(1, 2, 1); 
    imshow(I{t},[]); 
    title('Imagen Original');
    
    subplot(1, 2, 2);
    imshow(uint8(NMS),[]); 
    title('Supresión de No Máximos');

    % Guardar imagenes
    nombre= sprintf('F%d_Detector_Bordes_Canny.jpg', t); 
    imwrite(uint8(NMS), nombre);

end