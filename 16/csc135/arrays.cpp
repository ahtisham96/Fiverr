#include <iostream>

using namespace std;

int main()
{
    int x[] = {1, 2, 3, 4, 5, 6, 9, 8};
    bool found = false;

    int board[2][3] = {{2, 3, 1},
                        15, 25, 1}};

    cout << board[0][0] << endl;
    cout << board[1][2] << endl;

    for(int i = 0; i < 8 && found == false; i++)
    {
        if(x[i] == 9)
            found = true;

    }

    if(found)
        cout << "The number 9 is in the array!" << endl;
    else
        cout << "The number 9 is not in the array!" << endl;

    return 0;
}
