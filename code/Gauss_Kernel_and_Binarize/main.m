%%clc; clear; close all;
dbstop if error;

%% folder path
root_folder_path = uigetdir;
list_red = get_all_files_of_a_certain_name_pattern_in_a_rootpath(root_folder_path, '*.tif');

for i = 1:length(list_red)
    %% load figures
    full_path = list_red{i};
    old_fig = imread(full_path);

    %% process
    new_fig = Gauss_Kernel_and_Binarize(old_fig);

    %% save figures
    save_full_path = strrep(full_path,"data","result");
    create_folder(fileparts(save_full_path));
    imwrite(new_fig, save_full_path);
end