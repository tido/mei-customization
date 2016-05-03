/* @flow */

import Message from './Message';

export default class ValidationReport {
  isValid: boolean;
  messages: Message[];

  static create(messages: Array<Message>): ValidationReport {
    const isValid = !messages.some(message => message.isError());

    return new ValidationReport(isValid, messages);
  }

  constructor(isValid: boolean, messages: Message[]) {
    this.isValid = isValid;
    this.messages = messages;
  }

  getErrors(): Message[] {
    return this.messages.filter((message) => message.isError());
  }
}
