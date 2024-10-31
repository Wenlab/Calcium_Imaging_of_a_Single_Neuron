function new_fig = Gauss_Kernel_and_Binarize(old_fig)
% Function to smooth the image with a Gaussian kernel and then binarize
% it based on the max intensity in 16x16 blocks, followed by plotting
% the distribution of intensity values for both 1s and 0s.
%
% Input:
%   old_fig - Input image (1024x1024, assumed grayscale)
% Output:
%   new_fig - Binarized image after Gaussian smoothing and thresholding

% Step 1: Convert the input to double precision for accuracy
old_fig = double(old_fig);

% Step 2: Apply Gaussian Smoothing with a chosen sigma (e.g., 1)
sigma = 1;  % Gaussian kernel standard deviation
smoothed_image = imgaussfilt(old_fig, sigma);

% Step 3: Split the image into 16x16 blocks (each block is 64x64) and compute max intensities
block_size = 64;  % 1024 / 16 = 64
max_intensity_blocks = zeros(16, 16);  % To store max intensity of each 64x64 block

for i = 1:16
    for j = 1:16
        % Extract each 64x64 block
        block = smoothed_image((i-1)*block_size+1:i*block_size, (j-1)*block_size+1:j*block_size);
        % Find the maximum intensity in this block
        max_intensity_blocks(i, j) = max(block(:));
    end
end

% Step 4: Find the minimum of the maximum intensities
min_max_intensity = 1.1 * min(max_intensity_blocks(:));
disp(min_max_intensity);

% Step 5: Apply thresholding to the entire image based on the minimum max intensity
binary_fig = smoothed_image > min_max_intensity;  % Threshold the image

% Convert binary result to grayscale (0 -> 0, 1 -> 255)
new_fig = uint8(binary_fig * 255);

% % Step 6: Extract pixel intensities for both 1's and 0's
% intensity_ones = smoothed_image(new_fig);       % Intensities where new_fig == 1
% intensity_zeros = smoothed_image(~new_fig);     % Intensities where new_fig == 0
%
% % Step 7: Plot the distribution of intensities
% figure;
% subplot(2, 1, 1);
% histogram(intensity_ones);  % Plot intensity distribution for 1's
% title('Distribution of Intensities for Pixels with Value 1');
% xlabel('Intensity');
% ylabel('Frequency');
%
% subplot(2, 1, 2);
% histogram(intensity_zeros);  % Plot intensity distribution for 0's
% title('Distribution of Intensities for Pixels with Value 0');
% xlabel('Intensity');
% ylabel('Frequency');
end