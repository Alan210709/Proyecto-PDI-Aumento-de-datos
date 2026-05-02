%%%%%%%%%%%%%%% Umbralización Outsu doble %%%%%%%%%%%%%
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
    Im  = I{t};
    [M,N]=size(Im); 

    %histograma normalizado (Pi)
    [nk,rk]=imhist(Im);
    L = length(nk);
    Pi = nk / (M*N); 
    i = 0:L-1;
    iPi = i'.* Pi; % Intensidad por probabilidad
    mG = sum(iPi);  % Media global
    
    max_sigma = -1;
    K1_star = 0;
    K2_star = 0;
    
    
    for K1 = 1:L-2
        for K2 = K1+1:L-1
            
            % Probabilidades de las 3 regiones
            P1 = sum(Pi(1:K1));
            P2 = sum(Pi(K1+1:K2));
            P3 = sum(Pi(K2+1:L));
            
            % Evitar división por cero
            if P1 > 0 && P2 > 0 && P3 > 0
                m1 = sum(iPi(1:K1)) / P1;
                m2 = sum(iPi(K1+1:K2)) / P2;
                m3 = sum(iPi(K2+1:L)) / P3;
                
                % Calcular varianza sigma^2(K1, K2)
                sigma_cuad = P1*(m1-mG)^2 + P2*(m2-mG)^2 + P3*(m3-mG)^2;
                
                % Obtener sigma^2
                if sigma_cuad > max_sigma
                    max_sigma = sigma_cuad;
                    K1_star = K1 - 1; % Convertir índice (0-255)
                    K2_star = K2 - 1;
                end
            end
        end
    end
    
    %Umbralización de la imagen en tres regiones (a, b, c)
    
    IRes = zeros(M,N);
    IRes(Im <= K1_star) = 0;                     % Región a
    IRes(Im > K1_star & Im <= K2_star) = 127;    % Región b
    IRes(Im > K2_star) = 255;                    % Región c

    figure; 
    subplot(1, 2, 1); 
    imshow(I{t},[]); 
    title('Imagen Original');
    
    subplot(1, 2, 2);
    imshow(uint8(IRes),[]); 
    title('Outsu Simple');

    % Guardar imagenes
    nombre= sprintf('F%d_Outsu_Doble.jpg', t); 
    imwrite(uint8(IRes), nombre);

end