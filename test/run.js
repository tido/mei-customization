/** @jsx h */

import path from 'path';
import jade from 'jade';
import _ from 'lodash';
import { h } from 'preact';
import render from 'preact-render-to-string';
import { validateSync } from 'tido-mei-validation';
import { run as runOddTests } from 'odd-tests';

const schemaPaths = {
  tido: {
    rng: path.join(__dirname, '../build/schema/tido.rng'),
    schematron: path.join(__dirname, '../build/schema/tido.xsl'),
  },
};

runOddTests({
  oddPath: path.join(__dirname, '../src/tido.xml'),

  wrapFragment(templatePath, fragment) {
    const suffixMatch = templatePath.match(/\.(\w+)$/);
    if (!suffixMatch) {
      throw new Error(`Could not get suffix from "${templatePath}"`);
    }
    const suffix = suffixMatch[1];
    if (suffix !== 'js') {
      throw new Error(`Cannot process template with suffix "${suffix}"`);
    }

    const Template = require(templatePath).default;
    const xmlString = render(h(Template, { fragment }));
    delete require.cache[require.resolve(templatePath)];
    return xmlString;
  },

  validate(xmlString, schemaSpecName) {
    return validateSync(xmlString, schemaPaths[schemaSpecName], true);
  },
});
