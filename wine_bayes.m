clear all
close all
format long

filename = '.data.txt';
A = dataset('File', filename, 'Delimiter', ',', 'ReadVarNames', false);

u = unique(A(:, 5));%% take unique value of set
u = dataset2cell(u);%% convert the dataset array into cell array
u = u(2 : end, :);
p = [1 : size(u, 1)];%% convert class into values like 1 2 3

C = containers.Map(u, p);%% map the key with value

t = A(:, 5);%% take last row in variable t
t = dataset2cell(t);%% convert the dataset array into cell array
t = t(2 : end);
A.Var5 = C.values(t);%% convert the values of the data row 5 into classes numeric values 1 2 3


z = A(:, 5);
z = dataset2cell(z);
z = z(2 : end);
z = cell2mat(z);%% converts a cell array into an ordinary array.
z = mat2dataset(z); %%Convert Matrix to Dataset Array
A(:, 5) = z;
F1 = double(A);
%%%%%%% NORMALIZING F1 DATA %%%%%%%%%%
% normalized F1 data of each subject using the standard normal formulation has been stored in Z1.
Z1 = (F1-(mean(F1,2)))./(std(F1,0,2));





%%%%%%% PLOTTING DISTRIBUTION OF F1 DATA %%%%%%%%
figure('name','DISTRIBUTION OF F1 DATA');
plot(F1,'o');
xlabel('Participants (Subjects)');
ylabel('Measurement');
title('Fig 1 : DISTRIBUTION OF F1 DATA');
legend({'Class 1','Class 2','Class 3'});
%%%%%%% PLOTTING DISTRIBUTION OF Z1 DATA %%%%%%%%
figure('name','DISTRIBUTION OF Z1 DATA');
plot(Z1,'o');
xlabel('Participants (Subjects)');
ylabel('Measurement');
title('Fig 3 : DISTRIBUTION OF Z1 DATA');
legend({'Class 1','Class 2','Class 3'});



%%%%%% CALCULATING CLASSIFICATION ACCURACY OF DATA F1 %%%%%%%%%%
accuracy_F1 = accuracy(F1); %% classification accuracy of F1
error_F1 = 1-accuracy_F1; %% Error rate of F1 classification
percentage_accuracy_F1 = accuracy_F1*100; %% converting accuracy to percentage to display

%%%%%% CALCULATING CLASSIFICATION ACCURACY OF DATA Z1 %%%%%%%%%%
accuracy_Z1 = accuracy(Z1); %% classification accuracy of Z1
error_Z1 = 1-accuracy_Z1; %% Error rate of Z1 classification
percentage_accuracy_Z1 = accuracy_Z1*100; %% converting accuracy to percentage to display





%%%%%%% FUNCTION TAKES DATA AS INPUT AND RETURNS ITS CLASSIFICATION ACCURACY %%%%%%%%
function acc = accuracy(X)
    m = mean(X(1:100,:));       %% CALCULATING MEAN OF FIRST 100 SUBJECTS OF A DISTRIBUTION %%%%
    s = std(X(1:100,:));        %% CALCULATING STANDARD DEVIATION OF FIRST 100 SUBJECTS OF A DISTRIBUTION %%%%
    correct = 0;                %% INITIALIZING A VARIABLE 'CORRECT' %%%%
    for i = 1:5                 %% ITERATING THE DATA BY EACH COLUMN (CLASS) %%%%
        y = zeros(150,1);       %% INITIALIZING A VECTOR Y OF SIZE 900 X 5 TO STORE PROBABILITY OF EACH ELEMENT(MEASUREMENT) ACROSS ALL 5 CLASSES %%%
        for j = 1:5             %% ITERATING DATA OF EACH CLASS ACROSS ALL THE CLASSES %%%%
            y(:,j) = pdf('Normal',X(:,i),m(j),s(j)); %% CALCULATING PROBABILITY OF EACH CLASS (FOR SUBJECTS 101 TO 1000(900 DATA POINTS)) ACROSS ALL THE CLASS DISTRIBUTIONS AND STORING THEM IN Y MATRIX%%%%
        end
        [M,index] = max(y,[],2);%% DERIVING THE MAXIMUM VALUE AND INDEX (CLASS NUMBER) OF PROBABILITIES FOR EACH SUBJECT %%%%

        for k = 1:length(index) %% ITERATING THE CALSSIFIED CLASSES OF EACH ELEMENT OF CLASS I %%%%
           if index(k) == i     %% CHECKING WHETHER AN ELEMENT OF A CLASS IS CLASSIFIED AS ITS OWN CLASS(WHICH IS CORRECT) %%%%
              correct = correct + 1 ; %% COUNTING THE CORRECT CLASSIFICATION %%
           end
        end
    end
    acc = correct/4500;         %% CALCULATING AND RETURNING THE CLASSIFICATION ACCURACY OF THE ENTIRE DATA WHICH IS GIVEN AS INPUT %%%%

end
