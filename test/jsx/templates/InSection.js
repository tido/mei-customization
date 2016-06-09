/** @jsx h */
/* eslint-disable react/prop-types */

import { h } from 'preact';
import { uniqueId } from 'lodash/fp';

import MEI from '../components/MEI';

export const InSection = ({ fragment, children, scoreDef, staffCount }) => (
  <MEI scoreDef={scoreDef} staffCount={staffCount}>
    { fragment
      ? <section {...{ 'xml:id': uniqueId('tpl') }}
        dangerouslySetInnerHTML={{ __html: fragment }} />
      : <section {...{ 'xml:id': uniqueId('tpl') }}>
          {children}
        </section>
    }
  </MEI>
);

export default InSection;
