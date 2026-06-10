<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="msxsl"
                version="3.0">
  
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" indent="yes"/>
  <xsl:strip-space elements="*"/>
  
  <xsl:template match="/Messages">
    <xsl:apply-templates select="*" />
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:element name="ns0:{local-name()}" namespace="www.boltrics.nl/materialmasterdata:v1.00">
      <xsl:apply-templates select="@*|node()" />
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="@*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>
</xsl:stylesheet>