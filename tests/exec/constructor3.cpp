#include <iostream>

class A {
public:
  A();
};

A::A() {
  std::cout << "hello world\n";
}

int main() {
  A *a;
  std::cout << "no hello world\n";
}
