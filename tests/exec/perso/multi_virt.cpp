#include <iostream>

class A { public : int a; virtual void fa();};
class B { public : int b; virtual void fb(); virtual void h();};

class C : public A, public B { public : int c; virtual void fc();};

class D { public : int d; virtual void fd(); virtual void h();};
class E : public C, public D { public : int e; virtual void fb(); virtual void fd(); virtual void h();};

void B::fb() {std::cout << "B::fb";}
void E::fb() {std::cout << "E::fb";}
void A::fa() {std::cout << "A::fa";}
void D::fd() {std::cout << "D::fd";}
void E::fd() {std::cout << "E::fd";}
void C::fc() {std::cout << "E::fc";}

void E::h() {std::cout << "E::h";}
void B::h() {std::cout << "B::h";}
void D::h() {std::cout << "D::h";}


int main() {
  
  D* cp = new E();
  cp->h();

  std::cout << "\n";

  D* dp = new E() ;
  dp->fd();

  std::cout << "\n";

  A* ap = new C() ;
  ap->fa();

  std::cout << "\n";

  return 0;
}




