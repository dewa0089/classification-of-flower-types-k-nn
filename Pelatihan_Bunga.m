clc; clear; close all;
warning off all;

nama_folder = 'Data_Latih';
nama_file = dir(fullfile(nama_folder,'*.png'));
total_images = numel(nama_file);

% Menginisialisasi Variable ciri_latih
ciri_latih = zeros(total_images, 7);

for n = 1:total_images
    % Membaca Gambar RGB 
    Img = imread(fullfile(nama_folder, nama_file(n).name));

    % Mengkonversi Gambar RGB ke Gambar grayscale
    Img_gray = rgb2gray(Img);

    % Konversi Gambar grayscale image Ke binary
    thresh = graythresh(Img_gray);
    bw = im2bw(Img_gray, thresh);

    % Operasi Morfologi Gradient
    se = strel('disk', 1);
    dilated = imdilate(bw, se);
    eroded = imerode(bw, se);
    bw = dilated - eroded;
    
    % Mengekstraksi Fitur Warna HSV
    HSV = rgb2hsv(Img);
    H = HSV(:,:,1);
    S = HSV(:,:,2);
    V = HSV(:,:,3);
    H(~Img_gray ) = 0;
    S(~Img_gray) = 0;
    V(~Img_gray) = 0;
    Hue = sum(sum(H))/sum(sum(Img_gray));
    Saturation = sum(sum(S))/sum(sum(Img_gray));
    Value = sum(sum(V))/sum(sum(Img_gray));
    
    % Menghitung GLCM
    glcm = graycomatrix(Img_gray, 'Offset', [0 1]); 
    stats = graycoprops(glcm); % Mengekstraksi Fitur GLCM 
    
    % Menyimpan Hasil Ekstraksi Fitur HSV ke ciri_latih
    ciri_latih(n, 1) = Hue;
    ciri_latih(n, 2) = Saturation;
    ciri_latih(n, 3) = Value;
    
   % Menyimpan Hasil Ekstraksi Fitur GLCM ke ciri_latih
    ciri_latih(n, 4) = stats.Contrast; 
    ciri_latih(n, 5) = stats.Correlation; 
    ciri_latih(n, 6) = stats.Energy; 
    ciri_latih(n, 7) = stats.Homogeneity;
end

% Normalisasi Data ciri_latih
[ciri_latihZ, muZ, sigmaZ] = zscore(ciri_latih);

% Menginisialisasi variable kelas_latih 
kelas_latih = cell(total_images, 1);

% Mengisi nama kelas di dalam kelas_latih
for k = 1:10
    kelas_latih{k} = 'Rose';
end

for k = 11:20
    kelas_latih{k} = 'Calendula';
end

for k = 21:30
    kelas_latih{k} = 'Iris';
end

for k = 31:40
    kelas_latih{k} = 'Dandelion';
end

for k = 41:50
    kelas_latih{k} = 'Viola';
end

for k = 51:60
    kelas_latih{k} = 'Lilium';
end

for k = 61:70
    kelas_latih{k} = 'WaterLily';
end

PC1 = ciri_latihZ(:,1);
PC2 = ciri_latihZ(:,2);

% Kelas Rose
x1 = PC1(1:10);
y1 = PC2(1:10);

% Kelas Calendula
x2 = PC1(11:20);
y2 = PC2(11:20);

% Kelas Iris
x3 = PC1(21:30);
y3 = PC2(21:30);

% Kelas Dandelion
x4 = PC1(31:40);
y4 = PC2(31:40);

% Kelas Viola
x5 = PC1(41:50);
y5 = PC2(41:50);

% Kelas Lilium
x6 = PC1(51:60);
y6 = PC2(51:60);

% Kelas Waterlily
x7 = PC1(61:70);
y7 = PC2(61:70);

% menampilkan sebaran data pada masing-masing kelas pelatihan
figure
plot(x1,y1,'b.','MarkerSize',30)
hold on
plot(x2,y2,'g.','MarkerSize',30)
plot(x3,y3,'r.','MarkerSize',30)
plot(x4,y4,'y.','MarkerSize',30)
plot(x5,y5,'m.','MarkerSize',30)
plot(x6,y6,'c.','MarkerSize',30)
plot(x7,y7,'k.','MarkerSize',30)
hold off
grid on
xlabel('PC1')
ylabel('PC2')
legend('Rose','Calendula','Iris','Dandelion','Viola','Lilium','WaterLily')
title('Sebaran data pelatihan KNN')

% Pengklasifikasian Menggunakan K-NN
Mdl = fitcknn([PC1,PC2],kelas_latih, 'NumNeighbors', 7,'Distance','euclidean');

% Menyimpan Hasil ekstraksi Ciri dan hasil klasifikasi
save ciri_database Mdl muZ sigmaZ x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 y5 y6 y7;