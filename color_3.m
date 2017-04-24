im=imread('F:\c1.jpg');
im = rgb2gray(im);
subplot(3, 3,1);
imshow(im);

M=256;
G=256;
scale=[];
Nr=[];
l=2;
% n=1;
while l<=(M/2)
    r = l;
    blockSizeR = r;
    blockSizeC = r;
    
    
    sliceNumber = 1;
    ld = (l * 256)/M;
    nr = zeros(1,l*l);
    for row = 1:blockSizeR:M
        for col = 1:blockSizeC:M
            row1 = row;
            row2 = row1 + blockSizeR - 1;
            col1 = col;
            col2 = col1 + blockSizeC - 1;
            %extract block
            oneBlock = im(row1:row2,col1:col2);
%             subplot(2, 2, sliceNumber);
%             imshow(oneBlock);
%             sliceNumber = sliceNumber + 1;
%             fprintf('%d   %d   %d   %d\n',row1,row2,col1,col2);

            maxI = max(max(oneBlock));
            minI = min(min(oneBlock));
            %number of boxes
            nb = ceil(maxI / ld);
            if maxI == minI
                nr(1,sliceNumber) = 1;
            else
                nr(1,sliceNumber) = ((maxI - minI)/ld);
            end 
            sliceNumber = sliceNumber + 1;
%             p=maxI-minI
        end
    end
    Nr = [Nr sum(nr)];
    scale = [scale M/l];
    l = l * 2;
%     n = n + 1;
end
subplot(3, 1, 2);
N = log(Nr)
S = log(scale)
p = polyfit(S, N, 1);
f = polyval(p, S);
fprintf('Dimension = %d\n',p(1));
plot(S,N,'o--',S,f,'*--');
m = p(1);
c = p(2);
% x = (((m * S) + c) - N)/(1 + (m * m))
y=0;
for j=1:length(N)
    x = (((m * S(j)) + c) - N(j))/(1 + (m * m));
    if x<0
        y = y + x * -1;
    else
        y = y + x;
    end
end
n = length(N);
E = (1/n)*sqrt(y);
fprintf('Error = %d\n',E);
