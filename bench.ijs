NB. matmul using GPU backend via ArrayFire
NB. requires nvidia gpu with cuda
LIB =: '/opt/arrayfire/lib64/libafcuda.so.3 '
chk =: {{ if. 0<>{.y do. exit echo 'ERROR',":y else. 1{:: y end. }}
af_get_data_ptr    =: LIB,'af_get_data_ptr i i i'
af_iota            =: LIB,'af_iota i * i *l i *l i'
af_matmul          =: LIB,'af_matmul i *x x x i i'
af_sync            =: LIB,'af_sync i i'
f64 =: 2  NB. 2 = arrayfire type code for double precision float

jtest_result =: {{ r;(timex'r=.a+/ .*a=.1+i.2#y') }}
jtest =: {{ 1{::jtest_result y }}

aftest_result =: {{
 shp =. 2#y
 n_bytes =. 8**/shp
 assert. 3.5>1e9%~n_bytes  NB. enough space to do all ops on GPU? (max 4GB, 3.5GB to be safe)
 h1 =. mema n_bytes  NB. (host pointer)
 i =. chk af_iota cd (,h1);2;shp;1;(,1);f64

 NB. matmul happens here
 t =. timex 'o1 =. chk af_matmul cd (,h1);({.i);({.i);0;0' NB. matmul (device)
 chk af_sync cd _1
 echo 0j5":t

 NB. copy to host, free memory
 NB. FIXME - the following code segfaults on large array sizes
 NB. - cold start segfaults with N=128 or higher
 NB. - warm start segfaults with N=1500 or higher
 h2 =. mema 8**/shp
 af_get_data_ptr cd h2;{.o1
 r=.shp$memr h2,0,(*/shp),8
 t;r [memf"0 h1,h2
}}

aftest =: {{ 0{::aftest_result y }}

NB. aftest 1  NB. uncomment to "warm up" ArrayFire
exit aftest "._1{::ARGV
