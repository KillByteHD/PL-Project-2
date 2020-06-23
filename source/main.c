#include <stdio.h>
#include <string.h>
#include "family.h"

int main(void)
{
    family_tree* fam = init_family_tree();
    add_person(fam, strdup(":Antonio"));
    set_person_gender(fam, ":Antonio", MALE);

    const person_data* tmp;
    if((tmp = get_person_data(fam, ":Antonio")) != NULL)
    {
        printf("Chamó %s",":Antonio");
    }
}