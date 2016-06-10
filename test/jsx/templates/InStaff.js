/** @jsx h */
/* eslint-disable react/prop-types */

import { h } from 'preact';
import { uniqueId } from 'lodash/fp';

import InMeasure from './InMeasure';

export const InStaff = ({ fragment, children }) => (
  <InMeasure>
    { fragment
      ? <staff {...{ 'xml:id': uniqueId('tpl'), n: 1 }}
        dangerouslySetInnerHTML={{ __html: fragment }} />
      : <staff {...{ 'xml:id': uniqueId('tpl'), n: 1 }}>
          {children}
        </staff>
    }
  </InMeasure>
);

export default InStaff;
