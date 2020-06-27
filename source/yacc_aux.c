#include "yacc_aux.h"


typedef void (*PredicateHandler)(family_tree* , const char*, const char*, const char*);


void handle_init(family_tree* fam, const char* subj, const char* __unnamed__ , const char* obj)
{
    (void) __unnamed__;
    add_person(fam, obj);
}

void handle_gender(family_tree* fam, const char* subj, const char* __unnamed__ , const char* obj)
{
    (void) __unnamed__;
    if(strcmp(obj,":Male") == 0)
    {
        set_person_gender(fam, subj, MALE);
    }
    else if(strcmp(obj,":Female") == 0)
    {
        set_person_gender(fam, subj, FEMALE);
    }
    else
    {
        /* Gender error handling */
    }
}

void handle_relation(family_tree* fam, const char* subj, const char* rel_name , const char* obj)
{
    add_person_relation(fam, subj, rel_name, obj);
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
        handlers[predicate_type.pred_type](fam, subject, predicate_type.string, object);
    }
}


triplet_aux triplet_ctor(const char* a_subject, const pred_type a_predicate_type, const char* a_object)
{
    return (triplet_aux) {
        .subject = a_subject,
        .predicate = a_predicate_type,
        .object = a_object
    };
}