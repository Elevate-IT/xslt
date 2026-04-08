<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="3.0"
                xmlns:ns0="www.boltrics.nl/sendshipment:v1.00">
  <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes"/>
  <xsl:strip-space elements="*"/>
  
  <xsl:template match="/">
    <xsl:for-each select="/ns0:Message/ns0:Documents/ns0:Document">
      <xsl:call-template name="emit-k-line"/>
      <xsl:call-template name="emit-p-and-s-lines"/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="emit-k-line">
    <xsl:value-of select="concat('K',codepoints-to-string(for $i in 1 to (16 - string-length('K')) return 32))"/>
    <xsl:value-of select="normalize-space(ns0:No)"/>
    <xsl:text>|</xsl:text>
    <xsl:value-of select="normalize-space(ns0:DocumentDate)"/>
    <xsl:text>|</xsl:text>
    <xsl:value-of select="normalize-space(ns0:ExternalDocumentNo)"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>
  
  <xsl:template name="emit-p-and-s-lines">
    <xsl:variable name="doc" select="."/>
    
    <xsl:for-each-group select="ns0:DocumentLines/ns0:DocumentLine[normalize-space(ns0:UnitofMeasureCode) != '']"
      group-by="normalize-space(ns0:UnitofMeasureCode)">
      <xsl:sort select="current-grouping-key()"/>
      
      <xsl:variable name="uom" select="current-grouping-key()"/>
      <xsl:variable name="qtySum" select="sum(current-group()/number(ns0:Quantity))"/>
      
      <xsl:text>P</xsl:text>
      <xsl:value-of select="$uom"/>
      <xsl:text>|</xsl:text>
      <xsl:value-of select="format-number($qtySum, '0.############')"/>
      <xsl:text>&#10;</xsl:text>
      
      <xsl:for-each-group select="$doc/ns0:DocumentLines/ns0:DocumentLine/ns0:DocumentDetailLines/ns0:DocumentDetailLine[normalize-space(ns0:UnitofMeasureCode) = $uom and normalize-space(ns0:CarrierNo) != '']"
        group-by="normalize-space(ns0:CarrierNo)">
        <xsl:sort select="current-grouping-key()"/>
        <xsl:value-of select="concat('S',codepoints-to-string(for $i in 1 to (3 - string-length('S')) return 32))"/>
        <xsl:value-of select="$uom"/>
        <xsl:value-of select="current-grouping-key()"/>
        <xsl:text>&#10;</xsl:text>
      </xsl:for-each-group>
    </xsl:for-each-group>
  </xsl:template>
</xsl:stylesheet>