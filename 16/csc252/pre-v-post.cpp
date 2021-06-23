#include <iostream>

using namespace std;

int main() {

    int x, y, z;

    x = 5;
    y = ++x;
    z = x++;

    cout << "x = " << x << endl;
    cout << "y = " << y << endl;
    cout << "z = " << z << endl;

    return 0;
}
