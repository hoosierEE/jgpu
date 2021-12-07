NB. matmul using GPU backend via ArrayFire
LIB =: '/opt/arrayfire/lib64/libafcuda.so.3 '  NB. GPU backend, requires nvidia gpu
sh =: 1e3*2}.{{{{y,+/_2{.y}}^:y 0 1}}8  NB. fibonacci shaped sequence (1000..34000 elements)
sz =: 1e9%~8**/@(2#]) sh  NB. GB of each result (0.008..9.248 GB)

af_create_array  =: LIB,'af_create_array i *x *d x *x i'
af_create_handle =: LIB,'af_create_handle i * i *l i'
af_get_data_ptr  =: LIB,'af_get_data_ptr i i i'
af_matmul        =: LIB,'af_matmul i *x x x i i'
f64 =: 2  NB. 2 = arrayfire type code for double precision float

jtest =: {{
 a =. 1+i.2#y
 t =. timex 'r=.a+/ .*a'
 if. 1-:x do. r;t else. t end.}}

aftest =: {{
 chk =. {{ if. 0<>{.y do. exit echo y else. 1{:: y end. }}
 shp =. 2#y
 'p1 p2' =. mema each 2#8**/shp  NB. allocate 2 same-size pointers
 ha1 =. chk af_create_handle cd (,p1);(#shp);shp;f64
 ha2 =. chk af_create_handle cd (,p2);(#shp);shp;f64
 ma1 =. chk af_create_array cd ha1;(1+i.shp);(#shp);shp;f64
 t =. 6!:1''  NB. start
 out =. chk af_matmul cd ha2;({.ma1);({.ma1);0;0  NB. the actual matmul is here
 echo 'matmul argument shapes: (', (":shp), '), (' ,(":shp), ')'
 out =. chk af_get_data_ptr cd p2;{.out
 echo 'ok'
 out =. shp$memr out,0,(*/shp),8
 t =. t-~6!:1''  NB. elapsed
 memf"0 p1,p2  NB. free memory
 if. 1-:x do. r;t else. t end.}}

NB. 0 aftest 127 NB. Warm-up. Largest size possible without segfault
NB. 0 aftest ".2{::ARGV
NB. exit''

jbench =: {{
 r =. 0 0$0
 for_i. 500 1000 2000 5000 do. r =. r,0 jtest i end.
 r}}
NB. exit''
