
import path from 'path';
import jade from 'jade';
import _ from 'lodash';
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
    const jadeOptions = { _, pretty: true, data: fragment };
    return jade.renderFile(templatePath, jadeOptions);
  },

  validate(xmlString, schemaSpecName) {
    return validateSync(xmlString, schemaPaths[schemaSpecName], true);
  },
});
