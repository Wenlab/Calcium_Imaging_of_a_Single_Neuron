function create_mip(folder_path, frame_per_volume)
    % Directory where the MIPs will be saved
    [father_folder_path, folder_name] = fileparts(folder_path);
    save_folder = strcat(father_folder_path, '_Max_Intensity_Projection');
    save_folder = fullfile(save_folder,folder_name);
    if ~exist(save_folder, 'dir')
        mkdir(save_folder);
    end
    
    % Get a list of TIFF files in the folder
    files = dir(fullfile(folder_path, '*.tif'));
    num_files = length(files);
    
    % Process every volume
    for idx = 1:frame_per_volume:num_files
        end_idx = min(idx + frame_per_volume - 1, num_files); % Ensure we don't go out of bounds
        max_image = []; % Initialize the MIP image

        % Read and compute the maximum intensity projection
        for j = idx:end_idx
            current_image = imread(fullfile(folder_path, files(j).name));
            if isempty(max_image)
                max_image = current_image;
            else
                max_image = max(max_image, current_image); % Compute MIP
            end
        end
        
        % Save the MIP image
        mip_filename = sprintf('MIP_from_%08d_to_%08d.tif', idx, end_idx);
        imwrite(max_image, fullfile(save_folder, mip_filename));
    end
end