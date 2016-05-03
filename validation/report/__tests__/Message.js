/* @flow */

import { assert } from 'chai';
import Message, { MessageType } from '../Message';

describe('Message', () => {
  describe('#toString', () => {
    it('returns a string', (done) => {
      const message = new Message('bla', MessageType.ERROR, 'message');

      const string = message.toString();
      assert.equal(string, 'ERROR [bla] message');
      done();
    });
  });
});
