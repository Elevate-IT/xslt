<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="3.0"
                xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
  
  <xsl:mode on-no-match="shallow-copy"/>
  
  <xsl:output method="xml" indent="true"/>
  
  <xsl:template match="array[@key = 'packages']/map/string[@key = 'description']/text()">
    <xsl:value-of select="../../map[@key = 'deliveryNoteInfo']/array[@key = 'deliveryNoteLines'][1]/map/string[@key = 'articleName']"/>
  </xsl:template>
</xsl:stylesheet>