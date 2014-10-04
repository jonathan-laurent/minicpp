#include <iostream>

int test(int a) {
    int *b = &a;
    *b = *b + 42;
    return a;
}

int main() {
    int x = 0;
    int y = test(x);
    std::cout << "x = " << x << "\n";
    std::cout << "y = " << y << "\n";
}

