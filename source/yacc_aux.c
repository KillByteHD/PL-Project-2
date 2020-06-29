#include "yacc_aux.h"

#include <stdio.h>

typedef void (*PredicateHandler)(family_tree* , const char*, const char*, const char*);


void handle_init(family_tree* fam, const char* subj, const char* __unnamed__ , const char* obj)
{
    (void) __unnamed__;
    (void) obj;
    if (get_person_data(fam, subj) == NULL)
    {
        add_person(fam, subj);
    }

}

void handle_gender(family_tree* fam, const char* subj, const char* __unnamed__ , const char* obj)
{
    (void) __unnamed__;
    if (get_person_data(fam, subj) != NULL)
    {
        if(strcmp(obj,":Male") == 0)
        {
            set_person_gender(fam, subj, MALE);
            return;
        }
        else if(strcmp(obj,":Female") == 0)
        {
            set_person_gender(fam, subj, FEMALE);
            return;
        }
    }

}

void handle_relation(family_tree* fam, const char* subj, const char* rel_name , const char* obj)
{
    if (get_person_data(fam, subj) != NULL)
    {
        add_person_relation(fam, subj, rel_name, obj);
    }
    else
    {
        /* Unmatched name error handling */
    }
}


void handle_predicate_action(family_tree* fam, const char* subject, const pred_type predicate_type, const char* object)
{
    static const PredicateHandler handlers[3] = {
        handle_init, handle_gender, handle_relation 
    };

    if(predicate_type.pred_type > MAX_PRED_IDX)
    {
        /* Invalid predicate type handling */
    }
    else
    {
        //printf("%d\n", predicate_type.pred_type);
        handlers[predicate_type.pred_type](fam, subject, predicate_type.string, object);
    }
}


triplet_aux triplet_ctor(const char* a_subject, const pred_type a_predicate_type, const char* a_object)
{
    return (const triplet_aux) {
        .subject = strdup(a_subject),
        .predicate = a_predicate_type,
        .object = strdup(a_object)
    };
}