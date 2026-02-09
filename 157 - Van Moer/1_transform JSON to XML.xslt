<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="3.0"
                xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
  
  <xsl:output method="xml" indent="true"/>
  
  <xsl:template match="/*:input">
    <xsl:copy-of select="json-to-xml(current())"/>
  </xsl:template>
</xsl:stylesheet>