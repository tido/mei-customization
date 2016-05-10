# Tido MEI Customization
ODD specification and documentation of the Tido MEI Customization.

# Setup

```
git clone https://github.com/tido/mei-customization.git
```

If you run [node](http://nodejs.org) and would like to build the schema and/or
the documentation or run the tests:

```bash
cd mei-customization
npm install
```

# Usage - Schemata and Guidelines

Use the schema files in `build/schema/` to validate MEI documents.
Refer to the html guidelines in `build/guidelines` folder for documentation of the
customization format.

# The source

The Tido ODD customization file is located at `src/tido.xml`.
In addition to the schema specifications, this file contains examples of
valid and invalid fragments.

# Build

## Java dependencies
In order to build the schema and guidelines you will need
- a Java Development Kit (JDK)
- `ANT`

## MEI and TEI dependencies
The Tido MEI Customization project contains copies of `https://github.com/music-encoding/music-encoding` and `https://github.com/TEIC/Stylesheets` in the `vendor` folder. In case these dependencies need to be updated, run `./update-git-dependencies.sh` and commit the updated project.

## Build commands

In order to build the schema:
```
ant -lib vendor/stylesheets/lib schema
```
The output schema will be placed in `build/schema`

To build the HTML guidelines:
```
ant -lib vendor/stylesheets/lib html-guidelines
```
The output of this will be placed in `build/guidelines`

## Test environment for Node

In addition to providing documentation, the provided examples also serve validation
test for the schema. A [node](https://nodejs.org) test environment is included in order to make sure
that provided examples (or counter-examples) are indeed validated (or invalidated)
by the compiled schema.

### Run the tests

```
npm test
```

### Build and test

In Node you can also run the build scripts through npm scripts:
```
npm run schema
npm run html-guidelines
```

And if you want to do all the above at once, that is build the schema, build the documentation and run the tests:
```
npm run refresh
```

# Modifying the Customization

When modifying the schema it is expected that for each feature there are valid
and invalid examples provided. Each of these examples then serve as a test case
for the test environment to check whether the examples actually conform to the
compiled schemata.

Typically, test cases are appended to `<elementSpec>`, `<classSpec>` etc.
elements they refer to (as a child of `<exemplum>`), but `<egXML>` may appear
anywhere in the ODD, for example in the initial prose descriptions of the
features. If the content of `<egXML>` is supposed to be valid against the Tido
schema, it will have an attribute `@valid="true"`, if it is supposed to be
invalid, it will have `@valid="false"`. Incomplete examples, which are in fact
invalid but could be made valid by providing additional attributes are marked
with `@valid="feasible"`. In that case, its content will be skipped when running
the validation tests.

The test environment uses the `jade` template library to construct complete MEI
documents from the MEI fragments in `<egXML>`. The `test/jade` folder contains
wrappers and mixins that help to contextualise the provided examples. In order to
assign a wrapper to a fragment, the `<egXML>` elements link to `<rendition>`
declarations in the `<teiHeader>` which point to the Jade template files in concern.

Here's a full example of a class specification with a single test case:

```
<classSpec ident="att.startendid" module="MEI.shared" type="atts" mode="change">
  <attList>
    <attDef ident="endid" usage="opt" mode="change">
      <datatype>
        <rng:ref name="data.URI.local"/>
      </datatype>
    </attDef>
  </attList>
  <exemplum>
    <p>A valid <gi>pedal</gi> element with local URI references in
      <att>startid</att> and <att>endid</att></p>
    <egXML xmlns="http://www.tei-c.org/ns/Examples" valid="true" rendition="#afterStaff">
      <pedal dir="down" staff="1" layer="1" startid="#n01" endid="#n02"/>
    </egXML>
  </exemplum>
</classSpec>
```
