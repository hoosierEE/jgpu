// src/mm.cpp
#include <arrayfire.h>
int main(){
    // ArrayFire uses column-major ordering
    af::dim4 d1(2,3);
    af::array m1 = af::moddims(af::seq(1,2*3), d1);
    af_print(m1);
    af_print(af::flat(m1.T()));
    af::dim4 d2(3,4);
    af::array m2 = af::moddims(af::seq(1,3*4), d2);
    af::array m3 = af::matmul(m1,m2);
    af_print(m3);

    // but it is possible to "fake" row-major ordering
    af::dim4 r1(3,2);
    af::array t1 = af::moddims(af::seq(1,2*3), r1);
    af_print(t1);

    af::dim4 r2(4,3);
    af::array t2 = af::moddims(af::seq(1,3*4), r2);
    af_print(t2);
    // af::array m4 = af::matmulTT(t2,t1).T();
    af::array m4 = af::matmulTT(t1,t2);
    af_print(m4);
}
