% draw red and green channel together~
%
% 2023-12-13, Yixuan Li
%

function draw_red_green_together(folder_path,pooling_method,analyze_area,analyze_worm,volume_per_second,leaking_percentage)

% Get a list of all .tif files in the folder
switch pooling_method
    case "mean"
        list = get_all_files_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'intensity_volume_mean.mat');
        save_folder_path = fullfile(folder_path,analyze_area,strcat("animal_",num2str(analyze_worm)),"mean pooling");
        create_folder(save_folder_path);
    case "max"
        list = get_all_files_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'intensity_volume_max.mat');
        save_folder_path = fullfile(folder_path,analyze_area,strcat("animal_",num2str(analyze_worm)),"max pooling");
        create_folder(save_folder_path);
    case "median"
        list = get_all_files_of_a_certain_name_pattern_in_a_rootpath(folder_path, 'intensity_volume_median.mat');
        save_folder_path = fullfile(folder_path,analyze_area,strcat("animal_",num2str(analyze_worm)),"median pooling");
        create_folder(save_folder_path);
end

% error
if length(list) ~= 2
    error("The number of intensity_volume.mat is not 2!");
end

%% get channel info
if contains(list{1},"Red")
    I_1_info = "Red";
    I_2_info = "Green";
elseif contains(list{1},"Green")
    error("The Red and Green Channels Are Switched.");
end

%% load data
I_red = load_data_from_mat(list{1});
I_green = load_data_from_mat(list{2});

%% Fix light-leaking problem

I_red = I_red - I_green * leaking_percentage;

if sum(I_red < 0) >= 1
    why;
end

%% number of volumes
n_volume = length(I_red);

%% Tukey
figure;
histogram(I_red);
xlabel("I_1");
ylabel("count");
IQR_index = 3;
[~, ~, mask_up_1, mask_down_1, up_limit, down_limit, upper_bound, lower_bound] = Tukey_test(I_red, IQR_index);
Tukey_test_draw_lines(up_limit, down_limit, upper_bound, lower_bound);
saveas(gcf,fullfile(save_folder_path, 'Tukey_test_for_I_1'),'png');

figure;
histogram(I_green);
xlabel("I_2");
ylabel("count");
IQR_index = 3;
[~, ~, mask_up_2, mask_down_2, up_limit, down_limit, upper_bound, lower_bound] = Tukey_test(I_green, IQR_index);
Tukey_test_draw_lines(up_limit, down_limit, upper_bound, lower_bound);
saveas(gcf,fullfile(save_folder_path, 'Tukey_test_for_I_2'),'png');

mask_up = mask_up_1 | mask_up_2;
mask_down = mask_down_1 | mask_down_2;

is_outlier = mask_up | mask_down;
I_red(is_outlier) = nan;
I_green(is_outlier) = nan;

%% plot I
figure;

subplot(4,1,1)
plot_intensity(I_red,list{1});
volume_to_second_for_xlabel(n_volume,volume_per_second);

subplot(4,1,2)
plot_intensity(I_green,list{2});
volume_to_second_for_xlabel(n_volume,volume_per_second);

subplot(4,1,3)
if I_1_info == "Red"
    I_ratio = plot_ratio(I_red,I_green);
else
    I_ratio = plot_ratio(I_green,I_red);
end
volume_to_second_for_xlabel(n_volume,volume_per_second);

subplot(4,1,4)
I_ratio_normalized = normalization_dividing_by_the_mean(I_ratio);
plot(1:length(I_ratio_normalized),I_ratio_normalized,'k');

volume_to_second_for_xlabel(n_volume,volume_per_second);
xlabel("t (s)","FontSize",20);
ylabel("$\frac{ratio-<ratio>}{<ratio>}$","Interpreter","latex","FontSize",20);
ylim([-0.5 +0.5]);

set_full_screen;
saveas(gcf,fullfile(save_folder_path, 'intensity_r_g_ratio'),'png');
saveas(gcf,fullfile(save_folder_path, 'intensity_r_g_ratio'),'fig');

%% plot normalized I
figure;
I_1_normalized = plot_intensity_normalized(I_red,list{1});
subtitle(sprintf("volume per second = %d",volume_per_second));
set_full_screen;

figure;
I_2_normalized = plot_intensity_normalized(I_green,list{2});
subtitle(sprintf("volume per second = %d",volume_per_second));
set_full_screen;

%% plot I
figure;
plot_intensity(I_red,list{1});
xlabel("volume","FontSize",20);
subtitle(sprintf("volume per second = %d",volume_per_second));
set_full_screen;

figure;
plot_intensity(I_green,list{2});
xlabel("volume","FontSize",20);
subtitle(sprintf("volume per second = %d",volume_per_second));
set_full_screen;

%% Corr
is_nan_1 = isnan(I_red);
is_nan_2 = isnan(I_green);
is_nan = is_nan_1 | is_nan_2;

I_1_filted = I_red(~is_nan);
I_2_filted = I_green(~is_nan);

% Pearson Corr
r = corrcoef(I_1_filted,I_2_filted);
fprintf("Pearson Corr = %.4f\n",r(1,2));

% slope of least square
p = polyfit(I_1_filted, I_2_filted, 1);
fprintf("slope of least square = %.4f\n",p(1));

% Visualize_as_X_and_Y
figure;
axis equal;
plot(I_1_filted,I_2_filted,'k-o');
xlabel(I_1_info);
ylabel(I_2_info);
title(sprintf("r = %.2f; b = %.2f",r(1,2),p(1)));
saveas(gcf,fullfile(save_folder_path, 'Visualize_as_X_and_Y'),'png');

%% close
close all;

%% Coefficient of Variance
if I_1_info == "Red"
    CV_Red = std(I_red,'omitnan') / mean(I_red,'omitnan');
    CV_Green = std(I_green,'omitnan') / mean(I_green,'omitnan');
else
    CV_Red = std(I_green,'omitnan') / mean(I_green,'omitnan');
    CV_Green = std(I_red,'omitnan') / mean(I_red,'omitnan');
end

save_para_value_to_txt(save_folder_path, CV_Red);
save_para_value_to_txt(save_folder_path, CV_Green);

fprintf("CV of Red: %.4f\n",CV_Red);
fprintf("CV of Green: %.4f\n",CV_Green);

%% disp
disp('figures saved successfully!')

end