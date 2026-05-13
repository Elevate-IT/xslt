<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map">
  
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  
  <xsl:template match="/">
    <!-- Step 1: parse the JSON text into an XDM map -->
    <xsl:variable name="json" select="parse-json(/input)"/>
    
    <!-- Step 2: extract the "value" string from the map -->
    <xsl:variable name="escaped" select="map:get($json, 'value')"/>
    
    <!-- Step 3: parse the escaped XML string into a node-tree -->
    <xsl:variable name="inner" select="parse-xml($escaped)"/>
    
    <!-- Step 4: apply templates against the inner Response -->
    <xsl:apply-templates select="$inner/Response"/>
  </xsl:template>
  
  <!-- Identity copy -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>