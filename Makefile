CFLAGS = -g -O3 -Wall -std=c99
ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS += -I$(ERLANG_PATH)
CFLAGS += -Ic_src
CFLAGS += -g -DDEBUG -D_GNU_SOURCE
ifeq ($(shell uname -s), Darwin)
LDFLAGS += -flat_namespace -undefined suppress
endif
LIB_SO_NAME = priv/jaypeg.so
CFLAGS += -fPIC
NIF=c_src/jaypeg.c

$(LIB_SO_NAME): $(NIF)
	mkdir -p priv
	$(CC) $(CFLAGS) -shared $(LDFLAGS) $^ -ljpeg -o $@
