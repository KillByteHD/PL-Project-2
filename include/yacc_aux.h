#ifndef YACC_AUX_H
#define YACC_AUX_H

#include <stdint.h>

#define NAMED_INDIVIDUAL 0x00
#define PERSON 0x01

#define PRED_INIT_IDX 0U
#define PRED_GENDER_IDX 1U
#define PRED_RELATION_IDX 2U
#define MAX_PRED_IDX 3U

typedef struct kek{
    uint8_t pred_type;
    char* string;
} pred_type;

void handle_predicate_action(family_tree* fam, const char* subject, const pred_type predicate_type, const char* object);

#endif // YACC_AUX_H