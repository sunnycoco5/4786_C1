Ma = csvread('Adjacency.csv');
Ms = csvread('seed.csv');
Mf = csvread('features.csv');
eigv = [2 2];

%{
signal=zeros(12000,10);
for i = 1:12000
    for j=1:10
        for k=1:3
            if Ma(i,Ms(j,k))==1
                signal(i,j)=signal(i,j)+1;
            end
        end 
    end
end
%}

%%spectral clustering
%{
D=zeros(12000,12000);
for i=1:12000
    for j=1:12000
        D(i,i)=D(i,i)+Ma(i,j);
    end
end
L = D - Ma;
[A,B] = eig(L,D);


[evectors, evalues] = eig(L);

newspace = evectors(:, eigv(1,1): eigv(1,2));


n = size(eigv);
for i = 2: n(1)
    newspace = [newspace evectors(:, eigv(i,1): eigv(i,2))];
end

[idx,C]=kmeans(V,10,'Start',I);
%}

D=zeros(12000,12000);
for i=1:12000
    for j=1:12000
        D(i,i)=D(i,i)+Ma(i,j);
    end
end
L = D - Ma;
[A,B] = eig(L,D);

%%% CCA %%%

%{
I=zeros(10,103);

[X,Y,r,U,V]=canoncorr(B,Mf);

for i =1:10
    I(i,:) = V(Ms(i,1),:);
end
%}


[idx,C]=kmeans(B,10,'Start',I);
%Write Results
result=zeros(2,12000);
for i=1:12000
    result(i,1)=i;
    result(i,2)=idx(i)-1;
end
csvwrite('Prediction.csv',result);

error=0;
% Check Error
for i=1:10
    for j=1:3
        if idx(Ms(i,j))~=i
            error=error+1;
        end
    end
end

S=sprintf('Error: %d',error);
disp(S)