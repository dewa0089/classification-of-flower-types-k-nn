clc; clear; close all;
warning off all;

%Nama Folder Data Yang ingin diujikan
nama_folder = 'Data_Uji';
nama_file = dir(fullfile(nama_folder, '*.png'));
jumlah_file = numel(nama_file);

%Pemanggilan ciri - ciri dari pelatihan/ekstraksi yang telah dilakukan
load ciri_database.mat

% Menginisialisasi Variable ciri_uji
ciri_uji = zeros(jumlah_file, 7);

for n = 1:jumlah_file
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
    H(~Img_gray) = 0;
    S(~Img_gray) = 0;
    V(~Img_gray) = 0;
    Hue = sum(sum(H))/sum(sum(Img_gray));
    Saturation = sum(sum(S))/sum(sum(Img_gray));
    Value = sum(sum(V))/sum(sum(Img_gray));
    
    % Menghitung GLCM
    glcm = graycomatrix(Img_gray, 'Offset', [0 1]); 
    stats = graycoprops(glcm); % Mengekstraksi Fitur GLCM 
    
    % Menyimpan Hasil Ekstraksi Fitur HSV
    ciri_uji(n, 1) = Hue;
    ciri_uji(n, 2) = Saturation;
    ciri_uji(n, 3) = Value;
    
    % Menyimpan Hasil Ekstraksi Fitur GLCM
    ciri_uji(n, 4) = stats.Contrast; 
    ciri_uji(n, 5) = stats.Correlation; 
    ciri_uji(n, 6) = stats.Energy; 
    ciri_uji(n, 7) = stats.Homogeneity; 
end


% Normalisasi Nilai Ciri Uji
ciri_ujiZ = zeros(jumlah_file,7);
for k = 1:jumlah_file
ciri_ujiZ(k,:) = (ciri_uji(k,:) - muZ)./sigmaZ;
end

% Ekstrak Variable Ciri_UjiZ ke dalam Variable PC
PC1 = ciri_ujiZ(:,1);
PC2 = ciri_ujiZ(:,2);

% Mengujikan Hasil Klasifikasi KNN
hasil_uji = predict(Mdl,[PC1,PC2]);

% Kelas Rose
x1 = [];
y1 = [];
jumlah_rose = 0;
for n = 1:jumlah_file
if isequal(hasil_uji{n},'Rose');
jumlah_rose = jumlah_rose+1;
x1(jumlah_rose,1) = PC1(n);
y1(jumlah_rose,1) = PC2(n);
end
end

% Kelas Calendula
x2 = [];
y2 = [];
jumlah_calendula = 0;
for n = 1:jumlah_file
if isequal(hasil_uji{n},'Calendula');
jumlah_calendula = jumlah_calendula+1;
x2(jumlah_calendula,1) = PC1(n);
y2(jumlah_calendula,1) = PC2(n);
end
end

% Kelas Iris
x3 = [];
y3 = [];
jumlah_iris= 0;
for n = 1:jumlah_file
if isequal(hasil_uji{n},'Iris');
jumlah_iris= jumlah_iris+1;
x3(jumlah_iris,1) = PC1(n);
y3(jumlah_iris,1) = PC2(n);
end
end

% Kelas Dandelion
x4 = [];
y4 = [];
jumlah_dandelion= 0;
for n = 1:jumlah_file
if isequal(hasil_uji{n},'BellFlower');
jumlah_dandelion = jumlah_dandelion+1;
x4(jumlah_dandelion,1) = PC1(n);
y4(jumlah_dandelion,1) = PC2(n);
end
end

% Kelas Viola
x5 = [];
y5 = [];
jumlah_viola = 0;
for n = 1:jumlah_file
if isequal(hasil_uji{n},'Viola');
jumlah_viola = jumlah_viola+1;
x5(jumlah_viola,1) = PC1(n);
y5(jumlah_viola,1) = PC2(n);
end
end

% Kelas Lilium
x6 = [];
y6 = [];
jumlah_lilium = 0;
for n = 1:jumlah_file
if isequal(hasil_uji{n},'Lilium');
jumlah_lilium = jumlah_lilium+1;
x6(jumlah_lilium,1) = PC1(n);
y6(jumlah_lilium,1) = PC2(n);
end
end

% Kelas WaterLily
x7 = [];
y7 = [];
jumlah_waterlily = 0;
for n = 1:jumlah_file
if isequal(hasil_uji{n},'WaterLily');
jumlah_waterlily = jumlah_waterlily+1;
x7(jumlah_waterlily,1) = PC1(n);
y7(jumlah_waterlily,1) = PC2(n);
end
end


