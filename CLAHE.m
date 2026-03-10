%% Parcial 2-Práctica 1: Algoritmo CLAHE
clear; close;clc;
im=imread('D2.jpg');
im=0.2989*im(:,:,1) + 0.5870*im(:,:,2) + 0.1140*im(:,:,3);
figure;imshow(im);

% Dimensiones
[M,N]=size(im);
L=256;

tam1=M/2;
tam2=N/2;

Parte1=im(1:tam1, 1:tam2);
Parte2=im(tam1+1:M, 1:tam2);
Parte3=im(1:tam1, tam2+1:N);
Parte4=im(tam1+1:M, tam2+1:N);

% Histogramas
[nk1,rk1]=imhist(Parte1);
[nk2,rk2]=imhist(Parte2);
[nk3,rk3]=imhist(Parte3);
[nk4,rk4]=imhist(Parte4);

cliplimit=120;

freqTotal={nk1,nk2,nk3,nk4};

for i=1:4
    recorrido=freqTotal{i};
    exceso=0;

    for j=1:256
        if recorrido(j)>cliplimit
            exceso=exceso+(recorrido(j)-cliplimit);
            recorrido(j)=cliplimit;
        end
    end
    
    incremento=floor(exceso/L);
    residuo=mod(exceso,L);
    
    recorrido=recorrido+incremento;
    
    for j=1:residuo
        recorrido(j)=recorrido(j)+1;
    end
    
    freqTotal{i}=recorrido;
end

freq1a=freqTotal{1};
freq2a=freqTotal{2};
freq3a=freqTotal{3};
freq4a=freqTotal{4};

% Totales de pixeles
tot1=sum(freq1a);
tot2=sum(freq2a);
tot3=sum(freq3a);
tot4=sum(freq4a);

% --- Cálculo de la Transformación T ---
% probabilidad (pk) y la suma acumulada (sk)
pk1 = freq1a/tot1;
pk2 = freq2a/tot2;
pk3 = freq3a/tot3;
pk4 = freq4a/tot4;

% Ecualización (SUMA acumulada de las probabilidades)
sk1 = cumsum(pk1);
sk2 = cumsum(pk2);
sk3 = cumsum(pk3);
sk4 = cumsum(pk4);

% Transformación T (suma acumulada por L-1 y se redondea)
for i=1:L
    T1(i) = round((L-1) * sk1(i));
    T2(i) = round((L-1) * sk2(i));
    T3(i) = round((L-1) * sk3(i));
    T4(i) = round((L-1) * sk4(i));
end  

% --- Mapeo de pixeles (Transformación de la imagen) ---
for i=1:M/2
    for j=1:N/2
        % Imagen 1, parte 1
        rk1_aux = Parte1(i,j);
        im1_res(i,j) = T1(rk1_aux + 1);
        
        % Imagen 1, parte 2
        rk2_aux = Parte2(i,j);
        im2_res(i,j) = T2(rk2_aux + 1);
        
        % Imagen 1, parte 3
        rk3_aux = Parte3(i,j);
        im3_res(i,j) = T3(rk3_aux + 1);

        % Imagen 1, parte 4
        rk4_aux = Parte4(i,j);
        im4_res(i,j) = T4(rk4_aux + 1);
    end
end

im1_res=uint8(im1_res);
im2_res=uint8(im2_res);
im3_res=uint8(im3_res);
im4_res=uint8(im4_res);

% --- Interpolación bilineal usando las 4 transformaciones ---
for i=1:M
    for j=1:N
        valor=double(im(i,j))+1;
        
        x=(j-1)/(N-1);
        y=(i-1)/(M-1);
        
        v1=double(T1(valor));
        v2=double(T2(valor));
        v3=double(T3(valor));
        v4=double(T4(valor));
        
        superior=(1-x)*v1 + x*v3;
        inferior=(1-x)*v2 + x*v4;
        
        Im_final(i,j)=(1-y)*superior + y*inferior;
    end
end

Im_final=uint8(Im_final);

figure;
subplot(2,2,1),imshow(im1_res),title('Parte 1');
subplot(2,2,2),imshow(im3_res),title('Parte 3');
subplot(2,2,3),imshow(im2_res),title('Parte 2');
subplot(2,2,4),imshow(im4_res),title('Parte 4');

figure;
imshow(Im_final);
title('Resultado final con interpolación');

Img = uint8(Im_final);
imwrite(Img, 'D2_CLAHE.jpg');

