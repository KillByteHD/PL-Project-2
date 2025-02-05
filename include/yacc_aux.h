#ifndef YACC_AUX_H
#define YACC_AUX_H

#include <stdint.h> // Not necessary

#include "family.h"

#define NAMED_INDIVIDUAL 0x00
#define PERSON 0x01

#define PRED_INIT_IDX 0x00
#define PRED_GENDER_IDX 0x01
#define PRED_RELATION_IDX 0x02
#define MAX_PRED_IDX 0x03


typedef struct __pred_type
{
    uint8_t pred_type;
    char* string;
} pred_type;


typedef struct __triplet_aux
{
    char* subject;
    pred_type predicate;
    char* object;
} triplet_aux;


void handle_predicate_action(family_tree* fam, const char* subject, const pred_type predicate_type, const char* object);

triplet_aux triplet_ctor(const char* subject, const pred_type predicate_type, const char* object);

#endif // YACC_AUX_H