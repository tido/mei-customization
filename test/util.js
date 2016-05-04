/* @flow */

import { validateSync } from 'mei-validation-js';

import jade from 'jade';
import { _, assign } from 'lodash';
import { DOMParser } from 'xmldom';

const wrappersPath = 'test/jade/wrappers';
const globals = { _, pretty: true };

export function parseXML(str) {
  return new DOMParser().parseFromString(str, 'text/xml');
}

export function wrapFragment(
  wrapperName,
  data,
  options,
  valid = true,
  validate,
  schemaPaths
) {
  if (typeof wrapperName !== 'string') {
    throw new Error('Cannot wrap without a wrapper name.');
  }

  const filePath = `${wrappersPath}/${wrapperName}.jade`;
  const jadeOptions = assign({}, globals, { data }, options);

  const mei = jade.renderFile(filePath, jadeOptions);

  // console.log(mei); // eshint-ignore-line

  // TODO refactor
  if (validate !== 'never' || validate === 'always') {
    const report = validateSync(mei, schemaPaths, true);
    if (valid) {
      assertValid(report);
    } else {
      assertInvalid(report);
    }
  }

  return mei;
}

function assertValid(report) {
  const errors = report.getErrors();
  const messages = errors.map(error => error.toString()).join('\n');

  if (errors.length) {
    throw new Error(`expected MEI to be valid\n${messages}`);
  }
}

function assertInvalid(report) {
  if (report.isValid) {
    throw new Error('expected MEI to be invalid');
  }
}
