#include <iostream>

class A {
    public:
    int y;
    A();
    int f(int x);
};

class B {
    public:
    int z;
    B();
    int g(int x);
};

class C : public A, public B {
    public:
    int q;
    C();
    int f(int x);
};

A::A() {
    y = 12;
}

B::B() {
    z = 7;
}

C::C() {
    q = 11;
}

int A::f(int x) {
    return x * y;
}

int B::g(int x) {
    return x * z;
}

int C::f(int x) {
    return x * q;
}

int main() {
    C test;
    std::cout << "C.f(1) = " << test.f(1) << "\n";
    std::cout << "C.g(1) = " << test.g(1) << "\n";
    A *q = &test;
    std::cout << "A.f(1) = " << q->f(1) << "\n";
    B *r = &test;
    std::cout << "B.g(1) = " << r->g(1) << "\n";
}

