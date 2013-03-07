REBAR = $(shell pwd)/rebar

.PHONY: deps rel stagedevrel package version all

all: deps compile

compile:
	$(REBAR) compile

console: compile
	erl -pa deps/*/ebin ebin

deps:
	$(REBAR) get-deps

clean:
	$(REBAR) clean
	make -C rel/pkg clean

distclean: clean
	$(REBAR) delete-deps

test: xref
	$(REBAR) skip_deps=true eunit

##
## Developer targets
##

xref: all
	$(REBAR) xref skip_deps=true
