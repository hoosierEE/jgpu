NB. matmul.ijs
NB. In J, matrix multiplication between matrices x and y is: x +/ . * y
NB. We want to perform this operation on the GPU when it offers better performance.
NB. CPU-GPU memory transfers have high latency, so for small matrices it's better to stay on the CPU.
NB. What is the crossover point? It depends on both matrix size and your hardware.
NB. One way to find this crossover is by empirical measurements.

NB. aftypes  :: ctype      :: jtype
NB. af_array :: void*      :: l (or *?)
NB. dim_t    :: long long  :: l
NB. af_dtype :: enum       :: i

NB. af_dtype values:
f32 =: 0 NB. f:float
c32 =: 1 NB. c:complex
f64 =: 2
c64 =: 3
b8  =: 4 NB. b:boolean
s32 =: 5 NB. s:signed integral value
u32 =: 6 NB. u:unsigned integral value
u8  =: 7
s64 =: 8
u64 =: 9
s16 =: 10 NB. #if AF_API_VERSION >= 32
u16 =: 11 NB. #if AF_API_VERSION >= 32
f16 =: 12 NB. #if AF_API_VERSION >= 37

NB. selected af_* C API functions
LIB =: '/opt/arrayfire/lib64/libafcpu.so.3 '
af_create_array  =: LIB,'af_create_array i *x *d x *x i'
af_identity      =: LIB,'af_identity i * i *l i'
af_matmul        =: LIB,'af_matmul i *x x x i i'
af_print         =: LIB,'af_print i *'
af_randu         =: LIB,'af_randu i * i *l i'
af_get_data_ptr  =: LIB,'af_get_data_ptr i *i i'
af_create_handle =: LIB,'af_create_handle i * i *l i'
NB. this works:
NB. '/opt/arrayfire/lib64/libafcpu.so.3 af_randu i * i *l i' cd (,a);3;2 2;2

NB. Proof of concept:
NB. use af_identity() to generate a matrix, then display it with af_print().
a =: mema 16*8 NB. 4x4 x64-bit integers
p =: 1{:: r =: af_identity cd (,a);2;4 4;u64
NB. af_get_data_ptr cd a;p

NB. First, allocate. Pass pointer to af_identity so it has somewhere to put the result.
NB. Going to do a 4x4 matrix of int type
NB. a =: mema 4*4*8
NB. af_identity&cd a;2;4 4;s64
