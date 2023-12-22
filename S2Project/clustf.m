function distances = clustf(Xtrain,Xtest,k)
[Ztrain,Zmean,Zstd] = zscore(Xtrain);
[~,C] = kmeans(Ztrain,k); % Creates k clusters
Ztest = (Xtest-Zmean)./Zstd;
d = pdist2(C,Ztest,'euclidean','Smallest',1);
distances = sum(d.^2);
end