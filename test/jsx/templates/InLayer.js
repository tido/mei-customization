/** @jsx h */
/* eslint-disable react/prop-types */

import { h } from 'preact';
import { uniqueId } from 'lodash/fp';

import InStaff from './InStaff';

export const InLayer = ({ fragment, children }) => (
  <InStaff>
    { fragment
      ? <layer {...{ 'xml:id': uniqueId('tpl'), n: 1 }}
        dangerouslySetInnerHTML={{ __html: fragment }} />
      : <layer {...{ 'xml:id': uniqueId('tpl'), n: 1 }}>
          {children}
        </layer>
    }
  </InStaff>
);

export default InLayer;
