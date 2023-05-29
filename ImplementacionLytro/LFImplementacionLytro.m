%Algoritmo para evaluar los campos de luz obtenidos por la cámara Lytro
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
%   Este algoritmo se basa en la obtención, el procesamiento y la visualización 
%de campos de luz antes y después de pasar por la implementación de distintos 
%filtros de reenfoque sintético. Adicionalmente, el algoritmo cuenta con la 
%obtención y creación de imágenes blancas obtenidas desde la aplicación para
%la cámara Lytro y, por otra parte, este cuanta con la decodificación, 
%calibración y rectificación de los campos de luz obtenidos por esta plenóptica.
%
%Este metodo se implementó para la versión 0.5 de lightfield Toolbox.
%
%Lightfield Toolbox:
%https://github.com/doda42/LFToolbox
%
%
%Entradas:
%   -   DirLF = Archivo .lfr que contiene el campo de luz en bruto.
%   -   InputFname = Dirección de todos los archivos de una foto decodificados
%   -   LFPaddedSize = Tamaño del filtro en el dominio de la frecuencia. 
%                      Esto debe coincidir o exceder el tamaño del campo 
%                      de luz que se filtrará.
%   -   Pendientes y anchos de banda para los filtros de reenfoque.
%       -   Slope1Sum, Slope2Sum.
%       -   Slope
%       -   Slope1
%       -   Slope2
%       -   BW
%
%Entradas opcionales:
%   -   Fotografías en blanco obtenidas de los archivos internos de la Lytro.
%
%
%Salidas:
%   -   Imágenes calibradas y rectificadas con alguna variación de
%   reenfoque.
%
%   Se recomienda leer el "Manual para el uso de las librerías de LightField
%Toolbox.pdf" antes de usar esta implementación. El archivo se puede
%encontrar en la pagina de sharepoint o en el Repositorio en la carpeta 
% “Documentación”.
%   Link sharepoint:
%   https://livejaverianaedu.sharepoint.com/sites/FotografaPlenoptica2/Manual
%   20Para%20el%20manejo%20de%20las%20Libreras%20de%20LFToolbox/Forms/AllItems.aspx
%%
%   Si se requiere el manejo de muestras para otra versión de la camara Lytro
%"sn-A102430881" es necesario obtener los archivos para la creación de
%imágenes en blanco y el tipo de calibración que la camara requiera. Estos
%archivos los trae predeterminada la camara y usualmente estan llamados con
%los nombres Data.C.3, Data.C.2, etc. Esta función decodifica estos archivos 
%y obtiene las imágenes blancas en bruto como archivos .raw y .txt

%   Nota: Esta función no es necesaria correrla si se van a manejar las muestras
%de la cámara Lytro dadas en el ejemplo o muestras nuevas tomadas con esta misma.

%Descomentar la función para su uso.
%LFUtilUnpackLytroArchive;

%%
%   Luego de obtener los archivos decodificados de la función anterior, Se corre 
%esta función para obtener una cuadricula de micro lentes con sus centroides 
%marcados con puntos en rojo (La imagen en blanco usada para decodificar los 
%campos de luz).

%   Nota: Como la función anterior, esta función no es necesaria correrla si 
%se van a manejar las muestras de la cámara Lytro dadas en el ejemplo o muestras 
%nuevas tomadas con esta misma.

%Descomentar la función para su uso.
%LFUtilProcessWhiteImages;

%%
%
%               Comienzo del algoritmo
%
%Decodificación del archivo .lfr dado por la aplicación de Lytro.
%Para usar otro campo de luz solo se debe cambiar la dirección.
%   Entradas:
DirLF = 'Images/IMG_0002.lfr';
LFUtilDecodeLytroFolder(DirLF);
%Corrección de color
DecodeOptions.OptionalTasks = 'ColourCorrect';
LFUtilDecodeLytroFolder(DirLF, [], DecodeOptions);

%%
%Lectura y visualización de los archivos decodificados por la función anterior
%   Entradas:
InputFname = fullfile('Images','F01','IMG_0002__Decoded');

%---Carga de campo de luz---
fprintf('Cargando %s...', InputFname);
load(InputFname,'LF');
fprintf(' Hecho\n');
LFSize = size(LF);

CurFigure = 1;
LFFigure(CurFigure);
CurFigure = CurFigure + 1;
LFDisp(LF);
%LFDispMousePan(LF);
axis image off
truesize
title('Entrada');
drawnow

%%
%---Demostración del filtro de suma y desplazamiento---
CurFigure = 2;
%   Entradas:
Slope1Sum = -2/9;
Slope2Sum = 6/9;

for( Slope = [Slope1Sum, Slope2Sum])% Flor: -2/9;  Fondo: 6/9.
	fprintf('Aplicando filtro de suma y desplazamiento');
	[ShiftImg, FiltOptionsOut] = LFFiltShiftSum( LF, Slope );
	fprintf(' Hecho\n');
	FiltOptionsOut

	LFFigure(CurFigure); 
	CurFigure = CurFigure + 1;
	LFDisp(ShiftImg);
	axis image off
 	truesize
	title(sprintf('Filtro de suma y desplazamiento, Pendiente %.3g', Slope));
	drawnow
