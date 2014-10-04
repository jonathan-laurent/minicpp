# MINICPP
# Leonard Blier - Jonathan Laurent

garbage = *.cmx *.cmi 
conflicts_info = *.automaton *.conflicts

all : 
	ocamlbuild main.native


.PHONY : conflicts
conflicts :

	-rm -f $(conflicts_info)
	menhir -v parser.mly
	-rm -f $(garbage) parser.mli parser.ml
	-emacs parser.conflicts


.PHONY : clean
clean :

	-rm -rf _build
	-rm -rf main.native $(garbage) $(conflicts_info)