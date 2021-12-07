NB. matmul using GPU backend via ArrayFire
NB. LIB =: '/opt/arrayfire/lib64/libafcpu.so.3 '  NB. GPU backend, requires nvidia gpu
LIB =: '/opt/arrayfire/lib64/libafcuda.so.3 '  NB. GPU backend, requires nvidia gpu
chk =: {{ if. 0<>{.y do. exit echo 'ERROR',":y else. 1{:: y end. }}
af_create_array  =: chk@cd~&(LIB,'af_create_array i *i *d x *x i')  NB. hard-coded for 'double' type
af_create_handle   =: chk@cd~&(LIB,'af_create_handle i * i *l i')
af_alloc_device_v2 =: chk@cd~&(LIB,'af_alloc_device_v2 i * i')
af_free_device_v2  =: chk@cd~&(LIB,'af_free_device_v2 i *')
af_get_device_ptr  =: chk@cd~&(LIB,'af_get_device_ptr i ')
af_get_data_ptr    =: chk@cd~&(LIB,'af_get_data_ptr i i i')
af_get_device      =: chk@cd~&(LIB,'af_get_device i i')
af_matmul          =: chk@cd~&(LIB,'af_matmul i *x x x i i')
af_release_array   =: chk@cd~&(LIB,'af_release_array i x')
af_sync            =: chk@cd~&(LIB,'af_sync i i')
f64 =: 2  NB. 2 = arrayfire type code for double precision float

NB. sh =: 1e3*2}.{{{{y,+/_2{.y}}^:y 0 1}}8  NB. fibonacci shaped sequence (1000..34000 elements)
NB. sz =: 1e9%~8**/@(2#]) sh  NB. GB of each result (0.008..9.248 GB)

jtest_result =: {{ r;(timex'r=.a+/ .*a=.1+i.2#y') }}
jtest =: {{ 1{::jtest_result y }}

aftest_result =: {{
 shp =. 2#y
 'p1 p2' =. mema each 2#8**/shp  NB. allocate 2 same-size pointers on host
 ma1 =. af_create_array (,p1);(1+i.shp);(#shp);shp;f64  NB. (device)

 NB. matmul happens:
 t =. 6!:1''  NB. start
 o1 =. af_matmul (,p2);({.ma1);({.ma1);0;0  NB. matmul (device)
 echo '   time taken for (i.', (":shp), ') +/ .* (i.' ,(":shp), '):'
 t =. t-~6!:1''  NB. elapsed

 device =. af_get_device pdev =. mema 8
 af_sync device
 o2 =. af_get_data_ptr p2;{.o1
 r =. shp$memr o2,0,(*/shp),8
 NB. free memory
 af_release_array"0 ma1,o1
 memf"0 p1,p2,pdev  NB. free memory
 r;t
}}

aftest =: {{ 1{::aftest_result y }}

NB. 0 aftest 127 NB. Warm-up. Largest size possible without segfault
NB. 0 aftest ".2{::ARGV
NB. exit''

jbench =: {{
 r =. 0 0$0
 for_i. 500 1000 2000 5000 do. r =. r,0 jtest i end.
 r}}
NB. exit''
