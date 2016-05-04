# notation-odd
ODD specification and documentation for Tido music notation

# Setup

```bash
git clone https://github.com/tido/notation-core.git
cd notation-core
npm install
```

# Update git dependencies

The Tido MEI Customization project contains copies of `https://github.com/music-encoding/music-encoding` and `https://github.com/TEIC/Stylesheets` in the `vendor` folder. In case these dependencies need to get updated, run `./update-git-dependencies.sh` and commit the updated project.

# Modifying the Tido MEI Customization ODD

Tido's customization ODD of the MEI guidelines is located at
`src/tido.xml`. In addition to the specifications, this file should
contain valid and invalid test cases for the specified features. Each test case
must be wrapped in an `<egXML>` element. Typically, the test cases should get
append to the `<elementSpec>`, `<classSpec>` etc. they refer to (as a child of
`<exemplum>`), but `<egXML>` may appear anywhere in the ODD, for example in the
initial prose descriptions of the features. If the content of `<egXML>` is
supposed to be valid against the Tido schema, add the attribute
`@valid="true"`, if it is supposed to be invalid, add `@valid="false"`.
Incomplete examples which are in fact invalid but could be made valid by
providing additional attributes should be marked with `@valid="feasible"`.
In that case, its content will be skipped when running the validation tests.

In addition to `@valid`, each `<egXML>` element to get validated must contain a
reference to one of the wrappers located at `resources/templates/wrappers`.
Specify the wrapper by providing its filename in `@tido:wrapper`.

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

In order to build the schemata, build the HTML guidelines and run the tests with a single command run:

```
npm run refresh
```
