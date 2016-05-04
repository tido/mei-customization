<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="tei html"
    version="2.0">

    <xsl:import href="../../../../vendor/stylesheets/html/html.xsl"/>

    <xsl:param name="institution"></xsl:param>
    <xsl:param name="homeLabel">TIDO</xsl:param>
    <xsl:param name="homeURL">http://tido-music.com</xsl:param>
    <xsl:param name="homeWords">TIDO</xsl:param>
    <!-- <xsl:param name="feedbackURL">http://tido-music.com</xsl:param> -->
    <!-- <xsl:param name="searchURL">http://google.com</xsl:param> -->
    <xsl:param name="numberBackHeadings"></xsl:param>

   <xsl:output method="xhtml" omit-xml-declaration="yes" encoding="utf-8"/>

    <xsl:template match="html:*">
      <xsl:element name="{local-name()}">
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:template>

    <xsl:template match="html:*/comment()">
      <xsl:copy-of select="."/>
    </xsl:template>

  <xsl:template match="tei:div[@type='frontispiece']">
      <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:div[@type='illustration']">
      <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
