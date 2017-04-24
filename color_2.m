
rgbImage = imread('F:\c4.jpg'); % image address
subplot(3, 1, 1);
imshow(rgbImage);
% set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
[rows columns numberOfColorBands] = size(rgbImage);

rc=rgbImage(:,:,1);
gc=rgbImage(:,:,2);
bc=rgbImage(:,:,3);
r=reshape(rc,1,[]);
g=reshape(gc,1,[]);
b=reshape(bc,1,[]);
%     RGB=[r;g;b];
rm = max(r);
gm = max(g);
bm = max(b);
q = 0.21*double(rm) + 0.72*double(gm) + 0.07*double(bm);

Nr = [];
scale = [];
M = 256; %size of image in power of 2
for l=5:10:200
    blockSizeR = l; % Rows in block.
    blockSizeC = l; % Columns in block
    
    remR = rem(rows, blockSizeR);
    remC = rem(columns, blockSizeC);
    
    wholeBlockRows = floor(rows / blockSizeR);
    blockVectorR = [blockSizeR * ones(1, wholeBlockRows),remR]; 
    wholeBlockCols = floor(columns / blockSizeC);
    
%     fprintf('RemC = %d RemR = %d  l = %d\n',remC,remR,l);
    blockVectorC = [blockSizeC * ones(1, wholeBlockCols),remC];
    M = wholeBlockRows * l;
    rgb = rgbImage(1:l*wholeBlockRows,1:l*wholeBlockCols,:);
    if numberOfColorBands > 1
        % It's a color image.
        ca = mat2cell(rgbImage, blockVectorR, blockVectorC, numberOfColorBands);
    else
        ca = mat2cell(rgbImage, blockVectorR, blockVectorC);
    end
    numPlotsR = size(ca, 1);
    numPlotsC = size(ca, 2);
    ld = (l * q)/M;
    nr = 0;
    for r = 1 : numPlotsR
        for c = 1 : numPlotsC
            oneBlock = ca{r,c};
            maxI = sum(max(max(oneBlock)))/3;
            minI = sum(min(min(oneBlock)))/3;
            hb = ceil(double(maxI)/ ld);
            if maxI == minI
                nr = nr + 1;
            else
                nr = nr + hb;
            end 
        end
    end
    Nr = [Nr nr];
    scale = [scale M/l];
end
subplot(3, 1, 2);
N = log(Nr);
S = log(scale);
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
