function generate_pdf(img_dirname, img_dirpath, fS, f1, f2)


% %% FIXME THIS IS NOT GENERAL
% img_dirname 
% % 211006_BRZ0182_OS1OS2_1_small_7
% img_dirpath
% % C:\Users\Interns\Documents\MATLAB\data\211006_BRZ0182_OS1OS2_1_small_7

clear figure_property;
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';
figure_property.Width= '11'; % Figure width on canvas
figure_property.Height= '8'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '12';
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '12';
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
figure_property.FontWeight= 'auto';
figure_property.FontAngle= 'auto';
figure_property.FontEncoding= 'latin1';
figure_property.PSLevel= '3';
figure_property.Renderer= 'painters';
figure_property.Resolution= '600';
figure_property.LineStyleMap= 'none';
figure_property.ApplyStyle= '0';
figure_property.Bounds= 'tight';
figure_property.LockAxes= 'off';
figure_property.LockAxesTicks= 'off';
figure_property.ShowUI= 'off';
figure_property.SeparateText= 'off';

img_dir_content = dir(fullfile(img_dirpath, 'png'));
video_dir_content = dir(fullfile(img_dirpath, 'mp4'));

pmax = size(img_dir_content, 1) - 2;

% vmax = size(video_dir_content, 1) - 2;
% allmax = pmax + vmax;

figure(111);
for pp = 1:pmax
    imagefilefeatures = img_dir_content(pp + 2);
    [filepath,name,ext] = fileparts(fullfile(imagefilefeatures.folder, imagefilefeatures.name));
    subplot(3, 5, pp); % 3 = lign & 5 = col
    if ext == '.png'
        imshow(fullfile(imagefilefeatures.folder, imagefilefeatures.name));
    end
    axis image;
    th = title(name, 'Interpreter', 'none');
    titlePos = get(th , 'position');
    titlePos(2) = titlePos(2) - 20;
    set(th , 'position' , titlePos);
    ax = gca;
    ax.TitleFontSizeMultiplier = 0.595;
end

videofilefeatures = video_dir_content(3);
[video_dir_path,name,ext] = fileparts(fullfile(videofilefeatures.folder, videofilefeatures.name));

% v = VideoReader(video_dir_path);
% 
% while hasFrame(v)
%     frame = frameread(v,1);
% end
% 
% subplot(3, 5, pp + 1);


% f = figure(111);
% f.Units = 'inches';
% f.Position = [1 1 11 8];
% 
% figure(111)

chosen_figure=111;
set(chosen_figure, 'PaperUnits', 'inches');
set(chosen_figure, 'PaperPositionMode', 'auto');
set(chosen_figure,'PaperSize', [str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure, 'Units', 'inches');
% hgexport(fullfile(img_dirpath),fullfile(img_dirname, '.pdf'),figure_property); %Set desired file name
print(chosen_figure, img_dirname, '-dpdf', '-fillpage');
movefile(strcat(img_dirname, '.pdf'), img_dirpath);