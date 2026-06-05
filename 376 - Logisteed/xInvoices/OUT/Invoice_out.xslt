<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                xmlns:ns0="www.boltrics.nl/receivesapinvoice:v1.00">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
  <xsl:template match="/">
    <xsl:for-each select="//Header">
      <xsl:text>H</xsl:text>
      <xsl:text>0</xsl:text>
      <!-- Return 32 is unicode voor spatie -->
      <xsl:value-of select="concat(codepoints-to-string(for $i in 1 to (50 - string-length(InvoiceNumber)) return 32), InvoiceNumber)"/>
      <xsl:text>0000000000</xsl:text>
      <xsl:value-of select="concat('IN',codepoints-to-string(for $i in 1 to (30 - string-length('IN')) return 32))"/>
      <xsl:value-of select="InvoiceDate"/>
      <xsl:text>0000000000</xsl:text>
      <xsl:text>                                                                                                                                                                               </xsl:text>
      <xsl:value-of select="InvoiceCurrency"/>
      
      <!-- enter -->
      <xsl:text>&#10;</xsl:text> 
    </xsl:for-each>
    
    <xsl:for-each select="//Lines/Line">
      <xsl:if test="ERPLineNo != ''">
        <xsl:text>L</xsl:text>
        <xsl:text>0</xsl:text>
        <xsl:value-of select="concat(codepoints-to-string(for $i in 1 to (50 - string-length(//InvoiceNumber)) return 32), //InvoiceNumber)"/>
        <xsl:text>0000000000</xsl:text>
        <xsl:value-of select="concat('IN', codepoints-to-string(for $i in 1 to (30 - string-length('IN')) return 32))"/>
        <xsl:value-of select="substring(ERPLineNo, string-length(ERPLineNo) - 3)" />
        <xsl:value-of select="concat(ItemNo2, codepoints-to-string(for $i in 1 to (50 - string-length(ItemNo2)) return 32))"/>
        <xsl:value-of select="HSCode"/>
        <xsl:text>                    </xsl:text>
        <xsl:text>AIR CONDITIONING</xsl:text>
        <xsl:text>                                                                                                                                                                                                                                                                                                                                              </xsl:text>
        <xsl:value-of select="CountryOfOrigin"/>
        <xsl:text>    0000000000  </xsl:text>
        <xsl:value-of select="substring(GrossWeight, string-length(GrossWeight) - 16)" />
        <xsl:value-of select="substring(NetWeight, string-length(NetWeight) - 16)" />
        <xsl:text>NAR </xsl:text>
        <xsl:value-of select="substring(Quantity,2)"/>
        <xsl:text>00000000000000000000                                                                                   0000000000    </xsl:text>
        <xsl:value-of select="substring(InvLineNetVal,3)"/>
        <xsl:value-of select="substring(InvLineNetVal,3)"/>        
        <xsl:text>00000000000000000000000000000000</xsl:text>

        <!-- enter -->
        <xsl:text>&#10;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>