<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                xmlns:s0="www.boltrics.nl/sendshipments4o:v1.00">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no" />
  
  <xsl:template match="/">
    <xsl:apply-templates select="/s0:Message/s0:Documents/s0:Document" />
  </xsl:template>  
  
  <xsl:template match="/s0:Message/s0:Documents/s0:Document">   
    <xsl:for-each select="s0:DocumentLines/s0:DocumentLine">
      <xsl:text>S</xsl:text>
      <xsl:value-of select="//s0:Document/s0:No"/>
      <xsl:value-of select="codepoints-to-string(for $i in 1 to (41) return 32)"/>
      <!-- <xsl:text>00000000</xsl:text> -->
      <xsl:value-of select="format-number(ceiling(s0:LineNo div 10000), '0000000000')" />
      <xsl:value-of select="codepoints-to-string(for $i in 1 to (40) return 32)"/>
      <xsl:value-of select="substring(concat(s0:No, '                  '), 1, 18)" />
      <xsl:value-of select="codepoints-to-string(for $i in 1 to (32) return 32)"/>
      <xsl:value-of select="format-number(s0:QuantityBase, '00000000000000000')" />
      <xsl:text>SDD</xsl:text>
      <xsl:value-of select="codepoints-to-string(for $i in 1 to (332) return 32)"/>
      <xsl:text>0000000000</xsl:text>
      <xsl:value-of select="codepoints-to-string(for $i in 1 to (54) return 32)"/>
      
      <xsl:value-of select="substring(concat(//s0:Document/s0:ShipToAddress/s0:Name, '                                   '), 1, 35)"/>
      <xsl:value-of select="substring(concat(//s0:Document/s0:ShipToAddress/s0:Address, '                                   '), 1, 35)"/>
      <xsl:value-of select="substring(concat(//s0:Document/s0:ShipToAddress/s0:City, '                                   '), 1, 35)"/>
      <xsl:value-of select="substring(concat(//s0:Document/s0:ShipToAddress/s0:PostCode, '         '), 1, 9)"/>
      <xsl:value-of select="substring(concat(//s0:Document/s0:ShipToAddress/s0:CountryRegionCode, '  '), 1, 2)"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="substring(concat(s0:CalculatedTripNo, '         '), 1, 9)"/>
      <xsl:text>&#10;</xsl:text> 
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>