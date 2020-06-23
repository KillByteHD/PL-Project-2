#include "family.h"



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


void add_person(family_tree* fs, char* name)
{
    person_data* person = malloc(sizeof(person_data)); 
    person->gender = NULL;
    person->relations = g_ptr_array_new();
    
    g_ptr_array_set_free_func(person->relations, __free_relation);
    g_hash_table_insert(fs, name, person);
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


void add_person_relation(family_tree* fs, const char* name, relation* rel)
{
    person_data* tmp = (person_data*) g_hash_table_lookup(fs, name);
    g_ptr_array_add(tmp->relations, rel);
}


void free_family_tree(family_tree* fs)
{
    g_hash_table_remove_all(fs);
    free(fs);
}