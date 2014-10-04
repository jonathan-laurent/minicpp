#include <iostream>


class A { public :
  int a;
};

class B : public A { public :
  int b;
};

class C : public A { public :
  int c;
};

class D : public B, public C { public :
  int d;
};



void f(A* ap) {std::cout << ap->a << "\n";}

int main () {

  D* dp = new D();
  dp->a = 42;
  std::cout << dp-> a << "\n";

  f(dp);

  return 0;
}
