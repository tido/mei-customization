/** @jsx h */
/* eslint-disable react/prop-types */

import { h } from 'preact';
import { uniqueId } from 'lodash/fp';

import InSection from './InSection';

export const InInitialStaffGrp = ({ fragment }) => (
  <InSection>
    <scoreDef {...{ 'xml:id': uniqueId('tpl') }}>
      <staffGrp {...{ 'xml:id': uniqueId('tpl') }}
        dangerouslySetInnerHTML={{ __html: fragment }} />
    </scoreDef>
    <measure {...{ 'xml:id': uniqueId('tpl'), n: 1 }}>
      <staff {...{ 'xml:id': uniqueId('tpl'), n: 1 }}>
        <layer {...{ 'xml:id': uniqueId('tpl'), n: 1 }} />
      </staff>
    </measure>
  </InSection>
);

export default InInitialStaffGrp;
