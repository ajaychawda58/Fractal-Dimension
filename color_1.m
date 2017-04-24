im=imread('F:\c4.jpg');
subplot(3, 3,1);
imshow(im);

rc=im(:,:,1);
gc=im(:,:,2);
bc=im(:,:,3);
r=reshape(rc,1,[]);
g=reshape(gc,1,[]);
b=reshape(bc,1,[]);
%     RGB=[r;g;b];
rm = max(r);
gm = max(g);
bm = max(b);

% RGB = (rm + gm + bm)/3;
M = 256;
q = 0.21*double(rm) + 0.72*double(gm) + 0.07*double(bm);
scale=[];
Nr=[];
l=2;
% n=1;
while l<=(M/2)
    r = l;
    sliceNumber = 1;
%     RGB = 255;
    ld = (l * q)/M;
    nr = 0;
    blockSizeR = r;
    blockSizeC = r;
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

            maxI = sum(max(max(oneBlock)))/3;
            minI = sum(min(min(oneBlock)))/3;
            
            %number of boxes
            hb = ceil(double(maxI) / ld);
%             fprintf('%d   %d   %d\n',maxI,minI,hb);
%             nr(1,sliceNumber) = ((maxI - minI)/ld);
            if maxI == minI
                nr = nr + 1;
            else
                nr = nr + hb;
            end 
            sliceNumber = sliceNumber + 1;
%             p=maxI-minI
        end
    end
    Nr = [Nr nr];
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
