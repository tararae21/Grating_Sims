%% Fork Hologram Generator
% Honors Capstone, SP 2022
% Tara Crowe

% Enter Hologram and Interference Parameters

N = 4800; %Dimension of Hologram in microns
Angle1 = asind(0.6328/120); % Angle of plane wave in degrees for a period of 120 um
V=0.5; % Beam Contribution Controller (0.5 indicates each beam has the same amplitude)
L = 1; % Topological charge
P=1; % Radial Mode
lambda=0.6328*1e-6; % Wavelength (He-Ne laser)
W=1000*lambda; % LG Beam Diameter at plane of interference

% Create sample space
del=1*1e-6; % Scale for micron size
x=-N/2:N/2-1;
y=-N/2:N/2-1;
[X,Y]=meshgrid(del*x,del*y);

% Generate LG Beam
r = sqrt(X.^2 + Y.^2);
Phi = atan2(X,Y);
Term1 =(((sqrt(2)*r./W)).^abs(L));
Term2 = polyval(LaguerreGen(P,L),((2.*r.^2)/W^2)); %[12]
Term3 = (exp(-(r.^2)/W^2));
Term4 = (exp(1i*L.*Phi));
Z = A.*Term1.*Term2.*Term3.*Term4;

% Isolate Phase component of LG beam
Phase = angle(Z); 

% Create LG object wave
LG = 0.5*exp(1i*(Phase)); 

% Create tilted plane reference wave
B=0.5*exp(1i*(2*pi/lambda)*tand(Angle1)*(X)); 

% Simulate interference between object and reference wave
intf_patt = LG+B; 
hgram = abs(intf_patt).*abs(intf_patt); %Intensity of Interference Patten 1

% Generate Fork hologram
inv_mask=imbinarize(hgram);%Binarized intensity
hologram = ~(inv_mask);

% Inverted mask for conversion to DFX
inv_mask_border = padarray(inv_mask,[600,600],1,'both');
% Hologram mask for viewing
hologram_border = padarray(hologram,[600,600],0,'both');

% Convert inverse mask to phase grating 
% Increases diffraction efficiency into m = 1 and m = -1 diffraction maxima
% [13]
phase_grating = exp(1i*pi*inv_mask);

% Zero-padd phase grating
% Effectively decreases spatial frequency of grating to enhance resolution
% of diffraction pattern
zp_grating = padarray(phase_grating,[600,600],0,'both');

% Optionally display hologram resul
figure
imagesc(hologram_border);

% Optionally save inverted mask and/or hologram
imwrite(inv_mask_border,'INV_L1P1_paper_example.bmp');
imwrite(hologram_border,'L1P1_hologram_example.bmp');


% Simulate Diffraction
E = fftshift(fft2(zp_grating)); %Modeling Far Field Diffraction pattern
E_int = (abs(E)/(N*N)).*(abs(E)/(N*N)); %Intensity

figure
imagesc(E_int);
title(' Simulated Diffraction Pattern');

%---------------------------------
% Function Used to Generate Laguerre Polynomial Values
% Mattthias Trampisch (2022). Generalized Laguerre polynomial 
%(https://www.mathworks.com/matlabcentral/fileexchange/15916-generalized-laguerre-polynomial)
% MATLAB Central File Exchange. 
%---------------------------------
