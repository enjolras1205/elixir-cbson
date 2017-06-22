ERLANG_PATH:=$(shell erl -eval 'io:format("~s~n", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS=-g -fPIC -O2 -std=c99
ERLANG_FLAGS=-I$(ERLANG_PATH)
CC?=gcc
EBIN_DIR=ebin
TARGET=priv/bson_nif.so

ifeq ($(shell uname),Darwin)
	OPTIONS=-dynamiclib -undefined dynamic_lookup
endif

NIF_SRC=\
	src/bson_nif.c \
	src/bson_decoder.c \
	src/bson_encoder.c \
	src/bson_utils.c \

all: nif

mix:
	mix compile

nif:$(TARGET)

$(TARGET): $(NIF_SRC)
	$(CC) $(CFLAGS) $(ERLANG_FLAGS) -shared $(OPTIONS) $(NIF_SRC) -o $@

cbson-clean:
	rm -rf priv/*.so

clean: cbson-clean

.PHONY: all cbson-clean
