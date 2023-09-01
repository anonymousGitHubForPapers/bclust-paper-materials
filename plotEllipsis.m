function [] = plotEllipsis(mu, A, s, color)
a = A(1,1);
b = A(1,2);
c = A(2,1);
d = A(2,2);
mu1 = mu(1);
mu2 = mu(2);

% (x-mu)'A(x-mu) = [x-mu1;y-mu2]'[a,b;c,d]*[x-mu1;y-mu2] =
% = [x-mu1;y-mu2]'[(x-mu1)*a + (y-mu2)*b; (x-mu1)*c + (y-mu2)*d] =
% = (x-mu1)*((x-mu1)*a + (y-mu2)*b) + (y-mu2)*(x-mu1)*c + (y-mu2)*d
plot(mu(1),mu(2),'x','Color',color);
fimplicit(@(x,y) (x-mu1).*((x-mu1).*a + (y-mu2).*b) + (y-mu2).*((x-mu1).*c + (y-mu2).*d) - s,'Color',color);
end