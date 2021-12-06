NB. matmul.ijs
NB. Perform matrix multiply on GPU for better performance.
NB. CPU-GPU memory transfers have high latency,
NB. so for small matrices it's better to stay on the CPU.
NB. What is the crossover point?
NB. It depends on both matrix size and your hardware.
NB. One way to find this crossover is by empirical measurements.
NB. This script aims to take some measurements for various data sizes,
NB. and compare results to find a crossover point, if one exists.

NB. Pseudo-dictionary data structure using 2xN boxes.
NB. Keys in first row, values in second row.
dict_str_int =: {{({.,: ".&.>@{:)|:2&{.@cut;._2 y}}
dict_int_str =: {{({:,:~".&.>@{.)|:2&{.@cut;._2 y}}
dget =: {{({:x){::~(<y)ss{.x}} NB. pseudo-dict indexing: (x dget y) = (x[y])

NB. TYPES
AF_TYPE =: dict_str_int {{)n
 f32 0 NB. (f)loat (c)omplex (b)oolean (s)igned (u)nsigned
 c32 1
 f64 2
 c64 3
 b8  4
 s32 5
 u32 6
 u8  7
 s64 8
 u64 9
 s16 10 NB. #if AF_API_VERSION >= 32
 u16 11 NB. #if AF_API_VERSION >= 32
 f16 12 NB. #if AF_API_VERSION >= 37
}}

NB. ERRORS
NB. int:str; get 'AF_ERR_XYZ' based on integer
AF_ERR =: dict_int_str {{)n
 0   AF_SUCCESS  NB. rejoice
 101 AF_ERR_NO_MEM
 102 AF_ERR_DRIVER
 103 AF_ERR_RUNTIME
 201 AF_ERR_INVALID_ARRAY
 202 AF_ERR_ARG
 203 AF_ERR_SIZE
 204 AF_ERR_TYPE
 205 AF_ERR_DIFF_TYPE
 207 AF_ERR_BATCH
 208 AF_ERR_DEVICE
}}

NB. ArrayFire C API (selected functions)
NB. LIB =: '/opt/arrayfire/lib64/libafcpu.so.3 '
LIB =: '/opt/arrayfire/lib64/libafcuda.so.3 '
af_create_array  =: LIB,'af_create_array i *x *d x *x i'
NB. af_create_array(af_array *arr,
NB.                 const void *const data,
NB.                 const unsigned ndims,
NB.                 const dim_t *const dims,
NB.                 const af_dtype type)
NB.    (af_array*, void*, unsigned, long*, int)
NB. F          *x     *f         x     *x    i
NB. J          *x     *j         x     *x    i
NB. D          *x     *d         x     *x    i
NB. S          *x     *i         x     *x    i

af_create_handle =: LIB,'af_create_handle i * i *l i'
af_get_data_ptr  =: LIB,'af_get_data_ptr i i i'
af_get_type      =: LIB,'af_get_type i *i *'
af_identity      =: LIB,'af_identity i * i *l i'
af_matmul        =: LIB,'af_matmul i *x x x i i'
af_print_array   =: LIB,'af_print_array i *'
af_randu         =: LIB,'af_randu i * i *l i'

NB. Sanity check 1: make a 4x4 identity matrix.
p1 =: mema 16*8  NB. 4x4 float64
h1 =: 1{:: af_create_handle cd (,p1);2;4 4;AF_TYPE dget 'f64'
i1 =: 1{:: af_identity cd h1;2;4 4;AF_TYPE dget 'f64'
rr =: 1{:: af_get_data_ptr cd (p1);{.i1
echo 4 4$memr rr,0,16,8 NB. =i.4

NB. Sanity check 2: create an array from J data (reusing pointer p1)
h2 =: 1{:: af_create_handle cd (,p1);2;4 4;AF_TYPE dget 'f64'
a2 =: 1{:: af_create_array cd h2;(i.16);2;4 4;AF_TYPE dget 'f64'
rr =: 1{:: af_get_data_ptr cd p1;{.a2
echo (datatype,': '"_,":)memr rr,0,16,8

NB. The main event: matmul
f64 =: AF_TYPE dget 'f64'
p1 =: mema 8*2*3 NB. 2x3
p2 =: mema 8*3*4 NB. 3x4
p3 =: mema 8*2*4 NB. 2x4

h1 =: 1{:: af_create_handle cd (,p1);2;2 3;f64
h2 =: 1{:: af_create_handle cd (,p2);2;3 4;f64
h3 =: 1{:: af_create_handle cd (,p3);2;2 4;f64

m1 =: 1{:: af_create_array cd h1;(1+i.2 3);2;2 3;f64
m2 =: 1{:: af_create_array cd h2;(1+i.3 4);2;3 4;f64

NB. Sanity check 3: show the matrices before doing the matmul.
echo 'm1: ',":2 3$memr(1{:: af_get_data_ptr cd p1;{.m1),0,6,8
echo 'm2: ',":3 4$memr(1{:: af_get_data_ptr cd p1;{.m2),0,12,8

m3 =: 1{:: af_matmul cd h3;({.m1);({.m2);0;0 NB. no transform
rr =: 1{:: af_get_data_ptr cd p3;{.m3
NB. memr rr,0,(2*4),8
echo 'm3 = m1 +/ .* m2 (NB. arrayfire is column major): ',":2 4 $ memr rr,0,(2*4),8

NB. ArrayFire uses column-major ordering, so (1+i.2 3) +/ .*(1+i.3 4) gives a different result in J.
