<?xml version="1.0" encoding="UTF-8"?><sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:rng="http://relaxng.org/ns/structure/1.0" queryBinding="xslt2">
   <sch:ns xmlns="http://relaxng.org/ns/structure/1.0" xmlns:xlink="http://www.w3.org/1999/xlink" prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>
   <ns xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" prefix="mei" uri="http://www.music-encoding.org/ns/mei"/>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.augmentdots-dots-dots_attribute_requires_dur-constraint-1">
      <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:*[@dots]">
                <sch:assert test="@dur">An element with a dots attribute must also have a dur
                  attribute.</sch:assert>
              </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.controlevent-require_staff_attribute-constraint-2">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:dynam|mei:fing|mei:fingGrp|mei:mordent|mei:ornam|mei:pedal|mei:tie|mei:trill|mei:turn|mei:fermata|mei:octave">
                  <sch:assert test="ancestor-or-self::*[name()='staff' or @staff]">The element or one of its ancestors must be a staff or contain a @staff attribute.</sch:assert>
                </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.controlevent-require_layer_with_singlevalue_staff-constraint-3">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:*[not(name() = ('slur', 'tie', 'note'))][@staff][not(contains(@staff, ' '))]">
                  <sch:assert test="exists(@layer)">@layer must be present when @staff contains a single value.</sch:assert>
                </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.controlevent-require_place_with_singlevalue_staff-constraint-4">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:*[not(name() = ('slur', 'tie', 'note', 'octave'))][@staff][not(contains(@staff, ' '))]">
                  <sch:assert test="exists(@place)">@place must be present when @staff contains a single value.</sch:assert>
                </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.controlevent-no_layer_with_multivalue_staff-constraint-5">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:*[@staff]">
                  <sch:assert test="not(contains(@staff, ' ') and @layer)">@layer must be absent when @staff contains multiple values.</sch:assert>
                </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.controlevent-no_place_with_multivalue_staff-constraint-6">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:*[@staff]">
                  <sch:assert test="not(contains(@staff, ' ') and @place)">@place must be absent when @staff contains multiple values.</sch:assert>
                </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.name-nymref-check_nymrefTarget-constraint-7">
      <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="@nymref">
                <sch:assert role="warning" test="not(normalize-space(.) eq '')">@nymref attribute
                  has no content.</sch:assert>
                <sch:assert role="warning" test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">The value in @nymref must correspond to the @xml:id attribute of an
                  element.</sch:assert>
              </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.note.log-require_oct_and_pname_or_loc-constraint-8">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:note">
                  <sch:assert test="(@pname and @oct) or @loc">either @pname and @oct or @loc
                    must be specified on a note.</sch:assert>
                </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.note.log-standalone_note_require_dur-constraint-9">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:note[not(ancestor::mei:chord)]">
                  <sch:assert test="exists(@dur)">Must have dur attribute.</sch:assert>
                </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.note.log-standalone_note_require_stem.dir-constraint-10">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:note[not(ancestor::mei:chord)]">
                  <sch:assert test="exists(@stem.dir)">Must have stem.dir attribute.</sch:assert>
                </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.note.log-no_note_dur_in_chord-constraint-11">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:note[ancestor::mei:chord]">
                  <sch:report test="exists(@dur)">@dur attribute not permitted on notes within a chord.</sch:report>
                </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.note.log-no_note_stem.dir_in_chord-constraint-12">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:note[ancestor::mei:chord]">
                  <sch:report test="@stem.dir">@stem.dir not permitted on notes within a chord.</sch:report>
                </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.startendid-endid-check_endidTarget-constraint-13">
      <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="@endid">
                <sch:assert role="warning" test="not(normalize-space(.) eq '')">@endid attribute has
                  no content.</sch:assert>
                <sch:assert role="warning" test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">The value in @endid must correspond to the @xml:id attribute of an
                  element.</sch:assert>
              </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.startid-startid-check_startidTarget-constraint-14">
      <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="@startid">
                <sch:assert role="warning" test="not(normalize-space(.) eq '')">@startid attribute
                  has no content.</sch:assert>
                <sch:assert role="warning" test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">The value in @startid must correspond to the @xml:id attribute of an
                  element.</sch:assert>
              </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.typed-subtype-When_subtype-constraint-15">
      <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:*[@subtype]">
                <sch:assert test="@type">An element with a subtype attribute must have a type
                  attribute.</sch:assert>
              </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-clef-Clef_position_lines-constraint-16">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:clef[ancestor::mei:staffDef[@lines]]">
               <sch:let name="thisstaff" value="ancestor::mei:staffDef/@n"/>
               <sch:assert test="number(@line) &lt;=               number(ancestor::mei:staffDef[@n=$thisstaff and @lines][1]/@lines)">The clef position must be less than or equal to the number of lines on the
              staff.</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-clef-Clef_position_nolines-constraint-17">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:clef[ancestor::mei:staffDef[not(@lines)]]">
               <sch:let name="thisstaff" value="ancestor::mei:staffDef/@n"/>
               <sch:assert test="number(@line) &lt;=               number(preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines)">The clef position must be less than or equal to the number of lines on the
              staff.</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-dir-dir_type_required_closed_list-constraint-18">
            <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:dir">
                  <sch:assert test="@type=('expression', 'technique')">Must have a @type of 'expression' or 'technique'</sch:assert>
                </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-dir-dir_start-type_attributes_required-constraint-19">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:dir[not(ancestor::mei:syllable)]">
               <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of
              the attributes: startid, tstamp, tstamp.ges or tstamp.real</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-dynam-dynam_start-type_attributes_required-constraint-20">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:dynam">
               <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real"> Must have one of
              the attributes: startid, tstamp, tstamp.ges or tstamp.real</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-dynam-dynam_end-type_attributes-constraint-21">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:dynam[@val2]">
               <sch:assert test="@dur or @dur.ges or @endid or @tstamp2">When @val2 is present, either
              @dur, @dur.ges, @endid, or @tstamp2 must also be present.</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-keySig-key_att_pair-constraint-22">
            <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:keySig">
                  <sch:report test="not(@pname and @mode)"> Key signature must be complete (both
                    @pname and @mode are required).</sch:report>
                </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-mei-Check_staff-constraint-23">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:*[@staff]">
               <sch:assert test="every $i in tokenize(@staff, '\s+') satisfies $i=//mei:staffDef/@n">The values in @staff must correspond to @n attribute of a staffDef
              element.</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-ornam-ornam_start-type_attributes_required-constraint-24">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:ornam">
               <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of
              the attributes: startid, tstamp, tstamp.ges or tstamp.real</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-rest-Check_restline-constraint-25">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:rest[@line]">
               <sch:let name="thisstaff" value="ancestor::mei:staff/@n"/>
               <sch:assert test="number(@line) &lt;=               number(preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines)">The value of @line must be less than or equal to the number of lines on the
              staff.</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-section-Check_sectionexpansion-constraint-26">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:section[mei:expansion]">
               <sch:assert test="descendant::mei:section|descendant::mei:ending|descendant::mei:rdg">Must have descendant section, ending, or rdg elements that can be pointed
              to.</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-staffDef-Check_staffDefn-constraint-27">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:staffDef">
               <sch:let name="thisstaff" value="@n"/>
               <sch:assert test="@n">A staffDef must have an n attribute.</sch:assert>
               <sch:assert test="@lines or preceding::mei:staffDef[@n=$thisstaff and @lines]">The first
              occurrence of a staff must declare the number of staff lines.</sch:assert>
               <sch:assert test="count(mei:clef) + count(mei:clefGrp) &lt; 2">Only one clef or clefGrp
              is permitted.</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-staffDef-Check_ancestor_staff-constraint-28">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:staffDef[ancestor::mei:staff]">
               <sch:let name="thisstaff" value="@n"/>
               <sch:assert test="ancestor::mei:staff/@n eq $thisstaff">If a staffDef appears in a
              staff, it must bear the same @n than this staff.</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-staffDef-Check_clef_position_staffDef-constraint-29">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:staffDef[@clef.line and @lines]">
               <sch:assert test="number(@clef.line) &lt;= number(@lines)">The clef position must be
              less than or equal to the number of lines on the staff.</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-staffDef-Check_clef_position_staffDef_nolines-constraint-30">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:staffDef[@clef.line and not(@lines)]">
               <sch:let name="thisstaff" value="@n"/>
               <sch:let name="stafflines" value="preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines"/>
               <sch:assert test="number(@clef.line) &lt;= number($stafflines)">The clef position must
              be less than or equal to the number of lines on the staff.</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-staffDef-Check_tab_strings_lines-constraint-31">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:staffDef[@tab.strings and @lines]">
               <sch:let name="countTokens" value="count(tokenize(normalize-space(@tab.strings), '\s'))"/>
               <sch:assert test="$countTokens = 1 or $countTokens = @lines">The tab.strings attribute
              must have the same number of values as there are staff lines.</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-staffDef-Check_tab_strings_nolines-constraint-32">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:staffDef[@tab.strings and not(@lines)]">
               <sch:let name="countTokens" value="count(tokenize(normalize-space(@tab.strings), '\s'))"/>
               <sch:let name="thisStaff" value="@n"/>
               <sch:assert test="$countTokens = 1 or $countTokens = preceding::mei:staffDef[@n=$thisStaff and @lines][1]/@lines">The tab.strings attribute must have the same number of values as there are staff
              lines.</sch:assert>
            </sch:rule>
         </pattern>
   <sch:pattern xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:xlink="http://www.w3.org/1999/xlink">
            <sch:rule context="mei:staffDef[@lines.color and @lines]">
              <sch:let name="countTokens" value="count(tokenize(normalize-space(@lines.color), '\s'))"/>
              <sch:assert test="$countTokens = 1 or $countTokens = @lines">The lines.color attribute
                must have either 1) a single value or 2) the same number of values as there are
                staff lines.</sch:assert>
            </sch:rule>
            <sch:rule context="mei:staffDef[@lines.color and not(@lines)]">
              <sch:let name="countTokens" value="count(tokenize(normalize-space(@lines.color), '\s'))"/>
              <sch:let name="thisStaff" value="@n"/>
              <sch:assert test="$countTokens = 1 or $countTokens = preceding::mei:staffDef[@n=$thisStaff and @lines][1]/@lines">The lines.color attribute must have either 1) a single value or 2) the same number
                of values as there are staff lines.</sch:assert>
            </sch:rule>
          </sch:pattern>
   <sch:pattern xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:xlink="http://www.w3.org/1999/xlink">
            <sch:rule context="mei:staffDef[@ppq][ancestor::mei:scoreDef[@ppq]]">
              <sch:let name="staffPPQ" value="@ppq"/>
              <sch:let name="scorePPQ" value="ancestor::mei:scoreDef[@ppq][1]/@ppq"/>
              <sch:assert test="($scorePPQ mod $staffPPQ) = 0">The value of ppq must be a factor of
                the value of ppq on an ancestor scoreDef.</sch:assert>
            </sch:rule>
          </sch:pattern>
   <sch:pattern xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:xlink="http://www.w3.org/1999/xlink">
            <sch:rule context="mei:staffDef[@ppq][preceding::mei:scoreDef[@ppq]]">
              <sch:let name="staffPPQ" value="@ppq"/>
              <sch:let name="scorePPQ" value="preceding::mei:scoreDef[@ppq][1]/@ppq"/>
              <sch:assert test="($scorePPQ mod $staffPPQ) = 0">The value of ppq must be a factor of
                the value of ppq on a preceding scoreDef.</sch:assert>
            </sch:rule>
          </sch:pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-staffGrp-Check_staffGrp_unique_staff_n_values-constraint-37">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:staffGrp">
               <sch:let name="countstaves" value="count(descendant::mei:staffDef)"/>
               <sch:let name="countuniqstaves" value="count(distinct-values(descendant::mei:staffDef/@n))"/>
               <sch:assert test="$countstaves eq $countuniqstaves">Each staffDef must have a unique
              value for the n attribute.</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-tempo-tempo_in_header_disallow_most_attrs-constraint-38">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:tempo[ancestor::mei:meiHead]">
               <sch:assert test="not(@*[name() != 'label' and name() != 'n' and name() != 'xml:base' and name() != 'xml:id' and name() != 'xml:lang'])">Only label, n, xml:base, xml:id, and xml:lang attributes allowed when this element
              occurs in the header.</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-tempo-tempo_start-type_attributes_required-constraint-39">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:tempo[not(ancestor::mei:syllable) and not(ancestor::mei:work) and not(ancestor::mei:expression) and not(count(ancestor::mei:*) = 0)]">
               <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of
              the attributes: startid, tstamp, tstamp.ges or tstamp.real</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-beam-When_not_copyof_beam_content-constraint-40">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:beam[not(@copyof)]">
               <sch:assert test="count(descendant::*[local-name()='note' or local-name()='rest' or               local-name()='chord' or local-name()='space']) &gt; 1">A beam without a copyof attribute must have at least 2 note, rest, chord, or space
              descendants.</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-fermata-fermata_start-type_attributes_required-constraint-41">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:fermata">
               <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of
              the attributes: startid, tstamp, tstamp.ges or tstamp.real</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-hairpin-hairpin_place_required_with_single_staff-constraint-42">
            <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:hairpin[not(contains(@staff, ' '))]">
                  <sch:assert test="exists(@place)">Must have place attribute.</sch:assert>
                </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-meterSig-meter_att_pair-constraint-43">
            <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:meterSig">
                  <sch:report test="not(@count and @unit)">Time signature must be complete (both
                    @count and @unit are required).</sch:report>
                </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-octave-octave_start-_and_end-type_attributes_required-constraint-44">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:octave">
               <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of
              the attributes: startid, tstamp, tstamp.ges or tstamp.real</sch:assert>
               <sch:assert test="@dur or @dur.ges or @endid or @tstamp2">Must have one of the
              attributes: dur, dur.ges, endid, or tstamp2</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-pedal-pedal_style_consistent-constraint-45">
            <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:pedal[@form][@dir=('bounce', 'up')]">
                  <sch:let name="form" value="@form"/>
                  <sch:assert test="preceding::mei:pedal[1][@form=$form]">
                    Pedal styles must be consistent between pedal down and pedal up.</sch:assert>
                </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-pedal-pedal_start-type_attributes_required-constraint-46">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:pedal">
               <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of
              the attributes: startid, tstamp, tstamp.ges or tstamp.real</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-slur-slur_start-_and_end-type_attributes_required-constraint-47">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:slur">
               <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of
              the attributes: startid, tstamp, tstamp.ges or tstamp.real</sch:assert>
               <sch:assert test="@dur or @dur.ges or @endid or @tstamp2">Must have one of the
              attributes: dur, dur.ges, endid, or tstamp2</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-tie-tie_start-_and_end-type_attributes_required-constraint-48">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:tie">
               <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of
              the attributes: startid, tstamp, tstamp.ges or tstamp.real</sch:assert>
               <sch:assert test="@dur or @dur.ges or @endid or @tstamp2">Must have one of the
              attributes: dur, dur.ges, endid, or tstamp2</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-tie-tie_containing_curve-constraint-49">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:tie[mei:curve[@bezier or @bulge or @curvedir or @lform or @lwidth or             @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or             @endvo or @x or @y or @x2 or @y2]]">
               <sch:assert test="not(@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or               @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2)" role="warning">The visual attributes of the tie (@bezier, @bulge, @curvedir, @lform,
              @lwidth, @ho, @startho, @endho, @to, @startto, @endto, @vo, @startvo, @endvo, @x, @y,
              @x2, and @y2) will be overridden by visual attributes of the contained curve
              elements.</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-mordent-mordent_start-type_attributes_required-constraint-50">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:mordent">
               <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of
              the attributes: startid, tstamp, tstamp.ges or tstamp.real</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-trill-trill_start-type_attributes_required-constraint-51">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:trill">
               <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of
              the attributes: startid, tstamp, tstamp.ges or tstamp.real</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-turn-turn_start-type_attributes_required-constraint-52">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:turn">
               <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of
              the attributes: startid, tstamp, tstamp.ges or tstamp.real</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-fing-stack_exclusion-constraint-53">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:fing">
               <sch:assert test="not(descendant::mei:stack)">The stack element is not allowed anywhere
              in fing.</sch:assert>
            </sch:rule>
         </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-fingGrp-require_fingeringLike_children-constraint-54">
            <sch:rule xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" context="mei:fingGrp">
               <sch:assert test="count(mei:fing) + count(mei:fingGrp) &gt; 1">At least 2 fing or
              fingGrp elements are required.</sch:assert>
            </sch:rule>
         </pattern>
   <sch:pattern xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:xlink="http://www.w3.org/1999/xlink">
            <sch:rule context="mei:fingGrp[not(ancestor::mei:fingGrp)][@tstamp or @startid]">
              <sch:assert test="not(child::mei:*[@tstamp or @startid])">When @tstamp or @startid is
                present on fingGrp, its child elements cannot have a @tstamp or @startid
                attribute.</sch:assert>
            </sch:rule>
            <sch:rule context="mei:fingGrp[not(ancestor::mei:fingGrp)][not(@tstamp or @startid)]">
              <sch:assert test="count(descendant::mei:*[@tstamp or @startid]) = count(child::mei:*[local-name()='fing' or local-name()='fingGrp'])">When @tstamp or @startid is not present on fingGrp, each of its child elements must
                have a @tstamp or @startid attribute.</sch:assert>
            </sch:rule>
          </sch:pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.spanning.req-require_precisely_one_start_spec-constraint-57">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:slur">
                  <sch:assert test="(@tstamp and not(@startid)) or (not(@tstamp) and @startid)">precisely one of @tstamp or @startid must be defined</sch:assert>
                </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xlink="http://www.w3.org/1999/xlink" id="tido-att.spanning.req-require_precisely_one_end_spec-constraint-58">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0" context="mei:slur">
                  <sch:assert test="(@tstamp2 and not(@endid)) or (not(@tstamp2) and @endid)">precisely one of @tstamp2 or @endid must be defined</sch:assert>
                </sch:rule>
   </pattern>
   <sch:diagnostics/>
</sch:schema>