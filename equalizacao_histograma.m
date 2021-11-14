function ep = equalizacao_histograma(path_img)
%{
    equalizacao_histograma (str) : Path da imagem
    ep : imagem equalizada
%}

% leitura da imagem
img_original = imread(path_img);

% convertendo para escala de cinza
imagem_cinza_original = rgb2gray(img_original);

% plotando a figura original e em escala de cinza
figure;
subplot(2, 1, 1);
imshow(img_original);
title('Imagem original');
subplot(2, 1, 2);
imshow(imagem_cinza_original);
title('Imagem cinza', "color", "magenta");

imagem_cinza = double(imagem_cinza_original);

% pegando o tamanho da imagem
size_image = size(imagem_cinza);
fprintf('Tamanho: %d \n', size_image);

% criando histograma
hist1 = zeros(1,256);
for i=1:size_image(1)
    for j=1:size_image(2)
        for k=0:255
            if imagem_cinza(i,j)==k
                hist1(k+1)=hist1(k+1)+1;
            end
        end
    end
end

% comparando com a função nativa do matlab
figure;
subplot(2, 1, 1);
plot(hist1);
title('Histograma manual');
subplot(2, 1, 2);
histogram(imagem_cinza);
title('Histograma MATLAB', "color", "red");

% gerando pdf
pdf = (1/(size_image(1)*size_image(2)))*hist1;

% cdf
cdf = zeros(1,256);
cdf(1)=pdf(1);

for i=2:256
    cdf(i)=cdf(i-1)+pdf(i);
end
cdf = round(255*cdf);

ep = zeros(size_image);
for i=1:size_image(1)
    for j=1:size_image(2)
        t=(imagem_cinza(i,j)+1);
        ep(i,j)=cdf(t);
    end                                             
end

% equalizando a imagem
hist2 = zeros(1,256);
for i=1:size_image(1)
    for j=1:size_image(2)
        for k=0:255
            if ep(i,j)==k
                hist2(k+1)=hist2(k+1)+1;
            end
        end
    end
end

% comparando 
figure;
subplot(2, 1, 1);
imshow(uint8(ep));
title('Equalização');
subplot(2, 1, 2);
histeq(imagem_cinza_original);
title('Equalização MATLAB', "color", "green");

figure;
subplot(2, 1, 1);
stem(hist2);
title('Histograma');
subplot(2, 1, 2);
imhist(imagem_cinza_original);
title('Histograma Matlab', "color", "red");