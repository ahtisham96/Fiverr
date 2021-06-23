/**
*	Author: Prof. Earl
* 	Temperature reading w/ functions and files
**/

// include 
#include <iostream>
#include <iomanip>
#include <fstream>

using namespace std;

void open_file(ifstream&);
bool get_temperature(ifstream&, double&);
char get_unit(ifstream&);
double convert_temperature(double, char);
void display_results(double, double, char);

int main()
{
	double org_temp, converted_temp;
	char unit;

    ifstream file;

    open_file(file);
	
	while(get_temperature(file, org_temp))
	{
		unit = get_unit(file);
		
		converted_temp = convert_temperature(org_temp, unit);
		
		display_results(org_temp, converted_temp, unit);
	}
	
	return 0;
}

void open_file(ifstream& file)
{
    string filename;

    cout << "Please enter the name of the file: " << endl;
    cin >> filename;

    file.open(filename.c_str());
}

bool get_temperature(ifstream& file, double& temp)
{
	file >> temp;
	
	if(file.eof())
		return false;
	else
		return true;
	
}

char get_unit(ifstream& file) 
{
	char unit;
	file >> unit;
	return unit;
}

double convert_temperature(double org_temp, char org_unit)
{
	org_unit = toupper(org_unit);
	if(org_unit == 'C')
		return (org_temp * (9.0/5.0)) + 32;
	else
		return (org_temp - 32) * (5.0/9.0);
}

void display_results(double org_temp, double converted_temp, char org_unit)
{
	char new_unit;
	org_unit = toupper(org_unit);
	new_unit = (org_unit == 'C' ? 'F' : 'C');
	cout << fixed << showpoint << setprecision(2);
	
	cout << setw(30) << left << "Original Temperature:" << right << org_temp << " " << org_unit << endl;
	cout << setw(30) << left << "Converted Temperature:" << right << converted_temp << " " << new_unit << endl;
}
		
