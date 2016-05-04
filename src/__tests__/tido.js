import path from 'path';
import {
  flow, property, forEach, invokeMap, join, find, map, flatten, curry, toArray,
} from 'lodash/fp';

import { wrapFragment, parseXML } from 'mei-validation-js/lib/util';
import { read } from 'mei-validation-js/lib/util/fileReader';

const oddPath = path.resolve(__dirname, '../tido.xml');
const wrapperAttributeName = 'tido:wrapper';

const getElementsByTagName = curry(
  (tagName, domElement) =>
    toArray(domElement.getElementsByTagName(tagName)));

const getAttribute = curry((attributeName, domElement) =>
  domElement.getAttribute(attributeName)
);

const getSchemaPaths = (schemaSpecName) => ({
  rng: path.resolve(__dirname, `../../../../build/dist/schema/${schemaSpecName}.rng`),
  schematron: path.resolve(__dirname, `../../../../build/dist/schema/${schemaSpecName}.xsl`),
});


describe(`ODD at ${oddPath}`, () => {
  it('should only contain egXML tests validating against the created ' +
     ' schemata in the specified manner', (done) => {
    read(oddPath)
      .then(parseXML)
      .then(oddDocument => {
        const schemaSpecNames = flow(
          getElementsByTagName('schemaSpec'),
          map(getAttribute('ident'))
        )(oddDocument);
        forEach(
          schemaSpecName =>
            flow(
              getTestElements(schemaSpecName),
              forEach(validateElement(schemaSpecName))
            )(oddDocument),
          schemaSpecNames
        );
      })
      .then(() => done(), done);
  });
});

const getTestElements = (schemaSpecName) => (xml) => {
  const schemaSpecs = getElementsByTagName('schemaSpec')(xml);
  const specGrps = getElementsByTagName('specGrp')(xml);
  const body = getElementsByTagName('body')(xml)[0];

  const schemaSpec = find(
    (element) => getAttribute('ident')(element) === schemaSpecName,
    schemaSpecs
  );

  const relevantSpecGrps = flow(
    getElementsByTagName('specGrpRef'),
    map(
      flow(
        getAttribute('target'),
        ref => ref.substr(1),
        id => find(specGrp => getAttribute('xml:id')(specGrp) === id, specGrps)
      )
    )
  )(schemaSpec);

  const testElements = flow(
    map(getElementsByTagName('egXML')),
    map(nodeList => Array.from(nodeList)),
    flatten,
  )([body, schemaSpec, ...relevantSpecGrps]);

  return testElements;
};

const validateElement = (schemaSpecName) => (element) => {
  const schemaPaths = getSchemaPaths(schemaSpecName);
  const fragment = getInnerXMLString(element);
  const validAttribute = getAttribute('valid')(element);
  const wrapperName = getAttribute(wrapperAttributeName)(element);

  describe(fragment, () => {
    switch (validAttribute) {
      case 'true':
        it(`should be valid against schema spec "${schemaSpecName}"`, () => {
          wrapFragment(wrapperName, fragment, undefined, true, 'always', schemaPaths);
        });
        break;
      case 'false':
        it(`should be invalid against schema spec "${schemaSpecName}"`, () => {
          wrapFragment(wrapperName, fragment, undefined, false, 'always', schemaPaths);
        });
        break;
      default:
    }
  });
};

const getInnerXMLString = flow(
  property('childNodes'),
  invokeMap('toString'),
  join('')
);
