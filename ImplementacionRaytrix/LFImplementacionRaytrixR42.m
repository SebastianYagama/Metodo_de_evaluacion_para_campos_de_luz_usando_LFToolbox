%Algoritmo para evaluar los campos de luz obtenidos por la cámara Raytrix
%                       R42 en notación de Levoy
%
%
%    Autores:
%       - Jhon Sebastian Yagama Parra
%       - Juan Sebastian Mora Zarza
%
%
%   Pontificia Universidad Javeriana
%              Bogota D.C.
%                 2023
%
%
%Descripción general del algoritmo implementado:
%Este algoritmo se basa en la obtención, el procesamiento y la visualización 
%de campos de luz antes y después de pasar por la implementación de distintos 
%filtros de reenfoque sintético.
%
%Este metodo se implementó para la versión 0.5 de lightfield Toolbox.
%
%Lightfield Toolbox:
%https://github.com/doda42/LFToolbox
%
%
%Entradas:
%   -   Campo de luz en notación de Levoy.
%   -   Pendiente y ancho de banda para los filtros de reenfoque.
%      -   ShiftSumSlope1, ShiftSumSlope2.
%      -   PlanarSlope.
%      -   PlanarBW.
%      -   HyperfanSlope1, HyperfanSlope2.
%      -   HyperfanBW.
%
%Salidas:
%   -   Imágenes con alguna variación de reenfoque.
%
%Se recomienda leer el "Manual para el uso de las librerías de LightField
%Toolbox.pdf" antes de usar esta implementación. El archivo se puede
%encontrar en la pagina de sharepoint o en el Repositorio en la carpeta 
% “Documentación”.
%   Link sharepoint:
%   https://livejaverianaedu.sharepoint.com/sites/FotografaPlenoptica2/Manual
%   20Para%20el%20manejo%20de%20las%20Libreras%20de%20LFToolbox/Forms/AllItems.aspx


%%
%Carga del campo de luz en notación de Levoy
LF = LFReadGantryArray('ImplementacionRaytrix/LightfieldsRaytrixR42/Flor4/Lightfield flores lente 3', struct('UVLimit', 256, 'STSize', [15,15], 'FnamePattern', '*.jpg'));
%LF = LFReadGantryArray('ImplementacionRaytrix/StanfordGantry/LegoKnights/rectified', struct('UVLimit', 256, 'STSize', [17,17], 'FnamePattern', '*.png'));
Figure2 = LFDispMousePan(LF);
LFSize = size(LF);
UVLimit = 300;  % Light fields get scaled to this size in u,v 
%- Params for linear filters
% These must be tuned to conform to the characteristics of the light field

%%
%---Demostración del filtro de suma y desplazamiento---
CurFigure = 1;
%   Entradas:
ShiftSumSlope1 = 0.131;
ShiftSumSlope2 = 0.232;

for( Slope = [ShiftSumSlope1, ShiftSumSlope2])
	fprintf('Aplicando filtro de suma y desplazamiento');
	ShiftImg = LFFiltShiftSum(LF, Slope, struct('UpsampRate', 2));
	fprintf(' Done\n');
    LFFigure(CurFigure);
    CurFigure = CurFigure + 1;
	LFDisp(ShiftImg);
	axis image off
 	truesize
	title(sprintf('Filtro de suma y desplazamiento, slope %.3g', Slope));
	drawnow
end

%%
%---Demostración del filtro lineal 2D---
CurFigure = 3;
%   Entradas:
PlanarSlope = -0.1;
PlanarBW = 0.03;
fprintf('Construyendo línea de frecuencia 2D... ');
Htv = LFBuild2DFreqLine( LFSize([1,3]), PlanarSlope, PlanarBW);
fprintf('Aplicando filtro en t,v');
LFFilt = LFFilt2DFFT( LF, Htv, [1,3]);
LFFigure(CurFigure);
CurFigure = CurFigure + 1;
LFDisp(LFFilt);
axis image off
truesize
title(sprintf('Freq. filtro lineal. t,v; Pendiente %.3g, BW %.3g', PlanarSlope, PlanarBW));
drawnow

fprintf('Construyendo línea de frecuencia 2D... ');
Hsu = LFBuild2DFreqLine( LFSize([2,4]), PlanarSlope, PlanarBW);
fprintf('Aplicando filtro en s,u');
LFFilt = LFFilt2DFFT( LFFilt, Hsu, [2,4]);
LFFigure(CurFigure);
CurFigure = CurFigure + 1;
LFDisp(LFFilt);
axis image off
truesize
title(sprintf('Freq. filtro lineal. t,v luego de s,u; slope %.3g, BW %.3g', PlanarSlope, PlanarBW));
drawnow

%%
%---Demonstrate 4D Planar filter---
CurFigure = 5;
fprintf('Construyendo un plano de frecuencia 4D... ');
PlanarSlope = -0.1;
PlanarBW = 0.06;
H = LFBuild4DFreqPlane(LFSize, PlanarSlope, PlanarBW);
fprintf('Aplicando filtro');
LFFilt = LFFilt4DFFT( LF, H);
LFFigure(CurFigure);
CurFigure = CurFigure + 1;
LFDisp(LFFilt);
axis image off
truesize
title(sprintf('Filtro plano de frecuencia, Pendiente %.3g, HyperfanBW %.3g', PlanarSlope, PlanarBW));
drawnow

%%
%---Demonstrate 4D Hyperfan filter---
fprintf('Construyendo un hyperfan de frecuencia 4D ... ');
CurFigure = 6;
%   Entradas:
HyperfanSlope1 = -0.1;
HyperfanSlope2 = 0.1;
HyperfanBW = 0.035;

H = LFBuild4DFreqHyperfan(LFSize, HyperfanSlope1, HyperfanSlope2, HyperfanBW);
fprintf('Aplicando filtro');
LFFilt = LFFilt4DFFT(LF, H);
LFFigure(CurFigure);
CurFigure = CurFigure + 1;
LFDisp(LFFilt);
axis image off
truesize
title(sprintf('Filtro hyperfan de frecuencia, Pendientes %.3g, %.3g, HyperfanBW %.3g', HyperfanSlope1, HyperfanSlope2, HyperfanBW));
drawnow




