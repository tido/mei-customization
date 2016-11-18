/** @jsx h */
/* eslint-disable react/prop-types */

import { h } from 'preact';
import { uniqueId } from 'lodash/fp';

import MEIHead from './MEIHead';
import ScoreDef from './ScoreDef';

const MEI = ({ children, staffCount = 1, scoreDef }) => (
  <mei {...{
    'xml:id': uniqueId('tpl'),
    meiversion: '3.0.0',
    xmlns: 'http://www.music-encoding.org/ns/mei',
    'xmlns:xlink': 'http://www.w3.org/1999/xlink',
    'xmlns:tido': 'http://tido-music.com/ns/1.0',
  }}>
    <MEIHead />
    <music {...{ 'xml:id': uniqueId('tpl') }}>
      <body {...{ 'xml:id': uniqueId('tpl') }}>
        <mdiv {...{ 'xml:id': uniqueId('tpl') }}>
          <score {...{ 'xml:id': uniqueId('tpl') }}>
            {scoreDef || <ScoreDef staffCount={staffCount} />}
            {children}
          </score>
        </mdiv>
      </body>
    </music>
  </mei>
);

export default MEI;
