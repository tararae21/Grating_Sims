%% Interference and Diffraction Simulations to Produce and Test Computer Generated Holographic Optical Elements
% Written by Tara Crowe

% Refrences:
%   Bhattacharya, S. & Vijayakumar, A. Design and fabrication of diffractive optical elements with MATLAB. (SPIE Press, 2017). 
%   Laguerre-Gauss Visualization, Justin Harrison (Matlab File Exchange)
%   Carpentier, Alicia V., et al. “Making Optical Vortices with Computer-Generated Holograms.” American Journal of Physics, vol. 76, no. 10, 2008, pp. 916–921., https://doi.org/10.1119/1.2955792. 
%% Generate Fork Hologram (radial mode neglected)

% Define parameters
% Period = 120; % microns, line width 60 microns
% Lines = 30; % Number of lines TOTAL desired in grating
% N=Lines*(Period/2); %Defines size of sample space for 1 pixel = 1 um
N = 1800; % Generic small sample space to save processing time
Angle1 = asind(0.6328/120); % Angle of plane wave in degrees for a period of 120 um
V=0.5; % Beam Contribution Controller
L = 3; % Topological charge
lambda=0.6328*1e-6; % Wavelength (He-Ne laser)

% Create sample space
del=1*1e-6; % micron size conversion
x=-N/2:N/2-1;
y=-N/2:N/2-1;
[X,Y]=meshgrid(x*del,y*del);

% Simulate Interference to produce grating
A=V*exp(1i*L*(atan2(Y,X))); % Helical Beam (Object wave)
B=V*exp(1i*(2*pi/lambda)*tand(Angle1)*Y); % Tilted Plane wave (refrence wave)
D=A+B; % Interference of the object and reference wave
I=abs(D).*abs(D); % Irradiance

% Construct Grating
I1=imbinarize(I); % Binarize Irradiance patteren
Grating=exp(1i*pi*I1);% Generate the phase grating

%Save grating using Imwrite() to preserve scaling,
%Filename = strcat('LG_P',num2str(P),'L',num2str(L),'_Grating.tif')
%imwrite(Grating,Filename);

% Display Hologram
Rgrating = real(Grating);
figure
colormap(gray);
imagesc(Rgrating);
title('Fork Hologram'); %Add in strcat title inclding radial and azimuthal info, num lines and period

% Display Far Field Diffraction patter of Hologram
% Z-padding increases the resolution of the generated pattern
zp = padarray(Grating,[500,500],0,'both');
E1 = fftshift(fft2(zp));
E1_int = (abs(E1)/(N*N)).*(abs(E1)/(N*N));
figure
imagesc(E1_int);
title('Far Field Grating Diffraction Pattern Zero-padded');


%------------------------------------------------------------------------------------------

% The following section of code is optional, and is just used as a
% visualization aid

%{
cmap = laser_cmap(); %Black and red color map imitating red laser light

% Interference Pattern
figure
colormap(cmap);
imagesc(I);
title('Irradiance of interference pattern');

Rgrating = real(Grating);
Igrating = imag(Grating);

% Binarized Interference Pattern
figure
colormap(gray);
imagesc(I1);
title('Binarized Interference Pattern');

% Imaginary Parts of Grating-> same as the Binarized Interference Pattern
figure
colormap(gray);
imagesc(Igrating);
%title('Imaginary Phase Grating');
%}
%% Hologram WITH radial mode considerations

% Define Parameters
P = 0; % Radial mode
L = 1; % Topological Charge
A = 0.5; % Wave Contribution Controller
lambda = 0.6328*1e-6; % Wavelength (He-Ne Laser)
W=500*lambda; % Beam Diameter
% Period = 120; % microns, line width 60 microns
% Lines = 30; % Number of lines TOTAL desired in grating
% N=Lines*(Period/2); %Defines size of sample space for 1 pixel = 1 um
N = 500; % Generic Sample space to save processing time
Angle1 = asind(0.6328/120); %Angle of incidence for a grating with a period of 60


% Define sample space and resolution
del = 1*1e-6;
x = -N/2:N/2-1;
y = -N/2:N/2-1;
[X,Y] = meshgrid(del*x,del*y);

% Laguerre-Gauss equation at z = 0: 

%{
Combined terms into single step, not sure if it helped reduce processing
time or not...

t = ((X.^2 + Y.^2)/(W^2));
Phi = L.*atan2(Y,X);
Term1 =(((sqrt(2)*sqrt(X.^2 + Y.^2)/W)).^L);
Term2 =(laguerreL(P,L,2.*t));
Term3 = (exp(-t));
Term4 = (exp(1i*Phi));
%}

Z = A.*(((sqrt(2)*sqrt(X.^2 + Y.^2)/W)).^L).*(laguerreL(P,L,2.*((X.^2 + Y.^2)/(W^2)))).*(exp(-((X.^2 + Y.^2)/(W^2)))).*(exp(1i*(L.*atan2(Y,X))));

Spatial = real(Z);
Phase = angle(Z); %Phase profile of LG Beam!!
Intensity = abs(Z);%Intensity of LG Beam (our donut!)

LG = 0.5*exp(1i*(Phase)); %Adding a contribution amplitude to the phase profile of the LG beam gives us our object wave 

% Displaying LG beam results, comment out or delete these as desired
figure
imagesc(Intensity);
colormap(cmap);
title('Intensity of LG Beam');

figure
imagesc(Phase);
title('LG Phase Profile');

figure
imagesc(real(LG));
title("LG Object wave");

% Simulate Interference between Object and Refrence wave
B=0.5*exp(1i*(2*pi/lambda)*tand(Angle1)*Y); % Tilted Plane wave (refrence wave)
gram = LG+B; %Interference between LG phase profile intensity and B
hgram = abs(gram).*abs(gram); %Intensity of Interference Patten 1

% Generate Grating
mask=imbinarize(hgram);%Binarized intensity
grating = exp(1i*pi*mask);

figure
imagesc(mask);
colormap(gray);
title('Hologram mask');

figure
imagesc(real(grating));
colormap(gray);
title('Grating 1');

% Display Far Field Diffraction patter of Hologram
% Z-padding increases the resolution of the generated pattern
zp = padarray(grating,[500,500],0,'both');
E2 = fftshift(fft2(zp));
E2_int = (abs(E2)/(N*N)).*(abs(E2)/(N*N));

figure
imagesc(E2_int);
title('Far Field Grating Diffraction Pattern Zero-padded');


%% Generate Grayscale SPP
%Defining SPP parameters, No radial mode parameter
N2=500; % Matrix size
L2=2;

%Constructing the SPP sample space
x2=1:N2;
y2=1:N2;
[Y2,X2]=meshgrid(y2,x2);

%Constructing the SPP
theta2=atan2((X2-N2/2),(Y2-N2/2));
r=sqrt((X2-N2/2).*(X2-N2/2)+(Y2-N2/2).*(Y2-N2/2));
A1=0.5*exp(1i*L2*(theta2)); %Phase profile of SPP

%A1(r>30)=0; %parameter to limit size

figure
colormap(gray);
imagesc(theta2);
title("Phase Profile");

figure
colormap(gray)
imagesc(real(A1));
title("Spiral Phase Plate/Vortex Retarder phase profile (crossed polarizers)");
