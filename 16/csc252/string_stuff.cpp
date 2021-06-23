#include <iostream>

using namespace std;

void swap(int&, int&);

int main()
{
    string str1 = "Hot";
    string str2 = "Cold";

    int a = 2, b = 3;

    swap(a, b);

    cout << "First character of str1 is: " << str1[1] << endl;

//    str1.swap(str2);
    for(int i = 0; i < str1.length(); i++)
    {
        cout << str1[i] << endl;   
    }

    cout << "str1 is: " << str1 << endl;
    cout << "str2 is: " << str2 << endl;

    cout << "a is: " << a << endl;
    cout << "b is: " << b << endl;
    return 0;
}

void swap(int& num1, int& num2)
{
    int temp = num1;
    num1 = num2;
    num2 = temp;
}
