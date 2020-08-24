default: test

.PHONY: impl
impl:
	make -C impl gui

.PHONY: test
test:
	make -C tests/rtl run

clean:
	make -C impl clean
	make -C tests/rtl clean