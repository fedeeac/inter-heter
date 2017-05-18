% [tm,um]: medicion
% [tr,ur]: referencia

% constantes
fs=71.6452e6; % frecuencia del haz (no calculada)

% lectura de datos
m1=csvread('F0011CH1.csv',0,3,[0 3 2499 4]);
r1=csvread('F0011CH4.csv',0,3,[0 3 2499 4]);
m2=csvread('F0012CH1.csv',0,3,[0 3 2499 4]);
r2=csvread('F0012CH4.csv',0,3,[0 3 2499 4]);
m3=csvread('F0013CH1.csv',0,3,[0 3 2499 4]);
r3=csvread('F0013CH4.csv',0,3,[0 3 2499 4]);
tm1=m1(:,1);
um1=m1(:,2);
tm2=m2(:,1);
um2=m2(:,2);
tm3=m3(:,1);
um3=m3(:,2);
tr1=r1(:,1);
ur1=r1(:,2);
tr2=r2(:,1);
ur2=r2(:,2);
tr3=r3(:,1);
ur3=r3(:,2);

fur1=fft(ur1);
fur1filt=fur1;
fur1filt(end/2:end)=0;
fur2=fft(ur2);
fur2filt=fur2;
fur2filt(end/2:end)=0;
fur3=fft(ur3);
fur3filt=fur3;
fur3filt(end/2:end)=0;

% PLL: generación de señales en fase y en cuadratura
Ir1=real(ifft(fur1filt));
Qr1=imag(ifft(fur1filt));
Ir2=real(ifft(fur2filt));
Qr2=imag(ifft(fur2filt));
Ir3=real(ifft(fur3filt));
Qr3=imag(ifft(fur3filt));

% normalización (señales medidas)
um1n=um1/(max(abs(um1)));
um2n=um2/(max(abs(um2)));
um3n=um3/(max(abs(um3)));

% mas normalizacion
Ir1=Ir1/(max(abs(Ir1)));
Ir2=Ir2/(max(abs(Ir2)));
Ir3=Ir3/(max(abs(Ir3)));
Qr1=Qr1/(max(abs(Qr1)));
Qr2=Qr2/(max(abs(Qr2)));
Qr3=Qr3/(max(abs(Qr3)));

% mixer
I1=um1n.*Qr1;
Q1=um1n.*Ir1;
I2=um2n.*Qr2;
Q2=um2n.*Ir2;
I3=um3n.*Qr3;
Q3=um3n.*Ir3;

% filtro pasabajos: frecuencia de corte 300 Hz
fc=300; % frecuencia de corte
fm=1000; % frecuencia de muestreo
[b,a]=butter(6,fc/(fm/2)); % filtro de Butterworth orden 6

% filtrado de las señales
If1=filter(b,a,I1);
Qf1=filter(b,a,Q1);
If2=filter(b,a,I2);
Qf2=filter(b,a,Q2);
If3=filter(b,a,I3);
Qf3=filter(b,a,Q3);

% cálculo de diferencia de fase
phi1=atan2(If1,Qf1);
phi2=atan2(If2,Qf2);
phi3=atan2(If3,Qf3);
%rad2deg(mean(phi1))
%rad2deg(mean(phi2))
%rad2deg(mean(phi3))