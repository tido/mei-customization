#MEI Customizations for Tido

## ODD

Adjustments to the MEI schema and documentation are expressed in TEI ODD. The main customization is `customizations/tido.xml`.

Every change to the ODD should be compiled to schema and docs and tested before pushing to the repository.

## Generating schemata and guidelines

The ODD can be transformed into RelaxNG schema and HTML documentation with tools provided by the TEI.

### Using TEI's command line script

To generate the RelaxNG schema:

* Get MEI's [latest source](https://code.google.com/p/music-encoding/source/browse/trunk/source/specs/mei-source.xml)

* Clone [TEI's XSLT](https://github.com/TEIC/Stylesheets)

* Run TEI's script to convert ODD to RelaxNG. Make sure to set the pick the desired schema with `--schema`. The main schema is `tido`.

```bash
$ ./teitorelaxng --localsource=PATH_TO/mei-source.xml --schema=tido \
/PATH_TO/tidodd/customizations/tido.xml \
/PATH_TO/tidodd/schemata/tido.rng
```

To generate the HTML guidelines:

* Clone [TEI's XSLT](https://github.com/TEIC/Stylesheets)

* Run either `teitopdf` or `teitohtml`. Make sure to set the pick the desired schema with `--schema`. The main schema is `tido`.

```bash
$ ./teitopdf --localsource=PATH-TO/mei-source.xml --schema=tido \
PATH-TO/schema/odd/customizations/tido.xml PATH-TO-OUTPUT.pdf
```

### Using the ANT / npm scripts

To generate the RNG and XSLT files for validation, run `npm run schema` or `ant -lib vendor/stylesheets/lib/saxon9he.jar schemata` from the project root.

To generate HTML guidelines, run `npm run html-guidelines` or `ant -lib vendor/stylesheets/lib/saxon9he.jar html-guidelines` from the project root.

To generate PDF guidelines, run `npm run pdf-guidelines` or `ant -lib vendor/stylesheets/lib/saxon9he.jar pdf-guidelines` from the project root.

Requirements: ANT and a JDK. In addition, the PDF guidelines depend on xelatech (install in Ubuntu by running `sudo apt-get install texlive-latex-extra`)

## Tests

Each customization and constrain in `customizations/tido.xml` should be tested with one or more XML files to be validated with `schemata/tido.rng`. The test files don't have to validate, as some tests are supposed to fail. Eventually this should be adjusted to make automatic testing possible.
