%%%%%%%%%%%%%%% LBP %%%%%%%%%%%%%
clc;
clear;
close all;
Fuego_raw = imread('./Fuego.jpg');
Fuego_gray = 0.2989*double(Fuego_raw(:,:,1)) + 0.5870*double(Fuego_raw(:,:,2)) + 0.1140*double(Fuego_raw(:,:,3));

Humo_raw = imread('./Humo.png');
Humo_gray = 0.2989*double(Humo_raw(:,:,1)) + 0.5870*double(Humo_raw(:,:,2)) + 0.1140*double(Humo_raw(:,:,3));

Veg_raw = imread('./Vegetacion.jpg');
Veg_gray = 0.2989*double(Veg_raw(:,:,1)) + 0.5870*double(Veg_raw(:,:,2)) + 0.1140*double(Veg_raw(:,:,3));
p = [128 64 32 16 8 4 2 1]; 

% CALCULAR HISTOGRAMA LBP PARA FUEGO 
J_fuego = padarray(Fuego_gray, [1 1], 'replicate', 'both');
[M_f, N_f] = size(Fuego_gray);
LBP_fuego = zeros(M_f, N_f);
for i = 2:M_f+1
    for j = 2:N_f+1
        v = J_fuego(i-1:i+1, j-1:j+1);
        c = v(2,2);
        cont = [v(1,1)>=c, v(1,2)>=c, v(1,3)>=c, v(2,3)>=c, v(3,3)>=c, v(3,2)>=c, v(3,1)>=c, v(2,1)>=c];
        LBP_fuego(i-1,j-1) = sum(cont .* p);
    end
end
pk_fuego = imhist(uint8(LBP_fuego), 256);
pk_fuego = pk_fuego / sum(pk_fuego);

%CALCULAR HISTOGRAMA LBP PARA HUMO 
J_humo = padarray(Humo_gray, [1 1], 'replicate', 'both');
[M_h, N_h] = size(Humo_gray);
LBP_humo = zeros(M_h, N_h);
for i = 2:M_h+1
    for j = 2:N_h+1
        v = J_humo(i-1:i+1, j-1:j+1);
        c = v(2,2);
        cont = [v(1,1)>=c, v(1,2)>=c, v(1,3)>=c, v(2,3)>=c, v(3,3)>=c, v(3,2)>=c, v(3,1)>=c, v(2,1)>=c];
        LBP_humo(i-1,j-1) = sum(cont .* p);
    end
end
pk_humo = imhist(uint8(LBP_humo), 256);
pk_humo = pk_humo / sum(pk_humo);

%CALCULAR HISTOGRAMA LBP PARA Vegetación 
J_Veg = padarray(Veg_gray, [1 1], 'replicate', 'both');
[M_v, N_v] = size(Veg_gray);
LBP_Veg = zeros(M_v, N_v);
for i = 2:M_v+1
    for j = 2:N_v+1
        v = J_Veg(i-1:i+1, j-1:j+1);
        c = v(2,2);
        cont = [v(1,1)>=c, v(1,2)>=c, v(1,3)>=c, v(2,3)>=c, v(3,3)>=c, v(3,2)>=c, v(3,1)>=c, v(2,1)>=c];
        LBP_Veg(i-1,j-1) = sum(cont .* p);
    end
end
pk_veg = imhist(uint8(LBP_Veg), 256);
pk_veg = pk_veg / sum(pk_veg);

nombres = {'F1.jpg', 'F2.jpg', 'M1.jpg', 'M2.jpg', 'D1.jpg', 'D2.jpg'};

for t = 1:6
    I_raw = imread(['./', nombres{t}]);
    I_gray = 0.2989*double(I_raw(:,:,1)) + 0.5870*double(I_raw(:,:,2)) + 0.1140*double(I_raw(:,:,3));
    
    % Calcular LBP
    J_act = padarray(I_gray, [1 1], 'replicate', 'both');
    [M_a, N_a] = size(I_gray);
    LBP_act = zeros(M_a, N_a);
    for i = 2:M_a+1
        for j = 2:N_a+1
            v = J_act(i-1:i+1, j-1:j+1);
            c = v(2,2);
            cont = [v(1,1)>=c, v(1,2)>=c, v(1,3)>=c, v(2,3)>=c, v(3,3)>=c, v(3,2)>=c, v(3,1)>=c, v(2,1)>=c];
            LBP_act(i-1,j-1) = sum(cont .* p);
        end
    end
    pk_act = imhist(uint8(LBP_act), 256);
    pk_act = pk_act / sum(pk_act);
    
    % Distancia Chi-Cuadrado contra Fuego
    chi2_fuego = sum(((pk_act - pk_fuego).^2) ./ (pk_act + pk_fuego + eps));
    
    % Distancia Chi-Cuadrado contra Humo
    chi2_humo = sum(((pk_act - pk_humo).^2) ./ (pk_act + pk_humo + eps));

    % Distancia Chi-Cuadrado contra Humo
    chi2_veg = sum(((pk_act - pk_veg).^2) ./ (pk_act + pk_veg + eps));
    
    %Resultados
    fprintf('Imagen: %s\n', nombres{t});
    if chi2_fuego < 0.5
        disp('  > Alerta: FUEGO detectado.');
    else
        disp('  > Sin rastro de fuego.');
    end
    
    if chi2_humo < 0.5
        disp('  > Alerta: HUMO detectado.');
    else
        disp('  > Sin rastro de humo.');
    end

    if chi2_veg < 0.5
        disp('  > Alerta: VEGETACIÓN detectada.');
    else
        disp('  > Sin rastro de vegetación.');
    end
    fprintf('  (Dists -> Fuego: %.4f | Humo: %.4f | Vegetación: %.4f)\n\n\n', chi2_fuego, chi2_humo,chi2_veg);
end