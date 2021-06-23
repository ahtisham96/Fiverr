#include <iostream>

using namespace std;

void static_variable();

int main()
{
	for(int i = 0; i < 10; i++)
	{
		static_variable();
	}
}

void static_variable()
{
	int i = 0;
	cout << "i is: " << i << endl;
	i++;
}