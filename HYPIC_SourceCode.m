classdef HYPIC < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure      matlab.ui.Figure
        GridLayout    matlab.ui.container.GridLayout
        PanelAnh      matlab.ui.container.Panel
        GridLayout2   matlab.ui.container.GridLayout
        Image10       matlab.ui.control.Image
        Image9        matlab.ui.control.Image
        Image8        matlab.ui.control.Image
        Image7        matlab.ui.control.Image
        Image6        matlab.ui.control.Image
        Image5        matlab.ui.control.Image
        Image4        matlab.ui.control.Image
        Image3        matlab.ui.control.Image
        Image2        matlab.ui.control.Image
        Image         matlab.ui.control.Image
        Panel         matlab.ui.container.Panel
        QuaylaiAnh    matlab.ui.control.Image
        Xuat          matlab.ui.control.Image
        UIAxes        matlab.ui.control.UIAxes
        TabGroup      matlab.ui.container.TabGroup
        EditTab       matlab.ui.container.Tab
        sngLabel_2    matlab.ui.control.Label
        Contrast      matlab.ui.control.Image
        Smooth        matlab.ui.control.Image
        sngLabel_7    matlab.ui.control.Label
        Sharpen       matlab.ui.control.Image
        sngLabel_6    matlab.ui.control.Label
        sngLabel      matlab.ui.control.Label
        Brightness    matlab.ui.control.Image
        NngcaoTab     matlab.ui.container.Tab
        Filter        matlab.ui.control.Image
        sngLabel_8    matlab.ui.control.Label
        Nhieu         matlab.ui.control.Image
        sngLabel_5    matlab.ui.control.Label
        Edge          matlab.ui.control.Image
        sngLabel_10   matlab.ui.control.Label
        Histogram     matlab.ui.control.Image
        sngLabel_9    matlab.ui.control.Label
        ButtonGroup   matlab.ui.container.ButtonGroup
        Slider_range  matlab.ui.control.RangeSlider
        SocBtn        matlab.ui.control.Button
        MuitiuBtn     matlab.ui.control.Button
        Quaylai       matlab.ui.control.Image
        BrightAuto    matlab.ui.control.Image
        Slider        matlab.ui.control.Slider
        SoSanh        matlab.ui.control.Image
    end

    
    properties (Access = private)
           OriginalImage   % Lưu ảnh gốc để so sánh/reset
           ProcessedImage  % Lưu ảnh sau khi qua các bộ lọc % Description
           PreviousImage %Lưu ảnh của bước ngay trước đó
           CurrentMode % Lưu tên chức năng đang chọn (ví dụ: 'Brightness', 'Contrast'...)
           IsShowingOriginal = false; % Mặc định là đang hiện ảnh đã xử lý
    end
    
    methods (Access = private)
        

    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
           
            % Hiện Panel chọn ảnh lên trên cùng
            app.PanelAnh.Visible = 'on';
    
            % (Tùy chọn) Ẩn các công cụ khác để người dùng tập trung chọn ảnh
            app.TabGroup.Visible = 'off'; 
            app.Slider.Visible = 'off';
            app.ButtonGroup.Visible = 'off';

        end

        % Image clicked function: Image, Image10, Image2, Image3, Image4, 
        % ...and 5 other components
        function ImageClicked(app, event)
            % 1. Lấy ảnh từ chính cái Image vừa click (hoặc imread file gốc)
            app.OriginalImage = imread(event.Source.Tag); 
            app.ProcessedImage = app.OriginalImage;
    
            % 2. Hiển thị lên trục tọa độ chính
            imshow(app.OriginalImage, 'Parent', app.UIAxes);
    
            % 3. "Dọn dẹp" giao diện: Ẩn Panel chọn ảnh, hiện công cụ chỉnh sửa
            app.PanelAnh.Visible = 'off';
            app.TabGroup.Visible = 'on';
            app.ButtonGroup.Visible = 'on';
            app.SocBtn.Visible = "off";
            app.MuitiuBtn.Visible ="off";
            app.Slider_range.Visible = 'off';

        end

        % Image clicked function: Brightness
        function BrightnessImageClicked(app, event)
            app.CurrentMode = 'Brightness';
            app.Slider.Limits = [-255 255]; 
            app.Slider.Value = 0;      % Mặc định là 0 (giữ nguyên)
            app.Slider.Visible = 'on';
            app.BrightAuto.Visible = 'on';
            app.SocBtn.Visible = "off";
            app.MuitiuBtn.Visible ="off";
            app.Slider_range.Visible = 'off';
            app.PreviousImage = app.ProcessedImage;
        end

        % Image clicked function: BrightAuto
        function BrightAutoImageClicked(app, event)
            if isempty(app.OriginalImage)
                return;
            end
            %app.PreviousImage = app.ProcessedImage;
            fhsv = rgb2hsv(app.ProcessedImage); % Chuyển sang HSV
            fhsv(:,:,3) = histeq(fhsv(:,:,3)); % Chỉ cân bằng kênh Value (độ sáng)
            app.ProcessedImage = hsv2rgb(fhsv); % Chuyển ngược lại RGB
            imshow(app.ProcessedImage, 'Parent', app.UIAxes);
        end

        % Image clicked function: Contrast
        function ContrastImageClicked2(app, event)
            app.CurrentMode = 'Contrast';
            app.Slider.Limits = [0 2]; % Hệ số nhân độ sáng từ 0 đến 2
            app.Slider.Value = 1;      % Mặc định là 1 (giữ nguyên)
            app.Slider.Visible = 'on';
            app.SocBtn.Visible = "off";
            app.MuitiuBtn.Visible ="off";
            app.Slider_range.Visible = 'off';
            app.PreviousImage = app.ProcessedImage;

        end

        % Image clicked function: Sharpen
        function SharpenImageClicked(app, event)
            app.CurrentMode = 'Sharpen';
            % Slider đại diện cho mức độ sắc nét (ví dụ từ 0 đến 5)
            app.Slider.Limits = [0 5]; 
            app.Slider.Value = 0; % Mặc định là 0 (chưa làm nét)
            app.Slider.Visible = 'on';
            app.BrightAuto.Visible = 'off';
            app.SocBtn.Visible = "off";
            app.MuitiuBtn.Visible ="off";
            app.Slider_range.Visible = 'off';
            app.PreviousImage = app.ProcessedImage;
        end

        % Image clicked function: Smooth
        function SmoothImageClicked(app, event)
            app.CurrentMode = 'Smooth';
            % Slider sẽ đại diện cho kích thước bộ lọc (ví dụ từ 1 đến 15)
            app.Slider.Limits = [1 15]; 
            app.Slider.Value = 1; % Mặc định là 1 (không làm mịn)
            app.Slider.Visible = 'on';
            app.BrightAuto.Visible = 'off';
            app.SocBtn.Visible = "off";
            app.MuitiuBtn.Visible ="off";
            app.Slider_range.Visible = 'off';
            app.PreviousImage = app.ProcessedImage;
        end

        % Image clicked function: Nhieu
        function NhieuImageClicked(app, event)
            app.Slider.Visible = 'off';
            app.SocBtn.Visible = "on";
            app.MuitiuBtn.Visible ="on";
            app.Slider_range.Visible = 'off';
            app.PreviousImage = app.ProcessedImage;
        
        end

        % Image clicked function: Filter
        function FilterImageClicked(app, event)
            app.CurrentMode = 'Filter';
            % Tông màu (Hue) trong MATLAB chạy từ 0 đến 1
            app.Slider.Limits = [0 1]; 
            app.Slider.Value = 0; % Mặc định không đổi màu
            app.Slider.Visible = 'on';
            app.SocBtn.Visible = "off";
            app.MuitiuBtn.Visible ="off";
            app.Slider_range.Visible = 'off';
            app.PreviousImage = app.ProcessedImage;
        end

        % Button pushed function: SocBtn
        function SocBtnButtonPushed(app, event)
            app.Slider_range.Visible = "on";
            app.SocBtn.Visible = "off";
            app.MuitiuBtn.Visible ="off";
            app.CurrentMode = 'NhieuSoc';
            app.PreviousImage = app.ProcessedImage;

        end

        % Button pushed function: MuitiuBtn
        function MuitiuBtnButtonPushed(app, event)
            if isempty(app.ProcessedImage), return; end
            app.PreviousImage = app.ProcessedImage;
    
            % 1. Lấy ảnh hiện tại để xử lý
            img = app.ProcessedImage;
    
            % 2. Thuật toán lọc trung vị (Median Filter)
            % Nếu là ảnh màu, ta lọc trên từng kênh màu hoặc chuyển sang ảnh xám
            if size(img, 3) == 3
                % Lọc cho từng kênh R, G, B
                r = medfilt2(img(:,:,1), [3 3]);
                g = medfilt2(img(:,:,2), [3 3]);
                b = medfilt2(img(:,:,3), [3 3]);
                app.ProcessedImage = cat(3, r, g, b);
                
            else
                % Nếu là ảnh xám
                app.ProcessedImage = medfilt2(img);
            end
    
            % 3. Hiển thị kết quả
            imshow(app.ProcessedImage, 'Parent', app.UIAxes);
            msgbox('Đã nhận diện và khử nhiễu muối tiêu bằng Median Filter');
        end

        % Image clicked function: Edge
        function EdgeImageClicked(app, event)
            app.Slider.Visible = 'on';
            app.CurrentMode = 'Edge';
            app.Slider.Limits = [0 1]; 
            app.Slider.Value = 0.2;
            app.SocBtn.Visible = "off";
            app.MuitiuBtn.Visible ="off";
            app.Slider_range.Visible = 'off';
            app.PreviousImage = app.ProcessedImage;
        end

        % Image clicked function: Xuat
        function XuatImageClicked(app, event)
            % 1. Mở hộp thoại lưu file
            [file, path] = uiputfile({'*.png','Portable Network Graphics (*.png)'; ...
                              '*.jpg','Joint Photographic Experts Group (*.jpg)'}, ...
                              'Lưu ảnh kết quả');

            % 2. KIỂM TRA ĐIỀU KIỆN ĐÚNG:
            % Nếu người dùng KHÔNG bấm Cancel (file sẽ là tên file, không phải số 0)
            if ischar(file) || isstring(file)
                fullPath = fullfile(path, file);
        
                % 3. Lưu ảnh đang hiển thị (ProcessedImage)
                imwrite(app.ProcessedImage, fullPath);
        
                % Thông báo thành công
                uiconfirm(app.UIFigure, ['Đã lưu ảnh tại: ', file], 'Thành công', ...
                        'Options', {'OK'}, 'Icon', 'success');
            end
        end

        % Image clicked function: Quaylai
        function QuaylaiImageClicked(app, event)
            if isempty(app.PreviousImage)
                return;
            end
            app.ProcessedImage = app.PreviousImage;
            imshow(app.ProcessedImage, 'Parent', app.UIAxes);
                % Ẩn biểu đồ hoặc slider nếu đang hiện
      
             app.Slider.Visible = 'off';
             app.SocBtn.Visible = "off";
             app.MuitiuBtn.Visible ="off";
        
        end

        % Image clicked function: Histogram
        function HistogramImageClicked(app, event)
            % 1. Lấy ảnh gốc để xử lý
            f = app.OriginalImage;

            % 2. Thực hiện cân bằng Histogram (Dùng hệ màu HSV để giữ màu tự nhiên)
            fhsv = rgb2hsv(f);
            fhsv(:,:,3) = histeq(fhsv(:,:,3)); % Cân bằng lược đồ trên kênh độ sáng (Value)[cite: 1]
            app.ProcessedImage = hsv2rgb(fhsv);

            % 3. Cập nhật ảnh lên giao diện chính
            imshow(app.ProcessedImage, 'Parent', app.UIAxes);

            % 4. Mở cửa sổ mới để hiển thị so sánh (Đoạn code bạn muốn bỏ vô)
            fig = figure('Name', 'So sánh Histogram', 'NumberTitle', 'off', 'Color', 'white');
    
            % --- Hiển thị Ảnh cũ và Lược đồ cũ ---
            subplot(2, 2, 1);
            imshow(app.OriginalImage);
            title('Ảnh gốc');
     
            subplot(2, 2, 2);
            imhist(rgb2gray(app.OriginalImage)); % Vẽ lược đồ xám của ảnh gốc
            title('Histogram ảnh gốc');
            grid on;
    
            % --- Hiển thị Ảnh mới và Lược đồ mới ---
            subplot(2, 2, 3);
            imshow(app.ProcessedImage);
            title('Ảnh sau khi xử lý');
    
            subplot(2, 2, 4);
            imhist(rgb2gray(app.ProcessedImage)); % Vẽ lược đồ xám của ảnh mới
            title('Histogram ảnh mới (Đã trải đều)');
            grid on;
        end

        % Image clicked function: QuaylaiAnh
        function QuaylaiAnhClicked(app, event)
            % Hiện Panel chọn ảnh lên trên cùng
            app.PanelAnh.Visible = 'on';
    
            % (Tùy chọn) Ẩn các công cụ khác để người dùng tập trung chọn ảnh
            app.TabGroup.Visible = 'off'; 
            app.Slider.Visible = 'off';
            app.ButtonGroup.Visible = 'off';
        end

        % Image clicked function: SoSanh
        function SoSanhBtnButtonPushed(app, event)
            % 1. Kiểm tra biến trạng thái
            if app.IsShowingOriginal == true
                % Nếu đang hiện ảnh gốc -> Chuyển về ảnh xử lý
                if ~isempty(app.ProcessedImage)
                    imshow(app.ProcessedImage, 'Parent', app.UIAxes);
                end
                app.IsShowingOriginal = false; % Tắt trạng thái xem gốc
            else
                % Nếu đang hiện ảnh xử lý -> Chuyển sang ảnh gốc
                if ~isempty(app.OriginalImage)
                    imshow(app.OriginalImage, 'Parent', app.UIAxes);
                end
                app.IsShowingOriginal = true; % Bật trạng thái xem gốc
            end
        end

        % Value changing function: Slider
        function SliderValueChanging(app, event)
            val = event.Value;
            if isempty(app.OriginalImage)
                return;
            end

            switch app.CurrentMode
                case 'Brightness'
                    %Chỉnh độ sáng (cộng hệ số)
                    a= app.PreviousImage + val;
                    app.ProcessedImage = a;
            
                case 'Smooth'
                    % 1. Tạo bản sao ảnh đã làm mịn 
                    k = round(val);
                    if mod(k, 2) == 0, k = k + 1; end
                    if size(app.PreviousImage, 3) == 3
                        R = medfilt2(app.PreviousImage(:,:,1), [k k]);
                        G = medfilt2(app.PreviousImage(:,:,2), [k k]);
                        B = medfilt2(app.PreviousImage(:,:,3), [k k]);
                        img_blurred = cat(3, R, G, B);
                    else
                        img_blurred = medfilt2(app.PreviousImage, [k k]);
                    end
                    %  2. Nhận diện vùng da để tạo Mask (Mặt nạ)
                    img_ycbcr = rgb2ycbcr(app.PreviousImage);
                    Cb = img_ycbcr(:,:,2);
                    Cr = img_ycbcr(:,:,3);

                    % Thuật toán ngưỡng: Vùng nào nằm trong khoảng này thì khả năng cao là da
                    % "Phân đoạn ảnh dựa trên ngưỡng màu"
                    mask = (Cb > 77) & (Cb < 127) & (Cr > 133) & (Cr < 173);

                    % Làm mờ nhẹ cái mặt nạ để khi ghép không bị răng cưa
                    mask = imgaussfilt(double(mask), 2);
                    % 3. Trộn ảnh theo công thức Alpha Blending
                    % Ảnh kết quả = Ảnh gốc * (1 - mask) + Ảnh mờ * mask
                    img_orig = double(app.PreviousImage);
                    img_smooth = double(img_blurred);

                    % Nhân từng pixel (broadcast)
                    app.ProcessedImage = uint8(img_orig .* (1 - mask) + img_smooth .* mask);
                    

                case 'Sharpen'
                    % val là cường độ làm nét (amount)
                    if val == 0
                        app.ProcessedImage = app.PreviousImage;
                    else
                        % val từ slider (ví dụ từ 0 đến 2)
                        alpha = val; 
    
                        % Tạo một kernel lọc thông cao đơn giản
                        % Ma trận này sẽ giữ lại chi tiết biên và làm mờ vùng nền
                        h = [-1 -1 -1; -1 8 -1; -1 -1 -1]; 
    
                        % Thực hiện lọc
                        high_pass_part = imfilter(double(app.PreviousImage), h);
    
                        % Cộng phần tần số cao vào ảnh gốc để làm nét
                        app.ProcessedImage = uint8(double(app.PreviousImage) + alpha * high_pass_part);
 
                    end
                
                case 'Contrast'
                    img_double = double(app.PreviousImage);
                    % Công thức tăng/giảm tương phản quanh giá trị trung bình
                    a = uint8((img_double - 128) * val + 128);
                    app.ProcessedImage = a;
                case 'Edge'
                    % 1. Chuyển sang hệ màu HSV
                    f = app.PreviousImage;
                    fhsv = rgb2hsv(f); 

                    % 2. Tạo Mask dựa trên độ bão hòa màu (thường vật thể chính có màu đậm hơn nền)
                    S = fhsv(:,:,2); % Độ bão hòa
                     % Độ sáng
    
                    % Kết hợp: Lấy vùng có màu sắc (S > val) HOẶC vùng có độ sáng rõ rệt
                    mask = S > val;
                    mask = imfill(mask, 'holes'); % Lấp đầy các lỗ trống bên trong vật thể

                    % 3. Làm mịn biên của Mask để nhãn dán trông đẹp hơn
                    mask = bwareaopen(mask, 500); 
                    mask = imfilter(double(mask), fspecial('average', 5)) > 0.5;

                    % 4. Tạo ảnh kết quả với nền trắng (giống như dán sticker lên giấy)
                    sticker = 255 * uint8(ones(size(f))); % Tạo nền trắng tinh
                    mask_3ch = uint8(cat(3, mask, mask, mask)); % Biến mask thành 3 kênh màu

                    % Chỗ nào mask = 1 thì giữ ảnh gốc, chỗ nào mask = 0 thì lấy nền trắng
                    result = f .* mask_3ch + sticker .* (1 - mask_3ch);

                    % 5. Hiển thị kết quả
                    app.ProcessedImage = result;
                    
                case 'Filter'
                    if size(app.PreviousImage, 3) == 3 % Chỉ xử lý ảnh màu
                        % 1. Chuyển sang hệ HSV
                        hsv = rgb2hsv(double(app.PreviousImage)/255);
                        H = hsv(:,:,1);
        
                        % 2. Xoay vòng tông màu (val từ slider nên để từ 0 đến 1)
                        % Công thức: H_new = mod(H + val, 1)
                        H = mod(H + val, 1);
        
                        % 3. Ghép lại và hiển thị
                        hsv(:,:,1) = H;
                        app.ProcessedImage = hsv2rgb(hsv);
                    else
                        % Nếu là ảnh xám thì không đổi màu được, có thể thông báo hoặc bỏ qua
                        app.ProcessedImage = app.PreviousImage;
                    end


            end
    
            % Hiển thị kết quả ngay lập tức
            imshow(app.ProcessedImage, 'Parent', app.UIAxes);
        end

        % Value changing function: Slider_range
        function Slider_rangeValueChanging(app, event)
            range_val = event.Value;
            if isempty(app.PreviousImage)
                return;
            end
    
            switch app.CurrentMode
                case 'NhieuSoc'
                    r1 = range_val(1);
                    r2 = range_val(2);
                    app.ProcessedImage = PeriodicFilter(app.PreviousImage,r1,r2);
                    imshow(app.ProcessedImage, 'Parent', app.UIAxes);
                    
            end


        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 400 750];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.Theme = 'light';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x'};
            app.GridLayout.RowHeight = {'1x', 40, 100};

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.GridLayout);
            app.ButtonGroup.Layout.Row = 2;
            app.ButtonGroup.Layout.Column = 1;

            % Create SoSanh
            app.SoSanh = uiimage(app.ButtonGroup);
            app.SoSanh.ImageClickedFcn = createCallbackFcn(app, @SoSanhBtnButtonPushed, true);
            app.SoSanh.Position = [321 6 40 29];
            app.SoSanh.ImageSource = fullfile(pathToMLAPP, 'beforeafter.png');

            % Create Slider
            app.Slider = uislider(app.ButtonGroup);
            app.Slider.ValueChangingFcn = createCallbackFcn(app, @SliderValueChanging, true);
            app.Slider.FontName = 'Tahoma';
            app.Slider.FontSize = 10;
            app.Slider.Visible = 'off';
            app.Slider.Position = [79 27 178 3];

            % Create BrightAuto
            app.BrightAuto = uiimage(app.ButtonGroup);
            app.BrightAuto.ImageClickedFcn = createCallbackFcn(app, @BrightAutoImageClicked, true);
            app.BrightAuto.Visible = 'off';
            app.BrightAuto.Position = [272 6 25 29];
            app.BrightAuto.ImageSource = fullfile(pathToMLAPP, 'brightnessauto.png');

            % Create Quaylai
            app.Quaylai = uiimage(app.ButtonGroup);
            app.Quaylai.ImageClickedFcn = createCallbackFcn(app, @QuaylaiImageClicked, true);
            app.Quaylai.Position = [1 3 57 34];
            app.Quaylai.ImageSource = fullfile(pathToMLAPP, 'undo.png');

            % Create MuitiuBtn
            app.MuitiuBtn = uibutton(app.ButtonGroup, 'push');
            app.MuitiuBtn.ButtonPushedFcn = createCallbackFcn(app, @MuitiuBtnButtonPushed, true);
            app.MuitiuBtn.Icon = fullfile(pathToMLAPP, 'salt.png');
            app.MuitiuBtn.FontName = 'Tahoma';
            app.MuitiuBtn.FontSize = 10;
            app.MuitiuBtn.FontWeight = 'bold';
            app.MuitiuBtn.Visible = 'off';
            app.MuitiuBtn.Position = [69 7 110 28];
            app.MuitiuBtn.Text = 'Nhiễu muối tiêu';

            % Create SocBtn
            app.SocBtn = uibutton(app.ButtonGroup, 'push');
            app.SocBtn.ButtonPushedFcn = createCallbackFcn(app, @SocBtnButtonPushed, true);
            app.SocBtn.Icon = fullfile(pathToMLAPP, 'pattern.png');
            app.SocBtn.FontName = 'Tahoma';
            app.SocBtn.FontSize = 10;
            app.SocBtn.FontWeight = 'bold';
            app.SocBtn.Visible = 'off';
            app.SocBtn.Position = [191 7 101 27];
            app.SocBtn.Text = 'Nhiễu sọc';

            % Create Slider_range
            app.Slider_range = uislider(app.ButtonGroup, 'range');
            app.Slider_range.Limits = [0 50];
            app.Slider_range.ValueChangingFcn = createCallbackFcn(app, @Slider_rangeValueChanging, true);
            app.Slider_range.FontName = 'Tahoma';
            app.Slider_range.FontSize = 10;
            app.Slider_range.Visible = 'off';
            app.Slider_range.Position = [79 27 201 3];
            app.Slider_range.Value = [5 40];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout);
            app.TabGroup.Layout.Row = 3;
            app.TabGroup.Layout.Column = 1;

            % Create EditTab
            app.EditTab = uitab(app.TabGroup);
            app.EditTab.Title = 'Chỉnh sửa';

            % Create Brightness
            app.Brightness = uiimage(app.EditTab);
            app.Brightness.ImageClickedFcn = createCallbackFcn(app, @BrightnessImageClicked, true);
            app.Brightness.Position = [37 35 37 35];
            app.Brightness.ImageSource = fullfile(pathToMLAPP, 'brightness.png');

            % Create sngLabel
            app.sngLabel = uilabel(app.EditTab);
            app.sngLabel.Position = [37 14 49 22];
            app.sngLabel.Text = 'Độ sáng';

            % Create sngLabel_6
            app.sngLabel_6 = uilabel(app.EditTab);
            app.sngLabel_6.Position = [215 14 49 22];
            app.sngLabel_6.Text = 'Làm nét';

            % Create Sharpen
            app.Sharpen = uiimage(app.EditTab);
            app.Sharpen.ImageClickedFcn = createCallbackFcn(app, @SharpenImageClicked, true);
            app.Sharpen.Position = [215 35 37 35];
            app.Sharpen.ImageSource = fullfile(pathToMLAPP, 'stars (1).png');

            % Create sngLabel_7
            app.sngLabel_7 = uilabel(app.EditTab);
            app.sngLabel_7.Position = [291 14 51 22];
            app.sngLabel_7.Text = 'Làm mịn';

            % Create Smooth
            app.Smooth = uiimage(app.EditTab);
            app.Smooth.ImageClickedFcn = createCallbackFcn(app, @SmoothImageClicked, true);
            app.Smooth.Position = [291 35 37 35];
            app.Smooth.ImageSource = fullfile(pathToMLAPP, 'water.png');

            % Create Contrast
            app.Contrast = uiimage(app.EditTab);
            app.Contrast.ImageClickedFcn = createCallbackFcn(app, @ContrastImageClicked2, true);
            app.Contrast.Position = [133 35 37 35];
            app.Contrast.ImageSource = fullfile(pathToMLAPP, 'magic-wand.png');

            % Create sngLabel_2
            app.sngLabel_2 = uilabel(app.EditTab);
            app.sngLabel_2.Position = [108 14 88 22];
            app.sngLabel_2.Text = 'Độ tương phản';

            % Create NngcaoTab
            app.NngcaoTab = uitab(app.TabGroup);
            app.NngcaoTab.Title = 'Nâng cao';

            % Create sngLabel_9
            app.sngLabel_9 = uilabel(app.NngcaoTab);
            app.sngLabel_9.Position = [291 14 61 22];
            app.sngLabel_9.Text = 'Histogram';

            % Create Histogram
            app.Histogram = uiimage(app.NngcaoTab);
            app.Histogram.ImageClickedFcn = createCallbackFcn(app, @HistogramImageClicked, true);
            app.Histogram.Position = [300 35 37 35];
            app.Histogram.ImageSource = fullfile(pathToMLAPP, 'histogram.png');

            % Create sngLabel_10
            app.sngLabel_10 = uilabel(app.NngcaoTab);
            app.sngLabel_10.Position = [197 14 55 22];
            app.sngLabel_10.Text = 'Tách nền';

            % Create Edge
            app.Edge = uiimage(app.NngcaoTab);
            app.Edge.ImageClickedFcn = createCallbackFcn(app, @EdgeImageClicked, true);
            app.Edge.Position = [206 35 37 35];
            app.Edge.ImageSource = fullfile(pathToMLAPP, 'picture.png');

            % Create sngLabel_5
            app.sngLabel_5 = uilabel(app.NngcaoTab);
            app.sngLabel_5.Position = [24 14 64 22];
            app.sngLabel_5.Text = 'Khử nhiễu ';

            % Create Nhieu
            app.Nhieu = uiimage(app.NngcaoTab);
            app.Nhieu.ImageClickedFcn = createCallbackFcn(app, @NhieuImageClicked, true);
            app.Nhieu.Position = [33 35 37 35];
            app.Nhieu.ImageSource = fullfile(pathToMLAPP, 'sea.png');

            % Create sngLabel_8
            app.sngLabel_8 = uilabel(app.NngcaoTab);
            app.sngLabel_8.Position = [121 14 31 22];
            app.sngLabel_8.Text = 'Filter';

            % Create Filter
            app.Filter = uiimage(app.NngcaoTab);
            app.Filter.ImageClickedFcn = createCallbackFcn(app, @FilterImageClicked, true);
            app.Filter.Position = [118 35 37 35];
            app.Filter.ImageSource = fullfile(pathToMLAPP, 'filter.png');

            % Create Panel
            app.Panel = uipanel(app.GridLayout);
            app.Panel.Layout.Row = 1;
            app.Panel.Layout.Column = 1;

            % Create UIAxes
            app.UIAxes = uiaxes(app.Panel);
            app.UIAxes.XColor = [1 1 1];
            app.UIAxes.XTick = [];
            app.UIAxes.YColor = [1 1 1];
            app.UIAxes.YTick = [];
            app.UIAxes.GridColor = [0 0 0];
            app.UIAxes.Position = [11 15 360 508];

            % Create Xuat
            app.Xuat = uiimage(app.Panel);
            app.Xuat.ImageClickedFcn = createCallbackFcn(app, @XuatImageClicked, true);
            app.Xuat.Position = [331 538 46 31];
            app.Xuat.ImageSource = fullfile(pathToMLAPP, 'save.png');

            % Create QuaylaiAnh
            app.QuaylaiAnh = uiimage(app.Panel);
            app.QuaylaiAnh.ImageClickedFcn = createCallbackFcn(app, @QuaylaiAnhClicked, true);
            app.QuaylaiAnh.Position = [10 542 24 22];
            app.QuaylaiAnh.ImageSource = fullfile(pathToMLAPP, 'Bản sao undo.png');

            % Create PanelAnh
            app.PanelAnh = uipanel(app.GridLayout);
            app.PanelAnh.ForegroundColor = [0.0667 0.4431 0.7451];
            app.PanelAnh.TitlePosition = 'centertop';
            app.PanelAnh.Title = 'Chọn ảnh để chỉnh sửa';
            app.PanelAnh.Visible = 'off';
            app.PanelAnh.Layout.Row = [1 3];
            app.PanelAnh.Layout.Column = 1;
            app.PanelAnh.FontName = 'Georgia';
            app.PanelAnh.FontAngle = 'italic';
            app.PanelAnh.FontWeight = 'bold';
            app.PanelAnh.FontSize = 14;

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.PanelAnh);
            app.GridLayout2.RowHeight = {'1x', '1x', '1x', '1x', '1x'};

            % Create Image
            app.Image = uiimage(app.GridLayout2);
            app.Image.ImageClickedFcn = createCallbackFcn(app, @ImageClicked, true);
            app.Image.Tag = 'autumn.tif';
            app.Image.Layout.Row = 1;
            app.Image.Layout.Column = 1;
            app.Image.ImageSource = fullfile(pathToMLAPP, 'Ảnhtest', 'autumn.png');

            % Create Image2
            app.Image2 = uiimage(app.GridLayout2);
            app.Image2.ImageClickedFcn = createCallbackFcn(app, @ImageClicked, true);
            app.Image2.Tag = 'pout.png';
            app.Image2.Layout.Row = 1;
            app.Image2.Layout.Column = 2;
            app.Image2.ImageSource = fullfile(pathToMLAPP, 'pout.png');

            % Create Image3
            app.Image3 = uiimage(app.GridLayout2);
            app.Image3.ImageClickedFcn = createCallbackFcn(app, @ImageClicked, true);
            app.Image3.Tag = 'cameraman.png';
            app.Image3.Layout.Row = 2;
            app.Image3.Layout.Column = 1;
            app.Image3.ImageSource = fullfile(pathToMLAPP, 'cameraman.png');

            % Create Image4
            app.Image4 = uiimage(app.GridLayout2);
            app.Image4.ImageClickedFcn = createCallbackFcn(app, @ImageClicked, true);
            app.Image4.Tag = 'peppers.png';
            app.Image4.Layout.Row = 3;
            app.Image4.Layout.Column = 1;
            app.Image4.ImageSource = fullfile(pathToMLAPP, 'Ảnh màn hình 2026-05-02 lúc 20.04.15.png');

            % Create Image5
            app.Image5 = uiimage(app.GridLayout2);
            app.Image5.ImageClickedFcn = createCallbackFcn(app, @ImageClicked, true);
            app.Image5.Tag = 'nhieuot.png';
            app.Image5.Layout.Row = 2;
            app.Image5.Layout.Column = 2;
            app.Image5.ImageSource = fullfile(pathToMLAPP, 'nhieuot.png');

            % Create Image6
            app.Image6 = uiimage(app.GridLayout2);
            app.Image6.ImageClickedFcn = createCallbackFcn(app, @ImageClicked, true);
            app.Image6.Tag = 'cat.png';
            app.Image6.Layout.Row = 3;
            app.Image6.Layout.Column = 2;
            app.Image6.ImageSource = fullfile(pathToMLAPP, 'cat.png');

            % Create Image7
            app.Image7 = uiimage(app.GridLayout2);
            app.Image7.ImageClickedFcn = createCallbackFcn(app, @ImageClicked, true);
            app.Image7.Tag = '2meo.png';
            app.Image7.Layout.Row = 4;
            app.Image7.Layout.Column = 1;
            app.Image7.ImageSource = fullfile(pathToMLAPP, '2meo.png');

            % Create Image8
            app.Image8 = uiimage(app.GridLayout2);
            app.Image8.ImageClickedFcn = createCallbackFcn(app, @ImageClicked, true);
            app.Image8.Tag = 'file3.png';
            app.Image8.Layout.Row = 4;
            app.Image8.Layout.Column = 2;
            app.Image8.ImageSource = fullfile(pathToMLAPP, 'file3.png');

            % Create Image9
            app.Image9 = uiimage(app.GridLayout2);
            app.Image9.ImageClickedFcn = createCallbackFcn(app, @ImageClicked, true);
            app.Image9.Tag = 'nhieusoc.png';
            app.Image9.Layout.Row = 5;
            app.Image9.Layout.Column = 1;
            app.Image9.ImageSource = fullfile(pathToMLAPP, 'nhieusoc.png');

            % Create Image10
            app.Image10 = uiimage(app.GridLayout2);
            app.Image10.ImageClickedFcn = createCallbackFcn(app, @ImageClicked, true);
            app.Image10.Tag = 'saturn.png';
            app.Image10.Layout.Row = 5;
            app.Image10.Layout.Column = 2;
            app.Image10.ImageSource = fullfile(pathToMLAPP, 'Ảnh màn hình 2026-05-02 lúc 20.00.03.png');

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = HYPIC

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end