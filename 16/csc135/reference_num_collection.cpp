#include <iostream>

using namespace std;

void average_numbers(double&, double&);

int main()
{
    double average, sum;

    average_numbers(sum, average);

    cout << "Sum is: " << sum << endl;
    cout << "Average is: " << average << endl;
    return 0;
}

void average_numbers(double& sum, double& average)
{
    int numbers_to_collect = 0, num;
    sum = 0; // Make sure sum is set to zero
    cout << "Please enter the numbers to collect: ";
    cin >> numbers_to_collect;

    cout << "Start entering your numbers:" << endl;
    for(int i = 0; i < numbers_to_collect; i++)
    {
        cin >> num;
        sum = num + sum;
    }

    average = sum / numbers_to_collect;
}
