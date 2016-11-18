/** @jsx h */
/* eslint-disable react/prop-types */

import { h } from 'preact';
import { times } from 'lodash/fp';
import { uniqueId } from 'lodash/fp';

import StaffDef from './StaffDef';

const defaultClefOrder = [
  { 'xml:id': uniqueId('tpl'), shape: 'G', line: 2 },
  { 'xml:id': uniqueId('tpl'), shape: 'F', line: 4 },
];

const createStaffDefFromN = (n) =>
  <StaffDef {...{
    'xml:id': uniqueId('tpl'),
    n: n + 1,
    clef: defaultClefOrder[n % defaultClefOrder.length],
  }} />;

const ScoreDef = ({ staffCount = 1 }) => {
  const staffDefs = times(createStaffDefFromN, staffCount);
  return (
    <scoreDef {...{ 'xml:id': uniqueId('tpl') }}>
      <staffGrp {...{ 'xml:id': uniqueId('tpl') }}>
        {staffDefs}
      </staffGrp>
    </scoreDef>
  );
};

export default ScoreDef;
