TESTS = $(shell ./common/list_tests.py)

default: all

all: clean rtl sw run

sw:
	@for test in $(TESTS) ; do \
		make -C tests/$$test main; \
	done

run:
	@for test in $(TESTS) ; do \
		make -C tests/$$test run; \
	done

	@echo "\n\nRESULTS:"

	@for test in $(TESTS) ; do \
		echo  -n "tests/$$test: \t"; \
		cat tests/$$test/result.txt ; \
	done

rtl:
	make -f vrltr.mk

clean:
	@for test in $(TESTS) ; do \
		make -C tests/$$test clean ; \
	done
	make -f vrltr.mk clean
