#include <iostream>

int f(int a, int b, int c, int d, int e, int f) {
    std::cout << "a = " << a << ", b = " << b <<
        ", c = " << c << ", d = " << d << ", e = " <<
        e << ", f = " << f << "\n";
    return a + b + c + d + e + f;
}

int main() {
    int x = f(1, 2, 3, 4, 5, 6);
    std::cout << "x = " << x << "\n";
}
