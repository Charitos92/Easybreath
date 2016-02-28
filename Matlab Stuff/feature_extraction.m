% Will segment incoming data into 5-minute data windows
% Features computed over these 5-minute segments

fid1 = fopen('mock_heart_rate.csv');
fid2 = fopen('mock_accelerometer.csv');

% Provided mock timestamps for stressed states
stressed_times = {'10:47:19'; '11:03:20'; '12:16:55'; '12:40:34'; '13:47:01'; '14:15:00'};

if (fid1>0) % && (fid2>0)
    hrv_data = textscan(fid1,'%s %s %f','Delimiter',',');
    fclose(fid1);
    accelero_data = textscan(fid2,'%s %s %f %f %f','Delimiter',',');
    fclose(fid2);

    [~, ~, ~, H, MN, S] = datevec(hrv_data{1});
    hrv_seconds = H*3600+MN*60+S;
    [~, ~, ~, H, MN, S] = datevec(accelero_data{1});
    acc_seconds = H*3600+MN*60+S;
    [~, ~, ~, H, MN, S] = datevec(stressed_times);
    stress_seconds = H*3600+MN*60+S;
    
    stress_labels = zeros(size(hrv_seconds));   
    for i=1:2:size(stress_seconds,1)
        interval = find((hrv_seconds >= stress_seconds(i) & hrv_seconds <= stress_seconds(i+1)));
        stress_labels(interval) = 1;
    end
    
    normalised_hrv_sec = hrv_seconds - min(hrv_seconds);
%     normalised_acc_sec = acc_seconds - min(acc_seconds);

    heart_rate = hrv_data{3};
    rr = 60./heart_rate;
    
%     x_axis = accelero_data{3};
%     y_axis = accelero_data{4};
%     z_axis = accelero_data{5};
   
    mod_hrv_sec = mod(normalised_hrv_sec, 300);
%     mod_acc_sec = mod(normalised_acc_sec, 300);

    % Segment readings into 5-minute data windows
    hrv_indexes = find(mod_hrv_sec < 5);
%     acc_indexes = find(mod_acc_sec == 0);

    num_indexes = size(hrv_indexes, 1) - 1;
    
    mean_heart_rate = zeros(num_indexes, 1);
    mean_rr = zeros(num_indexes, 1);
    
    stress_states = zeros(num_indexes, 1);
%     mean_x = zeros(num_indexes, 1);
%     mean_y = zeros(num_indexes, 1);
%     mean_z = zeros(num_indexes, 1);
    
    % Activity_Index = i=1:n sum(sqrt((x_(i+1)-x_i)^2 + 
    % (y_(i+1)-y_i)^2 + (z_(i+1)-z_i)^2))
%     diff_x = diff(x_axis).^2;
%     diff_y = diff(y_axis).^2;
%     diff_z = diff(z_axis).^2;
%     activity_sums = sqrt(diff_x + diff_y + diff_z);
    
%     activity = zeros(num_indexes, 1);
    features = cell(num_indexes, 1);

    for i=2:(num_indexes+1)
        mean_heart_rate(i-1) = mean(heart_rate(hrv_indexes(i-1):hrv_indexes(i)));
        mean_rr(i-1) = mean(rr(hrv_indexes(i-1):hrv_indexes(i)));
        stress_states(i-1) = mode(stress_labels(hrv_indexes(i-1):hrv_indexes(i)));
%         mean_x(i-1) = mean(x_axis(acc_indexes(i-1):acc_indexes(i)));
%         mean_y(i-1) = mean(y_axis(acc_indexes(i-1):acc_indexes(i)));
%         mean_z(i-1) = mean(z_axis(acc_indexes(i-1):acc_indexes(i)));
%         activity(i-1) = sum(activity_sums(acc_indexes(i-1):(acc_indexes(i)-1)));
%          features{i-1} = [mean_heart_rate(i-1) mean_rr(i-1) stress_states(i-1) mean_x(i-1) ...
%                 mean_y(i-1) mean_z(i-1) activity(i-1)];
    end    
    
    stress_data_table = table(mean_heart_rate, mean_rr, stress_states, ...
        'VariableNames', {'Mean_HR', 'Mean_RR', 'Is_Stressed'});
        
end