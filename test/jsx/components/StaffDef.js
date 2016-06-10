/** @jsx h */
/* eslint-disable react/prop-types */

import { h } from 'preact';
import { uniqueId } from 'lodash/fp';

const StaffDef = ({
  xmlId = uniqueId('tpl'),
  n,
  lines = 5,
  clef = { 'xml:id': uniqueId('tpl'), line: 2, shape: 'G' },
  keySig = { 'xml:id': uniqueId('tpl'), pname: 'c', accid: 'n', mode: 'major' },
  meterSig = { 'xml:id': uniqueId('tpl'), count: 4, unit: 4 },
}) => (
  <staffDef {...{ 'xml:id': xmlId, n, lines }}>
    <clef {...clef} />
    <keySig {...keySig} />
    <meterSig {...meterSig} />
  </staffDef>
);

export default StaffDef;
