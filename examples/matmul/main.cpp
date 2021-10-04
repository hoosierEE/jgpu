#include<arrayfire.h>
int main(void) {
    af::array M1 = af::randu(2,4);
    af::array M2 = af::randu(4,1);
    af::array result = af::matmul(M1, M2);
    af_print(result);
}
