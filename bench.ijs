NB. matmul using GPU backend via ArrayFire
NB. LIB =: '/opt/arrayfire/lib64/libafcpu.so.3 '  NB. cpu backend, requires mkl?
LIB =: '/opt/arrayfire/lib64/libafcuda.so.3 '  NB. GPU backend, requires nvidia gpu
chk =: {{ if. 0<>{.y do. exit echo 'ERROR',":y else. 1{:: y end. }}
af_alloc_device_v2 =: LIB,'af_alloc_device_v2 i * i'
af_create_array    =: LIB,'af_create_array i *i *d x *x i'  NB. hard-coded for 'double' type (*d)
af_create_handle   =: LIB,'af_create_handle i * i *l i'
af_eval            =: LIB,'af_eval i i'
af_free_device_v2  =: LIB,'af_free_device_v2 i *'
af_get_data_ptr    =: LIB,'af_get_data_ptr i i i'
af_get_device      =: LIB,'af_get_device i i'
af_get_device_ptr  =: LIB,'af_get_device_ptr i * i'
af_iota            =: LIB,'af_iota i * i *l i *l i'
af_matmul          =: LIB,'af_matmul i *x x x i i'
af_release_array   =: LIB,'af_release_array i x'
af_sync            =: LIB,'af_sync i i'
af_unlock_array    =: LIB,'af_unlock_array i i'
f64 =: 2  NB. 2 = arrayfire type code for double precision float

NB. NB. sanity check
NB. h =: mema 8*16
NB. r =: chk af_iota cd (,h);2;(4 4);1;(,1);f64
NB. NB. chk af_sync cd _1
NB. chk af_get_data_ptr cd h;{.r
NB. echo memr h,0,16,8
NB. memf h
NB. NB. exit''

jtest_result =: {{ r;(timex'r=.a+/ .*a=.1+i.2#y') }}
jtest =: {{ 1{::jtest_result y }}

aftest_result =: {{
 shp =. 2#y
 n_bytes =. 8**/shp
 assert. 3.5>1e9%~n_bytes  NB. enough space to do all ops on GPU? (max 4GB, 3.5GB to be safe)
 h1 =. mema n_bytes NB. (host pointer)
 i =. chk af_iota cd (,h1);2;shp;1;(,1);f64
 NB. d =. chk af_alloc_device_v2 cd (,h1);8**/shp  NB. (device pointer)
 NB. d =. chk af_create_array cd (,h1);(1+i.shp);(#shp);shp;f64  NB. (device pointer)

 NB. matmul happens here
 t =. timex 'o1 =. chk af_matmul cd (,h1);({.i);({.i);0;0' NB. matmul (device)
 chk af_sync cd _1
 echo 0j5":t

 NB. copy to host
 h2 =. mema 8**/shp
 af_get_data_ptr cd h2;{.o1
 r=.shp$memr h2,0,(*/shp),8
 NB. chk af_unlock_array cd d
 NB. chk af_release_array cd d
 NB. af_release_array"0 o1,d
 t;r NB. [memf"0 h1,h2
}}
NB.  af_sync _1
NB.  echo 'sync1'
NB.  o2 =. af_get_data_ptr p2;{.o1
NB.  af_sync _1
NB.  echo 'sync2'
NB.  r =. shp$memr o2,0,(*/shp),8
NB.  NB. free memory
NB.  af_release_array"0 ma1,o1
NB.  memf"0 p1,p2  NB. free memory
NB.  r;t
NB. }}

aftest =: {{ 0{::aftest_result y }}

aftest 1
exit aftest "._1{::ARGV
