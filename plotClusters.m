function [colors] = plotClusters(X, k, C, A, mu, colors)
figure;
hold on;
if(size(colors,1)==0)
    colors = hsv(k);
end
for i=1:k
    plot(X(C==i,1),X(C==i,2),'.','Color',colors(i,:));
    if(size(A,1))
        plotEllipsis(mu{i},A{i},det(A{i})/10,colors(i,:));
    end
end
drawnow;
end