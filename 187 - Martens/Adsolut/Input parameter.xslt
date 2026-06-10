<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="">
  
  <xsl:mode on-no-match="shallow-copy"/>
  
  <xsl:param name="input" />

  <xsl:output method="xml" indent="true" version="1.0" encoding="utf-8"/>
  
  <xsl:template match="/">
    <xsl:apply-templates select="$input"/>
  </xsl:template>
  
</xsl:stylesheet>
