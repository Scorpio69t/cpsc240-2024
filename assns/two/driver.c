#include <stdio.h>
#include <math.h>

extern double manager();

int main(void)
{
    printf("Welcome to Amazing Triangles programmed by Steven Hicken on %s.\n", __DATE__);
    double tri = manager();
    printf("The driver received this number %lf and will simply keep it.\n", tri);
    printf("An integer zero will now be sent to the operating system. Bye.\n");
    return 0;
}