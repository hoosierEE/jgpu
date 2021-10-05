struct stuff {
    double a[2];
    int i;
};

void fn(struct stuff *x) {
    x->a[x->i] += 100;
}
