NB. matmul using GPU backend via ArrayFire
NB. requires nvidia gpu with cuda
LIB =: '/opt/arrayfire/lib64/libafcuda.so.3 '
chk =: {{ if. 0<>{.y do. exit echo 'ERROR',":y else. 1{:: y end. }}
af_get_data_ptr    =: LIB,'af_get_data_ptr i i i'
af_iota            =: LIB,'af_iota i * i *l i *l i'
af_matmul          =: LIB,'af_matmul i *x x x i i'
af_sync            =: LIB,'af_sync i i'
f64 =: 2  NB. 2 = ArrayFire type code for double precision float

gpu_time =: {{
 shp =. 2#y
 n_bytes =. 8**/shp
  NB. enough space to do all ops on GPU? (max 4GB, 3.5GB to be safe)
 assert. 3.5>1e9%~n_bytes
 h1 =. mema n_bytes  NB. (host pointer)
 i =. chk af_iota cd (,h1);2;shp;1;(,1);f64

 NB. matmul happens here
 t =. timex 'o1 =. chk af_matmul cd (,h1);({.i);({.i);0;0'
 chk af_sync cd _1
 echo 0j5":t

 NB. FIXME - the following code segfaults:
 NB. - cold start segfaults with N=128 or higher
 NB. - warm start segfaults with N=1500 or higher

 NB. copy to host, free memory
 NB. h2 =. mema 8**/shp
 NB. af_get_data_ptr cd h2;{.o1
 NB. r=.shp$memr h2,0,(*/shp),8
 NB. r;t [memf"0 h1,h2
}}

N =: 10 100 200 500 1000 2000 4000 5000 6000 8000 10000 15000

NB. call this script with one N at a time, note result
NB. gpu_time 1  NB. uncomment to "warm up" ArrayFire
gpu_time "._1{::ARGV

NB. pure J matmul (denonted as "CPU" in report)
cpu_result =: {{ r;(timex'r=.a+/ .*a=.1+i.2#y') }}
cputest =: {{ 1{::cpu_result y }}
