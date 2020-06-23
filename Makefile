CC = gcc
FLEXC = lex
INCLUDE = -I include/
GLIB =`pkg-config --cflags --libs glib-2.0`
FLAGS = -Wall -Wextra -Wshadow -pedantic -Wno-unused-function -Wno-unused-parameter $(GLIB) $(INCLUDE)


SRC_FLEX = reee.l
SRC_YACC = reee.y
SRC = y.tab.c
YACCC = yacc

SOURCE_DIR = source
BUILD_DIR = build
OUT_DIR = bin


OUT = $(OUT_DIR)/reee

SRCEXT = c


SOURCES = $(shell find $(SOURCE_DIR) -type f -name "*.$(SRCEXT)")
OBJECTS = $(patsubst $(SOURCE_DIR)/%,$(BUILD_DIR)/%,$(SOURCES:.$(SRCEXT)=.o))

all:
	$(FLEXC) $(SRC_FLEX)
	$(YACCC) -d $(SRC_YACC)

	$(CC) ${FLAGS} $(SRC) -o $(OUT)

# TODO: make install

run: all
	./$(OUT)

clean:
	rm -rf $(OUT) $(OUT_DIR) $(BUILD_DIR)

graph:
	dot -Tpdf $(GRAPH).gv -o $(GRAPH).pdf
#make graph GRAPH=graph1




modules: dirs $(OUT)

dirs:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(OUT_DIR)

#build/%.o
$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.$(SRCEXT)
	$(CC) $(FLAGS) $(INCLUDE) -c -o $@ $<

$(OUT): $(OBJECTS)
	$(CC) $(FLAGS) $^ -o $@