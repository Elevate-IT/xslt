<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="3.0"
                xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
  
  <xsl:mode on-no-match="shallow-copy"/>
  
  <xsl:output method="text"/>
  
  <xsl:template match="/*:input">
    <xsl:variable name="input-as-xml" select="json-to-xml(current())"/>
    <xsl:variable name="transformed-xml" as="document-node()">
      <xsl:apply-templates select="$input-as-xml"/>
    </xsl:variable>
    
    <xsl:value-of select="xml-to-json($transformed-xml)"/>
  </xsl:template>
  
  <xsl:template match="array[@key = 'packages']/map/string[@key = 'description']/text()">
    <xsl:value-of select="../../map[@key = 'deliveryNoteInfo']/array[@key = 'deliveryNoteLines'][1]/map/string[@key = 'articleName']"/>
  </xsl:template>
</xsl:stylesheet>