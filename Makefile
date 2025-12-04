.PHONY: cov

cov:
	fvm flutter test -j=10 --coverage && genhtml coverage/lcov.info --output=coverage/html && open coverage/html/index.html