#include <stdio.h>
#include <string.h>
#include "family.h"

int main(void)
{
    family_tree* fam = init_family_tree();
    add_person(fam, strdup("Antonio"));
    set_person_gender(fam, "Antonio", MALE);

    add_person(fam, strdup("Antonieta"));
    set_person_gender(fam, "Antonieta", FEMALE);


    add_person(fam, strdup("GayDude1"));
    set_person_gender(fam, "GayDude1", MALE);
    add_person_relation(fam, "GayDude1", "temMae", "Antonieta");
    add_person_relation(fam, "GayDude1", "temPai", "Antonio");

    add_person(fam, strdup("GayDude2"));
    set_person_gender(fam, "GayDude2", MALE);

    add_person(fam, strdup("GayDudesDaughter"));
    set_person_gender(fam, "GayDudesDaughter", FEMALE);
    add_person_relation(fam, "GayDudesDaughter", "temPai", "GayDude1");
    add_person_relation(fam, "GayDudesDaughter", "temPai", "GayDude2");


    print_dot_tree(fam);
}