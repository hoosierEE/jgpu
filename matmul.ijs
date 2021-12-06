NB. matmul using GPU backend via ArrayFire
NB. TODO: error handling, benchmarking, better interface.
LIB =: '/opt/arrayfire/lib64/libafcuda.so.3 ' NB. GPU backend, requires nvidia gpu
{{assert. #1 dir}:LIB}}'' NB. ArrayFire must be installed for this demo to work
shp1 =: 2 3 NB.  left argument shape: 2x3
shp2 =: 3 4 NB. right argument shape: 3x4
shp3 =: ({.shp1),{:shp2 NB. result shape is therefore 2x4

af_create_array  =: LIB,'af_create_array i *x *d x *x i'
af_create_handle =: LIB,'af_create_handle i * i *l i'
af_get_data_ptr  =: LIB,'af_get_data_ptr i i i'
af_matmul        =: LIB,'af_matmul i *x x x i i'

NB. allocate memory for two operands (p1,p2), one result (p3)
p1 =: mema 8**/shp1
p2 =: mema 8**/shp2
p3 =: mema 8**/shp3

NB. Give ArrayFire access to the memory.
f64 =: 2  NB. 2 = arrayfire type code for double precision float
h1 =: 1{:: af_create_handle cd (,p1);(#shp1);shp1;f64
h2 =: 1{:: af_create_handle cd (,p2);(#shp2);shp2;f64
h3 =: 1{:: af_create_handle cd (,p3);(#shp3);shp3;f64
NB. J gives array elements to af_create_array, which stores them in device memory
m1 =: 1{:: af_create_array cd h1;(1+i.shp1);(#shp1);shp1;f64
m2 =: 1{:: af_create_array cd h2;(1+i.shp2);(#shp2);shp2;f64

NB. Show the matrices. Note column-major display.
echo ' compute (m1 +/ .* m2), where'
echo ' m1:',":x1 =: |:(|.shp1)$memr(1{:: af_get_data_ptr cd p1;{.m1),0,(*/shp1),8
echo ' m2:',":x2 =: |:(|.shp2)$memr(1{:: af_get_data_ptr cd p1;{.m2),0,(*/shp2),8

m3 =: 1{:: af_matmul cd h3;({.m1);({.m2);0;0
rr =: 1{:: af_get_data_ptr cd p3;{.m3
echo ' result (GPU):',":result_gpu =: shp3$memr rr,0,(2*4),8
echo {{ if. (shp3$,|:x1+/ .*x2) -: result_gpu do. r=.'yes' else. r=.'no' end.
' matches cpu result? ',r }} ''
memf"0 p1,p2,p3
NB. exit ''
