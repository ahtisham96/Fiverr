#include <iostream>

using namespace std;

int abs(int);
int secret(int);

void print_instructions();

int main()
{
	print_instructions();
	int num = -100;
	num = abs(num);
	cout <<	num << endl;
	
	cout << "Num after abs call: " << num << endl;

    return 0;
}

void print_instructions()
{
	cout << "Hello World!" << endl;
}

int abs(int number) 
{
	int return_value;
	if(number < 0)
		return_value = -number;
	else
		return_value = number;

	number = 1000;

	return return_value;
}

int secret(int x)
{
	if (x > 5)
		return 2 * x;

	return x;
}
