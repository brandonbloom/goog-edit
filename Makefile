ifndef CLOSURE_ROOT
$(error "Must define CLOSURE_ROOT")
endif

goog := $(CLOSURE_ROOT)/closure/goog
js := $(shell find $(goog) -name '*.js')
css := $(shell find $(goog)/css -name '*.css')
calcdeps := $(CLOSURE_ROOT)/closure/bin/calcdeps.py
compiler_url := \
  http://closure-compiler.googlecode.com/files/compiler-latest.zip
compiler := obj/compiler.jar

all: obj out out/goog_editor.js out/goog_editor.css

obj out:
	mkdir -p $@

out/goog_editor.js: obj/requires.js $(compiler)
	$(calcdeps) -p $(CLOSURE_ROOT) -i $< -o compiled -c $(compiler) > $@

out/goog_editor.css: css.deps $(css)
	cat $(shell sed -e "s|\(.*\)|$(goog)/css/\1.css|" $<) > $@

$(compiler): obj/compiler.zip
	cd obj && unzip -o compiler.zip $(@F)
	touch $@

obj/compiler.zip:
	curl $(compiler_url) > $@

obj/requires.js: js.deps $(js)
	sed -e 's/\(.*\)/goog.require("\1");/' $< > $@

clean:
	rm -rf obj out
