# Metodo_de_evaluacion_para_campos_de_luz_usando_LFToolbox
Código en Matlab para la evaluación de un campo de luz con la implementación de las librerías de Light Field Toolbox  


    Autores:
       - Jhon Sebastian Yagama Parra
       - Juan Sebastian Mora Zarza


   Pontificia Universidad Javeriana  
              Bogota D.C.  
                 2023  


### Descripción general del algoritmo implementado:
   Este algoritmo se basa en la obtención, el procesamiento y la visualización 
de campos de luz antes y después de pasar por la implementación de distintos 
filtros de reenfoque sintético. Adicionalmente, el algoritmo cuenta con la 
obtención y creación de imágenes blancas obtenidas desde la aplicación para
la cámara Lytro y, por otra parte, este cuanta con la decodificación, 
calibración y rectificación de los campos de luz obtenidos por esta plenóptica.

Este metodo se implementó para la versión 0.5 de lightfield Toolbox.

### Lightfield Toolbox:
https://github.com/doda42/LFToolbox

## Implementación Lytro:
### Entradas:
   -   DirLF = Archivo .lfr que contiene el campo de luz en bruto.  
   -   InputFname = Dirección de todos los archivos de una foto decodificados  
   -   LFPaddedSize = Tamaño del filtro en el dominio de la frecuencia. Esto debe coincidir o exceder el tamaño del campo de luz que se filtrará.
   -   Pendientes y anchos de banda para los filtros de reenfoque.
       -   Slope1Sum, Slope2Sum.
       -   Slope
       -   Slope1
       -   Slope2
       -   BW

### Entradas opcionales:
   -   Fotografías en blanco obtenidas de los archivos internos de la Lytro.


### Salidas:
   -   Imágenes calibradas y rectificadas con alguna variación de reenfoque.

   Se recomienda leer el "Manual para el uso de las librerías de LightField Toolbox.pdf" antes de usar esta implementación. El archivo se puede encontrar en la pagina de sharepoint o en el Repositorio en la carpeta “Documentación”.
   Link sharepoint:
   - https://livejaverianaedu.sharepoint.com/sites/FotografaPlenoptica2/Manual20Para%20el%20manejo%20de%20las%20Libreras%20de%20LFToolbox/Forms/AllItems.aspx
   - 
