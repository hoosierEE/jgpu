NB. benchmark j vs af performance
NB. Before running this script, run the following line in your shell:
NB. export LD_PRELOAD=/opt/arrayfire/lib64/libmkl_def.so:/opt/arrayfire/lib64/libmkl_avx2.so:/opt/arrayfire/lib64/libmkl_core.so:/opt/arrayfire/lib64/libmkl_intel_lp64.so:/opt/arrayfire/lib64/libmkl_intel_thread.so:/opt/arrayfire/lib64/libiomp5.so
load'~addons/math/arrayfire/arrayfire.ijs'

mp_bench=: 4 : 0
init_jaf_ x
jbench=. 1
if. y<0 do.
 y=. -y
 jbench=. 0
end.
ja=: (y,y)$0.3+?17$5000
NB. jb=: (y,y)$0.7+?17$5000

afa=: af_create_array_jaf_ ja NB. create arrayfire array
NB. afb=: af_create_array_jaf_ jb
NB. afa/afb - int scalar handles to data in af device space

NB. note args and result are transposed
aftime=: timex'qaf=: |:get_jaf_ af_matmul_jaf_ afa;afa;AF_MAT_TRANS_jaf_;AF_MAT_TRANS_jaf_'

if. jbench do.
 jtime=: timex'q=: ja (+/ .*) ja'
 assert q-:qaf
 jtime,aftime
else.
 aftime
end.
)

'backend size'=:2}.ARGV  NB. call like 'j mp_bench.ijs cuda 8000'
exit echo backend mp_bench ".size

NB. size    jcpu       afcuda     afcpu
NB. 1000   0.056262   0.100719   0.047372
NB. 2000   0.427451   0.771741   0.106946
NB. 4000   3.39665    5.84454    0.436433
NB. 6000  10.9967    18.9904     1.14112
NB. 8000  25.978     44.8076     2.80025
NB. 11000 69.1119   115.662      4.85914
