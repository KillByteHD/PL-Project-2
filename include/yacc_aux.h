#ifndef YACC_AUX_H
#define YACC_AUX_H

#include <stdint.h>

#define NAMED_INDIVIDUAL 0x00
#define PERSON 0x01

#define PRED_INIT_IDX 0
#define PRED_GENDER_IDX 1
#define PRED_RELATION_IDX 2


void handle_predicate_action(const char* subject, const uint8_t predicate_type, const char* object);

#endif // YACC_AUX_H