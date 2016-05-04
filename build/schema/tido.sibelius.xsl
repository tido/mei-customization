<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:mei="http://www.music-encoding.org/ns/mei" version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


   <!--PROLOG-->
   <xsl:output method="text"/>

   <!--XSD TYPES FOR XSLT2-->


   <!--KEYS AND FUNCTIONS-->


   <!--DEFAULT RULES-->


   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <xsl:apply-templates select="/" mode="M2"/>
      <xsl:apply-templates select="/" mode="M3"/>
      <xsl:apply-templates select="/" mode="M4"/>
      <xsl:apply-templates select="/" mode="M5"/>
      <xsl:apply-templates select="/" mode="M6"/>
      <xsl:apply-templates select="/" mode="M7"/>
      <xsl:apply-templates select="/" mode="M8"/>
      <xsl:apply-templates select="/" mode="M9"/>
      <xsl:apply-templates select="/" mode="M10"/>
      <xsl:apply-templates select="/" mode="M11"/>
      <xsl:apply-templates select="/" mode="M12"/>
      <xsl:apply-templates select="/" mode="M13"/>
      <xsl:apply-templates select="/" mode="M14"/>
      <xsl:apply-templates select="/" mode="M15"/>
      <xsl:apply-templates select="/" mode="M16"/>
      <xsl:apply-templates select="/" mode="M17"/>
      <xsl:apply-templates select="/" mode="M18"/>
      <xsl:apply-templates select="/" mode="M19"/>
      <xsl:apply-templates select="/" mode="M20"/>
      <xsl:apply-templates select="/" mode="M21"/>
      <xsl:apply-templates select="/" mode="M22"/>
      <xsl:apply-templates select="/" mode="M23"/>
      <xsl:apply-templates select="/" mode="M24"/>
      <xsl:apply-templates select="/" mode="M25"/>
      <xsl:apply-templates select="/" mode="M26"/>
      <xsl:apply-templates select="/" mode="M27"/>
      <xsl:apply-templates select="/" mode="M28"/>
      <xsl:apply-templates select="/" mode="M29"/>
      <xsl:apply-templates select="/" mode="M30"/>
      <xsl:apply-templates select="/" mode="M31"/>
      <xsl:apply-templates select="/" mode="M32"/>
      <xsl:apply-templates select="/" mode="M33"/>
      <xsl:apply-templates select="/" mode="M34"/>
      <xsl:apply-templates select="/" mode="M35"/>
      <xsl:apply-templates select="/" mode="M36"/>
      <xsl:apply-templates select="/" mode="M37"/>
      <xsl:apply-templates select="/" mode="M38"/>
      <xsl:apply-templates select="/" mode="M39"/>
      <xsl:apply-templates select="/" mode="M40"/>
      <xsl:apply-templates select="/" mode="M41"/>
      <xsl:apply-templates select="/" mode="M42"/>
      <xsl:apply-templates select="/" mode="M43"/>
      <xsl:apply-templates select="/" mode="M44"/>
      <xsl:apply-templates select="/" mode="M45"/>
      <xsl:apply-templates select="/" mode="M46"/>
      <xsl:apply-templates select="/" mode="M47"/>
      <xsl:apply-templates select="/" mode="M48"/>
      <xsl:apply-templates select="/" mode="M49"/>
      <xsl:apply-templates select="/" mode="M50"/>
      <xsl:apply-templates select="/" mode="M51"/>
      <xsl:apply-templates select="/" mode="M52"/>
      <xsl:apply-templates select="/" mode="M53"/>
      <xsl:apply-templates select="/" mode="M54"/>
      <xsl:apply-templates select="/" mode="M55"/>
      <xsl:apply-templates select="/" mode="M56"/>
      <xsl:apply-templates select="/" mode="M57"/>
      <xsl:apply-templates select="/" mode="M58"/>
      <xsl:apply-templates select="/" mode="M59"/>
      <xsl:apply-templates select="/" mode="M60"/>
      <xsl:apply-templates select="/" mode="M61"/>
      <xsl:apply-templates select="/" mode="M62"/>
      <xsl:apply-templates select="/" mode="M63"/>
      <xsl:apply-templates select="/" mode="M64"/>
      <xsl:apply-templates select="/" mode="M65"/>
      <xsl:apply-templates select="/" mode="M66"/>
      <xsl:apply-templates select="/" mode="M67"/>
      <xsl:apply-templates select="/" mode="M68"/>
      <xsl:apply-templates select="/" mode="M69"/>
      <xsl:apply-templates select="/" mode="M70"/>
      <xsl:apply-templates select="/" mode="M71"/>
      <xsl:apply-templates select="/" mode="M72"/>
      <xsl:apply-templates select="/" mode="M73"/>
      <xsl:apply-templates select="/" mode="M74"/>
      <xsl:apply-templates select="/" mode="M75"/>
      <xsl:apply-templates select="/" mode="M76"/>
      <xsl:apply-templates select="/" mode="M77"/>
      <xsl:apply-templates select="/" mode="M78"/>
      <xsl:apply-templates select="/" mode="M79"/>
      <xsl:apply-templates select="/" mode="M80"/>
      <xsl:apply-templates select="/" mode="M81"/>
      <xsl:apply-templates select="/" mode="M82"/>
      <xsl:apply-templates select="/" mode="M83"/>
      <xsl:apply-templates select="/" mode="M84"/>
      <xsl:apply-templates select="/" mode="M85"/>
      <xsl:apply-templates select="/" mode="M86"/>
      <xsl:apply-templates select="/" mode="M87"/>
      <xsl:apply-templates select="/" mode="M88"/>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->


   <!--PATTERN tido.sibelius-att.notationtype-notationsubtype-When_notationsubtype-constraint-1-->


	  <!--RULE -->
   <xsl:template match="mei:*[@notationsubtype]" priority="1000" mode="M2">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@notationtype"/>
         <xsl:otherwise>&#x2028;An element with a notationsubtype attribute must have a notationtype attribute. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M2"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M2"/>
   <xsl:template match="@*|node()" priority="-2" mode="M2">
      <xsl:apply-templates select="*" mode="M2"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.augmentdots-dots-dots_attribute_requires_dur-constraint-2-->


	  <!--RULE -->
   <xsl:template match="mei:*[@dots]" priority="1000" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur"/>
         <xsl:otherwise>&#x2028;An element with a dots attribute must also have a dur attribute. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M3"/>
   <xsl:template match="@*|node()" priority="-2" mode="M3">
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.classcodeident-classcode-check_classcodeTarget-constraint-3-->


	  <!--RULE -->
   <xsl:template match="@classcode" priority="1000" mode="M4">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@classcode attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:classCode/@xml:id"/>
         <xsl:otherwise>warning&#x2028;The value in @classcode must correspond to the @xml:id attribute of a classCode element. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M4"/>
   <xsl:template match="@*|node()" priority="-2" mode="M4">
      <xsl:apply-templates select="*" mode="M4"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.controlevent-no_layer_with_multivalue_staff-constraint-4-->


	  <!--RULE -->
   <xsl:template match="mei:*[@staff]" priority="1000" mode="M5">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (contains(@staff, ' ') and @layer) then false() else true()"/>
         <xsl:otherwise>&#x2028;@layer must be absent when @staff contains multiple values. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M5"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M5"/>
   <xsl:template match="@*|node()" priority="-2" mode="M5">
      <xsl:apply-templates select="*" mode="M5"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.controlevent-no_place_with_multivalue_staff-constraint-5-->


	  <!--RULE -->
   <xsl:template match="mei:*[@staff]" priority="1000" mode="M6">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (contains(@staff, ' ') and @place) then false() else true()"/>
         <xsl:otherwise>&#x2028;@place must be absent when @staff contains multiple values. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.custos.log-target-check_custosTarget-constraint-6-->


	  <!--RULE -->
   <xsl:template match="mei:custos/@target" priority="1000" mode="M7">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@target attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:note/@xml:id"/>
         <xsl:otherwise>warning&#x2028;The value in @target must correspond to the @xml:id attribute of a note element. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.datapointing-data-check_dataTarget-constraint-7-->


	  <!--RULE -->
   <xsl:template match="@data" priority="1000" mode="M8">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@data attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[ancestor::mei:music]/@xml:id"/>
         <xsl:otherwise>warning&#x2028;The value in @data must correspond to the @xml:id attribute of a descendant of the music element. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.declaring-decls-check_declsTarget-constraint-8-->


	  <!--RULE -->
   <xsl:template match="@decls" priority="1000" mode="M9">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@decls attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[ancestor::mei:meiHead]/@xml:id"/>
         <xsl:otherwise>warning&#x2028;Each value in @decls must correspond to the @xml:id attribute of an element within the metadata header. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.duration.additive-dur-ignore_dots_attribute-constraint-9-->


	  <!--RULE -->
   <xsl:template match="mei:*[contains(@dur, '.')]" priority="1000" mode="M10">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(@dots)"/>
         <xsl:otherwise>&#x2028;An element with a dur attribute that contains dotted values must not have a dots attribute. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.handident-hand-check_handTarget-constraint-10-->


	  <!--RULE -->
   <xsl:template match="@hand" priority="1000" mode="M11">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@hand attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:hand/@xml:id"/>
         <xsl:otherwise>warning&#x2028;Each value in @hand must correspond to the @xml:id attribute of a hand element. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.instrumentident-instr-check_instrTarget-constraint-11-->


	  <!--RULE -->
   <xsl:template match="@instr" priority="1000" mode="M12">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@instr attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:instrDef/@xml:id"/>
         <xsl:otherwise>warning&#x2028;The value in @instr must correspond to the @xml:id attribute of an instrDef element. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.joined-join-check_joinTarget-constraint-12-->


	  <!--RULE -->
   <xsl:template match="@join" priority="1000" mode="M13">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@join attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>warning&#x2028;Each value in @join must correspond to the @xml:id attribute of an element. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.layer.log-def-check_defTarget_layer-constraint-13-->


	  <!--RULE -->
   <xsl:template match="layer/@def" priority="1000" mode="M14">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@def attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:layerDef/@xml:id"/>
         <xsl:otherwise>warning&#x2028;The value in @def must correspond to the @xml:id attribute of a layerDef element. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.name-nymref-check_nymrefTarget-constraint-14-->


	  <!--RULE -->
   <xsl:template match="@nymref" priority="1000" mode="M15">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@nymref attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>warning&#x2028;The value in @nymref must correspond to the @xml:id attribute of an element. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.note.log-require_oct_and_pname_or_loc-constraint-15-->


	  <!--RULE -->
   <xsl:template match="mei:note" priority="1000" mode="M16">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (not(@pname and @oct) and not(@loc)) then false() else true()"/>
         <xsl:otherwise>&#x2028;either @pname and @oct or @loc must be specified on a note. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.plist-plist-check_plistTarget-constraint-16-->


	  <!--RULE -->
   <xsl:template match="@plist" priority="1000" mode="M17">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@plist attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>warning&#x2028;Each value in @plist must correspond to the @xml:id attribute of an element. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.responsibility-resp-check_respTarget-constraint-17-->


	  <!--RULE -->
   <xsl:template match="@resp" priority="1000" mode="M18">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@resp attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[ancestor::mei:meiHead]/@xml:id"/>
         <xsl:otherwise>warning&#x2028;The value in @resp must correspond to the @xml:id attribute of an element within the metadata header. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.staff.log-def-check_defTarget_staff-constraint-18-->


	  <!--RULE -->
   <xsl:template match="staff/@def" priority="1000" mode="M19">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@def attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:staffDef/@xml:id"/>
         <xsl:otherwise>warning&#x2028;The value in @def must correspond to the @xml:id attribute of a staffDef element. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.startendid-endid-check_endidTarget-constraint-19-->


	  <!--RULE -->
   <xsl:template match="@endid" priority="1000" mode="M20">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@endid attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>warning&#x2028;The value in @endid must correspond to the @xml:id attribute of an element. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.startid-startid-check_startidTarget-constraint-20-->


	  <!--RULE -->
   <xsl:template match="@startid" priority="1000" mode="M21">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@startid attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>warning&#x2028;The value in @startid must correspond to the @xml:id attribute of an element. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.typed-subtype-When_subtype-constraint-21-->


	  <!--RULE -->
   <xsl:template match="mei:*[@subtype]" priority="1000" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@type"/>
         <xsl:otherwise>&#x2028;An element with a subtype attribute must have a type attribute. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-annot-annot_content_constraint-constraint-22-->


	  <!--RULE -->
   <xsl:template match="mei:annot[mei:head or mei:lg or mei:p or mei:quote or mei:table]" priority="1000" mode="M23">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(mei:head[preceding-sibling::*[not(local-name()='head')]])"/>
         <xsl:otherwise>&#x2028;Head elements can only occur at the start of annot. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(*[../text()[normalize-space()]])"/>
         <xsl:otherwise>&#x2028;Mixed content is not allowed when head, lg, p, quote, or table is used. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(*[not(local-name() eq 'biblList' or local-name() eq 'castList' or local-name() eq 'head' or               local-name() eq 'lg' or local-name() eq 'list' or local-name() eq 'p' or local-name() eq 'quote' or               local-name() eq 'table')])"/>
         <xsl:otherwise>&#x2028;Unstructured text not allowed when head, lg, p, quote, or table elements are used. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-barLine-Check_barLinetaktplace-constraint-23-->


	  <!--RULE -->
   <xsl:template match="mei:barLine[@taktplace]" priority="1000" mode="M24">
      <xsl:variable name="staff" select="ancestor::mei:staff/@n"/>
      <xsl:variable name="staffpos" select="count(ancestor::mei:staff/preceding-sibling::mei:staff)               + 1"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="number(@taktplace) &lt;= number(2 *               preceding::mei:staffDef[@n=$staff and @lines][1]/@lines)"/>
         <xsl:otherwise>&#x2028; </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-chord-chord_notes_same_dur-constraint-24-->


	  <!--RULE -->
   <xsl:template match="mei:chord[@dur][count(distinct-values(for $n in descendant::mei:note return $n/@dur)) &gt; 0]" priority="1000" mode="M25">
      <xsl:variable name="durs" select="distinct-values(for $n in descendant::mei:note return $n/@dur)"/>
      <xsl:variable name="durs_count" select="count(distinct-values($durs)) + count(descendant::mei:note[not(@dur)])"/>

		    <!--REPORT -->
      <xsl:if test="$durs_count &gt; 1 or not($durs[1] = @dur)">&#x2028;Duration of chord and constituent notes must match. </xsl:if>
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-clef-Clef_position_lines-constraint-25-->


	  <!--RULE -->
   <xsl:template match="mei:clef[ancestor::mei:staffDef[@lines]]" priority="1000" mode="M26">
      <xsl:variable name="thisstaff" select="ancestor::mei:staffDef/@n"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="number(@line) &lt;=               number(ancestor::mei:staffDef[@n=$thisstaff and @lines][1]/@lines)"/>
         <xsl:otherwise>&#x2028;The clef position must be less than or equal to the number of lines on the staff. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-clef-Clef_position_nolines-constraint-26-->


	  <!--RULE -->
   <xsl:template match="mei:clef[ancestor::mei:staffDef[not(@lines)]]" priority="1000" mode="M27">
      <xsl:variable name="thisstaff" select="ancestor::mei:staffDef/@n"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="number(@line) &lt;=               number(preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines)"/>
         <xsl:otherwise>&#x2028;The clef position must be less than or equal to the number of lines on the staff. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-dir-dir_start-type_attributes_required-constraint-27-->


	  <!--RULE -->
   <xsl:template match="mei:dir[not(ancestor::mei:syllable)]" priority="1000" mode="M28">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-dynam-dynam_start-type_attributes_required-constraint-28-->


	  <!--RULE -->
   <xsl:template match="mei:dynam" priority="1000" mode="M29">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-dynam-dynam_end-type_attributes-constraint-29-->


	  <!--RULE -->
   <xsl:template match="mei:dynam[@val2]" priority="1000" mode="M30">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>&#x2028;When @val2 is present, either @dur, @dur.ges, @endid, or @tstamp2 must also be present. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-grpSym-check_grpSym_attributes_scoreDef-constraint-30-->


	  <!--RULE -->
   <xsl:template match="mei:grpSym[parent::mei:scoreDef]" priority="1000" mode="M31">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid and @endid and @level"/>
         <xsl:otherwise>&#x2028;In this context, grpSym must have startid, endid, and level attributes. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-grpSym-check_grpSym_attributes_staffDef-constraint-31-->


	  <!--RULE -->
   <xsl:template match="mei:grpSym[parent::mei:staffGrp]" priority="1000" mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(@startid or @endid or @level)"/>
         <xsl:otherwise>&#x2028;In this context, grpSym must not have startid, endid, or level attributes. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-keyAccid-Check_keyAccidPlacement-constraint-32-->


	  <!--RULE -->
   <xsl:template match="mei:keyAccid" priority="1000" mode="M33">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(@x and @y) or @loc"/>
         <xsl:otherwise>&#x2028;The @x and @y pair of attributes or @loc required. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-keySig-key_att_pair-constraint-33-->


	  <!--RULE -->
   <xsl:template match="mei:keySig" priority="1000" mode="M34">

		<!--REPORT -->
      <xsl:if test="not(@pname and @mode)">&#x2028;Key signature must be complete (both @pname and @mode are required). </xsl:if>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-mei-Check_staff-constraint-34-->


	  <!--RULE -->
   <xsl:template match="mei:*[@staff]" priority="1000" mode="M35">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(@staff, '\s+') satisfies $i=//mei:staffDef/@n"/>
         <xsl:otherwise>&#x2028;The values in @staff must correspond to @n attribute of a staffDef element. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-note-require_out_of_chord-constraint-35-->


	  <!--RULE -->
   <xsl:template match="mei:note" priority="1000" mode="M36">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (not(ancestor::mei:chord) and not(@dur)) then false() else true()"/>
         <xsl:otherwise>&#x2028;Must have dur attribute. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-note-no_stem_in_chord-constraint-36-->


	  <!--RULE -->
   <xsl:template match="mei:note[ancestor::mei:chord]" priority="1000" mode="M37">

		<!--REPORT -->
      <xsl:if test="@stem.dir or @stem.len or @stem.pos or @stem.x or @stem.y">&#x2028;Stem attributes not permitted on notes within a chord. </xsl:if>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-ornam-ornam_start-type_attributes_required-constraint-37-->


	  <!--RULE -->
   <xsl:template match="mei:ornam" priority="1000" mode="M38">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-phrase-phrase_start-_and_end-type_attributes_required-constraint-38-->


	  <!--RULE -->
   <xsl:template match="mei:phrase" priority="1000" mode="M39">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: dur, dur.ges, endid, or tstamp2 </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-phrase-phrase_containing_curve-constraint-39-->


	  <!--RULE -->
   <xsl:template match="mei:phrase[mei:curve[@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or             @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2]]" priority="1000" mode="M40">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or               @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2)"/>
         <xsl:otherwise>warning&#x2028;The visual attributes of the phrase (@bezier, @bulge, @curvedir, @lform, @lwidth, @ho, @startho, @endho, @to, @startto, @endto, @vo, @startvo, @endvo, @x, @y, @x2, and @y2) will be overridden by visual attributes of the contained curve elements. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-rest-Check_restline-constraint-40-->


	  <!--RULE -->
   <xsl:template match="mei:rest[@line]" priority="1000" mode="M41">
      <xsl:variable name="thisstaff" select="ancestor::mei:staff/@n"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="number(@line) &lt;=               number(preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines)"/>
         <xsl:otherwise>&#x2028;The value of @line must be less than or equal to the number of lines on the staff. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-section-Check_sectionexpansion-constraint-41-->


	  <!--RULE -->
   <xsl:template match="mei:section[mei:expansion]" priority="1000" mode="M42">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="descendant::mei:section|descendant::mei:ending|descendant::mei:rdg"/>
         <xsl:otherwise>&#x2028;Must have descendant section, ending, or rdg elements that can be pointed to. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-staffDef-Check_staffDefn-constraint-42-->


	  <!--RULE -->
   <xsl:template match="mei:staffDef" priority="1000" mode="M43">
      <xsl:variable name="thisstaff" select="@n"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@n"/>
         <xsl:otherwise>&#x2028;A staffDef must have an n attribute. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@lines or preceding::mei:staffDef[@n=$thisstaff and @lines]"/>
         <xsl:otherwise>&#x2028;The first occurrence of a staff must declare the number of staff lines. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(mei:clef) + count(mei:clefGrp) &lt; 2"/>
         <xsl:otherwise>&#x2028;Only one clef or clefGrp is permitted. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-staffDef-Check_ancestor_staff-constraint-43-->


	  <!--RULE -->
   <xsl:template match="mei:staffDef[ancestor::mei:staff]" priority="1000" mode="M44">
      <xsl:variable name="thisstaff" select="@n"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ancestor::mei:staff/@n eq $thisstaff"/>
         <xsl:otherwise>&#x2028;If a staffDef appears in a staff, it must bear the same @n than this staff. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-staffDef-Check_clef_position_staffDef-constraint-44-->


	  <!--RULE -->
   <xsl:template match="mei:staffDef[@clef.line and @lines]" priority="1000" mode="M45">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="number(@clef.line) &lt;= number(@lines)"/>
         <xsl:otherwise>&#x2028;The clef position must be less than or equal to the number of lines on the staff. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-staffDef-Check_clef_position_staffDef_nolines-constraint-45-->


	  <!--RULE -->
   <xsl:template match="mei:staffDef[@clef.line and not(@lines)]" priority="1000" mode="M46">
      <xsl:variable name="thisstaff" select="@n"/>
      <xsl:variable name="stafflines" select="preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="number(@clef.line) &lt;= number($stafflines)"/>
         <xsl:otherwise>&#x2028;The clef position must be less than or equal to the number of lines on the staff. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-staffDef-Check_tab_strings_lines-constraint-46-->


	  <!--RULE -->
   <xsl:template match="mei:staffDef[@tab.strings and @lines]" priority="1000" mode="M47">
      <xsl:variable name="countTokens" select="count(tokenize(normalize-space(@tab.strings), '\s'))"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$countTokens = 1 or $countTokens = @lines"/>
         <xsl:otherwise>&#x2028;The tab.strings attribute must have the same number of values as there are staff lines. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-staffDef-Check_tab_strings_nolines-constraint-47-->


	  <!--RULE -->
   <xsl:template match="mei:staffDef[@tab.strings and not(@lines)]" priority="1000" mode="M48">
      <xsl:variable name="countTokens" select="count(tokenize(normalize-space(@tab.strings), '\s'))"/>
      <xsl:variable name="thisStaff" select="@n"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$countTokens = 1 or $countTokens = preceding::mei:staffDef[@n=$thisStaff and @lines][1]/@lines"/>
         <xsl:otherwise>&#x2028;The tab.strings attribute must have the same number of values as there are staff lines. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M48"/>
   <xsl:template match="@*|node()" priority="-2" mode="M48">
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="mei:staffDef[@lines.color and @lines]" priority="1001" mode="M49">
      <xsl:variable name="countTokens" select="count(tokenize(normalize-space(@lines.color), '\s'))"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$countTokens = 1 or $countTokens = @lines"/>
         <xsl:otherwise>&#x2028;The lines.color attribute must have either 1) a single value or 2) the same number of values as there are staff lines. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="mei:staffDef[@lines.color and not(@lines)]" priority="1000" mode="M49">
      <xsl:variable name="countTokens" select="count(tokenize(normalize-space(@lines.color), '\s'))"/>
      <xsl:variable name="thisStaff" select="@n"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$countTokens = 1 or $countTokens = preceding::mei:staffDef[@n=$thisStaff and @lines][1]/@lines"/>
         <xsl:otherwise>&#x2028;The lines.color attribute must have either 1) a single value or 2) the same number of values as there are staff lines. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M49"/>
   <xsl:template match="@*|node()" priority="-2" mode="M49">
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="mei:staffDef[@ppq][ancestor::mei:scoreDef[@ppq]]" priority="1000" mode="M50">
      <xsl:variable name="staffPPQ" select="@ppq"/>
      <xsl:variable name="scorePPQ" select="ancestor::mei:scoreDef[@ppq][1]/@ppq"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="($scorePPQ mod $staffPPQ) = 0"/>
         <xsl:otherwise>&#x2028;The value of ppq must be a factor of the value of ppq on an ancestor scoreDef. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M50"/>
   <xsl:template match="@*|node()" priority="-2" mode="M50">
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="mei:staffDef[@ppq][preceding::mei:scoreDef[@ppq]]" priority="1000" mode="M51">
      <xsl:variable name="staffPPQ" select="@ppq"/>
      <xsl:variable name="scorePPQ" select="preceding::mei:scoreDef[@ppq][1]/@ppq"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="($scorePPQ mod $staffPPQ) = 0"/>
         <xsl:otherwise>&#x2028;The value of ppq must be a factor of the value of ppq on a preceding scoreDef. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M51"/>
   <xsl:template match="@*|node()" priority="-2" mode="M51">
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-staffGrp-Check_staffGrp_unique_staff_n_values-constraint-52-->


	  <!--RULE -->
   <xsl:template match="mei:staffGrp" priority="1000" mode="M52">
      <xsl:variable name="countstaves" select="count(descendant::mei:staffDef)"/>
      <xsl:variable name="countuniqstaves" select="count(distinct-values(descendant::mei:staffDef/@n))"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$countstaves eq $countuniqstaves"/>
         <xsl:otherwise>&#x2028;Each staffDef must have a unique value for the n attribute. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M52"/>
   <xsl:template match="@*|node()" priority="-2" mode="M52">
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-tempo-tempo_in_header_disallow_most_attrs-constraint-53-->


	  <!--RULE -->
   <xsl:template match="mei:tempo[ancestor::mei:meiHead]" priority="1000" mode="M53">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(@*[name() != 'label' and name() != 'n' and name() != 'xml:base' and name() != 'xml:id' and name() != 'xml:lang'])"/>
         <xsl:otherwise>&#x2028;Only label, n, xml:base, xml:id, and xml:lang attributes allowed when this element occurs in the header. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M53"/>
   <xsl:template match="@*|node()" priority="-2" mode="M53">
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-tempo-tempo_start-type_attributes_required-constraint-54-->


	  <!--RULE -->
   <xsl:template match="mei:tempo[not(ancestor::mei:syllable) and not(ancestor::mei:work) and not(ancestor::mei:expression) and not(count(ancestor::mei:*) = 0)]" priority="1000" mode="M54">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M54"/>
   <xsl:template match="@*|node()" priority="-2" mode="M54">
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-change-change_requirements-constraint-55-->


	  <!--RULE -->
   <xsl:template match="mei:change" priority="1000" mode="M55">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@isodate or mei:date"/>
         <xsl:otherwise>&#x2028;The date of the change must be recorded in an isodate attribute or date element. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@resp or mei:respStmt"/>
         <xsl:otherwise>&#x2028;The person responsible for the change must be recorded in a resp attribute or respStmt element. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M55"/>
   <xsl:template match="@*|node()" priority="-2" mode="M55">
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-incipCode-Check_incipCode_form_mimetype-constraint-56-->


	  <!--RULE -->
   <xsl:template match="mei:incipCode" priority="1000" mode="M56">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@form or @mimetype"/>
         <xsl:otherwise>&#x2028;incipCode must have a form or mimetype attribute. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M56"/>
   <xsl:template match="@*|node()" priority="-2" mode="M56">
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-beam-When_not_copyof_beam_content-constraint-57-->


	  <!--RULE -->
   <xsl:template match="mei:beam[not(@copyof)]" priority="1000" mode="M57">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(descendant::*[local-name()='note' or local-name()='rest' or               local-name()='chord' or local-name()='space']) &gt; 1"/>
         <xsl:otherwise>&#x2028;A beam without a copyof attribute must have at least 2 note, rest, chord, or space descendants. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M57"/>
   <xsl:template match="@*|node()" priority="-2" mode="M57">
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-beamSpan-beamspan_start-_and_end-type_attributes_required-constraint-58-->


	  <!--RULE -->
   <xsl:template match="mei:beamSpan" priority="1000" mode="M58">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: dur, dur.ges, endid, or tstamp2 </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M58"/>
   <xsl:template match="@*|node()" priority="-2" mode="M58">
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-bend-bend_start-_and_end-type_attributes_required-constraint-59-->


	  <!--RULE -->
   <xsl:template match="mei:bend" priority="1000" mode="M59">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: dur, dur.ges, endid, or tstamp2 </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M59"/>
   <xsl:template match="@*|node()" priority="-2" mode="M59">
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-breath-breath_start-type_attributes_required-constraint-60-->


	  <!--RULE -->
   <xsl:template match="mei:breath" priority="1000" mode="M60">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M60"/>
   <xsl:template match="@*|node()" priority="-2" mode="M60">
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-fermata-fermata_start-type_attributes_required-constraint-61-->


	  <!--RULE -->
   <xsl:template match="mei:fermata" priority="1000" mode="M61">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M61"/>
   <xsl:template match="@*|node()" priority="-2" mode="M61">
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-gliss-gliss_start-_and_end-type_attributes_required-constraint-62-->


	  <!--RULE -->
   <xsl:template match="mei:gliss" priority="1000" mode="M62">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: dur, dur.ges, endid, or tstamp2 </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M62"/>
   <xsl:template match="@*|node()" priority="-2" mode="M62">
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-hairpin-hairpin_start-_and_end-type_attributes_required-constraint-63-->


	  <!--RULE -->
   <xsl:template match="mei:hairpin" priority="1000" mode="M63">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: dur, dur.ges, endid, or tstamp2 </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M63"/>
   <xsl:template match="@*|node()" priority="-2" mode="M63">
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-harpPedal-harpPedal_start-type_attributes_required-constraint-64-->


	  <!--RULE -->
   <xsl:template match="mei:harpPedal" priority="1000" mode="M64">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M64"/>
   <xsl:template match="@*|node()" priority="-2" mode="M64">
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-meterSig-meter_att_pair-constraint-65-->


	  <!--RULE -->
   <xsl:template match="mei:meterSig" priority="1000" mode="M65">

		<!--REPORT -->
      <xsl:if test="not(@count and @unit)">&#x2028;Time signature must be complete (both @count and @unit are required). </xsl:if>
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M65"/>
   <xsl:template match="@*|node()" priority="-2" mode="M65">
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-octave-octave_start-_and_end-type_attributes_required-constraint-66-->


	  <!--RULE -->
   <xsl:template match="mei:octave" priority="1000" mode="M66">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: dur, dur.ges, endid, or tstamp2 </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M66"/>
   <xsl:template match="@*|node()" priority="-2" mode="M66">
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="mei:measure/mei:ossia" priority="1001" mode="M67">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(mei:*) = count(mei:staff)"/>
         <xsl:otherwise>&#x2028;Ossia may contain only staff elements in this context. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="mei:staff/mei:ossia" priority="1000" mode="M67">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(mei:*) = count(mei:layer)"/>
         <xsl:otherwise>&#x2028;Ossia may contain only layer elements in this context. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M67"/>
   <xsl:template match="@*|node()" priority="-2" mode="M67">
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-pedal-pedal_style_consistent-constraint-69-->


	  <!--RULE -->
   <xsl:template match="mei:pedal[@form][@dir=('bounce', 'up')]" priority="1000" mode="M68">
      <xsl:variable name="form" select="@form"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="preceding::mei:pedal[@dir=('down', 'half')][1][@form=$form]"/>
         <xsl:otherwise>&#x2028;Pedal styles must be consistent between pedal down and pedal up. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M68"/>
   <xsl:template match="@*|node()" priority="-2" mode="M68">
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-pedal-pedal_start-type_attributes_required-constraint-70-->


	  <!--RULE -->
   <xsl:template match="mei:pedal" priority="1000" mode="M69">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M69"/>
   <xsl:template match="@*|node()" priority="-2" mode="M69">
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-slur-slur_start-_and_end-type_attributes_required-constraint-71-->


	  <!--RULE -->
   <xsl:template match="mei:slur" priority="1000" mode="M70">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: dur, dur.ges, endid, or tstamp2 </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M70"/>
   <xsl:template match="@*|node()" priority="-2" mode="M70">
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-slur-slur_containing_curve-constraint-72-->


	  <!--RULE -->
   <xsl:template match="mei:slur[mei:curve[@bezier or @bulge or @curvedir or @lform or @lwidth or             @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or             @x or @y or @x2 or @y2]]" priority="1000" mode="M71">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or               @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2)"/>
         <xsl:otherwise>warning&#x2028;The visual attributes of the slur (@bezier, @bulge, @curvedir, @lform, @lwidth, @ho, @startho, @endho, @to, @startto, @endto, @vo, @startvo, @endvo, @x, @y, @x2, and @y2) will be overridden by visual attributes of the contained curve elements. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M71"/>
   <xsl:template match="@*|node()" priority="-2" mode="M71">
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-tie-tie_start-_and_end-type_attributes_required-constraint-73-->


	  <!--RULE -->
   <xsl:template match="mei:tie" priority="1000" mode="M72">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: dur, dur.ges, endid, or tstamp2 </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M72"/>
   <xsl:template match="@*|node()" priority="-2" mode="M72">
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-tie-tie_containing_curve-constraint-74-->


	  <!--RULE -->
   <xsl:template match="mei:tie[mei:curve[@bezier or @bulge or @curvedir or @lform or @lwidth or             @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or             @endvo or @x or @y or @x2 or @y2]]" priority="1000" mode="M73">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or               @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2)"/>
         <xsl:otherwise>warning&#x2028;The visual attributes of the tie (@bezier, @bulge, @curvedir, @lform, @lwidth, @ho, @startho, @endho, @to, @startto, @endto, @vo, @startvo, @endvo, @x, @y, @x2, and @y2) will be overridden by visual attributes of the contained curve elements. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M73"/>
   <xsl:template match="@*|node()" priority="-2" mode="M73">
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-tuplet-When_not_copyof_tuplet_content-constraint-75-->


	  <!--RULE -->
   <xsl:template match="mei:tuplet[not(@copyof)]" priority="1000" mode="M74">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(descendant::*[local-name()='note' or local-name()='rest' or               local-name()='chord']) &gt; 1"/>
         <xsl:otherwise>&#x2028;A tuplet without a copyof attribute must have at least 2 note, rest, or chord descendants. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M74"/>
   <xsl:template match="@*|node()" priority="-2" mode="M74">
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-tupletSpan-tupletSpan_start-_and_end-type_attributes_required-constraint-76-->


	  <!--RULE -->
   <xsl:template match="mei:tupletSpan" priority="1000" mode="M75">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: dur, dur.ges, endid, or tstamp2 </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M75"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M75"/>
   <xsl:template match="@*|node()" priority="-2" mode="M75">
      <xsl:apply-templates select="*" mode="M75"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-mordent-mordent_start-type_attributes_required-constraint-77-->


	  <!--RULE -->
   <xsl:template match="mei:mordent" priority="1000" mode="M76">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M76"/>
   <xsl:template match="@*|node()" priority="-2" mode="M76">
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-trill-trill_start-type_attributes_required-constraint-78-->


	  <!--RULE -->
   <xsl:template match="mei:trill" priority="1000" mode="M77">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M77"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M77"/>
   <xsl:template match="@*|node()" priority="-2" mode="M77">
      <xsl:apply-templates select="*" mode="M77"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-turn-turn_start-type_attributes_required-constraint-79-->


	  <!--RULE -->
   <xsl:template match="mei:turn" priority="1000" mode="M78">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>&#x2028;Must have one of the attributes: startid, tstamp, tstamp.ges or tstamp.real </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M78"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M78"/>
   <xsl:template match="@*|node()" priority="-2" mode="M78">
      <xsl:apply-templates select="*" mode="M78"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.source-source-check_sourceTarget-constraint-80-->


	  <!--RULE -->
   <xsl:template match="@source" priority="1000" mode="M79">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@source attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:source/@xml:id"/>
         <xsl:otherwise>warning&#x2028;Each value in @source must correspond to the @xml:id attribute of a source element. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M79"/>
   <xsl:template match="@*|node()" priority="-2" mode="M79">
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-handShift-new-check_newTarget-constraint-81-->


	  <!--RULE -->
   <xsl:template match="@new" priority="1000" mode="M80">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@new attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:hand/@xml:id"/>
         <xsl:otherwise>warning&#x2028;The value in @new must correspond to the @xml:id attribute of a hand element. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M80"/>
   <xsl:template match="@*|node()" priority="-2" mode="M80">
      <xsl:apply-templates select="*" mode="M80"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-handShift-old-check_oldTarget-constraint-82-->


	  <!--RULE -->
   <xsl:template match="@old" priority="1000" mode="M81">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@old attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:hand/@xml:id"/>
         <xsl:otherwise>warning&#x2028;The value in @old must correspond to the @xml:id attribute of a hand element. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M81"/>
   <xsl:template match="@*|node()" priority="-2" mode="M81">
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.extsym-glyphnum-check_glyphnum-constraint-83-->


	  <!--RULE -->
   <xsl:template match="mei:*[starts-with(@glyphnum, 'U+')]" priority="1000" mode="M82">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="string-length(@glyphnum) = 6"/>
         <xsl:otherwise>warning&#x2028;SMuFL version 1.18 uses the range U+E000 - U+ECBF. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M82"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M82"/>
   <xsl:template match="@*|node()" priority="-2" mode="M82">
      <xsl:apply-templates select="*" mode="M82"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-fing-stack_exclusion-constraint-84-->


	  <!--RULE -->
   <xsl:template match="mei:fing" priority="1000" mode="M83">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(descendant::mei:stack)"/>
         <xsl:otherwise>&#x2028;The stack element is not allowed anywhere in fing. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M83"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M83"/>
   <xsl:template match="@*|node()" priority="-2" mode="M83">
      <xsl:apply-templates select="*" mode="M83"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-fingGrp-require_fingeringLike_children-constraint-85-->


	  <!--RULE -->
   <xsl:template match="mei:fingGrp" priority="1000" mode="M84">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(mei:fing) + count(mei:fingGrp) &gt; 1"/>
         <xsl:otherwise>&#x2028;At least 2 fing or fingGrp elements are required. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M84"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M84"/>
   <xsl:template match="@*|node()" priority="-2" mode="M84">
      <xsl:apply-templates select="*" mode="M84"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="mei:fingGrp[not(ancestor::mei:fingGrp)][@tstamp or @startid]" priority="1001" mode="M85">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(child::mei:*[@tstamp or @startid])"/>
         <xsl:otherwise>&#x2028;When @tstamp or @startid is present on fingGrp, its child elements cannot have a @tstamp or @startid attribute. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M85"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="mei:fingGrp[not(ancestor::mei:fingGrp)][not(@tstamp or @startid)]" priority="1000" mode="M85">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(descendant::mei:*[@tstamp or @startid]) = count(child::mei:*[local-name()='fing' or local-name()='fingGrp'])"/>
         <xsl:otherwise>&#x2028;When @tstamp or @startid is not present on fingGrp, each of its child elements must have a @tstamp or @startid attribute. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M85"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M85"/>
   <xsl:template match="@*|node()" priority="-2" mode="M85">
      <xsl:apply-templates select="*" mode="M85"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-list-list_type_constraint-constraint-88-->


	  <!--RULE -->
   <xsl:template match="mei:list[@type='gloss']" priority="1000" mode="M86">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(mei:label) = count(mei:li)"/>
         <xsl:otherwise>&#x2028;In a list of type "gloss" all items must be immediately preceded by a label. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M86"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M86"/>
   <xsl:template match="@*|node()" priority="-2" mode="M86">
      <xsl:apply-templates select="*" mode="M86"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.altsym-altsym-check_altsymTarget-constraint-89-->


	  <!--RULE -->
   <xsl:template match="@altsym" priority="1000" mode="M87">

		<!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>warning&#x2028;@altsym attribute has no content. </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:symbolDef/@xml:id"/>
         <xsl:otherwise>warning&#x2028;The value in @altsym must correspond to the @xml:id attribute of a symbolDef element. </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M87"/>
   <xsl:template match="@*|node()" priority="-2" mode="M87">
      <xsl:apply-templates select="*" mode="M87"/>
   </xsl:template>

   <!--PATTERN tido.sibelius-att.controlevent.strict-require_layer_when_staff_is_not_multivalued-constraint-90-->


	  <!--RULE -->
   <xsl:template match="mei:slur|mei:hairpin" priority="1000" mode="M88">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (not(contains(@staff, ' ')) and not(@layer)) then false() else true()"/>
         <xsl:otherwise>&#x2028;@layer must be specified unless @staff is multi-valued. </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M88"/>
   <xsl:template match="@*|node()" priority="-2" mode="M88">
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>
</xsl:stylesheet>