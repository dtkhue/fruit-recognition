clc
clear all
scrfile = dir('D:\projects\datain\*.jpg');
for r = 1:length(scrfile)
    filename = strcat('D:\chuyende\datain\',scrfile(r).name);
    he = imread(filename);
    cform = makecform('srgb2lab');
    lab_he = applycform(he,cform);
    ab = double(lab_he(:,:,2:3));
    nrows = size(ab,1);
    ncols = size(ab,2);
    ab = reshape(ab,nrows*ncols,2);
    nColors = 2;
    [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
        'Replicates',3);
    pixel_labels = reshape(cluster_idx,nrows,ncols);
    segmented_images = cell(1,2);
    rgb_label = repmat(pixel_labels,[1 1 3]);
    for k = 1:nColors
        color = he;
        color(rgb_label ~= k) = 255 ;
        segmented_images{k} = color;
    end
    B = segmented_images{2};
%     B = imresize(B,[500 500]);
    out= strcat('D:\chuyende\dataout\',scrfile(r).name);
    imwrite(B,out,'jpg');
end


