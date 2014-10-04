#include <iostream>

class A {
    public:
    int y;
    A();
    virtual int f(int x);
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
    virtual int f(int x);
    int g(int x);
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

int A::f(int xopia) {
    y++;
    return xopia * y;
}

int B::g(int xulliver) {
    z++;
    return xulliver * z;
}

int C::f(int xerod) {
    return xerod * q;
}

int C::g(int xavon) {
    return xavon * q * 404;
}

int main() {
    A test2;
    std::cout << "A.f(1) = " << test2.f(1) << "\n";

    B test3;
    std::cout << "B.g(1) = " << test3.g(1) << "\n";

    C test;
    std::cout << "C.f(1) = " << test.f(1) << "\n";
    std::cout << "C.g(1) = " << test.g(1) << "\n";
    A *q = &test;
    std::cout << "(C as A).f(1) = " << q->f(1) << "\n";
    std::cout << "C.f(1) = " << test.f(1) << "\n";
    std::cout << "(C as A).f(1) = " << q->f(1) << "\n";
    std::cout << "C.f(1) = " << test.f(1) << "\n";
    B *r = &test;
    std::cout << "(C as B).g(1) = " << r->g(1) << "\n";
    std::cout << "C.g(1) = " << test.g(1) << "\n";
    std::cout << "(C as B).g(1) = " << r->g(1) << "\n";
    std::cout << "C.g(1) = " << test.g(1) << "\n";
}

