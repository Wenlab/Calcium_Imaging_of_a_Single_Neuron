function intensity_volume = max_pooling(intensity, frame_per_volume)

% max-pooling for a volume. This procedure is equals to the so-called Max
% Intensity Projection.
%
% 2024-04-15, Yixuan Li
%

% Reshape
n = numel(intensity);
num_groups = floor(n / frame_per_volume);
intensity_reshaped = reshape(intensity(1:num_groups*frame_per_volume), frame_per_volume, []);

% Calculate max, omitnan
% intensity_volume = intensity_reshaped(2,:); % for Liu Qi's con-focal
intensity_volume = max(intensity_reshaped, [], 1);
intensity_volume = intensity_volume';

end