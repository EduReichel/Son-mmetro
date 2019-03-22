function varargout = sonometro(varargin)


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sonometro_OpeningFcn, ...
                   'gui_OutputFcn',  @sonometro_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before sonometro is made visible.
function sonometro_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for sonometro
handles.output = hObject;

 evalin( 'base', 'clear variables' );
A=[-44.7000000000000 -39.4000000000000 -34.6000000000000 -30.2000000000000 -26.2000000000000 -22.5000000000000 -19.1000000000000 -16.1000000000000 -13.4000000000000 -10.9000000000000 -8.60000000000000 -6.60000000000000 -4.80000000000000 -3.20000000000000 -1.90000000000000 -0.800000000000000 0.0 0.600000000000000 1 1.20000000000000 1.30000000000000 1.20000000000000 1 0.500000000000000 -0.100000000000000 -1.10000000000000 -2.50000000000000 -4.30000000000000 -6.60000000000000 -9.30000000000000];

C= [-4.40000000000000 -3 -2 -1.30000000000000 -0.800000000000000 -0.500000000000000 -0.300000000000000 -0.200000000000000 -0.100000000000000 0 0 0 0 0 0 0 0 0 -0.100000000000000 -0.200000000000000 -0.300000000000000 -0.500000000000000 -0.800000000000000 -1.30000000000000 -2 -3 -4.40000000000000 -6.20000000000000 -8.50000000000000 -11.2000000000000];

Z= [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];



handles.ponderacionA=A;
handles.ponderacionZ=Z;
handles.ponderacionC=C;

%________Creacion de filtros________%
msgbox('Creando Filtros, espere por favor...')
[SOS,G,F0,Nfc] = Thirds(48000,8);
handles.SOS=SOS;
handles.G=G;
F0=fix(F0);
handles.F0=F0;
handles.Nfc=Nfc;

assignin('base','SOS',SOS);
assignin('base','F0',F0);
assignin('base','G',G);
assignin('base','Nfc',Nfc);

msgbox('ok')
% Update handles structure
guidata(hObject, handles);





% UIWAIT makes sonometro wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sonometro_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function audio_Callback(hObject, ~, handles)

[x,fs,nombre]=signalLoad;
handles.x=x;
handles.fs=fs;
handles.nombre=nombre;

set(handles.nombreAudio,'String',nombre);
assignin('base','nombre', nombre);

guidata(hObject, handles);

function calibracion_Callback(hObject, ~, handles)

[y, nombre]=calibrationLoad;
assignin('base','y',y);
handles.y=y;

set(handles.nombreCalibracion,'String',nombre);
guidata(hObject, handles);


function calibrar_Callback(hObject, eventdata, handles)

senalOriginal=handles.x;
assignin('base','senalOriginal',senalOriginal);
senalCalibracion=handles.y;
assignin('base','senalCalibracion',senalCalibracion);



[calibratedSignal]=calibration(senalOriginal,senalCalibracion);


 
handles.calibratedSignal=calibratedSignal;
assignin('base','calibratedSignal',calibratedSignal);
guidata(hObject, handles);

% --- Executes on selection change in integraciones.
function integraciones_Callback(hObject, eventdata, handles)

IntegracionElegida= get(handles.integraciones, 'Value');
assignin('base','IntegracionElegida', IntegracionElegida);

switch IntegracionElegida
    case 2
        tiempoDeIntegracion=1;
    case 3
        tiempoDeIntegracion=0.125;
    case 4
        tiempoDeIntegracion=0.035;
end

msgbox('Por favor, espere que esta procesando')
senalCalibrada=handles.calibratedSignal;

fs=handles.fs;

[particiones]=cutSignal(senalCalibrada, fs, tiempoDeIntegracion);
assignin('base','particiones',particiones);
SOS=handles.SOS;
G=handles.G;
F0=handles.F0;

STF=cell(1,1);
STF{1}=senalCalibrada;
   
[audioFiltradodB] = Filters(SOS,G,particiones,F0);
% freq=[1:30];
% matrizdB=[];
% mff=[];
% for i=1:length(freq)
% [mff] = TercioDeOctava(senalCalibrada,freq(i));
% end
% 
% matrizdB=[matrizdB; mff];
% assignin('base','matrizdB',matrizdB);





[senalTotalFiltrada,audioFiltrado]=Filters(SOS,G,STF,F0);
    
msgbox('Listo!')


