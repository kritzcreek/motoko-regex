.PHONY: check docs test

check:
	find src -type f -name '*.mo' -print0 | xargs -0 $(shell vessel bin)/moc -Werror --check
docs:
	$(shell vessel bin)/mo-doc
test:
	make -C test
