/* @flow */

import path from 'path';
import java from 'java';

java.classpath.push(path.resolve(__dirname, '../../../../vendor/njing/njing.jar'));
java.classpath.push(path.resolve(__dirname, '../../../../vendor/njing/jing.jar'));

import { flow, map, compact } from 'lodash/fp';

import Message, { MessageType } from '../report/Message';

const cache = {};

const rngValidator = {
  TYPE: 'rng',

  validateWithFile: (
    xmlString: string,
    schemaPath: string,
    shouldCache: boolean
  ): Message[] =>
    validate(xmlString, schemaPath, shouldCache, ['loadSchemaFile', schemaPath]),

  validateWithFileSync: (
    xmlString: string,
    schemaPath: string,
    shouldCache: boolean
  ): Message[] =>
    validateSync(xmlString, schemaPath, shouldCache, ['loadSchemaFile', schemaPath]),

  validateWithStringSync: (
    xmlString: string,
    schemaPath: string,
    rngString: string,
    shouldCache: boolean
  ): Message[] =>
    validateSync(xmlString, schemaPath, shouldCache, ['loadSchemaString', rngString, '/']),
};

const validate = (
  xmlString: string,
  schemaPath: string,
  shouldCache: boolean,
  params: any[]
): Promise<Message[]> => (shouldCache && cache[schemaPath])
    ? runValidation(cache[schemaPath])
    : createOutputStream()
      .then(createValidator)
      .then(loadSchema(params, schemaPath, shouldCache))
      .then(runValidation(xmlString));

const createOutputStream = () => new Promise((resolve, reject) => {
  java.newInstance('java.io.ByteArrayOutputStream', 1024, (err, result) => {
    if (err) {
      reject(err);
    } else {
      resolve(result);
    }
  });
});

const createValidator = (result) => new Promise((resolve, reject) => {
  java.newInstance('com.tido.njing.NJing', result, (err, validator) => {
    if (err) {
      reject(err);
    } else {
      resolve({ validator, result });
    }
  });
});

const loadSchema = (params, schemaPath, shouldCache) =>
  ({ validator, result }) => new Promise((resolve, reject) => {
    java.callMethod(validator, ...params, (err) => {
      if (err) {
        reject(err);
      } else {
        if (shouldCache) {
          cache[schemaPath] = { result, validator };
        }
        resolve({ validator, result });
      }
    });
  });

const runValidation = (xmlString) => ({ validator, result }) => new Promise((resolve, reject) => {
  java.callMethod(validator, 'validateString', xmlString, '/', (err) => {
    if (err) {
      reject(err);
    } else {
      result.toByteArray((err, byteArray) => {
        if (err) {
          reject(err);
        } else {
          const buf = new Buffer(byteArray);
          const rawMessages = buf.toString().split('\n');
          const messages = createMessages(rawMessages);
          result.reset((err) => {
            if (err) {
              reject(err);
            } else {
              resolve(messages);
            }
          });
        }
      });
    }
  });
});

const validateSync = (
  xmlString: string,
  schemaPath: string,
  shouldCache: boolean,
  params: any[]
): Message[] => {
  let result;
  let validator;

  if (shouldCache && cache[schemaPath]) {
    result = cache[schemaPath].result;
    validator = cache[schemaPath].validator;
  } else {
    result = java.newInstanceSync('java.io.ByteArrayOutputStream', 1024);
    validator = java.newInstanceSync('com.tido.njing.NJing', result);
    java.callMethodSync(validator, ...params);

    if (shouldCache) {
      cache[schemaPath] = { result, validator };
    }
  }

  java.callMethodSync(validator, 'validateString', xmlString, '/');
  const buf = new Buffer(result.toByteArraySync());
  const rawMessages = buf.toString().split('\n');
  result.resetSync();

  return createMessages(rawMessages);
};

const createMessages = flow(
  map(createMessage),
  compact
);

const regex = /(.*):(\d+):(\d+): (\w+): (.*)/;

function createMessage(rawMessage: string): Message {
  if (rawMessage === '') return null;
  const match = regex.exec(rawMessage);
  if (!match) {
    throw new Error('unknown message format ' + rawMessage);
  }

  // currently ignoring systemId (first item in array) and message type
  // (fourth item) in validation report
  const [, line, column, , rawText] = match.slice(1);

  const messageType = MessageType.ERROR;
  const text = `[${line}:${column}] ${rawText}`;
  return new Message(rngValidator.TYPE, messageType, text);
}

export default rngValidator;
