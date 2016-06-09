/** @jsx h */
/* eslint-disable react/prop-types */

import { h } from 'preact';
import { uniqueId } from 'lodash/fp';

import InSection from './InSection';

const staffString = `
<staff n="1" xml:id="${uniqueId('tpl')}">
  <layer n="1" xml:id="${uniqueId('tpl')}"/>
</staff>
`;

export const AfterStaff = ({ fragment }) => (
  <InSection>
    <measure {...{ 'xml:id': uniqueId('tpl'), n: 1 }}
      dangerouslySetInnerHTML={{ __html: staffString + fragment }} />
  </InSection>
);

export default AfterStaff;
