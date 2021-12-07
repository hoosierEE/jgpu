NB. matmul using GPU backend via ArrayFire
LIB =: '/opt/arrayfire/lib64/libafcuda.so.3 '  NB. GPU backend, requires nvidia gpu
sh =: 1e3*2}.{{{{y,+/_2{.y}}^:y 0 1}}8  NB. fibonacci shaped sequence (1000..34000 elements)
sz =: 1e9%~8**/@(2#]) sh  NB. GB of each result (0.008..9.248 GB)

af_create_array  =: LIB,'af_create_array i *x *d x *x i'
af_create_handle =: LIB,'af_create_handle i * i *l i'
af_get_data_ptr  =: LIB,'af_get_data_ptr i i i'
af_matmul        =: LIB,'af_matmul i *x x x i i'
f64 =: 2  NB. 2 = arrayfire type code for double precision float

jtest =: {{a=.(1+i.2#y)
 t =. timex'r=.a+/ .*a'
 r;t}}

chk =: {{ if. 0<>{.y do. exit echo y else. 1{:: y end. }}
aftest =: {{
shp =. 2#y
'p1 p2 p3' =. mema each 3#8**/shp  NB. allocate 3 identical sized pointers
ha1 =. chk af_create_handle cd (,p1);(#shp);shp;f64
ha2 =. chk af_create_handle cd (,p2);(#shp);shp;f64
ma1 =. chk af_create_array cd ha1;(1+i.shp);(#shp);shp;f64
t1 =. 6!:1''
out =. chk af_matmul cd ha2;({.ma1);({.ma1);0;0  NB. the actual matmul is here
ret =. chk af_get_data_ptr cd p3;{.out
r =. shp$memr ret,0,(*/shp),8
t =. t1-~6!:1''
memf"0 p1,p2,p3
r;t
}}

NB. exit ''
