%% LG Visualization
%   Laguerre-Gauss Visualization, Justin Harrison (Matlab File Exchange)

P = 3; %Radial Mode
L = 3; %Topological Charge/Azimuthal mode
A = 0.5; %Beam contribution
%lambda = 0.6328*1e-6; %Wavelength
W=1; %Beam Diameter, change to fit N



%Define working grid size and resolution - smaller here, not to scale.
Grid = -5:0.05:5;

[X,Y] = meshgrid(Grid);

%Laguerre-Gauss equation at z = 0: 
t = (X.^2 + Y.^2)/(W^2);
Phi = L.*atan2(Y,X);
Term1 =((sqrt(2)*sqrt(X.^2 + Y.^2)/W)).^L;
Term2 =laguerreL(P,L,2.*t);
Term3 = exp(-t);
Term4 = exp(1i*Phi);

Z = A.*Term1.*Term2.*Term3.*Term4;

Spatial = real(Z);
Phase = angle(Z); %This is what we use to construct our LG beam
Intensity = abs(Z); %Gives you your Donut
cmap = laser_cmap();

%Plots and code borrowed by Justin Harrison
Filename = strcat('LG_P',num2str(P),'L',num2str(L),'.tif')
figure('Name',strcat('LG',num2str(P),',',num2str(L)),'Renderer', 'painters', 'Position', [125 125 1300 300])
subplot(1,3,1)
xlabel('E(x,y)')
xlim([1 length(Grid)]);ylim([1 length(Grid)]);
surface(Spatial)
colormap(cmap)
colorbar()
shading interp 
subplot(1,3,2)
xlabel('|E(x,y)|\^{2}')
xlim([1 length(Grid)]);ylim([1 length(Grid)]);
surface(Intensity)
colormap(cmap)
colorbar()
shading interp 
subplot(1,3,3)
xlabel('Phase')
xlim([1 length(Grid)]);ylim([1 length(Grid)]);
surface(Phase)
colormap(cmap)
colorbar('Ticks',[-pi -pi/2 0 pi/2 pi], 'Ticklabels',{'-\pi', '-\pi/2', '0', '\pi/2', '\pi'})
shading interp 

% If you want to save any of the figures for any reason
%{
figure 
xlim([1 length(Grid)]);ylim([1 length(Grid)]);
surface(Intensity)
colormap(cmap)
axis off
shading interp 
exportgraphics(gcf,Filename,'resolution',201);
%}