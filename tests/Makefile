garbage = $(wildcard *.cmx) $(wildcard *.cmi) $(wildcard *.o) $(wildcard *.cmx)

test : 
	ocamlopt tests.ml -o tests

.PHONY : clean
clean : 
	-rm -f $(garbage)
	-rm -f tests