assignin('base','senalTotalFiltrada',senalTotalFiltrada);
handles.senalTotalFiltrada=senalTotalFiltrada;
assignin('base','audioFiltradodB',audioFiltradodB);
handles.audioFiltradodB=audioFiltradodB;
assignin('base','particiones', particiones);
handles.particiones=particiones;
guidata(hObject, handles);

function integraciones_CreateFcn(hObject, eventdata, handles)
% hObject    handle to integraciones (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in ponderaciones.
function ponderaciones_Callback(hObject, eventdata, handles)

ponderacionElegida= get(handles.ponderaciones, 'Value');
assignin('base','ponderacionElegida', ponderacionElegida);

switch ponderacionElegida
    case 2
        ponderacionElegida=handles.ponderacionA;
    case 3
        ponderacionElegida=handles.ponderacionC;
    case 4
        ponderacionElegida=handles.ponderacionZ;
end


audioFiltradodB=handles.audioFiltradodB;

t=size(audioFiltradodB);
t=t(1);
particionesPonderadas=[];

for i=1:t
    signal1=audioFiltradodB(i,:);
    [senalPonderada]=ponderacion(signal1, ponderacionElegida);
   
   particionesPonderadas=[particionesPonderadas; senalPonderada];
end



senalTotalFiltrada=handles.senalTotalFiltrada;

senalTotalPonderada=ponderacion(senalTotalFiltrada ,ponderacionElegida);
handles.senalTotalPonderada=senalTotalPonderada;

F0=handles.F0;
assignin('base','F0',F0);
Total=[F0;senalTotalPonderada];
handles.Total=Total;
assignin('base','Total',Total);


%_______________GRAFICAS----------%

%__________Grafico FFT_______%
axes(handles.AxesFFT);

F0=handles.F0;
F0Graf=[100 250 1000 2000 4000 6300 8000];
F0=F0(10:30);
senalTotalPonderada=senalTotalPonderada(10:30);
plot(F0,senalTotalPonderada)
title('FFT')

axis([min(F0Graf) max(F0Graf) 20 120]);
ax=gca;
%set(gca,'XTick',F0Graf,'XTickLabel',['100' '250' '1k' '2k' '4k' '8k']);

%__________Grafico WaveForm______%
calibratedSignal=handles.calibratedSignal;

axes(handles.waveform);

plot(calibratedSignal)



title('Senal en tiempo calibrada' )
%handles.axeswaveform=gca;
%set(gca,'YTick',[1:length(DirectivityPlot(:,1))],'YTickLabel',DirectivityAngles)


assignin('base','senalTotalPonderada', senalTotalPonderada);
assignin('base','particionesPonderadas',particionesPonderadas);

%______-Gráfico Bar___________%

axes(handles.histograma);


xplot = 1:numel(F0);
% bar(xplot,senalTotalPonderada)
%set(gca,'xscale','log');
bar(xplot,senalTotalPonderada , 'BarWidth', 0.8);
title('Gráfico de barra')
xl={'199' ,'251', '316', '398', '501', '630', '794', '1k', '1k2', '1k5', '1k9', '2k5', '3k1', '3k9', '5k', '6k3','7k9','10k','12k5','15k8','20k'};

% bar(F0,senalTotalPonderada),xlim([150 6400])

set(gca,'XTick',xplot,'XTickLabel',xl,'XTickLabelRotation',45,'ylim',[35 85]);
%set(gca,'YTick',[1:length(DirectivityPlot(:,1))],'YTickLabel',DirectivityAngles)



%_____________Leq________Percentiles___%


[Lpico,LmaxTotal, LminTotal,Percentiles]=levels(calibratedSignal, senalTotalPonderada,particionesPonderadas);


set(handles.Lpico,'String',Lpico);
set(handles.Lmax,'String',LmaxTotal);
set(handles.Lmin, 'String',LminTotal);

set(handles.Per10,'String',Percentiles(1));
set(handles.Per25,'String',Percentiles(2));
set(handles.Per50,'String',Percentiles(3));
set(handles.Per75,'String',Percentiles(4));
set(handles.Per90,'String',Percentiles(5));

guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function ponderaciones_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ponderaciones (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in exportar.
function exportar_Callback(hObject, eventdata, handles)
% hObject    handle to exportar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% exportar;

senalPonderada=handles.senalTotalPonderada;



xlsappend('tablaTercio.xls',senalPonderada,1)
% xlswrite('tablaTercio.xls', exportar,'datos', 'append');


msgbox('Sus datos fueron guardados')
% --- Executes on button press in sound.
function sound_Callback(hObject, eventdata, handles)
% hObject    handle to sound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=handles.x;
fs=handles.fs;


sound(x,fs)
