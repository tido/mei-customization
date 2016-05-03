<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:XSL="http://www.w3.org/1999/XSL/TransformAlias"
                version="2.0">

  <xsl:import href="../../../vendor/iso-schematron-xslt2/iso_schematron_skeleton_for_saxon.xsl"/>

  <xsl:variable name="softLineBreak" select="'&#x2028;'"/>
  <xsl:variable name="regularLineBreak" select="'&#x2029;'"/>

  <xsl:template name="process-prolog">
    <XSL:output method="text"/>
  </xsl:template>

  <xsl:template name="process-message">
    <xsl:param name="pattern"/>
    <xsl:param name="role"/>
    <xsl:variable name="text">
      <xsl:apply-templates mode="text"/>
    </xsl:variable>

    <xsl:value-of select="$role"/>
    <xsl:value-of select="$softLineBreak"/>
    <xsl:value-of select="normalize-space($text)"/>
    <xsl:value-of select="$regularLineBreak"/>
  </xsl:template>
</xsl:stylesheet>
