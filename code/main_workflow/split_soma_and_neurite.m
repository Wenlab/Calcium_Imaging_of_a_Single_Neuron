function [soma,axon_dendrite] = split_soma_and_neurite(binary_frame,disk_size,n_soma)

% open
se = strel('disk', disk_size);
binary_frame_opened = imopen(binary_frame, se);

% find connected regions
cc = bwconncomp(binary_frame_opened, 4);
n_pixels = cellfun(@numel, cc.PixelIdxList);

% init
soma = false(size(binary_frame));

% split
if isempty(n_pixels)
    axon_dendrite = false(size(binary_frame));
elseif n_soma == 1

    % make the biggest connected region to be the soma
    [~, largest_idx] = max(n_pixels);
    soma(cc.PixelIdxList{largest_idx}) = true;

    % make the diff to be the neurite
    axon_dendrite = binary_frame & ~soma;

elseif n_soma == 2

    % make the biggest and the second biggest connected region to be the soma
    [~, largest_idx] = max(n_pixels);
    n_pixels(largest_idx) = 0;
    [~, second_largest_idx] = max(n_pixels);
    soma(cc.PixelIdxList{largest_idx}) = true;
    soma(cc.PixelIdxList{second_largest_idx}) = true;

    % make the diff to be the neurite
    axon_dendrite = binary_frame & ~soma;

end

end