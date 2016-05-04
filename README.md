# Tido MEI Customization
ODD specification and documentation of the Tido MEI Customization.

# Setup

```bash
git clone https://github.com/tido/mei-customization.git
cd mei-customization
npm install
```

# Update git dependencies

The Tido MEI Customization project contains copies of `https://github.com/music-encoding/music-encoding` and `https://github.com/TEIC/Stylesheets` in the `vendor` folder. In case these dependencies need to be updated, run `./update-git-dependencies.sh` and commit the updated project.


# Overview

This section provides an overview of the project

## The source

Tido ODD customization file is located at `src/tido.xml`.
In addition to the schema specifications, this file contains examples of
valid and invalid fragments.


## Usage - Schemata and Guidelines

The `build` folder contains output schema and documentation.

### Build

In order to build the schemata, build the HTML guidelines and run the tests with a single command run:

```
npm run refresh
```

## Test environment

In addition to providing documentation, the provided examples also serve validation
test for the schema. A `nodejs` test environment is included in order to make sure
the provided examples (or counter-examples) are indeed validated (or invalidated)
by the compiled schema.


# Modifying the Customization

When modifying the schema it is expected that for each feature there are valid and invalid
examples provided. Each of these examples then serve as a test case for the test environment
to check whether the examples actually conform to the compiled schemata.

In order to instruct the test environment, each example within the documentation
is wrapped in a `<egXML>` and the expected validation outcome is given in the '@valid'
attribute. E.g. an `<egXML valid="true"/>` element specifies a test case where the expected result is `valid`.

Typically, test cases are appended to `<elementSpec>`,
`<classSpec>` etc. elements they refer to (as a child of
`<exemplum>`), but `<egXML>` may appear anywhere in the ODD, for example in the
initial prose descriptions of the features. If the content of `<egXML>` is
supposed to be valid against the Tido schema, it will have an attribute
`@valid="true"`, if it is supposed to be invalid, it will have `@valid="false"`.
Incomplete examples, which are in fact invalid but could be made valid by
providing additional attributes are marked with `@valid="feasible"`.
In that case, its content will be skipped when running the validation tests.

The test environment uses the `jade` template library to construct complete MEI fragments.
`test/jade` folder contains wrappers and mixins that help to contextualise the provided
examples. In order to do this, the `<egXML>` element refer to a wrappers, this instructs the
test environment to insert the provided example into the appropriate context, thus
providing a valid MEI document.

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
      <att>startid</att> and <att>endid</att>
    </p>
    <egXML
      xmlns="http://www.tei-c.org/ns/Examples"
      xml:space="preserve"
      valid="true"
      tido:wrapper="afterStaff">
      <pedal dir="down" staff="1" layer="1" startid="#n01" endid="#n02"/>
    </egXML>
  </exemplum>
</classSpec>
```


In order to check if all test cases provided in the ODD yield the expected
validation result, first make sure that the schemata are up to date:

```
npm run schema
```

and run the schema tests:

```
npm test
```
