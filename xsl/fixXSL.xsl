<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:XSL="http://www.w3.org/1999/XSL/TransformAlias"
                version="2.0">

  <xsl:template match="*">
      <xsl:copy>
         <xsl:apply-templates select="@*|*|text()|comment()|processing-instruction()"/>
      </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|comment()|text()|processing-instruction()">
      <xsl:copy/>
  </xsl:template>

    <!--
    Remove xsl:apply-templates children from all xsl:template elements
    matching an attribute so Saxon doesn't flood the console with the
    warning that xsl:apply-templates select="*" will never match a node
    -->
  <xsl:template match="xsl:apply-templates[@select='*'][matches(parent::xsl:template/@match, '@[\w]+$')]"/>

</xsl:stylesheet>
