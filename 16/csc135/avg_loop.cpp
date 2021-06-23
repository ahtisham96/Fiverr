#include <iostream>

using namespace std;

int main()
{
	int num_of_numbers;
	int sum = 0;
	int num = 0;

	cout << "How many numbers do you want to average? ";
	cin >> num_of_numbers;

	int i = 0;
	// for(int i = 0; i < num_of_numbers; i++)
	while (i < num_of_numbers)
	{
		// cout << "Loop : " << i << endl;
		cout << "Enter a whole number: ";
		cin >> num;
		if (num < 0)
			continue;
		sum = sum + num;
		cout << "Sum is: " << sum << endl;
		i++;
	}
	
	cout << "Your average is: " << sum / num_of_numbers << endl;

    return 0;
}
