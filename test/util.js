
import { validateSync } from 'tido-mei-validation';

import jade from 'jade';
import _ from 'lodash';
import { DOMParser } from 'xmldom';

export function parseXML(str) {
  return new DOMParser().parseFromString(str, 'text/xml');
}

export function wrapFragment(wrapperPath, data, valid, schemaPaths) {
  const jadeOptions = { _, pretty: true, data };
  const mei = jade.renderFile(wrapperPath, jadeOptions);
  const report = validateSync(mei, schemaPaths, true);

  if (valid) {
    assertValid(report);
  } else {
    assertInvalid(report);
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
