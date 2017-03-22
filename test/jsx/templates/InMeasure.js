/** @jsx h */
/* eslint-disable react/prop-types */

import { h } from 'preact';
import { uniqueId } from 'lodash/fp';

import InSection from './InSection';

export const InMeasure = ({ fragment, children }) => (
  <InSection>
    { fragment
      ? <measure {...{ 'xml:id': uniqueId('tpl'), n: 1 }}
        dangerouslySetInnerHTML={{ __html: fragment }} />
      : <measure {...{ 'xml:id': uniqueId('tpl'), n: 1 }}>
          {children}
        </measure>
    }
  </InSection>
);

export default InMeasure;
