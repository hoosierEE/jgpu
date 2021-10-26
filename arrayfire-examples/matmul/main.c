#include<arrayfire.h>
#include<stdio.h>
int main() {
    af_array M1, M2, result;
    dim_t d1[] = {2, 4};
    dim_t d2[] = {4, 3};
    if (AF_SUCCESS != af_randu(&M1, 2, d1, f64)) return 1;
    if (AF_SUCCESS != af_randu(&M2, 2, d2, f64)) return 1;
    if (AF_SUCCESS != af_matmul(&result, M1, M2, AF_MAT_NONE, AF_MAT_NONE)) return 1;
    af_print_array(result);
    return 0;
}
