#include <arrayfire.h>
#include <stdio.h>
int main(){
    dim_t dims[2] = { 10, 10 };
    af_array x = 0, y = 0;
    af_err err = af_randn(&x, 2, dims, f32); // check for error using err
    err = af_randn(&y, 2, dims, f32); // check for error using err

    // Now if we want to floor a multiplication of x with 100, it would like the following
    af_array factor = 0;
    err = af_constant(&factor, 1000, 2, dims, f32); // check for error using err
    af_array floored_x, scaled_x = 0;
    err = af_mul(&scaled_x, factor, x, false); // check for error using err
    err = af_floor(&floored_x, scaled_x); // check for error using err
    /* af_print(floored_x); */
    printf("hi world\n");
    return 0;
}
