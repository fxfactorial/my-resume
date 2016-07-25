#!/bin/bash

set -e

install_node_dependencies () {
    if ! [ -d "node_modules" ]; then
	    npm install react react-dom
    fi
}

compile () {
    js_of_ocaml \
	--pretty \
	--custom-header='#!/usr/bin/env node' \
	resume.byte \
	-o resume
    chmod +x resume
}

create_html () {
    ./resume resume.json >| index.html
}

create_pdf () {
    wkhtmltopdf index.html edgar_resume.pdf
}

install_node_dependencies
compile
create_html
create_pdf
open edgar_resume.pdf
