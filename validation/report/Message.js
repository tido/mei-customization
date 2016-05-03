/* @flow */

export default class Message {
  validator: string;
  type: string;
  text: string;

  constructor(validator: string, type: string, text: string) {
    this.validator = validator;
    this.type = type;
    this.text = text;
  }

  isError(): boolean {
    return this.type === MessageType.ERROR;
  }

  toString(): string {
    return `${this.type.toUpperCase()} [${this.validator}] ${this.text}`;
  }
}

export const MessageType: { [key: string]: string } = {
  ERROR: 'error',
  WARNING: 'warning',
};
