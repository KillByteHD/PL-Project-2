CC = gcc
FLEXC = lex
GLIB =`pkg-config --cflags --libs glib-2.0`
FLAGS = -Wall -Wextra -Wshadow -pedantic -Wno-unused-function -Wno-unused-parameter
OUT = reee
SRC_FLEX = reee.l
SRC_YACC = reee.y
SRC = y.tab.c
YACCC = yacc

all:
	$(FLEXC) $(SRC_FLEX)
	$(YACCC) -d $(SRC_YACC)

	$(CC) ${FLAGS} $(SRC) -o $(OUT)

# TODO: make install

run: all
	./$(OUT)

clean:
	rm -rf ${OUT}

graph:
	dot -Tpdf $(GRAPH).gv -o $(GRAPH).pdf
#make graph GRAPH=graph1