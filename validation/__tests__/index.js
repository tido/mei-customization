/* @flow */

import { assert } from 'chai';
import * as validation from '..';
import ValidationReport from '../report/ValidationReport';
import { wrapFragment } from '../../../../util/test';

const { ok, isTrue, isFalse, lengthOf, instanceOf } = assert;

describe('validation', () => {
  describe('#validate', () => {
    describe('given a not well-formed XML string and no schema paths', () => {
      it('passes an error and no result to the cb function', (done) => {
        validation
          .validate('sdf')
          .then(() => {
            done('Validating a not well-formed XML fragment should throw an error.');
          })
          .catch((err) => {
            ok(err);
            done();
          });
      });

      describe('given a well-formed invalid XML string and no schema paths', () => {
        it('passes no error (null) and an invalid validation report to the cb function', (done) => {
          validation
            .validate('<xml/>')
            .then((result) => {
              instanceOf(result, ValidationReport);
              isFalse(result.isValid);
              lengthOf(result.getErrors(), 1);
              done();
            })
            .catch(done);
        });
      });

      describe('given a valid MEI string and no schema paths', () => {
        it('passes no error (null) and a valid validation report to the cb function', (done) => {
          validation
             .validate(validMEI)
             .then((result) => {
               instanceOf(result, ValidationReport);
               isTrue(result.isValid);
               lengthOf(result.getErrors(), 0);
               done();
             })
             .catch(done);
        });
      });
    });
  });

  describe('#validateSync', () => {
    describe('given a not well-formed XML string and no schema paths', () => {
      it('throws an error', () => {
        const run = () => validation.validateSync('sdf');
        assert.throws(run);
      });

      describe('given a well-formed invalid XML string and no schema paths', () => {
        it('returns an invalid validation report', () => {
          const report = validation.validateSync('<xml/>');
          assert.instanceOf(report, ValidationReport);
          assert.isFalse(report.isValid);
          assert.lengthOf(report.getErrors(), 1);
        });
      });

      describe('given a valid MEI string and no schema paths', () => {
        it('returns a valid validation report', () => {
          const report = validation.validateSync(validMEI);
          assert.instanceOf(report, ValidationReport);
          assert.isTrue(report.isValid);
          assert.lengthOf(report.getErrors(), 0);
        });
      });
    });
  });
});

const fragment = `
<note dur="2" pname="c" oct="4" stem.dir="up" xml:id="n1"/>
<note dur="2" pname="c" oct="4" stem.dir="up" xml:id="n2"/>
`;

const validMEI = wrapFragment('inLayer', fragment, undefined, undefined, 'never');