end
%%
%---Configuración para filtros lineales---
CurFigure = 4;
%   Entradas:
LFPaddedSize = [16, 16, 400, 400];
BW = 0.03; % Ancho de banda del filtro
Slope = -2/9; % -2/9 = Flor enfocada
FiltOptions = [];
FiltOptions.Rolloff = 'Butter';

%---Demostración del filtro lineal 2D---
fprintf('Construyendo línea de frecuencia 2D... ');
Htv = LFBuild2DFreqLine( LFPaddedSize([1,3]), Slope, BW, FiltOptions);
fprintf('Aplicando filtro en t,v');
[LFFilt, FiltOptionsOut] = LFFilt2DFFT( LF, Htv, [1,3], FiltOptions );
FiltOptionsOut
LFFigure(CurFigure);
CurFigure = CurFigure + 1;
LFDisp(LFFilt);
axis image off
truesize
title(sprintf('Freq. filtro lineal. t,v; Pendiente %.3g, BW %.3g', Slope, BW));
drawnow

fprintf('Construyendo línea de frecuencia 2D... ');
Hsu = LFBuild2DFreqLine( LFPaddedSize([2,4]), Slope, BW, FiltOptions);
fprintf('Aplicando filtro en s,u');
[LFFilt, FiltOptionsOut] = LFFilt2DFFT( LFFilt, Hsu, [2,4], FiltOptions );
LFFigure(CurFigure);
CurFigure = CurFigure + 1;
LFDisp(LFFilt);
axis image off
truesize
title(sprintf('Freq. filtro lineal. t,v luego de s,u; Pendiente %.3g, BW %.3g', Slope, BW));
drawnow
%%
%---Demostración del filtro plano 4D---
CurFigure = 6;
%   Entradas:
LFPaddedSize = [16, 16, 400, 400];
BW = 0.03; % Ancho de banda del filtro
Slope = -2/9; % -2/9 = Flor enfocada

fprintf('Construyendo un plano de frecuencia 4D... ');
[H, FiltOptionsOut] = LFBuild4DFreqPlane( LFPaddedSize, Slope, BW );
fprintf('Aplicando filtro');
[LFFilt, FiltOptionsOut] = LFFilt4DFFT( LF, H, FiltOptionsOut );
FiltOptionsOut
LFFigure(CurFigure);
CurFigure = CurFigure + 1;
LFDisp(LFFilt);
axis image off
truesize
title(sprintf('Filtro plano de frecuencia, Pendiente %.3g, BW %.3g', Slope, BW));
drawnow
%%
%---Demostración del filtro Hyperfan 4D---
CurFigure = 7;
%   Entradas:
LFPaddedSize = [16, 16, 400, 400];
BW = 0.03; % Ancho de banda del filtro
Slope1 = -3/9; % -3/9 = Flor partes mas lejanas de la cámara
Slope2 = -6/9; % 4/9 = Flor partes mas cercanas de la cámara

fprintf('Construyendo un hyperfan de frecuencia 4D ... ');
[H, FiltOptionsOut] = LFBuild4DFreqHyperfan( LFPaddedSize, Slope1, Slope2, BW, FiltOptions );
fprintf('Aplicando filtro');
[LFFilt, FiltOptionsOut] = LFFilt4DFFT( LF, H, FiltOptionsOut );
FiltOptionsOut
LFFigure(CurFigure);
CurFigure = CurFigure + 1;
LFDisp(LFFilt);
axis image off
truesize
title(sprintf('Filtro hyperfan de frecuencia, Pendientes %.3g, %.3g, BW %.3g', Slope1, Slope2, BW));
drawnow

%%
%En esta sección se demuestra la calibración de la cámara Lytro, es
%opcional y no dependen de los filtros de reenfoque sintetico ni viceversa.
%
%Decodificación de las fotografías con el patrón de ajedrez para calibración de la cámara
LFUtilDecodeLytroFolder( ...
'Cameras/A000424242/PlenCalSmallExample/');%'Cameras/sn-A102430881/CalibracionTableroAjedrez/'
CalOptions.ExpectedCheckerSize = [8,6];% [11,6]
CalOptions.ExpectedCheckerSpacing_m = 1e-3*[35.1, 35.0];% 1e-3*[13.0, 13.0]
LFUtilCalLensletCam( ...
'Cameras/A000424242/PlenCalSmallExample', CalOptions);%'Cameras/sn-A102430881/CalibracionTableroAjedrez'
%Calibración
LFUtilProcessCalibrations;
%Rectificación
DecodeOptions.OptionalTasks = 'Rectify';
LFUtilDecodeLytroFolder( ...
'Images/F01/IMG_0002.lfr', [], DecodeOptions);%'Images/Ejemplos/IMG_0005__frame.raw'

