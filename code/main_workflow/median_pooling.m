function intensity_volume = median_pooling(intensity,frame_per_volume)

% median-pooling for a volume. 
%
% 2024-04-15, Yixuan Li
%

% Reshape
n = numel(intensity);
num_groups = floor(n / frame_per_volume);
intensity_reshaped = reshape(intensity(1:num_groups*frame_per_volume), frame_per_volume, []);

% Calculate median, omit nan
intensity_volume = median(intensity_reshaped, 1, 'omitnan');
intensity_volume = intensity_volume';

end