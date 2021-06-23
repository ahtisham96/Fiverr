#include <iostream>
#include <fstream>

using namespace std;

fstream open_file(string);
void read_file(ifstream&);

int main()
{
    ifstream file = open_file("test.txt");
	
	read_file(file);

    file.close();
    return 0;
}

ifstream open_file(string f_name)
{
	ifstream file;
	file.open(f_name.c_str());
	return file;
}

void read_file(ifstream& file)
{
	string word;
	while (file >> word)
	{
		cout << word << endl;
	}
}
