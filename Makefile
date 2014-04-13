build:
	lessc src/flexbox.less  dist/flexbox.css
	lessc -x src/flexbox.less  dist/flexbox.min.css

demo:
	coffee -c -o dist/ angular/*.coffee 

.PHONY: build