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
    [M,N]=size(I{t}); %128x128 pixeles
    [nk,rk]=imhist(I{t});
    tot=sum(nk);
    pk=nk/tot;
    pki = 0;

    %Ecualización
    for h=1:size(pk)
        pki = pk(h)+pki;
        sk = max(rk)*pki;
        T(h,1)=round(sk);
    end

    Img=[zeros(M,N)];
    
    %Histograma
    for i=1:M
        for j=1:N
            fx=I{t}(i,j);
            Img(i,j)=T(fx+1);
        end
    end
    
    %Mostrar imagen
    figure; 
    subplot(1, 2, 1); 
    imshow(uint8(I{t})); 
    title('Imagen Original');
    subplot(1, 2, 2);
    imshow(uint8(Img)); 
    title('Imagen Ecualizada');
    
    % Guardar imagenes
    nombre= sprintf('F_%d_Ecualizada.jpg', t); 
    Img = uint8(Img);
    imwrite(Img, nombre);
end

