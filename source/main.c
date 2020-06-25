#include <stdio.h>
#include <string.h>
#include "family.h"

int main(void)
{
    family_tree* fam = init_family_tree();
    //add_person_with_gender(fam, strdup("Antonio"), MALE);

    //add_person_with_gender(fam, strdup("Antonieta"), FEMALE);


    add_person_with_gender(fam, strdup("GayDude1"), MALE);
    add_person_relation(fam, "GayDude1", "temMae", "Antonieta");
    add_person_relation(fam, "GayDude1", "temPai", "Antonio");

    add_person_with_gender(fam, strdup("GayDude2"), MALE);

    add_person_with_gender(fam, strdup("GayDudesDaughter"), FEMALE);
    add_person_relation(fam, "GayDudesDaughter", "temPai", "GayDude1");
    add_person_relation(fam, "GayDudesDaughter", "temPai", "GayDude2");


    print_dot_tree(fam);
}