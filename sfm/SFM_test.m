%% SFM�����ļ�
% �������ļ��������Ա궨�ķ�����ȡ����ڲ�K����غ����� estimatingK;
% ����DLT��ֱ��������⣩�ķ�������PnP���⣬�����ô�matlab���ʵ��
% ���ļ���ҪΪ���߶�3D�ؽ��еġ�ϡ���ؽ����ĸ�������ñʼǣ���Щ�ط������˱Ƚϱ����Ľ��������
% �����ļ�д���˽��SFM����Ĵ������̣�Ӧ�Զ�����һ���İ���
% ��Ҫ�ο���
% �鼮��������Ӿ��ж���ͼ����
% Դ�룺SFMedu; Homographies-for-Plane-Detection-and-3D-Reconstruction.

% ����Ϊ��Ҫ���룬�����㷨���ŵ�algorithms�ļ�����
clear
clc
% �������ú��������ļ���·��
addpath('..\algorithms\');

%��ȡͼƬ����ȡ�����������������
images = im_read(5);
[descriptors,points] = getPointFeatures(images);

% �ɵ�һ��ͼ�Ա궨����ڲ�K��ע����������ͼƬ���ڲ���һ�£�
num_img = size(images,1);
K = estimatingK(imread('E:\��̳�\�㷨ʵ��\matlab\my_sfm\MVS\images\B21.jpg'));

% ��ȡƥ������ƥ��������
matchedPoints = cell(num_img-1,2);
matchPointsIndex = cell(num_img-1,1);
for i = 1:num_img-1
    indexPairs = matchFeatures(descriptors{i},descriptors{i+1});
    matchPointsIndex{i} = indexPairs; 
    matchedPoint1 = points{i}(indexPairs(:,1),:);
    matchedPoint2 = points{i+1}(indexPairs(:,2),:);
    matchedPoints{i,1} = matchedPoint1;
    matchedPoints{i,2} = matchedPoint2;
end

% ��ǰ����ͼ��ƥ�����ƻ�������F�����ʾ���E�����ӱ��ʾ����������2����Ӧ�ڶ���ͼƬ������Σ�����������ǻ�����ƥ������ά����
% �˴�������������ϵ�����1����Ӧ��һ��ͼƬ���غ�
F = estimateFundamentalMatrix(matchedPoints{1,1},matchedPoints{1,2});
E = computeE(F,K,K);
Rt1 = computePose(E,K,matchedPoints{1,1}.Location(1,:),matchedPoints{1,2}.Location(1,:));
X1 = trangulate(K,Rt1,matchedPoints{1,1},matchedPoints{1,2});
disp('Rt1 = ');
disp(Rt1);

% ���PnP���⣬����3D������Ӧ��2D������������ӦͼƬ�����
% Ϊʲô�������PnP�����⣬�����Ǹ�����⣺
% ����ͼ���ƥ�����ڽ�ͼ���ƥ�䣨����image1��image2ƥ�䡢image2��image3ƥ�䣩��
% ����������ϵ�����1�غϣ�������������ǰ��������εķ�����ֻ�ܵĵ����3��������2����Σ�
% ���Ҵ���ε�λ�������Ǿ���һ��δ֪�������Ź��ģ�����׼ȷ�ġ�
% ��������PnP����ʱ�����õ���DLT�ķ�ʽ��Ϊ�˱ܿ�BA�Ż����������Ϊʲô�ܿ�����������ñ���ƥ����������Ӧ�ķ���
% ���������ǣ�
% 1.�ҵ��� i ��ͼ����� i-1 ��ͼ���ƥ����ƥ����Ӧ��3D���ꣻ
% 2.�ҵ��� i ��ͼ����� i+1 ��ͼ���ƥ��㣬��ɸѡ����֪3D�����ƥ��㣻
% 3.��DLT���� i+1 ���������Ӧ�� i+1 ��ͼ�񣩵���Σ�
% 4.ɸѡ���� i ��ͼ����� i+1 ��ͼ���δ֪3D����ƥ�����ȡ3D���겢���뵽��֪3D������ȥ

% ���3����Σ�ע�⣺���������������ϵ�µģ�������������1�ģ�
[Rt2,X2,indForRt3] = getRt2andX(matchPointsIndex,points,X1,Rt1,K);

% ���4����Σ�ע�⣺���������������ϵ�µģ�������������1�ģ�
[Rt3,X3,indForRt4] = getRt3andX(matchPointsIndex,points,X2,Rt2,K,indForRt3);

% ���5����Σ�ע�⣺���������������ϵ�µģ�������������1�ģ�
[Rt4,X4] = getRt4andX(matchPointsIndex,points,X3,Rt3,K,indForRt4);

%% BA�Ż�����ͶӰ����Ż�����һ�ֽ��PnP����ķ������Ż�������
% ��һ������£�����ʽ��SFM��ÿ������һ��ͼ��һ���ӽ�/һ�������������ҪBA�Ż������ʹ��������ʱ��ϳ�
% �������Ŀ�����˽�SFM�Ļ������̣���ѡ����һ�������ҽϱ����ķ������PnP�����⣬������ߴ��������ٶ�
% BA�Ż���C++��ʹ��ceres��ʵ�ֽ�Ϊ��㣬������⡣����matlab��ʵ�ֽ�Ϊ���ӣ����ʺϳ�ѧ���Ķ���
% ���Ƕ�BA�Ż���matlab��������Ȥ�����Բο�SFMedu�е���غ���



            
        
        
        
        
        
        
        
        
        
        
        
        
        
        

