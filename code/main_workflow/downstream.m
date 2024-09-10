% down-stream: `is_outlier.mat`, `.mp4`, `intensity.mat` -> figures of red
% and green channel
%
% analyze_area: "all", "soma", "axon_dendrite".
%
% pooling-method: "max", "median", "mean".
% "max" is more reliable for scanning in z-axis, because 
% in a volume max-pooling will direct to the brightest frame.
%
% analyze_worm: "0", "1", "2", "3",...
% 0 for skipping
%
% 2023-12-04, Yixuan Li
%

clc;clear;close all;

dbstop if error;

my_add_path();

%% choose the path to the intermediate files
root_folder_path = uigetdir;

%% choose the area that you want to analyze
analyze_area = "all";

%% choose the pooling method
pooling_method = "max";

%% choose the worm to be analyzed
analyze_worm = 0;

%% change this parameter to the frame per volume of your experiment
frame_per_volume = 20;
volume_per_second = 5;

%% Light-leaking percentage (Ask Jiaqi Wang)
leaking_percentage = 0;

%% main
if root_folder_path ~= 0
    root_list = get_all_folders_of_a_certain_name_pattern_in_a_rootpath(root_folder_path,'w');
    [indx,tf] = listdlg('ListString',root_list,'ListSize',[800,600],'Name','Choose files');
    if tf==1
        for i = indx

            %% get folder path
            folder_path = root_list{i};

            %% is_outlier to is_outlier_union
            union_of_red_and_green_mask(folder_path);

            %% I_frame and is_outlier_union to I_volume
            list = get_all_folders_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'Red');
            folder_path_Red = list{1};
            intensity_and_mask_to_intensity(folder_path_Red,analyze_area,frame_per_volume,analyze_worm);

            list = get_all_folders_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'Green');
            folder_path_Green = list{1};
            intensity_and_mask_to_intensity(folder_path_Green,analyze_area,frame_per_volume,analyze_worm);

            %% I_volume to figures
            draw_red_green_together(folder_path,pooling_method,analyze_area,analyze_worm,volume_per_second,leaking_percentage);
        end
    end
end