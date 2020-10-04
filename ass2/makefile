BIN = parser
CC = g++

SRCS = $(BIN).Y $(BIN).l
HDRS = scanType.h util.h globals.h
OBJS = lex.yy.o $(BIN).tab.o util.o ourgetopt.o

$(BIN) : $(OBJS)
	$(CC) $(OBJS) -o c-

lex.yy.c : $(BIN).l $(BIN).tab.h $(HDR)
	flex $(BIN).l

#$(BIN).tab.o : 
$(BIN).tab.h $(BIN).tab.c : $(BIN).y util.c
	bison -v -t -d $(BIN).y

clean :
	rm -f *~ $(OBJS) $(BIN) lex.yy.c $(BIN).tab.h $(BIN).tab.c $(BIN).output c-
