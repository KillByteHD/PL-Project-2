##################################################################
#                            VARIABLES                           #
##################################################################

CC = gcc
FLEXC = lex
INCLUDE = -I $(INCLUDE_DIR)/
GLIB =`pkg-config --cflags --libs glib-2.0`
FLAGS = -Wall -Wextra -Wshadow -pedantic  $(GLIB) $(INCLUDE) #-Wno-unused-function -Wno-unused-parameter


SRC_FLEX = tp2.l
SRC_YACC = tp2.y
SRC = y.tab.c
YACCC = yacc

INCLUDE_DIR = include
SOURCE_DIR = source
BUILD_DIR = build
OUT_DIR = bin

OUT = $(OUT_DIR)/tp2

SRCEXT = c

SOURCES = $(shell find $(SOURCE_DIR) -type f -name "*.$(SRCEXT)")
OBJECTS = $(patsubst $(SOURCE_DIR)/%,$(BUILD_DIR)/%,$(SOURCES:.$(SRCEXT)=.o))

##################################################################
#                              RULES                             #
##################################################################

# Main compiling rule
# Builds the executable
# USAGE: make
all: dirs flex_n_yacc $(OBJECTS) $(OUT)


#
dirs:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(OUT_DIR)


# Rule to compile flex and yacc files 
# and move the '.c' and '.h' files to 'source/' and 'include/' respectivly
#
flex_n_yacc: #$(OBJECTS)
	$(FLEXC) $(SRC_FLEX)
	$(YACCC) -d $(SRC_YACC)
	@mv lex.yy.c $(SOURCE_DIR)/
	@mv y.tab.c  $(SOURCE_DIR)/
	@mv y.tab.h $(INCLUDE_DIR)/


# Rule to clean build files and executables
# USAGE: make clean
clean:
	rm -rf $(OUT) $(OUT_DIR) $(BUILD_DIR)

# Rule to specify a '.gv' file and build the corresponding pdf with the graph
# USAGE: make graph GRAPH=graphs/graph
graph:
	dot -Tpdf $(GRAPH).gv -o $(GRAPH).pdf


# Rule to instantly test a family tree example from the 'tests/' folder ended in the extension '.txt'
# Builds the '.gv' in the graphs folder and makes the '.pdf' file with the graph in the same folder
# USAGE: make graph GRAPH=family
inst: all
	./$(OUT) < tests/$(TEST).txt > graphs/$(TEST).gv && make graph GRAPH=graphs/$(TEST) && code graphs/$(TEST).pdf


# Auxiliar object file build rule
$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.$(SRCEXT)
	$(CC) $(FLAGS) -c $< -o $@ 

$(OUT): $(OBJECTS)
	$(CC) $(FLAGS) $^ -o $@

# TODO: make install