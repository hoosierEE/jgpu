typedef struct stuff {double a[2]; int i;} Stuff;
void fn(Stuff *x) {x->a[x->i] += 100;}
