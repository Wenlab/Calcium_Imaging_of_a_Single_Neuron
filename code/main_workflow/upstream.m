% up-stream:
%   `.tif` -> `is_outlier.mat`, `.mp4`, `intensity.mat`
%
% For binarization:
%   binarization method: "Direct_Adapt", "Gauss_Adapt".
%   sensitivity threshold: higher, more bright pixels.
%
% For opening:
%   template: use which channel's binarization result as the template.
%   all_template: "red", "green", "nan".
%   soma_template: "red", "green".
%   neurite_template: "same", "opposite".
%
% disk_size: 
%   larger, open more severely.
%
% Open for all: 
%   You can increase sensation threshold and then use opening for all.
%
% For multi worms: (depracated)
%   If your .tif files contain more than 1 worm (which is often the case when
%   we test immobile animals), you can simply write the rectangle containg
%   the worm in region_prop. eg: region_prop_red =
%   [600,800,100,300;480,600,540,680]. And set region_prop_red = [] if only 1 worm.
%
%   For all_template: "nan" is recommended for multi-worm, because different
%   worms will have different brighter channel.
%
% Frame per second:
%   The fps of you data.
%
% For test:
%   is_test: "true", "false".
%   You can set it as "true" with setting the start frame and the end frame 
%   to test the super-parameter.
%
% 2023-12-19, Yixuan Li
%

clc;clear;close all;

dbstop if error;

my_add_path();

%% choose the path to the data
folder_path = uigetdir;
list_red = get_all_folders_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'Red');
folder_path_red = list_red{1};
list_green = get_all_folders_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'Green');
folder_path_green = list_green{1};

%% For binarization
binarization_method = "Gauss_Adapt"; % "Gauss_Adapt" is recommended
sense_red = 0.5; % super-parameter
sense_green = 0.5; % super-parameter

%% For opening which splits the soma and the neurite

% "green" is recommended: In most cases, green channel is brighter, so it is more
% suitable to be a template.
all_template = "red"; 

% "red" is recommended: In most cases, red channel is dimmer, so it is
% easier to be splitted into the soma and the neurite than green channel.
soma_template = "green";

% "opposite" is recommended: Given that it is recommended to use dimmer channel as
% soma_template, "opposite" will retain more neurite than "same".
neurite_template = "opposite"; 

% disk size
disk_size = 5; % super-parameter

%% for the number of somas
n_soma = 1;

%% Opening for the whole neuron
use_open_for_all = true; % true is recommended
disk_size_for_all = 2; % super-parameter

%% fps
frame_per_second = 100; % Hz

%% Background intensity (Use image-J to get these)
intensity_background_red = 101;
intensity_background_green = 101;

%% For multi worms
region_prop_red = [];

%% For test
is_test = false;
start_frame = 1;
end_frame = 300;

%% main
tif_to_mask_and_mp4(folder_path_red,folder_path_green, ...
    binarization_method,sense_red,sense_green,...
    all_template,soma_template,neurite_template,disk_size,...
    is_test,start_frame,end_frame,...
    use_open_for_all,disk_size_for_all,...
    region_prop_red,...
    frame_per_second,...
    n_soma, ...
    intensity_background_red, intensity_background_green);