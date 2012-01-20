ifndef CLOSURE_ROOT
$(error "Must define CLOSURE_ROOT")
endif

goog := $(CLOSURE_ROOT)/closure/goog
editor_js := $(shell find $(goog)/editor -name '*.js')
editor_css := $(shell find $(goog)/css -path '*editor*' -name '*.css')
calcdeps := $(CLOSURE_ROOT)/closure/bin/calcdeps.py
compiler_url := \
  http://closure-compiler.googlecode.com/files/compiler-latest.zip
compiler := obj/compiler.jar

all: obj out out/goog_editor.js out/goog_editor.css

obj out:
	mkdir -p $@

out/goog_editor.js: obj/requires.js $(compiler)
	$(calcdeps) -p $(CLOSURE_ROOT) -i $< -o compiled -c $(compiler) > $@

out/goog_editor.css: $(editor_css)
	cat $+ > $@

$(compiler): obj/compiler.zip
	cd obj && unzip -o compiler.zip $(@F)
	touch $@

obj/compiler.zip:
	curl $(compiler_url) > $@

obj/requires.js: lib/require.sed $(editor_js)
	sed -f $+ > $@

clean:
	rm -rf obj out
