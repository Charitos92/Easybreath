% Test data to be provided

mean_heart_rate = [92.1 75.3 76.4 89.5 92.5 91.1 92.9 99.9 101.2 120.2 120.3 120.2 95.3 75.1 60.5 60.4 60.1]';
mean_rr = 60./mean_heart_rate;

test_data_matrix = cat(2, mean_heart_rate, mean_rr);

view(trainedClassifier, 'Mode', 'Graph');

stress_labels = predict(trainedClassifier, test_data_matrix);
