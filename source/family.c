#include "family.h"
#include <stdio.h>
#include <string.h>


static void __free_relation(void* ptr)
{
    free((void*) ((relation*) ptr)->name);
    free((void*) ((relation*) ptr)->target);
}

static void __free_relations(void* ptr)
{
    g_ptr_array_free(ptr, TRUE);
}


family_tree* init_family_tree(void)
{
    return g_hash_table_new_full(g_str_hash, g_str_equal, free, __free_relations);
}


void add_person(family_tree* fs, const char* name)
{
    person_data* person = malloc(sizeof(person_data)); 
    person->gender = NULL;
    person->relations = g_ptr_array_new();
    
    g_ptr_array_set_free_func(person->relations, __free_relation);
    g_hash_table_insert(fs, strdup(name), person);
}


void add_person_with_gender(family_tree* fs, const char* name, const uint8_t gender)
{
    person_data* person = malloc(sizeof(person_data)); 
    person->gender = malloc(sizeof(uint8_t));
    *(person->gender) = gender;
    person->relations = g_ptr_array_new();
    
    g_ptr_array_set_free_func(person->relations, __free_relation);
    g_hash_table_insert(fs, strdup(name), person);
}


person_data* get_person_data(family_tree* fs, const char* name)
{
    return (person_data*) g_hash_table_lookup(fs, name);
}


uint8_t* get_person_gender(family_tree* fs, const char* name)
{
    return get_person_data(fs,name)->gender;
}


GPtrArray* get_person_relations(family_tree* fs, const char* name)
{
    return get_person_data(fs,name)->relations;
}


void set_person_gender(family_tree* fs, const char* name, const uint8_t gender)
{
    person_data* tmp = (person_data*) g_hash_table_lookup(fs, name);
    if(tmp->gender == NULL)
        tmp->gender = malloc(sizeof(uint8_t));
    *(tmp->gender) = gender;
}


void add_person_relation(family_tree* fs, const char* name, const char* relation_name, const char* target)
{
    person_data* tmp = (person_data*) g_hash_table_lookup(fs, name);

    relation* new_relation = malloc(sizeof(relation));
    new_relation->name = strdup(relation_name);
    new_relation->target = strdup(target);
    g_ptr_array_add(tmp->relations, new_relation);
}


void free_family_tree(family_tree* fs)
{
    g_hash_table_remove_all(fs);
    free(fs);
}



static void __relations_print_element(void* data, void* person_name)
{
    //puts("relations print");
    const relation* tmp = (relation*) data;
    const char* name = (char*) person_name;

    printf("    %s -> %s [label=\"%s\"];\n", name, tmp->target, tmp->name);
}


static void __family_print_entry(void* key, void* value, void* user_data)
{
    (void) user_data;
    const char* name = (char*) key;
    const person_data* tmp = (person_data*) value;

    if(tmp->gender != NULL)
    {
        static const char* GENDER_TO_STR[2] = { "pink", "lightblue" };
        printf("    %s [color=%s];\n", name, GENDER_TO_STR[*(tmp->gender)]);
    }

    g_ptr_array_foreach(tmp->relations, __relations_print_element, (void*) name);

}

#include <unistd.h>

void print_dot_tree(family_tree* fs)
{
    puts("digraph Family\n{");
    puts("    node [shape=box,style=filled];") ;

    g_hash_table_foreach(fs, __family_print_entry, NULL);
    puts("}");
}


////////////// Induced relations //////////////





struct __name_and_mother
{
    char* name;
    char* mother;
    family_tree* fam; // Glib foreach doesnt know itself
    char* it_name; // When searching siblings name is stored here
};

static void __make_sibling_if_same_mother(void* data, void* user_data)
{
    struct __name_and_mother* nnm = (struct __name_and_mother*) user_data;
    const relation* tmp = (relation*) data;
    if(nnm->mother && strcmp(nnm->mother, tmp->target) == 0)
    {
        /* add this one as sibbling  */
        add_person_relation(nnm->fam, nnm->name, "temIrmao", nnm->it_name);
    }
}


static void __make_sibling_with_same_mother(void* key, void* value, void* user_data)
{
    struct __name_and_mother* nnm = (struct __name_and_mother*) user_data;
    char* name = (char*) key;
    const person_data* tmp = (person_data*) value;

    if( strcmp(nnm->name, name) != 0 )
    {
        nnm->it_name = name;
        g_ptr_array_foreach(tmp->relations, __make_sibling_if_same_mother, nnm);
    }
}


static void __find_momma(void* data, void* user_data)
{
    relation* tmp = (relation*) data;
    struct __name_and_mother* nnm = (struct __name_and_mother*) user_data;
    if( strcmp(tmp->name, "temMae") == 0)
    {
        nnm->mother = tmp->target;
    }
}


static void __foreach_entry_induce_siblings(void* key, void* value, void* user_data)
{
    struct __name_and_mother* nnm = (struct __name_and_mother*) user_data;
    char* name = (char*) key;
    const person_data* tmp = (person_data*) value;
    nnm->name = name;
    nnm->mother = NULL;
    g_ptr_array_foreach(tmp->relations, __find_momma, nnm);

    g_hash_table_foreach(nnm->fam, __make_sibling_with_same_mother, nnm);
}

void create_induced_relations(family_tree* fs)
{
    struct __name_and_mother nnm = (struct __name_and_mother) { .name=NULL, .mother=NULL, .fam=fs };

    g_hash_table_foreach(fs, __foreach_entry_induce_siblings, &nnm);

}

///////////////////////////////////////////////