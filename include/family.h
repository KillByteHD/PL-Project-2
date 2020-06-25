#ifndef FAMILY_H
#define FAMILY_H

#include <stdint.h>
#include <glib.h>

#define MALE 0x01
#define FEMALE 0x00


typedef struct __relation
{
    const char* name;     // Name of the relation
    const char* target;   // Target of this relation
} relation;


typedef struct __person_data
{
    uint8_t* gender;      // Other data about this person
    GPtrArray* relations; // Dynamic array of relations
} person_data;


typedef GHashTable family_tree; // Key: char* , Value: person_data*


family_tree* init_family_tree(void);

void add_person(family_tree*, const char* name);

void add_person_with_gender(family_tree*, const char* name, const uint8_t gender);


person_data* get_person_data(family_tree*, const char* name);

uint8_t* get_person_gender(family_tree*, const char* name);

GPtrArray* get_person_relations(family_tree*, const char* name);


void set_person_gender(family_tree*, const char* name, const uint8_t gender);

void add_person_relation(family_tree*, const char* name, const char* relation_name, const char* target);

void free_family_tree(family_tree*);

void print_dot_tree(family_tree*);

//void print_dot_tree(family_tree*);

#endif // FAMILY_H