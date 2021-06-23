#include <iostream>

using namespace std;

double adder(double num1);
double adder(double num1, double num2=6);
int adder(int num1, int num2);

int main()
{
    cout << adder(6.0) << endl;

    cout << adder(6, 7) << endl;
    return 0;
}

double adder(double num1)
{
    return num1 + 6;
}

int adder(int num1, int num2)
{
    return num1 + num2;
}

double adder(double num1, double num2=6)
{
    return num1 + num2;
}
