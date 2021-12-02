NB. matmul.ijs
NB. matrix multiplication
NB.
NB. About =: {{)n
NB. In J, matrix multiplication between matrices x and y is: x +/ . * y
NB. We want to perform this operation on the GPU when it offers better performance.
NB. CPU-GPU memory transfers have high latency, so for small matrices it's better to stay on the CPU.
NB. What is the crossover point? It depends on both matrix size and your hardware.
NB. One way to find this crossover is by empirical measurements.
NB. }}

NB. First: perform matrix multiplication on the cpu using hard-coded x and y.
NB. This is the baseline.
X =: 2 3 $ 1 2 3 4 5 6
Y =: 3 2 $ 1 2 3 4 5 6
echo 'X:'
echo X
echo 'Y:'
echo Y
echo 'X +/ . * Y (on CPU):'
echo X +/ . * Y

NB. '/opt/arrayfire/lib64/libafcpu.so.3 foo n *i' cd a
NB. Result should look like this:
NB. 22 28
NB. 49 64

NB. (af_array *out, const af_array lhs, const af_array rhs, const af_mat_prop optLhs, const af_mat_prop optRhs)
NB.             *x                   x                   x                         i                         i
matmul =: '/opt/arrayfire/lib64/libafcpu.so.3 af_matmul i *x x x i i'&cd
NB. (af_array *arr, const void *const data, const unsigned ndims, const dim_t *const dims, const af_dtype type)
NB.           *x                        *d                     x                       *x                    i
array =: '/opt/arrayfire/lib64/libafcpu.so.3 af_create_array i *x *d x *x i'&cd
