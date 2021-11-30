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

'/opt/arrayfire/lib64/libafcpu.so.3 foo n *i' cd a
NB. Result should look like this:
NB. 22 28
NB. 49 64
