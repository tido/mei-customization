/** @jsx h */
/* eslint-disable react/prop-types */

import { h } from 'preact';
import { uniqueId } from 'lodash/fp';

import MEI from '../components/MEI';

export const InSectionWithTwoStaves = ({ fragment }) => (
  <MEI staffCount="2">
    <section {...{ 'xml:id': uniqueId('tpl') }}
      dangerouslySetInnerHTML={{ __html: fragment }} />
  </MEI>
);

export default InSectionWithTwoStaves;
