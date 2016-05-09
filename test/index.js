
import fs from 'fs';
import path from 'path';
import {
  flow, property, forEach, invokeMap, join, find, map, flatten, toArray,
  keyBy, mapValues,
} from 'lodash/fp';

import { wrapFragment, parseXML } from './util';

const oddPath = path.resolve(__dirname, '../src/tido.xml');
const renditionAttributeName = 'rendition';

const getElementsByTagName = (tagName) =>
  (domElement) => toArray(domElement.getElementsByTagName(tagName));

const getAttribute = (attributeName) =>
  (domElement) => domElement.getAttribute(attributeName);

const getSchemaPaths = (schemaSpecName) => ({
  rng: path.resolve(__dirname, `../build/schema/${schemaSpecName}.rng`),
  schematron: path.resolve(__dirname, `../build/schema/${schemaSpecName}.xsl`),
});

describe(`ODD at ${oddPath}`, () => {
  it('should only contain egXML tests validating against the created ' +
     ' schemata in the specified manner', (done) => {
    Promise.resolve()
      .then(() => fs.readFileSync(oddPath, 'utf-8'))
      .then(parseXML)
      .then(oddDocument => {
        const renditionToWrapperPath = flow(
          getElementsByTagName('rendition'),
          keyBy(element => element.getAttribute('xml:id')),
          mapValues(element =>
            getElementsByTagName('ptr')(element)[0].getAttribute('target')
          )
        )(oddDocument);

        const schemaSpecNames = flow(
          getElementsByTagName('schemaSpec'),
          map(getAttribute('ident'))
        )(oddDocument);
        forEach(
          schemaSpecName =>
            flow(
              getTestElements(schemaSpecName),
              forEach(validateElement(renditionToWrapperPath, schemaSpecName))
            )(oddDocument),
          schemaSpecNames
        );
      })
      .then(() => done())
      .catch(done);
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
    flatten,
  )([body, schemaSpec, ...relevantSpecGrps]);

  return testElements;
};

const validateElement = (renditionToWrapperPath, schemaSpecName) => (element) => {
  const schemaPaths = getSchemaPaths(schemaSpecName);
  const fragment = getInnerXMLString(element);
  const validAttribute = getAttribute('valid')(element);
  const rendition = getAttribute(renditionAttributeName)(element).substr(1);
  const wrapperPath = renditionToWrapperPath[rendition];

  describe(fragment, () => {
    switch (validAttribute) {
      case 'true':
        it(`should be valid against schema spec "${schemaSpecName}"`, () => {
          assertWrapper(wrapperPath, rendition);
          wrapFragment(wrapperPath, fragment, undefined, true, 'always', schemaPaths);
        });
        break;
      case 'false':
        it(`should be invalid against schema spec "${schemaSpecName}"`, () => {
          assertWrapper(wrapperPath, rendition);
          wrapFragment(wrapperPath, fragment, undefined, false, 'always', schemaPaths);
        });
        break;
      default:
    }
  });
};

const assertWrapper = (wrapperPath, rendition) => {
  if (!wrapperPath) {
    throw new Error(`could not find wrapper for rendition "#${rendition}"`);
  }
};

const getInnerXMLString = flow(
  property('childNodes'),
  invokeMap('toString'),
  join('')
);
