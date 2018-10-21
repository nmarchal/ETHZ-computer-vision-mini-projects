% =========================================================================
% Exercise 4.3: Essential matrix
% =========================================================================
clear
addpath helpers
addpath images

clickPoints = false;
% dataset = 0;   % Your pictures
dataset = 1; % ladybug
% dataset = 2; % rect
% dataset = 3; % pumpkin

% image names
if(dataset==0)
    imgName1 = '';
    imgName2 = '';

    % Your camera calibration
    K = [];

elseif(dataset==1)
	imgName1 = 'images/ladybug_Rectified_0768x1024_00000064_Cam0.png';
	imgName2 = 'images/ladybug_Rectified_0768x1024_00000080_Cam0.png';

	K = [130.5024      0  500.0005
	      0  130.5024  372.3164
	      0         0    1.0000];
elseif(dataset==2)
	imgName1 = 'images/rect1.jpg';
	imgName2 = 'images/rect2.jpg';

	K = [  	1653.5  0    	0982.7;
			0    	1655.3 	0725.4;
			0.0		0.0		1.0 ];
elseif(dataset==3)
	imgName1 = 'images/pumpkin1.jpg';
	imgName2 = 'images/pumpkin2.jpg';

    K = [1197, 0,      466.19;
        0,     1199.1, 314.13;
        0,     0,      1];
end

% read in images
img1 = im2double(imread(imgName1));
img2 = im2double(imread(imgName2));

[pathstr1, name1] = fileparts(imgName1);
[pathstr2, name2] = fileparts(imgName2);

cacheFile = [pathstr1 filesep 'matches_' name1 '_vs_' name2 '.mat'];

% get point correspondences
if (clickPoints)
    [x1s, x2s] = getClickedPoints(img1, img2);
	save(cacheFile, 'x1s', 'x2s', '-mat');
else
	load('-mat', cacheFile, 'x1s', 'x2s');
end



%% YOUR CODE HERE

% image coordinates
nnx1s = K \ x1s;
nnx2s = K \ x2s;

% estimate fundamental matrix
[Eh, E] = essentialMatrix(nnx1s, nnx2s);

% EE is the essential matrix we wish to draw epipolar lines for
essential_constraint = 1 ; % 1: respected constrants, 0:no constraints
if essential_constraint 
    EE = Eh ;
else
    EE = E ;
end

%Compute fundamental matrix (see page 259 of additional document on moodle)
F = K'\EE/K
[U,S,V] = svd(F);
S(3,3) = 0;
Fh = U*S*V';

%claculate the epipoles
e1 = null(Fh,'r') ;
e2 = null(Fh','r') ;

% FF is the fundamental matrix we wish to draw epipolar lines for
sigularity_constraint = 1 ; % 1: use rank 2 F, 0:use rank 3 F
if sigularity_constraint 
    FF = Fh ;
else
    FF = F ;
end

% show clicked points
figure(1),hold off, imshow(img1, []); hold on; plot(x1s(1,:), x1s(2,:), '*r');
figure(2),hold off, imshow(img2, []); hold on; plot(x2s(1,:), x2s(2,:), '*b');

% compute the corresponding epipolar lines from F=K_inv'*E*K_inv
% draw epipolar lines in img 1
figure(1)
for k = 1:size(x1s,2)
   drawEpipolarLines(FF'*x2s(:,k), img1);
end
% draw epipolar lines in img 2
figure(2)
for k = 1:size(x2s,2)
   drawEpipolarLines(FF*x1s(:,k), img2);
end

% show epipoles
figure(1)
if sigularity_constraint && essential_constraint
    plot(e1(1),e1(2),'og','MarkerSize',20,'LineWidth',3) ;
    plot(e1(1),e1(2),'.g','MarkerSize',10,'LineWidth',5) ;
elseif ~sigularity_constraint &&  essential_constraint
    plot(e1(1),e1(2),'oc','MarkerSize',20,'LineWidth',3) ;
    plot(e1(1),e1(2),'.c','MarkerSize',10,'LineWidth',5) ;
elseif sigularity_constraint &&  ~essential_constraint
    plot(e1(1),e1(2),'om','MarkerSize',20,'LineWidth',3) ;
    plot(e1(1),e1(2),'.m','MarkerSize',10,'LineWidth',5) ;
else
    plot(e1(1),e1(2),'or','MarkerSize',30,'LineWidth',3) ;
    plot(e1(1),e1(2),'.r','MarkerSize',10,'LineWidth',5) ;
end
figure(2)
if sigularity_constraint && essential_constraint
    plot(e2(1),e2(2),'og','MarkerSize',20,'LineWidth',3) ;
    plot(e2(1),e2(2),'.g','MarkerSize',10,'LineWidth',5) ;
elseif ~sigularity_constraint &&  essential_constraint
    plot(e2(1),e2(2),'oc','MarkerSize',20,'LineWidth',3) ;
    plot(e2(1),e2(2),'.c','MarkerSize',10,'LineWidth',5) ;
elseif sigularity_constraint &&  ~essential_constraint
    plot(e2(1),e2(2),'om','MarkerSize',20,'LineWidth',3) ;
    plot(e2(1),e2(2),'.m','MarkerSize',10,'LineWidth',5) ;
else
    plot(e2(1),e2(2),'or','MarkerSize',30,'LineWidth',3) ;
    plot(e2(1),e2(2),'.r','MarkerSize',10,'LineWidth',5) ;
end

%%
% =========================================================================
% Exercise 4.4: Camera matrix
% =========================================================================
% Now you should use your essential matrix estimate to extract a camera pair

% TODO: implement decomposeE
P1 = [eye(3) [0;0;0]];
P2 = decomposeE(Eh, nnx1s, nnx2s);

% TODO: triangulate 3D points and plot together with cameras
% The function showCameras.m is can be useful here

% [ ... ]

