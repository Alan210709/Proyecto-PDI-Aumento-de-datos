%%%%%%%%%%%%%%% Umbralización Outsu Simple %%%%%%%%%%%%%
clc;
clear;
I{1} = imread('./F1.jpg');
I{2} = imread('./F2.jpg');
I{3} = imread('./M1.jpg');
I{4} = imread('./M2.jpg');
I{5} = imread('./D1.jpg');
I{6} = imread('./D2.jpg');

for t=3:6
    I{t} = 0.2989*I{t}(:,:,1) + 0.5870*I{t}(:,:,2) + 0.1140*I{t}(:,:,3);
    J = double(I{t});
    Im  = I{t};
    [M,N]=size(Im); %128x128 pixeles

    %Obtenemos intensidad
    [nk,rk]=imhist(J);
    L = length(nk);
    i = 0:1:L-1;
    
    %Obtenemos probabilidad 
    Pi = hist(double(reshape(Im,1,M*N)),i);
    Pi = Pi/(M*N);
    P1V = zeros(1,L-1);
    m1V = zeros(1,L-1);
    
    %Obtenemos Pk, mk y media global
    iPi= i.*Pi;
    disp(iPi);
    disp(Pi);
    mG=sum(iPi); % media global
    disp(mG);
    P1V = cumsum(Pi);
    m1V = cumsum(iPi);
    sigmaCuad = (P1V.*mG -m1V).*(P1V.*mG - m1V);
    sigmaCuad = sigmaCuad./(P1V.*(1-P1V));
    [maxFv,posmaxFv] = max(sigmaCuad);
    T = i(posmaxFv)/1; %Para imagenes medias y dificiles
    %T = i(posmaxFv)/2; %Para imagenes faciles
    
    disp(sigmaCuad);
    disp(maxFv);
    disp(posmaxFv);
    disp(T);
    IRes = Im;
    IRes(Im <= T) = 0;
    IRes(Im > T) = 255;
    
    figure; 
    subplot(1, 2, 1); 
    imshow(I{t},[]); 
    title('Imagen Original');
    
    subplot(1, 2, 2);
    imshow(uint8(IRes),[]); 
    title('Outsu Simple');

    % Guardar imagenes
    nombre= sprintf('F%d_Outsu_Simple.jpg', t); 
    imwrite(uint8(IRes), nombre);

end