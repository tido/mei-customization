/** @jsx h */
/* eslint-disable react/prop-types */

import { h } from 'preact';
import { uniqueId } from 'lodash/fp';

const MEIHead = () => (
  <meiHead {...{ 'xml:id': uniqueId('tpl') }}>
    {h('tido:style', { 'xml:id': uniqueId('tpl'), children: ["@import 'index.tss';"] })}
    <fileDesc {...{ 'xml:id': uniqueId('tpl') }}>
      <titleStmt {...{ 'xml:id': uniqueId('tpl') }}>
        <title {...{ 'xml:id': uniqueId('tpl') }}>Hand encoded test file</title>
        <respStmt {...{ 'xml:id': uniqueId('tpl') }}>
          <corpName role="creator" {...{ 'xml:id': uniqueId('tpl') }}
            >Tido Enterprise GmbH</corpName>
          </respStmt>
      </titleStmt>
      <pubStmt {...{ 'xml:id': uniqueId('tpl') }}>
        <respStmt {...{ 'xml:id': uniqueId('tpl') }}>
          <corpName {...{ 'xml:id': uniqueId('tpl') }}>Tido Enterprise GmbH</corpName>
        </respStmt>
        <address {...{ 'xml:id': uniqueId('tpl') }}>
          <addrLine {...{ 'xml:id': uniqueId('tpl') }}>Talstrasse, Leipzig</addrLine>
        </address>
        <availability {...{ 'xml:id': uniqueId('tpl') }}>
          <useRestrict {...{ 'xml:id': uniqueId('tpl') }}>All right reserved.</useRestrict>
        </availability>
      </pubStmt>
      <seriesStmt {...{ 'xml:id': uniqueId('tpl') }}>
        <title {...{ 'xml:id': uniqueId('tpl') }}>Tido MEI Examplars</title>
        <respStmt {...{ 'xml:id': uniqueId('tpl') }}>
          <corpName {...{ 'xml:id': uniqueId('tpl') }}>Tido</corpName>
        </respStmt>
      </seriesStmt>
    </fileDesc>
    <encodingDesc {...{ 'xml:id': uniqueId('tpl') }}>
      <projectDesc {...{ 'xml:id': uniqueId('tpl') }}>
        <p {...{ 'xml:id': uniqueId('tpl') }}
          >Encoded by hand in order to illustrate the encoding of a specific notation</p>
      </projectDesc>
    </encodingDesc>
  </meiHead>
);

export default MEIHead;
