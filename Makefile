all :
	cd src ; make
	cp src/_build/main.native minic++
	cd tests ; make
	cp tests/tests run-tests

.PHONY : clean
clean : 
	cd src ; make clean
	cd tests ; make clean
	-rm -f minic++
	-rm -f run-tests