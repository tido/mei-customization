/* @flow */

import * as path from 'path';
import { assign, flatten } from 'lodash/fp';
import ValidationReport from './report/ValidationReport';
import rng from './validator/rng';
import schematron from './validator/schematron';

type SchemaPaths = { rng: string, schematron: string };
type SchemaPathArgs = { rng?: string, schematron?: string };

const defaultSchemaPaths: SchemaPaths = {
  rng: path.resolve(__dirname, '../../../build/dist/schema/tido.rng'),
  schematron: path.resolve(__dirname, '../../../build/dist/schema/tido.xsl'),
};

export function validate(
  meiString: string,
  schemaPathArgs: SchemaPathArgs = {},
  shouldCache: boolean = false
): Promise<ValidationReport> {
  const schemaPaths = assign(defaultSchemaPaths, schemaPathArgs);

  const validationSteps = [
    rng.validateWithFile(meiString, schemaPaths.rng, shouldCache),
    schematron.validateWithFile(meiString, schemaPaths.schematron, shouldCache),
  ];

  return Promise
    .all(validationSteps)
    .then(flatten)
    .then(ValidationReport.create);
}


export function validateSync(
  meiString: string,
  schemaPathArgs: SchemaPathArgs = {},
  shouldCache: boolean = false
): ValidationReport {
  const schemaPaths = assign(defaultSchemaPaths, schemaPathArgs);

  const messages = [
    ...rng.validateWithFileSync(meiString, schemaPaths.rng, shouldCache),
    ...schematron.validateWithFileSync(meiString, schemaPaths.schematron, shouldCache),
  ];

  return ValidationReport.create(messages);
}
