
clear;
close all;

tic 
filename = 'iris.data.txt';
data = dlmread(filename, ',');
nrows = size(data, 1);
randrows = randperm(nrows);

%% Normalise the dataset
for i = 2 : size(data, 2)
    data(:, i) = data(:, i) / max(data(:, i));
end

X = data;
accuracyMatrixForRuns = zeros(10, 1);   % Matrix for storing accuracy 10 no. of times
meanaccuracy = zeros(4, 1);
e = zeros(4, 1);
k = [2, 3, 4, 5];
for times = 1 : 10
    for fold = 2 : 5    % Percentage division of dataset 50%, 30%, 25%, 20%
        for chunk = 1 : fold    % Splitting dataset into chunks for training and testing
                chunksize = floor(nrows/fold);
                x = (chunk - 1) * chunksize + 1;
                y = chunk * chunksize;
                testdata = X(randrows(x:y), :);
                if chunk == 1
                    traindata = X(randrows(y + 1:end), :);
                elseif chunk == fold
                    traindata = X(randrows(1 : x-1), :);
                else
                    traindata = X(randrows(1, x-1:y+1, end), :);
                end
                currentacc = mdcclassifier(traindata, testdata);
                s(chunk) = currentacc;
        end  
        meanaccuracy(fold - 1, 1) = mean(s); % Building a mean accuracy matrix
        out(fold - 1) = mean(s);
        e(fold - 1) = std(s); 
    end
    plot(3,3);     % Plotting the accuracy of different chunk values in form of a graph
    errorbar(k, out, e); 
    title(['Plot of Mean Accuracy for %chunks of data']);
    ylabel('Accuracy');
    %Accuracy for comparision of performance on 10 runs
    accuracyMatrixForRuns(times,1) = mean(meanaccuracy,'all');
end
toc


%MDC Classifier function
function accuracy = mdcclassifier(traindata, testdata)
    class = traindata;
    expclass = testdata(:,1);   % Expected class to compare training & test accuracy
    nClassRows = size(class, 1);
    nClassCols = size(class, 2);

    class1 = zeros(0,nClassCols);
    class2 = zeros(0,nClassCols);
    class3 = zeros(0,nClassCols);
    i=1;
    while (i<nClassRows)    % Storing into respective class from each chunk
                if(class(i, 1) == 1)
                    class1 = [class1;class(i,:)];
                elseif(class(i,1) == 2)
                    class2 = [class2;class(i,:)];
                elseif(class(i,1) == 3)
                    class3 = [class3;class(i,:)];
                end
                i = i + 1;
    end

    u1=mean(class1,'all');  % Mean value of Class 1
    u2=mean(class2,'all');  % Mean value of Class 2
    u3=mean(class3,'all');  % Mean value of Class 3

    for i = 1 : size(testdata)
            testRow = testdata(i,:);
            testRowMean = mean(testRow,'all');  % Mean value of each row in testing dataset 
            dist1 = sqrt((u1 - testRowMean) .^ 2 );
            dist2 = sqrt((u2 - testRowMean) .^ 2 );
            dist3 = sqrt((u3 - testRowMean) .^ 2 );
            
            b=[1,2,3];           
            c=[dist1,dist2,dist3];
            b=[b;c];    % Distance matrix
            b=transpose(b);
            poll = sortrows(b,2);
            expclass(i,1) = poll(1,1);  % Derived expected class            
    end
    %Error percentage calculation
    error = expclass - testdata(:, 1);
    accuracy = ((size(error, 1) - nnz(error))/size(error, 1));
end
