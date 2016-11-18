/** @jsx h */
/* eslint-disable react/prop-types */

import { h } from 'preact';
import { uniqueId } from 'lodash/fp';

import InSection from './InSection';

export const InStaffDefAfterLastMeasure = ({ fragment }) => (
  <InSection>
    <measure {...{ 'xml:id': uniqueId('tpl'), n: 1 }}>
      <staff {...{ 'xml:id': uniqueId('tpl'), n: 1 }}>
        <layer {...{ 'xml:id': uniqueId('tpl'), n: 1 }} />
      </staff>
    </measure>
    <measure {...{ 'xml:id': uniqueId('tpl'), n: 2 }}>
      <staff {...{ 'xml:id': uniqueId('tpl'), n: 1 }}>
        <layer {...{ 'xml:id': uniqueId('tpl'), n: 1 }} />
      </staff>
    </measure>
    <staffDef {...{ 'xml:id': uniqueId('tpl'), n: 1 }}
      dangerouslySetInnerHTML={{ __html: fragment }} />
  </InSection>
);

export default InStaffDefAfterLastMeasure;
